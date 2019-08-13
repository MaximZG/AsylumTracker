local AsylumTracker = AsylumTracker

local function UnitIdToName(unitId)
     local name = AsylumTracker.GetNameForUnitId(unitId) -- Character name for the specified TargetUnitId
     if name == "" then
          name = "#"..unitId
     else
          if AsylumTracker.groupMembers[name] ~= nil then
               name = AsylumTracker.groupMembers[name] -- Looks up the @DisplayName for the corresponding Character
               name = UndecorateDisplayName(name)
               name = zo_strformat("<<C:1>>", name) -- Capitalizes the DisplayName
          else
               return name
          end
     end
     return name
end

function AsylumTracker.OnCombatEvent(_, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)
     if result == ACTION_RESULT_INTERRUPT and AsylumTracker.sv.oppressive_bolts then
          AsylumTrackerOppressiveBoltsLabel:SetText(AsylumTracker.sv["interrupt_message"])
          zo_callLater(function() AsylumTracker.SetTimer("oppressive_bolts") end, 1000)
          return
     end
     if result == ACTION_RESULT_BEGIN then
          if abilityId == AsylumTracker.id["storm_the_heavens"] then
               if not AsylumTracker.stormIsActive and AsylumTracker.sv["sound_enabled"] then
                    PlaySound(SOUNDS.BATTLEGROUND_COUNTDOWN_FINISH)
               end
               AsylumTracker.stormIsActive = true
               AsylumTracker.SetTimer("storm_the_heavens") -- Storm the Heavens just started, so create a new timer to preemtively warn for the next Storm the Heavens
               AsylumTracker.dbgability(abilityId, result, hitValue)
               if AsylumTracker.sv.storm_the_heavens then
                    AsylumTrackerStormLabel:SetText(GetString(AST_NOTIF_KITE_NOW)) -- Sets the warning notifcation to KITE when Storm the Heavens is active
                    AsylumTrackerStorm:SetHidden(false) -- Unhides the notifcation for Storm the Heavens
               end
                    -- Storm the Heavens doesn't return a result to let you know when the storm ends, so I tell it to remove the notifcation from the screen 6 seconds after the storm started
               zo_callLater(function() AsylumTrackerStorm:SetHidden(true) AsylumTracker.stormIsActive = false end, 6000)

          elseif abilityId == AsylumTracker.id["defiling_blast"] and hitValue == 2000 then
               targetName = UnitIdToName(targetUnitId) -- Gets the @DisplayName for the player targeted by Llothis' defiling blast cone
               if targetName:sub(1, 1) == "#" then targetName = GetString(AST_SETT_YOU) end -- If UnitIdToName failed and returned #targetUnitId, then it was probably because you're not in a group, therefore it's on you
               if targetName == zo_strformat("<<C:1>>", AsylumTracker.displayName) then targetName = GetString(AST_SETT_YOU) end -- If targetName matches your @DisplayName
               if HashString(AsylumTracker.displayName) == 1325046754 then targetName = "Gary" end
               if not AsylumTracker.LlothisSpawned then AsylumTracker.LlothisSpawned = true end
               AsylumTracker.SetTimer("defiling_blast")
               AsylumTracker.dbgability(abilityId, result, hitValue)
               if targetName == GetString(AST_SETT_YOU) then
                    AsylumTrackerBlastLabel:SetText(GetString(AST_NOTIF_BLAST) .. "|cff0000" .. targetName .. "|r") -- States who the cone is targeting
                    if AsylumTracker.sv["sound_enabled"] then PlaySound(SOUNDS.BATTLEGROUND_COUNTDOWN_FINISH) end
               else
                    AsylumTrackerBlastLabel:SetText(GetString(AST_NOTIF_BLAST) .. targetName .. "|r") -- States who the cone is targeting
                    if AsylumTracker.sv["sound_enabled"] then PlaySound(SOUNDS.BATTLEGROUND_COUNTDOWN_FINISH) end
               end
               AsylumTrackerBlast:SetHidden(false) -- Unhides the notifcation

          elseif abilityId == AsylumTracker.id["oppressive_bolts"] then
               if not AsylumTracker.LlothisSpawned then AsylumTracker.LlothisSpawned = true end
               AsylumTracker.SetTimer("oppressive_bolts", 0)
               AsylumTracker.dbgability(abilityId, result, hitValue)
               AsylumTrackerOppressiveBoltsLabel:SetText("|cff0000" .. GetString(AST_NOTIF_INTERRUPT) .. "|r")
               AsylumTrackerOppressiveBolts:SetHidden(false)

          elseif abilityId == AsylumTracker.id["teleport_strike"] then
               targetName = UnitIdToName(targetUnitId)
               if targetName:sub(1, 1) == "#" then targetName = GetString(AST_SETT_YOU) end
               if targetName == zo_strformat("<<C:1>>", AsylumTracker.displayName) then targetName = GetString(AST_SETT_YOU) end
               if not AsylumTracker.FelmsSpawned then AsylumTracker.FelmsSpawned = true end
               AsylumTracker.SetTimer("teleport_strike")
               AsylumTracker.dbgability(abilityId, result, hitValue)
               if targetName == GetString(AST_SETT_YOU) then
                    AsylumTrackerTeleportStrikeLabel:SetText(GetString(AST_NOTIF_JUMP) .. "|cff0000" .. targetName .. "|r")
               else
                    AsylumTrackerTeleportStrikeLabel:SetText(GetString(AST_NOTIF_JUMP) .. targetName)
               end
               AsylumTrackerTeleportStrike:SetHidden(false)
               -- Removes the notifcation from the screen 2 seconds after Felm's jumps on his target
               zo_callLater(function() AsylumTrackerTeleportStrike:SetHidden(true) end, 2000)

          elseif abilityId == AsylumTracker.id["gusts_of_steam"] then
               -- Removed the HIDE notification from the screen 10 seconds after Olms starts jumping at his 90% 75% 50% 25% marks
               AsylumTrackerOlmsHPLabel:SetText(GetString(AST_NOTIF_OLMS_JUMP))
               AsylumTracker.dbgability(abilityId, result, hitValue)
               AsylumTracker.olmsJumping = true
               if AsylumTracker.firstJump then -- First in sequence (first of his 4 jumps around the room, not referring to the 90% jump)
                    AsylumTracker.firstJump = false
                    zo_callLater(function()
                         AsylumTrackerOlmsHP:SetHidden(true)
                         AsylumTracker.olmsJumping = false
                         AsylumTracker.firstJump = true
                    end, 12000)
                    if AsylumTracker.olmsHealth > "77" then -- Olms' First Jump at 90% (Llothis Spawns)
                         if AsylumTracker.sv.storm_the_heavens then
                              AsylumTracker.SetTimer("storm_the_heavens", 15)
                         end
                    end
               end

          elseif abilityId == AsylumTracker.id["trial_by_fire"] then
               AsylumTracker.SetTimer("trial_by_fire")
               if AsylumTracker.sv.trial_by_fire then
                    AsylumTracker.dbgability(abilityId, result, hitValue)
                    AsylumTrackerFireLabel:SetText(GetString(AST_NOTIF_FIRE) .. "|cff0000" .. GetString(AST_SETT_NOW) .. "|r")
                    AsylumTrackerFire:SetHidden(false)
                    zo_callLater(function() AsylumTrackerFire:SetHidden(true) end, 7000)
               end

          elseif abilityId == AsylumTracker.id["scalding_roar"] and hitValue == 2300 then
               AsylumTracker.SetTimer("scalding_roar")
               if AsylumTracker.sv.scalding_roar then
                    AsylumTracker.dbgability(abilityId, result, hitValue)
                    AsylumTrackerSteamLabel:SetText(GetString(AST_NOTIF_STEAM) .. "|cff0000" .. GetString(AST_SETT_NOW) .. "|r")
                    AsylumTrackerSteam:SetHidden(false)
                    zo_callLater(function() AsylumTrackerSteam:SetHidden(true) end, 5000)
               end

          elseif abilityId == AsylumTracker.id["exhaustive_charges"] then
               AsylumTracker.SetTimer("exhaustive_charges")
               if AsylumTracker.sv.exhaustive_charges then
                    AsylumTracker.dbgability(abilityId, result, hitValue)
                    AsylumTrackerChargesLabel:SetText(GetString(AST_NOTIF_CHARGES) .. "|cff0000" .. GetString(AST_SETT_NOW) .. "|r")
                    AsylumTrackerCharges:SetHidden(false)
                    zo_callLater(function() AsylumTrackerCharges:SetHidden(true) end, 2000)
               end
          end
     end
     if result == ACTION_RESULT_EFFECT_GAINED then
          if abilityId == AsylumTracker.id["static_shield"] then -- Instead of tracking when the protector spawns, I track when the protector gives Olms a shield
               AsylumTracker.sphereIsUp = true -- If Olms has a shield, then a protector is active
               AsylumTracker.dbgability(abilityId, result, hitValue)
               AsylumTrackerSphereLabel:SetText(GetString(AST_NOTIF_PROTECTOR))
               AsylumTrackerSphere:SetHidden(false)
          elseif abilityId == AsylumTracker.id.boss_event and hitValue == 1 then
               AsylumTracker.spawnTimes[targetUnitId] = GetGameTimeSeconds();
               dbg("Boss Event for [" .. targetUnitId .. "]")
          end
     end
     if result == ACTION_RESULT_EFFECT_FADED then
          if abilityId == AsylumTracker.id["defiling_blast"] then
               AsylumTrackerBlast:SetHidden(true) -- Hides defiling blast notification when the cone ends
          elseif abilityId == AsylumTracker.id["oppressive_bolts"] then
               AsylumTracker.SetTimer("oppressive_bolts")
          elseif abilityId == AsylumTracker.id["static_shield"] then -- All spheres dead, shield goes down.
               AsylumTracker.sphereIsUp = false
               AsylumTrackerSphere:SetHidden(true)
          end
     end
