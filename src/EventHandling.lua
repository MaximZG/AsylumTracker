local AsylumTracker = AsylumTracker
local EM = EVENT_MANAGER

function AsylumTracker.RegisterEvents()
     if AsylumTracker.isInVAS then -- Only register events if player is in Asylum to save resources
          local abilities = {} -- Stores event ids to be registered
          local eventName = AsylumTracker.name .. "_event_" -- Each filter must be registered separately, and must therefore have a different unique identifier.
          local eventIndex = 0
          local function RegisterForAbility(abilityId)
               if not abilities[abilityId] then -- If ability has not yet been registered
                    abilities[abilityId] = true
                    eventIndex = eventIndex + 1
                    EM:RegisterForEvent(eventName .. eventIndex, EVENT_COMBAT_EVENT, AsylumTracker.OnCombatEvent) -- Registers all combat events
                    EM:AddFilterForEvent(eventName .. eventIndex, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, abilityId) -- Filters the event to a specific ability
               end
          end

          -- Only registers abilities enabled in the settings
          for x, y in pairs(AsylumTracker.id) do
               if AsylumTracker.sv[x] and type(y) == "number" then
                    RegisterForAbility(y)
               end
          end
          if AsylumTracker.sv["oppressive_bolts"] then
               -- These are needed for tracking interrupts on Llothis
               RegisterForAbility(AsylumTracker.id["bash"])
               RegisterForAbility(AsylumTracker.id["force_shock"])
               RegisterForAbility(AsylumTracker.id["deep_breath"])
               RegisterForAbility(AsylumTracker.id["charge"])
               RegisterForAbility(AsylumTracker.id["poison_arrow"])
          end
          RegisterForAbility(AsylumTracker.id["gusts_of_steam"]) -- Olms Jump at 90/75/50/25
          -- Registers Olms' Steam Breath regardless of whether it is to be displayed in order to correctly track Olms' Storm the Heavens Timer
          if not AsylumTracker.sv.scalding_roar then RegisterForAbility(AsylumTracker.id["scalding_roar"]) end
          if not AsylumTracker.sv.storm_the_heavens then RegisterForAbility(AsylumTracker.id["storm_the_heavens"]) end
          if not AsylumTracker.sv.exhaustive_charges then RegisterForAbility(AsylumTracker.id["exhaustive_charges"]) end
          if not AsylumTracker.sv.trial_by_fire then RegisterForAbility(AsylumTracker.id["trial_by_fire"]) end

          EM:RegisterForEvent(AsylumTracker.name, EVENT_PLAYER_COMBAT_STATE, AsylumTracker.CombatState) -- Used to determine player's combat state
          EM:RegisterForEvent(AsylumTracker.name .. "_dormant", EVENT_EFFECT_CHANGED, AsylumTracker.OnEffectChanged) -- Used to determine if Llothis/Felms go down
          EM:RegisterForEvent(AsylumTracker.name .. "_bossaura", EVENT_COMBAT_EVENT, AsylumTracker.OnCombatEvent)
          EM:AddFilterForEvent(AsylumTracker.name .. "_bossaura", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, AsylumTracker.id.boss_event)
          EM:RegisterForUpdate(AsylumTracker.name .. "_updateTimers", AsylumTracker.refreshRate, AsylumTracker.UpdateTimers) -- Calls this function every half second to update timers and Olm's health
          EM:RegisterForUpdate(AsylumTracker.name .. "_monitorOlmsHP", AsylumTracker.refreshRate, AsylumTracker.MonitorOlmsHP)
          EM:RegisterForUpdate(AsylumTracker.name .. "_alternateColors", 1000, AsylumTracker.AlternateNotificationColors)

     end
end

-- Unregisters events if not in Asylum Sanctorium
function AsylumTracker.UnregisterEvents()
     if not AsylumTracker.isInVAS then
          local eventName = AsylumTracker.name .. "_event_"
          eventIndex = 0
          for x, y in pairs(AsylumTracker.id) do
               eventIndex = eventIndex + 1
               EM:UnregisterForEvent(eventName .. eventIndex, EVENT_COMBAT_EVENT)
          end

          EM:UnregisterForEvent(AsylumTracker.name, EVENT_PLAYER_COMBAT_STATE, AsylumTracker.CombatState)
          EM:UnregisterForEvent(AsylumTracker.name .. "_dormant", EVENT_EFFECT_CHANGED, AsylumTracker.OnEffectChanged)
          EM:UnregisterForEvent(AsylumTracker.name .. "_bossaura", EVENT_COMBAT_EVENT, AsylumTracker.OnCombatEvent)
          EM:UnregisterForUpdate(AsylumTracker.name .. "_updateTimers")
          EM:UnregisterForUpdate(AsylumTracker.name .. "_monitorOlmsHP")
          EM:UnregisterForUpdate(AsylumTracker.name .. "_alternateColors")
     end
end
