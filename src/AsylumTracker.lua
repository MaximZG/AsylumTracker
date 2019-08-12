AsylumTracker = AsylumTracker or {}
local AsylumTracker = AsylumTracker

local ASYLUM_SANCTORIUM = 1000
local HIGH_PRIORITY = 5
local MED_PRIORITY = 3
local LOW_PRIORITY = 1

AsylumTracker.name = "AsylumTracker"
AsylumTracker.author = "init3 [NA]"
AsylumTracker.version = "1.9"
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

local function RGBToHex(r, g, b, a)
     r = string.format("%x", r * 255)
     g = string.format("%x", g * 255)
     b = string.format("%x", b * 255)
     if #r < 2 then r = "0" .. r end
     if #g < 2 then g = "0" .. g end
     if #b < 2 then b = "0" .. b end
     return r .. g .. b
end

local function dbg(text)
     if AsylumTracker.sv.debug then
          d("|cff0096AsylumTracker [" .. round(GetGameTimeSeconds(), 3) .. "] ::|r|c992A18 " .. text .. "|r")
     end
end

local function dbgability(abilityId, result, hitValue)
     if abilityId and result and hitValue then
          if AsylumTracker.sv.debug_ability then
               d("|cff0096AsylumTracker [" .. round(GetGameTimeSeconds(), 3) .. "] ::|r|c184599 " .. GetAbilityName(abilityId) .. " (" .. abilityId .. ") with a result of " .. result .. " and a hit value of " .. hitValue)
          end
     end
end

local function dbgtimers(text)
     if AsylumTracker.sv.debug_timers then
          d("|cff0096AsylumTracker [" .. round(GetGameTimeSeconds(), 3) .. "] ::|r|c02731E " .. text .. "|r")
     end
end

function AsylumTracker.dbgunits(text)
     if AsylumTracker.sv.debug_units then
          d("|cff0096AsylumTracker [" .. round(GetGameTimeSeconds(), 3) .. "] ::|r|c992A18 " .. text .. "|r")
     end
end

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
local function SetTimer(key, timer_override, endtime_override)
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
          duration = timer_override or 27
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
               SetTimer("maim", timeEnding - GetGameTimeSeconds(), timeEnding)
               dbg("Updated Maim timer to " .. AsylumTracker.timers.maim .. " seconds.")
               break
          elseif abilityId == nil or abilityId == "" or abilityId == 0 then
               break
          end
     end
end

local function CreateNotification(text, duration, category, priority)
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

local function AdjustTimersOlms()
     local sh, sr, ec = AsylumTracker.timers.storm_the_heavens, AsylumTracker.timers.scalding_roar, AsylumTracker.timers.exhaustive_charges
     local sh_end, sr_end, ec_end = AsylumTracker.endTimes.storm_the_heavens, AsylumTracker.endTimes.scalding_roar, AsylumTracker.endTimes.exhaustive_charges
     if (sh > sr) and (sr > ec) then
          if (sr - ec < 2) and (sr - ec >= 1) and (ec > 0) then
               SetTimer("scalding_roar", sr + (2 - (sr - ec)), sr_end + (2 - (sr_end - ec_end)))
               sr = AsylumTracker.timers.scalding_roar
               sr_end = AsylumTracker.endTimes.scalding_roar
               dbg("[sh > sr > ec]: Updated Scalding Roar timer to: " .. AsylumTracker.timers.scalding_roar)
          end
     elseif (sr > sh) and (sh > ec) then
          if (sr - sh < 7) and (sr - sh >= 1) and (sh > 0) then
               SetTimer("scalding_roar", sr + (7 - (sr - sh)), sr_end + (7 - (sr_end - sh_end)))
               dbg("[sr > sh > ec]: Updated Scalding Roar timer to: " .. AsylumTracker.timers.scalding_roar)
          end
     elseif (sh > ec) and (ec > sr) then
          if (ec - sr < 6) and (ec - sr >= 1) and (sr > 0) then
               SetTimer("exhaustive_charges", ec + (6 - (ec - sr)), ec_end + (6 - (ec_end - sr_end)))
               ec = AsylumTracker.timers.exhaustive_charges
               ec_end = AsylumTracker.endTimes.exhaustive_charges
               dbg("[sh > ec > sr]: Updated Exhaustive Charges timer to: " .. AsylumTracker.timers.exhaustive_charges)
          end
     elseif (sr > ec) and (ec > sh) then
          if (ec - sh < 7) and (ec - sh >= 1) and (sh > 0) then
               SetTimer("exhaustive_charges", ec + (7 - (ec - sh)), ec_end + (7 - (ec_end - sh_end)))
               ec = AsylumTracker.timers.exhaustive_charges
               ec_end = AsylumTracker.endTimes.exhaustive_charges
               dbg("[sr > ec > sh]: Updated Exhaustive Charges timer to: " .. AsylumTracker.timers.exhaustive_charges)
          end
          if (sr - ec < 2) and (sr - ec >= 1) and (ec > 0) then
               SetTimer("scalding_roar", sr + (2 - (sr - ec)), sr_end + (2 - (sr_end - ec_end)))
               dbg("[sr > ec > sh]: Updated Scalding Roar timer to: " .. AsylumTracker.timers.scalding_roar)
          end
     elseif (ec > sh) and (sh > sr) then
          if (ec - sh < 7) and (ec - sh >= 1) and (sh > 0) then
               SetTimer("exhaustive_charges", ec + (7 - (ec - sh)), ec_end + (7 - (ec_end - sh_end)))
               dbg("[ec > sh > sr]: Updated Exhaustive Charges timer to: " .. AsylumTracker.timers.exhaustive_charges)
          end
     elseif (ec > sr) and (sr > sh) then
          if (sr - sh < 7) and (sr - sh >= 1) and (sh > 0) then
               SetTimer("scalding_roar", sr + (7 - (sr - sh)), sr_end + (7 - (sr_end - sh_end)))
               sr = AsylumTracker.timers.scalding_roar
               sr_end = AsylumTracker.timers.scalding_roar
               dbg("[ec > sr > sh]: Updated Scalding Roar timer to: " .. AsylumTracker.timers.scalding_roar)
          end
          if (ec - sr < 6) and (ec - sr >= 1) and (sr > 0) then
               SetTimer("exhaustive_charges", ec + (6 - (ec - sr)), ec_end + (6 - (ec_end - sr_end)))
               dbg("[ec > sr > sh]: Updated Exhaustive Charges timer to: " .. AsylumTracker.timers.exhaustive_charges)
          end
     end
