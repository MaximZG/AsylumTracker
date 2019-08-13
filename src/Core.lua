AsylumTracker = AsylumTracker or {}
local AsylumTracker = AsylumTracker
local EM = EVENT_MANAGER

local ASYLUM_SANCTORIUM = 1000
local HIGH_PRIORITY = 5
local MED_PRIORITY = 3
local LOW_PRIORITY = 1

AsylumTracker.name = "AsylumTracker"
AsylumTracker.author = "init3 [NA]"
AsylumTracker.version = "2.0"
AsylumTracker.variableVersion = 1
AsylumTracker.fontSize = 48
AsylumTracker.isMovable = false
AsylumTracker.olmsHealth = 100
AsylumTracker.isInVAS = false
AsylumTracker.isInCombat = false
AsylumTracker.olmsJumping = false
AsylumTracker.firstJump = true
AsylumTracker.spawnTimes = {}
AsylumTracker.LlothisSpawned = false
AsylumTracker.FelmsSpawned = false
AsylumTracker.soundPlayed = false
AsylumTracker.isRegistered = false
AsylumTracker.sphereIsUp = false
AsylumTracker.groupMembers = {}
AsylumTracker.refreshRate = 500
AsylumTracker.displayName = UndecorateDisplayName(GetUnitDisplayName("player"))
AsylumTracker.displayResolution = {
     width = GuiRoot:GetWidth(),
     height = GuiRoot:GetHeight()
}

AsylumTracker.id = {
     --Abilities for events that happen in the vAS fight
     storm_the_heavens = 98535, -- Lightning Storm
     defiling_blast = 95545, -- Llothis Poison Cone
     oppressive_bolts = 95585, -- Start of Llothis Attack that needs to be interrupted
     teleport_strike = 99138, -- Felms' Jump
     static_shield = 96010, -- Olms' Shield
     gusts_of_steam = 98868, -- Olms' jump
     trial_by_fire = 98582, -- Olms' fire below 25% HP
     scalding_roar = 98683,
     exhaustive_charges = 95482,
     pernicious_transmission = 99819,
     maim = 95657, -- Felms' Maim
     dormant = 99990, -- Used to tell if Felms/Llothis have been taken down in HM
     boss_event = 10298, -- Used to tell when Llothis/Felms spawn

     -- Abilities that can be used to interrupt Llothis
     bash = 21973,
     force_shock = 48010,
     deep_breath = 32797,
     charge = 26508,
     poison_arrow = 38648,
}

AsylumTracker.defaults = {
     -- Debugging
     debug = false,
     debug_ability = false,
     debug_timers = false,
     debug_units = false,
     -- Settings
     sound_enabled = true,
     llothis_notifications = true,
     felms_notifications = true,
     adjust_timers_olms = false,
     adjust_timers_llothis = false,

     -- Abilities
     interrupt_message = "Toxic",
     sphere_message_toggle = false,
     sphere_message = "SPHERE",
     storm_the_heavens = true,
     defiling_blast = true,
     static_shield = true,
     teleport_strike = false,
     oppressive_bolts = false,
     trial_by_fire = false,
     scalding_roar = false,
     exhaustive_charges = false,
     maim = false,

     -- XML Offsets
     olms_hp_offsetX = AsylumTracker.displayResolution["width"] / 2,
     olms_hp_offsetY = 330,
     storm_offsetX = AsylumTracker.displayResolution["width"] / 2,
     storm_offsetY = 380,
     blast_offsetX = AsylumTracker.displayResolution["width"] / 2,
     blast_offsetY = 430,
     sphere_offsetX = AsylumTracker.displayResolution["width"] / 2,
     sphere_offsetY = 480,
     teleport_strike_offsetX = AsylumTracker.displayResolution["width"] / 2,
     teleport_strike_offsetY = 530,
     oppressive_bolts_offsetX = AsylumTracker.displayResolution["width"] / 2,
     oppressive_bolts_offsetY = 580,
     fire_offsetX = AsylumTracker.displayResolution["width"] / 2,
     fire_offsetY = 630,
     steam_offsetX = AsylumTracker.displayResolution["width"] / 2,
     steam_offsetY = 680,
     maim_offsetX = AsylumTracker.displayResolution["width"] / 2,
     maim_offsetY = 730,
     exhaustive_charges_offsetX = AsylumTracker.displayResolution["width"] / 2,
     exhaustive_charges_offsetY = 780,

     -- Font Sizes
     font_size = 48,
     font_size_olms_hp = 48,
     font_size_storm = 48,
     font_size_blast = 48,
     font_size_sphere = 48,
     font_size_teleport_strike = 48,
     font_size_oppressive_bolts = 48,
     font_size_fire = 48,
     font_size_scalding_roar = 48,
     font_size_maim = 48,
     font_size_exhaustive_charges = 48,

     -- Notification Scale
     olms_hp_scale = 1,
     storm_scale = 1,
     blast_scale = 1,
     sphere_scale = 1,
     teleport_strike_scale = 1,
     oppressive_bolts_scale = 1,
     fire_scale = 1,
     scalding_roar_scale = 1,
     maim_scale = 1,
     exhaustive_charges_scale = 1,

     -- Colors
     color_timer = {0.81, .37, .03},
     color_olms_hp = {1, 0.4, 0, 1},
     color_olms_hp2 = {1, 0, 0, 1},
     color_storm = {1, 1, 1, 1},
     color_storm2 = {1, 1, 0, 1},
     color_blast = {0, 1, 0, 1},
     color_sphere = {0, 0, 1, 1},
     color_sphere2 = {1, 0, 0, 1},
     color_teleport_strike = {1, 0, 1, 1},
     color_oppressive_bolts = {0, 0, 1, 1},
     color_fire = {1, 0.4, 0, 1},
     color_scalding_roar = {0.5, 0.05, 1, 1},
     color_maim = {0.2, 0.93, .79, 1},
     color_exhaustive_charges = {0.18, 0.37, 0.45, 1},

     -- Sound Effects
     storm_the_heavens_sound = "BATTLEGROUND_CAPTURE_FLAG_CAPTURED_BY_OWN_TEAM",
     storm_the_heavens_volume = 1,
     defiling_blast_sound = "BATTLEGROUND_CAPTURE_AREA_CAPTURED_OTHER_TEAM",
     defiling_blast_volume = 1,
}