end

function AsylumTracker.OnEffectChanged(_, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType)
     if unitName:find("Llothis") or unitName:find("ロシス") or unitName:find("ллотис") then
          if not AsylumTracker.LlothisSpawned then
               AsylumTracker.LlothisSpawned = true
               if AsylumTracker.spawnTimes[unitId] then
                    local llothis_uptime = GetGameTimeSeconds() - AsylumTracker.spawnTimes[unitId]
                    if AsylumTracker.sv.defiling_blast then
                         AsylumTracker.SetTimer("defiling_blast", 12 - llothis_uptime)
                    end
                    if AsylumTracker.sv.oppressive_bolts then
                         AsylumTracker.SetTimer("oppressive_bolts", 12 - llothis_uptime)
                    end
               end
          end
     elseif unitName:find("Felms") or unitName:find("フェルムス") or unitName:find("фелмс") then
          if not AsylumTracker.FelmsSpawned then
               AsylumTracker.FelmsSpawned = true
               if AsylumTracker.spawnTimes[unitId] then
                    local felms_uptime = GetGameTimeSeconds() - AsylumTracker.spawnTimes[unitId]
                    if AsylumTracker.sv.teleport_strike then
                         AsylumTracker.SetTimer("teleport_strike", 12 - felms_uptime)
                    end
               end
          end
     end

     if abilityId == AsylumTracker.id["dormant"] then
          if changeType == EFFECT_RESULT_GAINED then
               if unitName:find("Llothis") or unitName:find("ロシス") or unitName:find("ллотис") then
                    if AsylumTracker.sv.defiling_blast then AsylumTracker.SetTimer("defiling_blast", 45) end
                    if AsylumTracker.sv.oppressive_bolts then AsylumTracker.SetTimer("oppressive_bolts", 45) end
                    AsylumTracker.SetTimer("llothis_dormant")
                    if AsylumTracker.sv["llothis_notifications"] then
                         AsylumTracker.CreateNotification("|c00ff00" .. GetString(AST_NOTIF_LLOTHIS_DOWN) .. "|r", 3000, 5, MED_PRIORITY)
                    end
               elseif unitName:find("Felms") or unitName:find("フェルムス") or unitName:find("фелмс") then
                    if AsylumTracker.sv.teleport_strike then
                         AsylumTracker.SetTimer("teleport_strike", 45)
                         AsylumTrackerTeleportStrike:SetHidden(true)
                    end
                    AsylumTracker.SetTimer("felms_dormant")
                    if AsylumTracker.sv["felms_notifications"] then
                         AsylumTracker.CreateNotification("|c00ff00" .. GetString(AST_NOTIF_FELMS_DOWN) .. "|r", 3000, 5, MED_PRIORITY)
                    end
               end
          elseif changeType == EFFECT_RESULT_FADED then
               if unitName:find("Llothis") or unitName:find("ロシス") or unitName:find("ллотис") then
                    AsylumTracker.SetTimer("llothis_dormant", 0)
                    if AsylumTracker.sv["llothis_notifications"] then
                         AsylumTracker.CreateNotification("|c00ff00" .. GetString(AST_NOTIF_LLOTHIS_UP) .. "|r", 3000, 5, MED_PRIORITY)
                    end
               elseif unitName:find("Felms") or unitName:find("フェルムス") or unitName:find("фелмс") then
                    AsylumTracker.SetTimer("felms_dormant", 0)
                    if AsylumTracker.sv["felms_notifications"] then
                         AsylumTracker.CreateNotification("|c00ff00" .. GetString(AST_NOTIF_FELMS_UP) .. "|r", 3000, 5, MED_PRIORITY)
                    end
               end
          end
     end
end