end

local function AdjustTimersLlothis()
     local db, ob = AsylumTracker.timers.defiling_blast, AsylumTracker.timers.oppressive_bolts
     local db_end, ob_end, ec_end = AsylumTracker.endTimes.defiling_blast, AsylumTracker.endTimes.oppressive_bolts
     if (ob > db) then
          if (ob - db < 7) and (ob - db >= 2) and (db > 0) then
               SetTimer("oppressive_bolts", ob + (7 - (ob - db)), ob_end + (7 - (ob_end - db_end)))
               dbg("[ob > db]: Updated Oppressive Bolts timer to: " .. AsylumTracker.timers.oppressive_bolts)
          end
     end
end

local function UpdateTimers()
     if AsylumTracker.isInCombat then
          if AsylumTracker.sv.adjust_timers_olms then AdjustTimersOlms() end
          if AsylumTracker.sv.adjust_timers_llothis then AdjustTimersLlothis() end
          if AsylumTracker.sv.maim then SetMaimedStatus() end
          for key, value in pairs(AsylumTracker.timers) do -- The key is the ability and the value is the endTime for the event
               if AsylumTracker.timers[key] > 0 then -- If there is a timer for the specified key event
                    AsylumTracker.timers[key] = (AsylumTracker.endTimes[key] - GetGameTimeSeconds())
                    if AsylumTracker.timers[key] < 0 then SetTimer(key, 0) end
                    local timeRemaining = AsylumTracker.timers[key]
                    dbgtimers(key .. ": " .. round(timeRemaining, 3))
                    if key == "storm_the_heavens" and timeRemaining < 6 and AsylumTracker.sv.storm_the_heavens then
                         AsylumTrackerStorm:SetHidden(false)
                         if timeRemaining >= 1 then
                              AsylumTrackerStormLabel:SetText(GetString(AST_NOTIF_KITE) .. "|c" .. RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. math.floor(timeRemaining) .. "|r")
                         else
                              AsylumTrackerStormLabel:SetText(GetString(AST_NOTIF_KITE) .. "|c" .. RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. GetString(AST_SETT_SOON).. "|r")
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
                              AsylumTrackerBlastLabel:SetText(GetString(AST_NOTIF_BLAST) .. "|c" .. RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. math.floor(timeRemaining) .. "|r")
                              AsylumTrackerBlast:SetHidden(false)
                         else
                              AsylumTrackerBlastLabel:SetText(GetString(AST_NOTIF_BLAST) .. "|c" .. RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. GetString(AST_SETT_SOON) .. "|r")
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
                              AsylumTrackerTeleportStrikeLabel:SetText(GetString(AST_NOTIF_JUMP) .. "|c" .. RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. math.floor(timeRemaining) .. "|r")
                              AsylumTrackerTeleportStrike:SetHidden(false)
                         else
                              AsylumTrackerTeleportStrikeLabel:SetText(GetString(AST_NOTIF_JUMP) .. "|c" .. RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. GetString(AST_SETT_SOON) .. "|r")
                              AsylumTrackerTeleportStrike:SetHidden(false)
                         end
                    elseif key == "oppressive_bolts" then
                         AsylumTrackerOppressiveBolts:SetHidden(false)
                         if timeRemaining >= 1 then
                              AsylumTrackerOppressiveBoltsLabel:SetText(GetString(AST_NOTIF_BOLTS) .. "|c" .. RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. math.floor(timeRemaining) .. "|r")
                         else
                              AsylumTrackerOppressiveBoltsLabel:SetText(GetString(AST_NOTIF_BOLTS) .. "|c" .. RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. GetString(AST_SETT_SOON) .. "|r")
                         end
                    elseif key == "exhaustive_charges" and timeRemaining < 6 and AsylumTracker.sv.exhaustive_charges then
                         if timeRemaining >= 1 then
                              AsylumTrackerChargesLabel:SetText(GetString(AST_NOTIF_CHARGES) .. "|c" .. RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. math.floor(timeRemaining) .. "|r")
                              AsylumTrackerCharges:SetHidden(false)
                         else
                              AsylumTrackerChargesLabel:SetText(GetString(AST_NOTIF_CHARGES) .. "|c" .. RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. GetString(AST_SETT_SOON) .. "|r")
                              AsylumTrackerCharges:SetHidden(false)
                         end
                    elseif key == "scalding_roar" and timeRemaining < 6 and AsylumTracker.sv.scalding_roar then
                         if timeRemaining >= 1 then
                              AsylumTrackerSteamLabel:SetText(GetString(AST_NOTIF_STEAM) .. "|c" .. RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. math.floor(timeRemaining) .. "|r")
                              AsylumTrackerSteam:SetHidden(false)
                         else
                              AsylumTrackerSteamLabel:SetText(GetString(AST_NOTIF_STEAM) .. "|c" .. RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. GetString(AST_SETT_SOON) .. "|r")
                              AsylumTrackerSteam:SetHidden(false)
                         end
                    elseif key == "llothis_dormant" then
                         if timeRemaining == 10 then
                              if AsylumTracker.sv["llothis_notifications"] then
                                   CreateNotification("|cff9933" .. GetString(AST_NOTIF_LLOTHIS_IN_10) .. "|r", 3000, 5, HIGH_PRIORITY)
                              end
                         elseif timeRemaining == 5 then
                              if AsylumTracker.sv["llothis_notifications"] then
                                   CreateNotification("|cff9933" .. GetString(AST_NOTIF_LLOTHIS_IN_5) .. "|r", 3000, 5, HIGH_PRIORITY)
                              end
                         end
                    elseif key == "felms_dormant" then
                         if timeRemaining == 10 then
                              if AsylumTracker.sv["felms_notifications"] then
                                   CreateNotification("|cff9933" .. GetString(AST_NOTIF_FELMS_IN_10) .. "|r", 3000, 5, HIGH_PRIORITY)
                              end
                         elseif timeRemaining == 5 then
                              if AsylumTracker.sv["felms_notifications"] then
                                   CreateNotification("|cff9933" .. GetString(AST_NOTIF_FELMS_IN_5) .. "|r", 3000, 5, HIGH_PRIORITY)
                              end
                         end
                    elseif key == "maim" then
                         if timeRemaining >= 0.5 then
                              if AsylumTracker.sv["maim"] then
                                   AsylumTrackerMaimLabel:SetText(GetString(AST_NOTIF_MAIM) .. "|c" .. RGBToHex(unpack(AsylumTracker.sv.color_timer)) .. math.floor(timeRemaining) .. "|r")
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

          local bossName = zo_strformat("<<C:1>>", GetUnitName("boss1"))
          if bossName ~= "" then -- HP for Boss1 (Since the addon only loads in Asylum, this works to determining if you're in the room with Olms, because if you are not, this function returns an empty string)
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
     else -- If not in Asylum AND in combat, clear any running timers
          for key, value in pairs(AsylumTracker.timers) do
               SetTimer(key, 0)
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
               dbg("Resetting Llothis and Felms spawn status")

               AsylumTracker.unitIds = {}
               AsylumTracker.dbgunits("Leaving Combat. Clearing Units Table")
               AsylumTracker.spawnTimes = {}
          end
     end
end

function AsylumTracker.OnCombatEvent(_, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)
     if result == ACTION_RESULT_INTERRUPT and AsylumTracker.sv.oppressive_bolts then
          AsylumTrackerOppressiveBoltsLabel:SetText(AsylumTracker.sv["interrupt_message"])
          zo_callLater(function() SetTimer("oppressive_bolts") end, 1000)
          return
     end
     if result == ACTION_RESULT_BEGIN then
          if abilityId == AsylumTracker.id["storm_the_heavens"] then
               if not AsylumTracker.stormIsActive and AsylumTracker.sv["sound_enabled"] then
                    PlaySound(SOUNDS.BATTLEGROUND_COUNTDOWN_FINISH)
               end
               AsylumTracker.stormIsActive = true
               SetTimer("storm_the_heavens") -- Storm the Heavens just started, so create a new timer to preemtively warn for the next Storm the Heavens
               dbgability(abilityId, result, hitValue)
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
               SetTimer("defiling_blast")
               dbgability(abilityId, result, hitValue)
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
               SetTimer("oppressive_bolts", 0)
               dbgability(abilityId, result, hitValue)
               AsylumTrackerOppressiveBoltsLabel:SetText("|cff0000" .. GetString(AST_NOTIF_INTERRUPT) .. "|r")
               AsylumTrackerOppressiveBolts:SetHidden(false)

          elseif abilityId == AsylumTracker.id["teleport_strike"] then
               targetName = UnitIdToName(targetUnitId)
               if targetName:sub(1, 1) == "#" then targetName = GetString(AST_SETT_YOU) end
               if targetName == zo_strformat("<<C:1>>", AsylumTracker.displayName) then targetName = GetString(AST_SETT_YOU) end
               if not AsylumTracker.FelmsSpawned then AsylumTracker.FelmsSpawned = true end
               SetTimer("teleport_strike")
               dbgability(abilityId, result, hitValue)
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
               dbgability(abilityId, result, hitValue)
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
                              SetTimer("storm_the_heavens", 15)
                         end
                    end
               end

          elseif abilityId == AsylumTracker.id["trial_by_fire"] then
               AsylumTrackerFireLabel:SetText(GetString(AST_NOTIF_FIRE))
               dbgability(abilityId, result, hitValue)
               AsylumTrackerFire:SetHidden(false)
               zo_callLater(function() AsylumTrackerFire:SetHidden(true) end, 8000)

          elseif abilityId == AsylumTracker.id["scalding_roar"] and hitValue == 2300 then
               SetTimer("scalding_roar")
               if AsylumTracker.sv.scalding_roar then
                    dbgability(abilityId, result, hitValue)
                    AsylumTrackerSteamLabel:SetText(GetString(AST_NOTIF_STEAM) .. "|cff0000" .. GetString(AST_SETT_NOW) .. "|r")
                    AsylumTrackerSteam:SetHidden(false)
                    zo_callLater(function() AsylumTrackerSteam:SetHidden(true) end, 5000)
               end

          elseif abilityId == AsylumTracker.id["exhaustive_charges"] then
               SetTimer("exhaustive_charges")
               if AsylumTracker.sv.exhaustive_charges then
                    dbgability(abilityId, result, hitValue)
                    AsylumTrackerChargesLabel:SetText(GetString(AST_NOTIF_CHARGES) .. "|cff0000" .. GetString(AST_SETT_NOW) .. "|r")
                    AsylumTrackerCharges:SetHidden(false)
                    zo_callLater(function() AsylumTrackerCharges:SetHidden(true) end, 2000)
               end
          end
     end
     if result == ACTION_RESULT_EFFECT_GAINED then
          if abilityId == AsylumTracker.id["static_shield"] then -- Instead of tracking when the protector spawns, I track when the protector gives Olms a shield
               AsylumTracker.sphereIsUp = true -- If Olms has a shield, then a protector is active
               dbgability(abilityId, result, hitValue)
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
               SetTimer("oppressive_bolts")
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
                         SetTimer("defiling_blast", 12 - llothis_uptime)
                    end
                    if AsylumTracker.sv.oppressive_bolts then
                         SetTimer("oppressive_bolts", 12 - llothis_uptime)
                         AsylumTrackerOppressiveBolts:SetHidden(false)
                    end
               end
          end
     elseif unitName:find("Felms") or unitName:find("フェルムス") or unitName:find("фелмс") then
          if not AsylumTracker.FelmsSpawned then
               AsylumTracker.FelmsSpawned = true
               if AsylumTracker.spawnTimes[unitId] then
                    local felms_uptime = GetGameTimeSeconds() - AsylumTracker.spawnTimes[unitId]
                    if AsylumTracker.sv.teleport_strike then
                         SetTimer("teleport_strike", 12 - felms_uptime)
                    end
               end
          end
     end

     if abilityId == AsylumTracker.id["dormant"] then
          if changeType == EFFECT_RESULT_GAINED then
               if unitName:find("Llothis") or unitName:find("ロシス") or unitName:find("ллотис") then
                    if AsylumTracker.sv.defiling_blast then SetTimer("defiling_blast", 45) end
                    if AsylumTracker.sv.oppressive_bolts then SetTimer("oppressive_bolts", 45) end
                    SetTimer("llothis_dormant")
                    if AsylumTracker.sv["llothis_notifications"] then
                         CreateNotification("|c00ff00" .. GetString(AST_NOTIF_LLOTHIS_DOWN) .. "|r", 3000, 5, MED_PRIORITY)
                    end
               elseif unitName:find("Felms") or unitName:find("フェルムス") or unitName:find("фелмс") then
                    if AsylumTracker.sv.teleport_strike then
                         SetTimer("teleport_strike", 45)
                         AsylumTrackerTeleportStrike:SetHidden(true)
                    end
                    SetTimer("felms_dormant")
                    if AsylumTracker.sv["felms_notifications"] then
                         CreateNotification("|c00ff00" .. GetString(AST_NOTIF_FELMS_DOWN) .. "|r", 3000, 5, MED_PRIORITY)
                    end
               end
          elseif changeType == EFFECT_RESULT_FADED then
               if unitName:find("Llothis") or unitName:find("ロシス") or unitName:find("ллотис") then
                    SetTimer("llothis_dormant", 0)
                    if AsylumTracker.sv["llothis_notifications"] then
                         CreateNotification("|c00ff00" .. GetString(AST_NOTIF_LLOTHIS_UP) .. "|r", 3000, 5, MED_PRIORITY)
                    end
               elseif unitName:find("Felms") or unitName:find("フェルムス") or unitName:find("фелмс") then
                    SetTimer("felms_dormant", 0)
                    if AsylumTracker.sv["felms_notifications"] then
                         CreateNotification("|c00ff00" .. GetString(AST_NOTIF_FELMS_UP) .. "|r", 3000, 5, MED_PRIORITY)
                    end
               end
          end
     end
end

function AsylumTracker.RegisterEvents()
     if AsylumTracker.isInVAS then -- Only register events if player is in Asylum to save resources
          local abilities = {} -- Stores event ids to be registered
          local eventName = AsylumTracker.name .. "_event_" -- Each filter must be registered separately, and must therefore have a different unique identifier.
          local eventIndex = 0
          local function RegisterForAbility(abilityId)
               if not abilities[abilityId] then -- If ability has not yet been registered
                    abilities[abilityId] = true
                    eventIndex = eventIndex + 1
                    EVENT_MANAGER:RegisterForEvent(eventName .. eventIndex, EVENT_COMBAT_EVENT, AsylumTracker.OnCombatEvent) -- Registers all combat events
                    EVENT_MANAGER:AddFilterForEvent(eventName .. eventIndex, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, abilityId) -- Filters the event to a specific ability
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

          EVENT_MANAGER:RegisterForEvent(AsylumTracker.name, EVENT_PLAYER_COMBAT_STATE, AsylumTracker.CombatState) -- Used to determine player's combat state
          EVENT_MANAGER:RegisterForEvent(AsylumTracker.name .. "_dormant", EVENT_EFFECT_CHANGED, AsylumTracker.OnEffectChanged) -- Used to determine if Llothis/Felms go down
          EVENT_MANAGER:RegisterForEvent(AsylumTracker.name .. "_bossaura", EVENT_COMBAT_EVENT, AsylumTracker.OnCombatEvent)
          EVENT_MANAGER:AddFilterForEvent(AsylumTracker.name .. "_bossaura", EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, AsylumTracker.id.boss_event)
          EVENT_MANAGER:RegisterForUpdate(AsylumTracker.name, AsylumTracker.refreshRate, UpdateTimers) -- Calls this function every half second to update timers and Olm's health
     end
end

-- Unregisters events if not in Asylum Sanctorium
function AsylumTracker.UnregisterEvents()
     if not AsylumTracker.isInVAS then
          local eventName = AsylumTracker.name .. "_event_"
          eventIndex = 0
          for x, y in pairs(AsylumTracker.id) do
               eventIndex = eventIndex + 1
               EVENT_MANAGER:UnregisterForEvent(eventName .. eventIndex, EVENT_COMBAT_EVENT)
          end

          EVENT_MANAGER:UnregisterForEvent(AsylumTracker.name, EVENT_PLAYER_COMBAT_STATE, AsylumTracker.CombatState)
          EVENT_MANAGER:UnregisterForEvent(AsylumTracker.name, EVENT_EFFECT_CHANGED, AsylumTracker.OnEffectChanged)
          EVENT_MANAGER:UnregisterForUpdate(AsylumTracker.name)
     end
end

function AsylumTracker.ToggleMovable()
     AsylumTracker.isMovable = not AsylumTracker.isMovable
     if AsylumTracker.isMovable then
          local hex_olms_hp = RGBToHex(unpack(AsylumTracker.sv["color_olms_hp"]))
          local hex_olms_hp2 = RGBToHex(unpack(AsylumTracker.sv["color_olms_hp2"]))
          AsylumTrackerOlmsHPLabel:SetText("|c" .. hex_olms_hp .. GetString(AST_PREVIEW_OLMS_HP_1) .. "|r|c" .. hex_olms_hp2 .. GetString(AST_PREVIEW_OLMS_HP_2) .. "|r")
          local hex_storm = RGBToHex(unpack(AsylumTracker.sv["color_storm"]))
          local hex_storm2 = RGBToHex(unpack(AsylumTracker.sv["color_storm2"]))
          AsylumTrackerStormLabel:SetText("|c" .. hex_storm .. GetString(AST_PREVIEW_STORM_1) .. "|r|c" .. hex_storm2 .. GetString(AST_PREVIEW_STORM_2) .. "|r")
          AsylumTrackerBlastLabel:SetText(GetString(AST_PREVIEW_BLAST))
          local hex_sphere = RGBToHex(unpack(AsylumTracker.sv["color_sphere"]))
          local hex_sphere2 = RGBToHex(unpack(AsylumTracker.sv["color_sphere2"]))
          AsylumTrackerSphereLabel:SetText("|c" .. hex_sphere .. GetString(AST_PREVIEW_SPHERE_1) .. "|r|c" .. hex_sphere2 .. GetString(AST_PREVIEW_SPHERE_2) .. "|r")
          AsylumTrackerTeleportStrikeLabel:SetText(GetString(AST_PREVIEW_JUMP))
          AsylumTrackerOppressiveBoltsLabel:SetText(GetString(AST_PREVIEW_BOLTS))
          AsylumTrackerFireLabel:SetText(GetString(AST_PREVIEW_FIRE))
          AsylumTrackerSteamLabel:SetText(GetString(AST_PREVIEW_STEAM))
          AsylumTrackerMaimLabel:SetText(GetString(AST_PREVIEW_MAIM))
          AsylumTrackerChargesLabel:SetText(GetString(AST_PREVIEW_CHARGES))

          AsylumTracker.SetFontSize()

          AsylumTrackerOlmsHP:SetMovable(true)
          if AsylumTracker.sv["storm_the_heavens"] then AsylumTrackerStorm:SetMovable(true) end
          if AsylumTracker.sv["defiling_blast"] then AsylumTrackerBlast:SetMovable(true) end
          if AsylumTracker.sv["static_shield"] then AsylumTrackerSphere:SetMovable(true) end
          if AsylumTracker.sv["teleport_strike"] then AsylumTrackerTeleportStrike:SetMovable(true) end
          if AsylumTracker.sv["oppressive_bolts"] then AsylumTrackerOppressiveBolts:SetMovable(true) end
          if AsylumTracker.sv["trial_by_fire"] then AsylumTrackerFire:SetMovable(true) end
          if AsylumTracker.sv["scalding_roar"] then AsylumTrackerSteam:SetMovable(true) end
          if AsylumTracker.sv["maim"] then AsylumTrackerMaim:SetMovable(true) end
          if AsylumTracker.sv["exhaustive_charges"] then AsylumTrackerCharges:SetMovable(true) end

          AsylumTrackerOlmsHP:SetHidden(false)
          if AsylumTracker.sv["storm_the_heavens"] then AsylumTrackerStorm:SetHidden(false) end
          if AsylumTracker.sv["defiling_blast"] then AsylumTrackerBlast:SetHidden(false) end
          if AsylumTracker.sv["static_shield"] then AsylumTrackerSphere:SetHidden(false) end
          if AsylumTracker.sv["teleport_strike"] then AsylumTrackerTeleportStrike:SetHidden(false) end
          if AsylumTracker.sv["oppressive_bolts"] then AsylumTrackerOppressiveBolts:SetHidden(false) end
          if AsylumTracker.sv["trial_by_fire"] then AsylumTrackerFire:SetHidden(false) end
          if AsylumTracker.sv["scalding_roar"] then AsylumTrackerSteam:SetHidden(false) end
          if AsylumTracker.sv["maim"] then AsylumTrackerMaim:SetHidden(false) end
          if AsylumTracker.sv["exhaustive_charges"] then AsylumTrackerCharges:SetHidden(false) end
     else
          AsylumTrackerOlmsHP:SetMovable(false)
          AsylumTrackerStorm:SetMovable(false)
          AsylumTrackerBlast:SetMovable(false)
          AsylumTrackerSphere:SetMovable(false)
          AsylumTrackerTeleportStrike:SetMovable(false)
          AsylumTrackerOppressiveBolts:SetMovable(false)
          AsylumTrackerFire:SetMovable(false)
          AsylumTrackerSteam:SetMovable(false)
          AsylumTrackerMaim:SetMovable(false)
          AsylumTrackerCharges:SetMovable(false)

          AsylumTrackerOlmsHP:SetHidden(true)
          AsylumTrackerStorm:SetHidden(true)
          AsylumTrackerBlast:SetHidden(true)
          AsylumTrackerSphere:SetHidden(true)
          AsylumTrackerTeleportStrike:SetHidden(true)
          AsylumTrackerOppressiveBolts:SetHidden(true)
          AsylumTrackerFire:SetHidden(true)
          AsylumTrackerSteam:SetHidden(true)
          AsylumTrackerMaim:SetHidden(true)
          AsylumTrackerCharges:SetHidden(true)
     end
end

function AsylumTracker.SetFontSize()
     local path = "EsoUI/Common/Fonts/univers67.otf"
     local outline = "soft-shadow-thick"
     AsylumTrackerOlmsHPLabel:SetFont(path .. "|" .. AsylumTracker.sv.font_size_olms_hp .. "|" .. outline)
     AsylumTrackerStormLabel:SetFont(path .. "|" .. AsylumTracker.sv.font_size_storm .. "|" .. outline)
     AsylumTrackerBlastLabel:SetFont(path .. "|" .. AsylumTracker.sv.font_size_blast .. "|" .. outline)
     AsylumTrackerSphereLabel:SetFont(path .. "|" .. AsylumTracker.sv.font_size_sphere .. "|" .. outline)
     AsylumTrackerTeleportStrikeLabel:SetFont(path .. "|" .. AsylumTracker.sv.font_size_teleport_strike .. "|" .. outline)
     AsylumTrackerOppressiveBoltsLabel:SetFont(path .. "|" .. AsylumTracker.sv.font_size_oppressive_bolts .. "|" .. outline)
     AsylumTrackerFireLabel:SetFont(path .. "|" .. AsylumTracker.sv.font_size_fire .. "|" .. outline)
     AsylumTrackerSteamLabel:SetFont(path .. "|" .. AsylumTracker.sv.font_size_scalding_roar .. "|" .. outline)
     AsylumTrackerMaimLabel:SetFont(path .. "|" .. AsylumTracker.sv.font_size_maim .. "|" .. outline)
     AsylumTrackerChargesLabel:SetFont(path .. "|" .. AsylumTracker.sv.font_size_exhaustive_charges .. "|" .. outline)

     AsylumTrackerOlmsHP:SetDimensions(AsylumTrackerOlmsHPLabel:GetTextWidth(), AsylumTrackerOlmsHPLabel:GetTextHeight())
     AsylumTrackerStorm:SetDimensions(AsylumTrackerStormLabel:GetTextWidth(), AsylumTrackerStormLabel:GetTextHeight())
     AsylumTrackerBlast:SetDimensions(AsylumTrackerBlastLabel:GetTextWidth(), AsylumTrackerBlastLabel:GetTextHeight())
     AsylumTrackerSphere:SetDimensions(AsylumTrackerSphereLabel:GetTextWidth(), AsylumTrackerSphereLabel:GetTextHeight())
     AsylumTrackerTeleportStrike:SetDimensions(AsylumTrackerTeleportStrikeLabel:GetTextWidth(), AsylumTrackerTeleportStrikeLabel:GetTextHeight())
     AsylumTrackerOppressiveBolts:SetDimensions(AsylumTrackerOppressiveBoltsLabel:GetTextWidth(), AsylumTrackerOppressiveBoltsLabel:GetTextHeight())
     AsylumTrackerFire:SetDimensions(AsylumTrackerFireLabel:GetTextWidth(), AsylumTrackerFireLabel:GetTextHeight())
     AsylumTrackerSteam:SetDimensions(AsylumTrackerSteamLabel:GetTextWidth(), AsylumTrackerSteamLabel:GetTextHeight())
     AsylumTrackerMaim:SetDimensions(AsylumTrackerMaimLabel:GetTextWidth(), AsylumTrackerMaimLabel:GetTextHeight())
     AsylumTrackerCharges:SetDimensions(AsylumTrackerChargesLabel:GetTextWidth(), AsylumTrackerChargesLabel:GetTextHeight())
end

function AsylumTracker.SetScale(label, scale)
     local label = label
     local size = size
     label:SetScale(scale)
end

function AsylumTracker.ResetAnchors()
     AsylumTrackerOlmsHP:ClearAnchors()
     AsylumTrackerStorm:ClearAnchors()
     AsylumTrackerBlast:ClearAnchors()
     AsylumTrackerSphere:ClearAnchors()
     AsylumTrackerTeleportStrike:ClearAnchors()
     AsylumTrackerOppressiveBolts:ClearAnchors()
     AsylumTrackerFire:ClearAnchors()
     AsylumTrackerSteam:ClearAnchors()
     AsylumTrackerMaim:ClearAnchors()
     AsylumTrackerCharges:ClearAnchors()

     AsylumTrackerOlmsHP:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, AsylumTracker.sv["olms_hp_offsetX"], AsylumTracker.sv["olms_hp_offsetY"])
     AsylumTrackerStorm:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, AsylumTracker.sv["storm_offsetX"], AsylumTracker.sv["storm_offsetY"])
     AsylumTrackerBlast:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, AsylumTracker.sv["blast_offsetX"], AsylumTracker.sv["blast_offsetY"])
     AsylumTrackerSphere:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, AsylumTracker.sv["sphere_offsetX"], AsylumTracker.sv["sphere_offsetY"])
     AsylumTrackerTeleportStrike:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, AsylumTracker.sv["teleport_strike_offsetX"], AsylumTracker.sv["teleport_strike_offsetY"])
     AsylumTrackerOppressiveBolts:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, AsylumTracker.sv["oppressive_bolts_offsetX"], AsylumTracker.sv["oppressive_bolts_offsetY"])
     AsylumTrackerFire:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, AsylumTracker.sv["fire_offsetX"], AsylumTracker.sv["fire_offsetY"])
     AsylumTrackerSteam:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, AsylumTracker.sv["steam_offsetX"], AsylumTracker.sv["steam_offsetY"])
     AsylumTrackerMaim:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, AsylumTracker.sv["maim_offsetX"], AsylumTracker.sv["maim_offsetY"])
     AsylumTrackerCharges:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, AsylumTracker.sv["exhaustive_charges_offsetX"], AsylumTracker.sv["exhaustive_charges_offsetY"])