AsylumTracker.timers = {
     storm_the_heavens = 0,
     defiling_blast = 0,
     teleport_strike = 0,
     oppressive_bolts = 0,
     scalding_roar = 0,
     maim = 0,
     exhaustive_charges = 0,
     trial_by_fire = 0,
     felms_dormant = 0,
     llothis_dormant = 0,
}

AsylumTracker.endTimes = {}

local function round(number, decimalPlaces)
     local mult = 10^(decimalPlaces or 0)
     local value = math.floor(number * mult + 0.5) / mult
     local decimal = tostring(value):match("%.(%d+)")
     if decimal then
          if #decimal == nil then
               value = value .. "000"
          elseif #decimal == 1 then
               value = value .. "00"
          elseif #decimal == 2 then
               value = value .. "0"
          end
          return value
     else
          return value .. ".000"
     end
end

function AsylumTracker.RGBToHex(r, g, b, a)
     r = string.format("%x", r * 255)
     g = string.format("%x", g * 255)
     b = string.format("%x", b * 255)
     if #r < 2 then r = "0" .. r end
     if #g < 2 then g = "0" .. g end
     if #b < 2 then b = "0" .. b end
     return r .. g .. b
end

function AsylumTracker.dbg(text)
     if AsylumTracker.sv.debug then
          d("|cff0096AsylumTracker [" .. round(GetGameTimeSeconds(), 3) .. "] ::|r|c992A18 " .. text .. "|r")
     end
end

function AsylumTracker.dbgability(abilityId, result, hitValue)
     if abilityId and result and hitValue then
          if AsylumTracker.sv.debug_ability then
               d("|cff0096AsylumTracker [" .. round(GetGameTimeSeconds(), 3) .. "] ::|r|c184599 " .. GetAbilityName(abilityId) .. " (" .. abilityId .. ") with a result of " .. result .. " and a hit value of " .. hitValue)
          end
     end
end

function AsylumTracker.dbgtimers(text)
     if AsylumTracker.sv.debug_timers then
          d("|cff0096AsylumTracker [" .. round(GetGameTimeSeconds(), 3) .. "] ::|r|c02731E " .. text .. "|r")
     end
end

function AsylumTracker.dbgunits(text)
     if AsylumTracker.sv.debug_units then
          d("|cff0096AsylumTracker [" .. round(GetGameTimeSeconds(), 3) .. "] ::|r|c992A18 " .. text .. "|r")
     end
end