end

function AsylumTracker.SavePosition()
     AsylumTracker.sv["olms_hp_offsetX"] = AsylumTrackerOlmsHP:GetLeft()
     AsylumTracker.sv["olms_hp_offsetY"] = AsylumTrackerOlmsHP:GetTop()
     AsylumTracker.sv["storm_offsetX"] = AsylumTrackerStorm:GetLeft()
     AsylumTracker.sv["storm_offsetY"] = AsylumTrackerStorm:GetTop()
     AsylumTracker.sv["blast_offsetX"] = AsylumTrackerBlast:GetLeft()
     AsylumTracker.sv["blast_offsetY"] = AsylumTrackerBlast:GetTop()
     AsylumTracker.sv["sphere_offsetX"] = AsylumTrackerSphere:GetLeft()
     AsylumTracker.sv["sphere_offsetY"] = AsylumTrackerSphere:GetTop()
     AsylumTracker.sv["teleport_strike_offsetX"] = AsylumTrackerTeleportStrike:GetLeft()
     AsylumTracker.sv["teleport_strike_offsetY"] = AsylumTrackerTeleportStrike:GetTop()
     AsylumTracker.sv["oppressive_bolts_offsetX"] = AsylumTrackerOppressiveBolts:GetLeft()
     AsylumTracker.sv["oppressive_bolts_offsetY"] = AsylumTrackerOppressiveBolts:GetTop()
     AsylumTracker.sv["fire_offsetX"] = AsylumTrackerFire:GetLeft()
     AsylumTracker.sv["fire_offsetY"] = AsylumTrackerFire:GetTop()
     AsylumTracker.sv["steam_offsetX"] = AsylumTrackerSteam:GetLeft()
     AsylumTracker.sv["steam_offsetY"] = AsylumTrackerSteam:GetTop()
     AsylumTracker.sv["maim_offsetX"] = AsylumTrackerMaim:GetLeft()
     AsylumTracker.sv["maim_offsetY"] = AsylumTrackerMaim:GetTop()
     AsylumTracker.sv["exhaustive_charges_offsetX"] = AsylumTrackerCharges:GetLeft()
     AsylumTracker.sv["exhaustive_charges_offsetY"] = AsylumTrackerCharges:GetTop()
end

function AsylumTracker.ResetToDefaults()
     AsylumTracker.sv["olms_hp_offsetX"] = AsylumTracker.defaults["olms_hp_offsetX"]
     AsylumTracker.sv["olms_hp_offsetY"] = AsylumTracker.defaults["olms_hp_offsetY"]
     AsylumTracker.sv["storm_offsetX"] = AsylumTracker.defaults["storm_offsetX"]
     AsylumTracker.sv["storm_offsetY"] = AsylumTracker.defaults["storm_offsetY"]
     AsylumTracker.sv["blast_offsetX"] = AsylumTracker.defaults["blast_offsetX"]
     AsylumTracker.sv["blast_offsetY"] = AsylumTracker.defaults["blast_offsetY"]
     AsylumTracker.sv["sphere_offsetX"] = AsylumTracker.defaults["sphere_offsetX"]
     AsylumTracker.sv["sphere_offsetY"] = AsylumTracker.defaults["sphere_offsetY"]
     AsylumTracker.sv["teleport_strike_offsetX"] = AsylumTracker.defaults["teleport_strike_offsetX"]
     AsylumTracker.sv["teleport_strike_offsetY"] = AsylumTracker.defaults["teleport_strike_offsetY"]
     AsylumTracker.sv["oppressive_bolts_offsetX"] = AsylumTracker.defaults["oppressive_bolts_offsetX"]
     AsylumTracker.sv["oppressive_bolts_offsetY"] = AsylumTracker.defaults["oppressive_bolts_offsetY"]
     AsylumTracker.sv["fire_offsetX"] = AsylumTracker.defaults["fire_offsetX"]
     AsylumTracker.sv["fire_offsetY"] = AsylumTracker.defaults["fire_offsetY"]
     AsylumTracker.sv["steam_offsetX"] = AsylumTracker.defaults["steam_offsetX"]
     AsylumTracker.sv["steam_offsetY"] = AsylumTracker.defaults["steam_offsetY"]
     AsylumTracker.sv["maim_offsetX"] = AsylumTracker.defaults["maim_offsetX"]
     AsylumTracker.sv["maim_offsetY"] = AsylumTracker.defaults["maim_offsetY"]
     AsylumTracker.sv["exhaustive_charges_offsetX"] = AsylumTracker.defaults["exhaustive_charges_offsetX"]
     AsylumTracker.sv["exhaustive_charges_offsetY"] = AsylumTracker.defaults["exhaustive_charges_offsetY"]

     AsylumTracker.ResetAnchors()