--[[ Name is a bit misleading. The function is called whenever there is a change to the world map,
meaning this will not only be called when you change zones, but also whenever you're using your world map]]
local function OnZoneChanged()
     --     local zone = zo_strformat("<<C:1>>", GetUnitZone("player"))
     local zone = zo_strformat("<<C:1>>", GetUnitZone("player"))
     local targetZone = zo_strformat("<<C:1>>", GetZoneNameById(ASYLUM_SANCTORIUM))
     if zone == targetZone then -- Checks to see if the player is in Asylum Sanctorium
          AsylumTracker.isInVAS = true
          if not AsylumTracker.isRegistered then --Used to prevent re-registering events when flipping through world map
               AsylumTracker.RegisterEvents()
               AsylumTracker.isRegistered = true
          end
     else
          AsylumTracker.isInVAS = false
          if AsylumTracker.isRegistered then
               AsylumTracker.UnregisterEvents() -- Unregisters events when not in Asylum Sanctorium to save resources
               AsylumTracker.isRegistered = false
          end
     end
end

-- Sets an estimated timer for some mechanics
function AsylumTracker.SetTimer(key, timer_override, endtime_override)
     local duration
     if key == "storm_the_heavens" then
          duration = timer_override or 41
     elseif key == "defiling_blast" then
          duration = timer_override or 21
     elseif key == "teleport_strike" then
          duration = timer_override or 21
     elseif key == "oppressive_bolts" then
          duration = timer_override or 12
     elseif key == "exhaustive_charges" then
          duration = timer_override or 12
     elseif key == "scalding_roar" then
          duration = timer_override or 28
     elseif key == "trial_by_fire" then
          duration = timer_override or 28
     elseif key == "llothis_dormant" then
          duration = timer_override or 45
     elseif key == "felms_dormant" then
          duration = timer_override or 45
     elseif key == "maim" then
          duration = timer_override or 15
     end
     AsylumTracker.timers[key] = duration
     AsylumTracker.endTimes[key] = endtime_override or (GetGameTimeSeconds() + duration)
end

local function SetMaimedStatus()
     for i = 1, 50 do
          local buffName, timeStarted, timeEnding, buffSlot, stackCount, fileName, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo("player", i)
          if abilityId == AsylumTracker.id.maim then
               AsylumTracker.SetTimer("maim", timeEnding - GetGameTimeSeconds(), timeEnding)
               AsylumTracker.dbg("Updated Maim timer to " .. AsylumTracker.timers.maim .. " seconds.")
               break
          elseif abilityId == nil or abilityId == "" or abilityId == 0 then
               break
          end
     end
end

function AsylumTracker.CreateNotification(text, duration, category, priority)
     local CSA = CENTER_SCREEN_ANNOUNCE
     local params = CSA:CreateMessageParams(category)
     params:SetCSAType(CENTER_SCREEN_ANNOUNCE_TYPE_RAID_TRIAL)
     params:SetText(text)
     params:SetLifespanMS(duration)
     params:SetPriority(priority)
     CSA:AddMessageWithParams(params)
end

function AsylumTracker.LoopSound(numberOfLoops, soundEffect)
     for i = 1, numberOfLoops do
          PlaySound(SOUNDS[soundEffect])
     end
end

function AsylumTracker.GetSounds()
     local sounds = {}
     for key, value in pairs(SOUNDS) do
          sounds[#sounds + 1] = key
          table.sort(sounds)
     end
     return sounds
end

local function SortTimers(tbl, sortFunction)
     local keys = {}
     for key in pairs(tbl) do
          table.insert(keys, key)
     end

     table.sort(keys, function(a, b)
          return sortFunction(tbl[a], tbl[b])
     end)
     return keys
end

function AsylumTracker.AdjustTimersOlms()
     local unsorted_timers = {}
     local durations = {
          trial_by_fire = 8,
          storm_the_heavens = 7,
          scalding_roar = 6,
          exhaustive_charges = 2,
     }

     if AsylumTracker.timers.storm_the_heavens > 0 then unsorted_timers["storm_the_heavens"] = AsylumTracker.timers.storm_the_heavens end
     if AsylumTracker.timers.trial_by_fire > 0 then unsorted_timers["trial_by_fire"] = AsylumTracker.timers.trial_by_fire end
     if AsylumTracker.timers.exhaustive_charges > 0 then unsorted_timers["exhaustive_charges"] = AsylumTracker.timers.exhaustive_charges end
     if AsylumTracker.timers.scalding_roar > 0 then unsorted_timers["scalding_roar"] = AsylumTracker.timers.scalding_roar end

     local sorted_timers = SortTimers(unsorted_timers, function(a, b) return a < b end)

     if #sorted_timers >= 2 then
          for i = 1, #sorted_timers - 1 do
               local timer1, timer2 = AsylumTracker.timers[sorted_timers[i]], AsylumTracker.timers[sorted_timers[i + 1]]
               local endTime1, endTime2 = AsylumTracker.endTimes[sorted_timers[i]], AsylumTracker.endTimes[sorted_timers[i + 1]]
               local duration1 = durations[sorted_timers[i]]
               if (timer2 - timer1) < duration1 then
                    if (timer2 - timer1) >= 1 then
                         local old_timeRemaining = timer2
                         local new_timeRemaining = timer2 + (duration1 - (timer2 - timer1))
                         local new_endTime = endTime2 + (duration1 - (endTime2 - endTime1))
                         if math.abs(new_timeRemaining - old_timeRemaining) > 0.15 then
                              AsylumTracker.SetTimer(sorted_timers[i + 1], new_timeRemaining, new_endTime)
                              AsylumTracker.dbg("Updated timer for " .. sorted_timers[i + 1] .. " to " .. AsylumTracker.timers[sorted_timers[i + 1]])
                         end
                    end
               end
          end
     end
end

function AsylumTracker.AdjustTimersLlothis()
     local db, ob = AsylumTracker.timers.defiling_blast, AsylumTracker.timers.oppressive_bolts
     local db_end, ob_end, ec_end = AsylumTracker.endTimes.defiling_blast, AsylumTracker.endTimes.oppressive_bolts
     if (ob > db) then
          if (ob - db < 7) and (ob - db >= 2) and (db > 0) then
               AsylumTracker.SetTimer("oppressive_bolts", ob + (7 - (ob - db)), ob_end + (7 - (ob_end - db_end)))
               AsylumTracker.dbg("[ob > db]: Updated Oppressive Bolts timer to: " .. AsylumTracker.timers.oppressive_bolts)
          end
     end
end

function AsylumTracker.UpdateTimers()
     if AsylumTracker.isInCombat then
          if AsylumTracker.sv.adjust_timers_olms then AsylumTracker.AdjustTimersOlms() end
          if AsylumTracker.sv.adjust_timers_llothis then AsylumTracker.AdjustTimersLlothis() end
          if AsylumTracker.sv.maim then SetMaimedStatus() end
          for key, value in pairs(AsylumTracker.timers) do -- The key is the ability and the value is the endTime for the event
               if AsylumTracker.timers[key] > 0 then -- If there is a timer for the specified key event
                    AsylumTracker.timers[key] = (AsylumTracker.endTimes[key] - GetGameTimeSeconds())
                    if AsylumTracker.timers[key] < 0 then AsylumTracker.SetTimer(key, 0) end
                    local timeRemaining = AsylumTracker.timers[key]
                    AsylumTracker.dbgtimers(key .. ": " .. round(timeRemaining, 3))
                    if key == "storm_the_heavens" and timeRemaining < 6 and AsylumTracker.sv.storm_the_heavens then
                         AsylumTrackerStorm:SetHidden(false)
                         if timeRemaining >= 1 then
                              AsylumTrackerStormLabel:SetText(GetString(AST_NOTIF_KITE) .. "|c" .. AsylumTracker.RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. math.floor(timeRemaining) .. "|r")
                         else
                              AsylumTrackerStormLabel:SetText(GetString(AST_NOTIF_KITE) .. "|c" .. AsylumTracker.RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. GetString(AST_SETT_SOON).. "|r")
                         end
                         if timeRemaining > 0 and not AsylumTracker.soundPlayed then
                              if AsylumTracker.sv["sound_enabled"] then
                                   AsylumTracker.soundPlayed = true
                                   AsylumTracker.LoopSound(AsylumTracker.sv.storm_the_heavens_volume, AsylumTracker.sv.storm_the_heavens_sound)
                                   zo_callLater(function() AsylumTracker.soundPlayed = false end, 900)
                              end
                         end
                    elseif key == "defiling_blast" and timeRemaining < 6 then
                         if timeRemaining >= 1 then
                              AsylumTrackerBlastLabel:SetText(GetString(AST_NOTIF_BLAST) .. "|c" .. AsylumTracker.RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. math.floor(timeRemaining) .. "|r")
                              AsylumTrackerBlast:SetHidden(false)
                         else
                              AsylumTrackerBlastLabel:SetText(GetString(AST_NOTIF_BLAST) .. "|c" .. AsylumTracker.RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. GetString(AST_SETT_SOON) .. "|r")
                              AsylumTrackerBlast:SetHidden(false)
                         end
                         if timeRemaining > 0 and not AsylumTracker.soundPlayed then
                              if AsylumTracker.sv["sound_enabled"] then
                                   AsylumTracker.soundPlayed = true
                                   AsylumTracker.LoopSound(AsylumTracker.sv.defiling_blast_volume, AsylumTracker.sv.defiling_blast_sound)
                                   zo_callLater(function() AsylumTracker.soundPlayed = false end, 900)
                              end
                         end
                    elseif key == "teleport_strike" and timeRemaining < 6 then
                         if timeRemaining >= 1 then
                              AsylumTrackerTeleportStrikeLabel:SetText(GetString(AST_NOTIF_JUMP) .. "|c" .. AsylumTracker.RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. math.floor(timeRemaining) .. "|r")
                              AsylumTrackerTeleportStrike:SetHidden(false)
                         else
                              AsylumTrackerTeleportStrikeLabel:SetText(GetString(AST_NOTIF_JUMP) .. "|c" .. AsylumTracker.RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. GetString(AST_SETT_SOON) .. "|r")
                              AsylumTrackerTeleportStrike:SetHidden(false)
                         end
                    elseif key == "oppressive_bolts" then
                         if timeRemaining >= 1 then
                              AsylumTrackerOppressiveBoltsLabel:SetText(GetString(AST_NOTIF_BOLTS) .. "|c" .. AsylumTracker.RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. math.floor(timeRemaining) .. "|r")
                         else
                              AsylumTrackerOppressiveBoltsLabel:SetText(GetString(AST_NOTIF_BOLTS) .. "|c" .. AsylumTracker.RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. GetString(AST_SETT_SOON) .. "|r")
                         end
                         AsylumTrackerOppressiveBolts:SetHidden(false)
                    elseif key == "exhaustive_charges" and timeRemaining < 6 and AsylumTracker.sv.exhaustive_charges then
                         if timeRemaining >= 1 then
                              AsylumTrackerChargesLabel:SetText(GetString(AST_NOTIF_CHARGES) .. "|c" .. AsylumTracker.RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. math.floor(timeRemaining) .. "|r")
                              AsylumTrackerCharges:SetHidden(false)
                         else
                              AsylumTrackerChargesLabel:SetText(GetString(AST_NOTIF_CHARGES) .. "|c" .. AsylumTracker.RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. GetString(AST_SETT_SOON) .. "|r")
                              AsylumTrackerCharges:SetHidden(false)
                         end
                    elseif key == "scalding_roar" and timeRemaining < 6 and AsylumTracker.sv.scalding_roar then
                         if timeRemaining >= 1 then
                              AsylumTrackerSteamLabel:SetText(GetString(AST_NOTIF_STEAM) .. "|c" .. AsylumTracker.RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. math.floor(timeRemaining) .. "|r")
                              AsylumTrackerSteam:SetHidden(false)
                         else
                              AsylumTrackerSteamLabel:SetText(GetString(AST_NOTIF_STEAM) .. "|c" .. AsylumTracker.RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. GetString(AST_SETT_SOON) .. "|r")
                              AsylumTrackerSteam:SetHidden(false)
                         end
                    elseif key == "trial_by_fire" and timeRemaining < 6 and AsylumTracker.sv.trial_by_fire then
                         if timeRemaining >= 1 then
                              AsylumTrackerFireLabel:SetText(GetString(AST_NOTIF_FIRE) .. "|c" .. AsylumTracker.RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. math.floor(timeRemaining) .. "|r")
                              AsylumTrackerFire:SetHidden(false)
                         else
                              AsylumTrackerFireLabel:SetText(GetString(AST_NOTIF_FIRE) .. "|c" .. AsylumTracker.RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. GetString(AST_SETT_SOON) .. "|r")
                              AsylumTrackerFire:SetHidden(false)
                         end
                         AsylumTrackerFire:SetHidden(false)
                    elseif key == "llothis_dormant" then
                         if timeRemaining == 10 then
                              if AsylumTracker.sv["llothis_notifications"] then
                                   AsylumTracker.CreateNotification("|cff9933" .. GetString(AST_NOTIF_LLOTHIS_IN_10) .. "|r", 3000, 5, HIGH_PRIORITY)
                              end
                         elseif timeRemaining == 5 then
                              if AsylumTracker.sv["llothis_notifications"] then
                                   AsylumTracker.CreateNotification("|cff9933" .. GetString(AST_NOTIF_LLOTHIS_IN_5) .. "|r", 3000, 5, HIGH_PRIORITY)
                              end
                         end
                    elseif key == "felms_dormant" then
                         if timeRemaining == 10 then
                              if AsylumTracker.sv["felms_notifications"] then
                                   AsylumTracker.CreateNotification("|cff9933" .. GetString(AST_NOTIF_FELMS_IN_10) .. "|r", 3000, 5, HIGH_PRIORITY)
                              end
                         elseif timeRemaining == 5 then
                              if AsylumTracker.sv["felms_notifications"] then
                                   AsylumTracker.CreateNotification("|cff9933" .. GetString(AST_NOTIF_FELMS_IN_5) .. "|r", 3000, 5, HIGH_PRIORITY)
                              end
                         end
                    elseif key == "maim" then
                         if timeRemaining >= 0.5 then
                              if AsylumTracker.sv["maim"] then
                                   AsylumTrackerMaimLabel:SetText(GetString(AST_NOTIF_MAIM) .. "|c" .. AsylumTracker.RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. math.floor(timeRemaining) .. "|r")
                                   AsylumTrackerMaim:SetHidden(false)
                              else
                                   AsylumTrackerMaim:SetHidden(true)
                              end
                         else
                              AsylumTrackerMaim:SetHidden(true)
                         end
                    end
               end
          end
     else -- If not in Asylum AND in combat, clear any running timers
          for key, value in pairs(AsylumTracker.timers) do
               AsylumTracker.SetTimer(key, 0)
          end
     end
end

function AsylumTracker.MonitorOlmsHP()
     local bossName = zo_strformat("<<C:1>>", GetUnitName("boss1"))
     if bossName ~= "" then -- HP for Boss1 (Since the addon only loads in Asylum, this works for determining if you're in the room with Olms, because if you are not, this function returns an empty string)
          local current, max, effective = GetUnitPower("boss1", POWERTYPE_HEALTH)
          AsylumTracker.olmsHealth = tostring(math.floor(string.format("%.1f", current / max * 100))) -- Format's Olm's health as a percentage
          if not AsylumTracker.olmsJumping then
               if AsylumTracker.olmsHealth >= "90" and AsylumTracker.olmsHealth <= "95" then
                    if AsylumTracker.olmsHealth >= "92" then
                         AsylumTrackerOlmsHPLabel:SetText(AsylumTracker.olmsHealth .. "%")
                         AsylumTrackerOlmsHPLabel:SetColor(unpack(AsylumTracker.sv["color_olms_hp"]))
                         AsylumTrackerOlmsHP:SetHidden(false)
                    else
                         AsylumTrackerOlmsHPLabel:SetText(AsylumTracker.olmsHealth .. "%")
                         AsylumTrackerOlmsHPLabel:SetColor(unpack(AsylumTracker.sv["color_olms_hp2"]))
                    end
               elseif AsylumTracker.olmsHealth >= "75" and AsylumTracker.olmsHealth <= "80" then
                    if AsylumTracker.olmsHealth >= "77" then
                         AsylumTrackerOlmsHPLabel:SetText(AsylumTracker.olmsHealth .. "%")
                         AsylumTrackerOlmsHPLabel:SetColor(unpack(AsylumTracker.sv["color_olms_hp"]))
                         AsylumTrackerOlmsHP:SetHidden(false)
                    else
                         AsylumTrackerOlmsHPLabel:SetText(AsylumTracker.olmsHealth .. "%")
                         AsylumTrackerOlmsHPLabel:SetColor(unpack(AsylumTracker.sv["color_olms_hp2"]))
                    end
               elseif AsylumTracker.olmsHealth >= "50" and AsylumTracker.olmsHealth <= "55" then
                    if AsylumTracker.olmsHealth >= "52" then
                         AsylumTrackerOlmsHPLabel:SetText(AsylumTracker.olmsHealth .. "%")
                         AsylumTrackerOlmsHPLabel:SetColor(unpack(AsylumTracker.sv["color_olms_hp"]))
                         AsylumTrackerOlmsHP:SetHidden(false)
                    else
                         AsylumTrackerOlmsHPLabel:SetText(AsylumTracker.olmsHealth .. "%")
                         AsylumTrackerOlmsHPLabel:SetColor(unpack(AsylumTracker.sv["color_olms_hp2"]))
                    end
               elseif AsylumTracker.olmsHealth >= "25" and AsylumTracker.olmsHealth <= "30" then
                    if AsylumTracker.olmsHealth >= "27" then
                         AsylumTrackerOlmsHPLabel:SetText(AsylumTracker.olmsHealth .. "%")
                         AsylumTrackerOlmsHPLabel:SetColor(unpack(AsylumTracker.sv["color_olms_hp"]))
                         AsylumTrackerOlmsHP:SetHidden(false)
                    else
                         AsylumTrackerOlmsHPLabel:SetText(AsylumTracker.olmsHealth .. "%")
                         AsylumTrackerOlmsHPLabel:SetColor(unpack(AsylumTracker.sv["color_olms_hp2"]))
                    end
               end
          end
     end
end

function AsylumTracker.AlternateNotificationColors()
     -- If a Protector/Sphere is up, this will alternate the colors of warning message between red and white to make it more noticable
     if AsylumTracker.sphereIsUp then
          r, g, b, a = AsylumTrackerSphereLabel:GetColor()
          local firstColor = AsylumTracker.sv["color_sphere"]
          r = string.format("%.2f", r)
          g = string.format("%.2f", g)
          b = string.format("%.2f", b)
          firstColor[1] = string.format("%.2f", firstColor[1])
          firstColor[2] = string.format("%.2f", firstColor[2])
          firstColor[3] = string.format("%.2f", firstColor[3])
          if r == firstColor[1] and g == firstColor[2] and b == firstColor[3] then
               AsylumTrackerSphereLabel:SetColor(unpack(AsylumTracker.sv["color_sphere2"]))
          else
               AsylumTrackerSphereLabel:SetColor(unpack(AsylumTracker.sv["color_sphere"]))
          end
     end
     if AsylumTracker.stormIsActive then
          r, g, b, a = AsylumTrackerStormLabel:GetColor()
          local firstColor = AsylumTracker.sv["color_storm"]
          r = string.format("%.2f", r)
          g = string.format("%.2f", g)
          b = string.format("%.2f", b)
          firstColor[1] = string.format("%.2f", firstColor[1])
          firstColor[2] = string.format("%.2f", firstColor[2])
          firstColor[3] = string.format("%.2f", firstColor[3])
          if r == firstColor[1] and g == firstColor[2] and b == firstColor[3] then
               AsylumTrackerStormLabel:SetColor(unpack(AsylumTracker.sv["color_storm2"]))
          else
               AsylumTrackerStormLabel:SetColor(unpack(AsylumTracker.sv["color_storm"]))
          end
     end
end

function AsylumTracker.IndexGroupMembers()
     local groupSize = GetGroupSize()
     if groupSize == 0 then -- If you're not in a group, but for whatever reason trying to solo Asylum, this will prevent the addon bugging out because it can't index the members in your non-existant group
          AsylumTracker.groupMembers[GetUnitName("player")] = GetUnitDisplayName("player")
     else
          for i = 1, GROUP_SIZE_MAX do -- For each member in your group
               local memberCharacterName = GetUnitName("group" .. i) -- The member's character name
               if memberCharacterName ~= nil then
                    local memberDisplayName = GetUnitDisplayName("group" .. i) -- The member's @DisplayName
                    AsylumTracker.groupMembers[memberCharacterName] = memberDisplayName -- Store them in the groupMembers table
               end
          end
     end
end

function AsylumTracker.CombatState(event, isInCombat)
     if isInCombat ~= AsylumTracker.isInCombat then
          AsylumTracker.isInCombat = isInCombat
          if isInCombat then
               AsylumTracker.IndexGroupMembers() -- Indexs the character and @DisplayNames for the members in your group when you enter combat
          else
               -- When you exit combat, this will remove any notifications that were on your screen when you left combat.
               AsylumTrackerOlmsHP:SetHidden(true)
               AsylumTrackerStorm:SetHidden(true)
               AsylumTrackerBlast:SetHidden(true)
               AsylumTrackerOppressiveBolts:SetHidden(true)
               AsylumTrackerSphere:SetHidden(true)
               AsylumTrackerTeleportStrike:SetHidden(true)
               AsylumTrackerFire:SetHidden(true)
               AsylumTrackerSteam:SetHidden(true)
               AsylumTrackerMaim:SetHidden(true)
               AsylumTrackerCharges:SetHidden(true)

               AsylumTracker.LlothisSpawned = false
               AsylumTracker.FelmsSpawned = false
               AsylumTracker.dbg("Resetting Llothis and Felms spawn status")

               AsylumTracker.unitIds = {}
               AsylumTracker.dbgunits("Leaving Combat. Clearing Units Table")
               AsylumTracker.spawnTimes = {}
          end
     end
end

-- Initialization function
function AsylumTracker.Initialize()
     AsylumTracker.savedVars = ZO_SavedVars:NewCharacterIdSettings("AsylumTrackerVars", AsylumTracker.variableVersion, nil, AsylumTracker.defaults) -- Defines saved variables
     AsylumTracker.sv = AsylumTrackerVars["Default"][GetDisplayName()][GetCurrentCharacterId()]
     AsylumTracker.CreateSettingsWindow() -- Creates the addon settings menu
     AsylumTracker.RegisterUnitIndexing()
     AsylumTracker.ResetAnchors()

     AsylumTracker.SetFontSize(AsylumTrackerOlmsHP, AsylumTrackerOlmsHPLabel, AsylumTracker.sv.font_size_olms_hp)
     AsylumTracker.SetFontSize(AsylumTrackerStorm, AsylumTrackerStormLabel, AsylumTracker.sv.font_size_storm)
     AsylumTracker.SetFontSize(AsylumTrackerBlast, AsylumTrackerBlastLabel, AsylumTracker.sv.font_size_blast)
     AsylumTracker.SetFontSize(AsylumTrackerSphere, AsylumTrackerSphereLabel, AsylumTracker.sv.font_size_sphere)
     AsylumTracker.SetFontSize(AsylumTrackerTeleportStrike, AsylumTrackerTeleportStrikeLabel, AsylumTracker.sv.font_size_teleport_strike)
     AsylumTracker.SetFontSize(AsylumTrackerOppressiveBolts, AsylumTrackerOppressiveBoltsLabel, AsylumTracker.sv.font_size_oppressive_bolts)
     AsylumTracker.SetFontSize(AsylumTrackerFire, AsylumTrackerFireLabel, AsylumTracker.sv.font_size_fire)
     AsylumTracker.SetFontSize(AsylumTrackerSteam, AsylumTrackerSteamLabel, AsylumTracker.sv.font_size_scalding_roar)
     AsylumTracker.SetFontSize(AsylumTrackerMaim, AsylumTrackerMaimLabel, AsylumTracker.sv.font_size_maim)
     AsylumTracker.SetFontSize(AsylumTrackerCharges, AsylumTrackerChargesLabel, AsylumTracker.sv.font_size_exhaustive_charges)

     AsylumTracker.SetScale(AsylumTrackerOlmsHPLabel, AsylumTracker.sv["olms_hp_scale"])
     AsylumTracker.SetScale(AsylumTrackerStormLabel, AsylumTracker.sv["storm_scale"])
     AsylumTracker.SetScale(AsylumTrackerBlastLabel, AsylumTracker.sv["blast_scale"])
     AsylumTracker.SetScale(AsylumTrackerSphereLabel, AsylumTracker.sv["sphere_scale"])
     AsylumTracker.SetScale(AsylumTrackerTeleportStrikeLabel, AsylumTracker.sv["teleport_strike_scale"])
     AsylumTracker.SetScale(AsylumTrackerOppressiveBoltsLabel, AsylumTracker.sv["oppressive_bolts_scale"])
     AsylumTracker.SetScale(AsylumTrackerFireLabel, AsylumTracker.sv["fire_scale"])
     AsylumTracker.SetScale(AsylumTrackerSteamLabel, AsylumTracker.sv["scalding_roar_scale"])
     AsylumTracker.SetScale(AsylumTrackerMaimLabel, AsylumTracker.sv["maim_scale"])
     AsylumTracker.SetScale(AsylumTrackerChargesLabel, AsylumTracker.sv["exhaustive_charges_scale"])

     if AsylumTracker.sv.sphere_message_toggle then
          ZO_CreateStringId("AST_NOTIF_PROTECTOR", AsylumTracker.sv.sphere_message)
     end

     AsylumTracker.IndexGroupMembers()

     SLASH_COMMANDS["/astracker"] = AsylumTracker.SlashCommand
end

function AsylumTracker.OnAddOnLoaded(event, addonName)
     if AsylumTracker.name ~= addonName then return end
     CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged", OnZoneChanged) -- Registers the callback used to determine which zone the player is in.
     AsylumTracker.Initialize()
     EM:UnregisterForEvent(AsylumTracker.name, EVENT_ADD_ON_LOADED) -- Unregisters the OnAddOnLoaded Function
end

EM:RegisterForEvent(AsylumTracker.name, EVENT_ADD_ON_LOADED, AsylumTracker.OnAddOnLoaded)