end

-- Initialization function
function AsylumTracker.Initialize()
     AsylumTracker.savedVars = ZO_SavedVars:NewCharacterIdSettings("AsylumTrackerVars", AsylumTracker.variableVersion, nil, AsylumTracker.defaults) -- Defines saved variables
     AsylumTracker.sv = AsylumTrackerVars["Default"][GetDisplayName()][GetCurrentCharacterId()]
     AsylumTracker.CreateSettingsWindow() -- Creates the addon settings menu
     AsylumTracker.RegisterUnitIndexing()
     AsylumTracker.ResetAnchors()

     AsylumTracker.SetFontSize()

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

function AsylumTracker.SlashCommand(cmd)
     cmd = string.lower(cmd)
     if cmd == "menu" then
          AsylumTracker.OpenSettingsPanel()
     elseif cmd == "toggle" then
          AsylumTracker.ToggleMovable()
     elseif cmd == "reset" then
          AsylumTracker.ResetToDefaults()
     elseif cmd == "debug status" then
          d("|cff0096AsylumTracker ::|r General Debugging:  |cff0096" .. tostring(AsylumTracker.sv.debug) .. "|r")
          d("|cff0096AsylumTracker ::|r Ability Debugging: |cff0096" .. tostring(AsylumTracker.sv.debug_ability) .. "|r")
          d("|cff0096AsylumTracker ::|r Timers Debugging: |cff0096" .. tostring(AsylumTracker.sv.debug_timers) .. "|r")
          d("|cff0096AsylumTracker ::|r Units Debugging: |cff0096" .. tostring(AsylumTracker.sv.debug_units) .. "|r")
     elseif cmd == "debug general" then
          AsylumTracker.sv.debug = not AsylumTracker.sv.debug
          d("|cff0096AsylumTracker ::|r General Debugging:  |cff0096" .. tostring(AsylumTracker.sv.debug) .. "|r")
     elseif cmd == "debug ability" then
          AsylumTracker.sv.debug_ability = not AsylumTracker.sv.debug_ability
          d("|cff0096AsylumTracker ::|r Ability Debugging: |cff0096" .. tostring(AsylumTracker.sv.debug_ability) .. "|r")
     elseif cmd == "debug timers" then
          AsylumTracker.sv.debug_timers = not AsylumTracker.sv.debug_timers
          d("|cff0096AsylumTracker ::|r Timers Debugging: |cff0096" .. tostring(AsylumTracker.sv.debug_timers) .. "|r")
     elseif cmd == "debug units" then
          AsylumTracker.sv.debug_units = not AsylumTracker.sv.debug_units
          d("|cff0096AsylumTracker ::|r Units Debugging: |cff0096" .. tostring(AsylumTracker.sv.debug_units) .. "|r")
     elseif cmd == "debug all on" then
          AsylumTracker.sv.debug = true
          d("|cff0096AsylumTracker ::|r General Debugging:  |cff0096" .. tostring(AsylumTracker.sv.debug) .. "|r")
          AsylumTracker.sv.debug_ability = true
          d("|cff0096AsylumTracker ::|r Ability Debugging: |cff0096" .. tostring(AsylumTracker.sv.debug_ability) .. "|r")
          AsylumTracker.sv.debug_timers = true
          d("|cff0096AsylumTracker ::|r Timers Debugging: |cff0096" .. tostring(AsylumTracker.sv.debug_timers) .. "|r")
          AsylumTracker.sv.debug_units = true
          d("|cff0096AsylumTracker ::|r Units Debugging: |cff0096" .. tostring(AsylumTracker.sv.debug_units) .. "|r")
     elseif cmd == "debug all off" then
          AsylumTracker.sv.debug = false
          d("|cff0096AsylumTracker ::|r General Debugging:  |cff0096" .. tostring(AsylumTracker.sv.debug) .. "|r")
          AsylumTracker.sv.debug_ability = false
          d("|cff0096AsylumTracker ::|r Ability Debugging: |cff0096" .. tostring(AsylumTracker.sv.debug_ability) .. "|r")
          AsylumTracker.sv.debug_timers = false
          d("|cff0096AsylumTracker ::|r Timers Debugging: |cff0096" .. tostring(AsylumTracker.sv.debug_timers) .. "|r")
          AsylumTracker.sv.debug_units = false
          d("|cff0096AsylumTracker ::|r Units Debugging: |cff0096" .. tostring(AsylumTracker.sv.debug_units) .. "|r")
     elseif cmd == "storm on" then
          AsylumTracker.sv.storm_the_heavens = true
          d("|cff0096AsylumTracker ::|r Storm the Heavens:  |cff0096" .. tostring(AsylumTracker.sv.storm_the_heavens) .. "|r")
     elseif cmd == "storm off" then
          AsylumTracker.sv.storm_the_heavens = false
          d("|cff0096AsylumTracker ::|r Storm the Heavens:  |cff0096" .. tostring(AsylumTracker.sv.storm_the_heavens) .. "|r")
     elseif cmd == "blast on" then
          AsylumTracker.sv.defiling_blast = true
          d("|cff0096AsylumTracker ::|r Defiling Blast:  |cff0096" .. tostring(AsylumTracker.sv.defiling_blast) .. "|r")
     elseif cmd == "blast off" then
          AsylumTracker.sv.defiling_blast = false
          d("|cff0096AsylumTracker ::|r Defiling Blast:  |cff0096" .. tostring(AsylumTracker.sv.defiling_blast) .. "|r")
     elseif cmd == "protector on" then
          AsylumTracker.sv.static_shield = true
          d("|cff0096AsylumTracker ::|r Protector:  |cff0096" .. tostring(AsylumTracker.sv.static_shield) .. "|r")
     elseif cmd == "protector off" then
          AsylumTracker.sv.static_shield = false
          d("|cff0096AsylumTracker ::|r Protector:  |cff0096" .. tostring(AsylumTracker.sv.static_shield) .. "|r")
     elseif cmd == "teleport on" then
          AsylumTracker.sv.teleport_strike = true
          d("|cff0096AsylumTracker ::|r Teleport Strike:  |cff0096" .. tostring(AsylumTracker.sv.teleport_strike) .. "|r")
     elseif cmd == "teleport off" then
          AsylumTracker.sv.teleport_strike = false
          d("|cff0096AsylumTracker ::|r Teleport Strike:  |cff0096" .. tostring(AsylumTracker.sv.teleport_strike) .. "|r")
     elseif cmd == "bolts on" then
          AsylumTracker.sv.oppressive_bolts = true
          d("|cff0096AsylumTracker ::|r Oppressive Bolts:  |cff0096" .. tostring(AsylumTracker.sv.oppressive_bolts) .. "|r")
     elseif cmd == "bolts off" then
          AsylumTracker.sv.oppressive_bolts = false
          d("|cff0096AsylumTracker ::|r Oppressive Bolts:  |cff0096" .. tostring(AsylumTracker.sv.oppressive_bolts) .. "|r")
     elseif cmd == "steam on" then
          AsylumTracker.sv.scalding_roar = true
          d("|cff0096AsylumTracker ::|r Scalding Roar:  |cff0096" .. tostring(AsylumTracker.sv.scalding_roar) .. "|r")
     elseif cmd == "steam off" then
          AsylumTracker.sv.scalding_roar = false
          d("|cff0096AsylumTracker ::|r Scalding Roar:  |cff0096" .. tostring(AsylumTracker.sv.scalding_roar) .. "|r")
     elseif cmd == "charges on" then
          AsylumTracker.sv.exhaustive_charges = true
          d("|cff0096AsylumTracker ::|r Exhaustive Charges:  |cff0096" .. tostring(AsylumTracker.sv.exhaustive_charges) .. "|r")
     elseif cmd == "charges off" then
          AsylumTracker.sv.exhaustive_charges = false
          d("|cff0096AsylumTracker ::|r Exhaustive Charges:  |cff0096" .. tostring(AsylumTracker.sv.exhaustive_charges) .. "|r")
     elseif cmd == "fire on" then
          AsylumTracker.sv.trial_by_fire = true
          d("|cff0096AsylumTracker ::|r Trial by Fire:  |cff0096" .. tostring(AsylumTracker.sv.trial_by_fire) .. "|r")
     elseif cmd == "fire off" then
          AsylumTracker.sv.trial_by_fire = false
          d("|cff0096AsylumTracker ::|r Trial by Fire:  |cff0096" .. tostring(AsylumTracker.sv.trial_by_fire) .. "|r")
     elseif cmd == "maim on" then
          AsylumTracker.sv.maim = true
          d("|cff0096AsylumTracker ::|r Maim:  |cff0096" .. tostring(AsylumTracker.sv.maim) .. "|r")
     elseif cmd == "maim off" then
          AsylumTracker.sv.maim = false
          d("|cff0096AsylumTracker ::|r Maim:  |cff0096" .. tostring(AsylumTracker.sv.maim) .. "|r")
     elseif cmd == "help" then
          d(":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
          d("|cff0096AsylumTracker Commands ::|r")
          d("|cff0096/astracker menu:|r Opens the AsylumTracker Settings panel")
          d("|cff0096/astracker toggle:|r Makes the notifications movable on the screen")
          d("|cff0096/astracker reset:|r Resets notifications to their default positions")
          d(" ")
          d("|cff0096/astracker debug status:|r Shows debugging states")
          d("|cff0096/astracker debug general:|r Toggles general debugging messages")
          d("|cff0096/astracker debug ability:|r Toggles ability debugging messages")
          d("|cff0096/astracker debug timers:|r Toggles timer debugging messages")
          d("|cff0096/astracker debug units:|r Toggles unit debugging messages")
          d("|cff0096/astracker debug all on:|r Enables all debugging messages")
          d("|cff0096/astracker debug all off:|r Disables all debugging messages")
          d(" ")
          d("|cff0096/astracker storm on/off:|r Toggles Storm The Heavens Notification")
          d("|cff0096/astracker blast on/off:|r Toggles Defiling Blast Notification")
          d("|cff0096/astracker protector on/off:|r Toggles Protectors Notification")
          d("|cff0096/astracker teleport on/off:|r Toggles Teleport Strike Notification")
          d("|cff0096/astracker bolts on/off:|r Toggles Oppressive Bolts Notification")
          d("|cff0096/astracker steam on/off:|r Toggles Steam Breath Notification")
          d("|cff0096/astracker charges on/off:|r Toggles Exhaustive Charges Notification")
          d("|cff0096/astracker fire on/off:|r Toggles Trial by Fire Notification")
          d("|cff0096/astracker maim on/off:|r Toggles Maim Notification")
          d(":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
     else
          d("|cff0096AsylumTracker ::|r Invalid Command. Type: |cff0096/astracker help|r for usage")
     end
end

function AsylumTracker.OnAddOnLoaded(event, addonName)
     if AsylumTracker.name ~= addonName then return end
     CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged", OnZoneChanged) -- Registers the callback used to determine which zone the player is in.
     AsylumTracker.Initialize()
     EVENT_MANAGER:UnregisterForEvent(AsylumTracker.name, EVENT_ADD_ON_LOADED) -- Unregisters the OnAddOnLoaded Function
end

EVENT_MANAGER:RegisterForEvent(AsylumTracker.name, EVENT_ADD_ON_LOADED, AsylumTracker.OnAddOnLoaded)
