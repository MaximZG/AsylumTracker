local AsylumTracker = AsylumTracker

function AsylumTracker.CreateSettingsWindow()
     local LAM2 = LibAddonMenu2
     local sv = AsylumTrackerVars["Default"][GetDisplayName()][GetCurrentCharacterId()]

     local panelData = {
          type = "panel",
          name = "Asylum Tracker",
          displayName = AST_SETT_HEADER,
          author = AsylumTracker.author,
          version = AsylumTracker.version,
          slashCommand = "/astracker",
          registerForRefresh = true,
     }
     LAM2:RegisterAddonPanel(AsylumTracker.name .. "Settings", panelData)

     local Settings = {
          {
               type = "header",
               name = AST_SETT_INFO,
               width = "full"
          },
          {
               type = "description",
               text = AST_SETT_DESCRIPTION,
               width = "full"
          },
          {
               type = "button",
               name = AST_SETT_UNLOCK,
               tooltip = AST_SETT_UNLOCK_TOOL,
               func = function(value)
                    AsylumTracker.ToggleMovable()
                    if not AsylumTracker.isMovable then
                         value:SetText(GetString(AST_SETT_UNLOCK))
                    else
                         value:SetText(GetString(AST_SETT_LOCK))
                    end
               end,
               width = "half",
          },
          {
               type = "button",
               name = AST_SETT_CENTER_NOTIF,
               tooltip = AST_SETT_CENTER_NOTIF_TOOL,
               func = function() AsylumTracker.ResetToDefaults() end,
               width = "half",
          },
          {
               type = "checkbox",
               name = AST_SETT_SOUND_EFFECT,
               tooltip = AST_SETT_SOUND_EFFECT_TOOL,
               getFunc = function() return sv["sound_enabled"] end,
               setFunc = function(value) sv["sound_enabled"] = value end,
               default = true,
               requiresReload = true,
               width = "full",
          },
          {
               type = "checkbox",
               name = AST_SETT_LLOTHIS_NOTIF,
               tooltip = AST_SETT_LLOTHIS_NOTIF_TOOL,
               getFunc = function() return sv["llothis_notifications"] end,
               setFunc = function(value) sv["llothis_notifications"] = value end,
               default = true,
               requiresReload = true,
               width = "full",
          },
          {
               type = "checkbox",
               name = AST_SETT_FELMS_NOTIF,
               tooltip = AST_SETT_FELMS_NOTIF_TOOL,
               getFunc = function() return sv["felms_notifications"] end,
               setFunc = function(value) sv["felms_notifications"] = value end,
               default = true,
               requiresReload = true,
               width = "full",
          },
          {
               type = "header",
               width = "full",
          },
          {
               type = "slider",
               name = AST_SETT_OLMS_HP_SIZE,
               tooltip = AST_SETT_OLMS_HP_SIZE_TOOL,
               getFunc = function() return sv["font_size_olms_hp"] end,
               setFunc = function(value) sv["font_size_olms_hp"] = value AsylumTracker.SetFontSize(AsylumTrackerOlmsHPLabel, value) end,
               min = 38,
               max = 72,
               step = 2,
               default = 48,
               width = "full",
          },
          {
               type = "slider",
               name = AST_SETT_OLMS_HP_SCALE,
               tooltip = AST_SETT_OLMS_HP_SCALE_TOOL,
               warning = AST_SETT_SCALE_WARN,
               getFunc = function() return sv["olms_hp_scale"] end,
               setFunc = function(value) sv["olms_hp_scale"] = value AsylumTracker.SetScale(AsylumTrackerOlmsHPLabel, value) end,
               min = 0.5,
               max = 2,
               step = 0.1,
               default = 1,
               width = "full",
          },
          {
               type = "colorpicker",
               name = AST_SETT_COLOR_1,
               tooltip = AST_SETT_OLMS_HP_COLOR_1_TOOL,
               getFunc = function() return unpack(sv["color_olms_hp"]) end,
               setFunc = function(r, g, b, a)
                    sv["color_olms_hp"] = {r, g, b, a}
                    AsylumTracker.ToggleMovable() AsylumTracker.ToggleMovable()
               end,
               width = "full",
          },
          {
               type = "colorpicker",
               name = AST_SETT_COLOR_2,
               tooltip = AST_SETT_OLMS_HP_COLOR_2_TOOL,
               getFunc = function() return unpack(sv["color_olms_hp2"]) end,
               setFunc = function(r, g, b, a)
                    sv["color_olms_hp2"] = {r, g, b, a}
                    AsylumTrackerOlmsHPLabel:SetColor(unpack(sv["color_olms_hp2"]))
                    AsylumTracker.ToggleMovable() AsylumTracker.ToggleMovable()
               end,
               width = "full",
          },
          {
               type = "header",
               width = "full",
          },
          {
               type = "checkbox",
               name = AST_SETT_STORM,
               tooltip = AST_SETT_STORM_TOOL,
               getFunc = function() return sv["storm_the_heavens"] end,
               setFunc =
               function(value)
                    sv["storm_the_heavens"] = value
                    AsylumTracker.ToggleMovable()
                    AsylumTracker.ToggleMovable()
               end,
               default = true,
               requiresReload = true,
               width = "full",
          },
          {
               type = "slider",
               name = AST_SETT_FONT_SIZE,
               tooltip = AST_SETT_STORM_SIZE_TOOL,
               getFunc = function() return sv["font_size_storm"] end,
               setFunc = function(value) sv["font_size_storm"] = value AsylumTracker.SetFontSize(AsylumTrackerStormLabel, value) end,
               min = 38,
               max = 72,
               step = 2,
               default = 48,
               width = "full",
               disabled = function() return not sv["storm_the_heavens"] end,
          },
          {
               type = "slider",
               name = AST_SETT_SCALE,
               tooltip = AST_SETT_STORM_SCALE_TOOL,
               warning = AST_SETT_SCALE_WARN,
               getFunc = function() return sv["storm_scale"] end,
               setFunc = function(value) sv["storm_scale"] = value AsylumTracker.SetScale(AsylumTrackerStormLabel, value) end,
               min = 0.5,
               max = 2,
               step = 0.1,
               default = 1,
               width = "full",
               disabled = function() return not sv["storm_the_heavens"] end,
          },
          {
               type = "colorpicker",
               name = AST_SETT_COLOR_1,
               tooltip = AST_SETT_STORM_COLOR_1_TOOL,
               getFunc = function() return unpack(sv["color_storm"]) end,
               setFunc = function(r, g, b, a)
                    sv["color_storm"] = {r, g, b, a}
                    AsylumTrackerStormLabel:SetColor(unpack(sv["color_storm"]))
                    AsylumTracker.ToggleMovable() AsylumTracker.ToggleMovable()
               end,
               width = "full",
               disabled = function() return not sv["storm_the_heavens"] end,
          },
          {
               type = "colorpicker",
               name = AST_SETT_COLOR_2,
               tooltip = AST_SETT_STORM_COLOR_2_TOOL,
               getFunc = function() return unpack(sv["color_storm2"]) end,
               setFunc = function(r, g, b, a)
                    sv["color_storm2"] = {r, g, b, a}
                    AsylumTracker.ToggleMovable() AsylumTracker.ToggleMovable()
               end,
               width = "full",
               disabled = function() return not sv["storm_the_heavens"] end,
          },
          {
               type = "dropdown",
               name = "Sound Effect",
               tooltip = "Sound effect that will be used for Storm the Heavens.",
               scrollable = true,
               choices = AsylumTracker.GetSounds(),
               getFunc = function() return sv.storm_the_heavens_sound end,
               setFunc = function(value) sv.storm_the_heavens_sound = value end,
               width = "full",
               disabled = function() return not sv.storm_the_heavens or not sv.sound_enabled end
          },
          {
               type = "slider",
               name = "Sound Effect Volume",
               tooltip = "Volume of Storm the Heavens Sound Effect",
               getFunc = function() return sv.storm_the_heavens_volume end,
               setFunc = function(value) sv.storm_the_heavens_volume = value end,
               min = 1,
               max = 50,
               step = 1,
               default = 1,
               width = "full",
               disabled = function() return not sv.storm_the_heavens or not sv.sound_enabled end
          },
          {
               type = "button",
               name = "Test",
               tooltip = "Test Sound Effect",
               func = function(value)
                    AsylumTracker.LoopSound(sv.storm_the_heavens_volume, sv.storm_the_heavens_sound)
               end,
               width = "full",
               disabled = function() return not sv.storm_the_heavens or not sv.sound_enabled end
          },
          {
               type = "header",
               width = "full",
          },
          {
               type = "checkbox",
               name = AST_SETT_BLAST,
               tooltip = AST_SETT_BLAST_TOOL,
               getFunc = function() return sv["defiling_blast"] end,
               setFunc = function(value)
                    sv["defiling_blast"] = value
                    AsylumTracker.ToggleMovable()
                    AsylumTracker.ToggleMovable()
               end,
               default = true,
               requiresReload = true,
               width = "full",
          },
          {
               type = "slider",
               name = AST_SETT_FONT_SIZE,
               tooltip = AST_SETT_BLAST_SIZE_TOOL,
               getFunc = function() return sv["font_size_blast"] end,
               setFunc = function(value) sv["font_size_blast"] = value AsylumTracker.SetFontSize(AsylumTrackerBlastLabel, value) end,
               min = 38,
               max = 72,
               step = 2,
               default = 48,
               width = "full",
               disabled = function() return not sv["defiling_blast"] end,
          },
          {
               type = "slider",
               name = AST_SETT_SCALE,
               tooltip = AST_SETT_BLAST_SCALE_TOOL,
               warning = AST_SETT_SCALE_WARN,
               getFunc = function() return sv["blast_scale"] end,
               setFunc = function(value) sv["blast_scale"] = value AsylumTracker.SetScale(AsylumTrackerBlastLabel, value) end,
               min = 0.5,
               max = 2,
               step = 0.1,
               default = 1,
               width = "full",
               disabled = function() return not sv["defiling_blast"] end,
          },
          {
               type = "colorpicker",
               name = AST_SETT_COLOR,
               tooltip = AST_SETT_BLAST_COLOR_TOOL,
               getFunc = function() return unpack(sv["color_blast"]) end,
               setFunc = function(r, g, b, a)
                    sv["color_blast"] = {r, g, b, a}
                    AsylumTrackerBlastLabel:SetColor(unpack(sv["color_blast"]))
                    AsylumTracker.ToggleMovable() AsylumTracker.ToggleMovable()
               end,
               width = "full",
               disabled = function() return not sv["defiling_blast"] end,
          },
          {
               type = "dropdown",
               name = "Sound Effect",
               tooltip = "Sound effect that will be used for Defiling Blast.",
               scrollable = true,
               choices = AsylumTracker.GetSounds(),
               getFunc = function() return sv.defiling_blast_sound end,
               setFunc = function(value) sv.defiling_blast_sound = value end,
               width = "full",
               disabled = function() return not sv.defiling_blast or not sv.sound_enabled end
          },
          {
               type = "slider",
               name = "Sound Effect Volume",
               tooltip = "Volume of Defiling Blast Sound Effect",
               getFunc = function() return sv.defiling_blast_volume end,
               setFunc = function(value) sv.defiling_blast_volume = value end,
               min = 1,
               max = 50,
               step = 1,
               default = 1,
               width = "full",
               disabled = function() return not sv.defiling_blast or not sv.sound_enabled end
          },
          {
               type = "button",
               name = "Test",
               tooltip = "Test Sound Effect",
               func = function(value)
                    AsylumTracker.LoopSound(sv.defiling_blast_volume, sv.defiling_blast_sound)
               end,
               width = "full",
               disabled = function() return not sv.defiling_blast or not sv.sound_enabled end
          },
          {
               type = "header",
               width = "full",
          },
          {
               type = "checkbox",
               name = AST_SETT_PROTECT,
               tooltip = AST_SETT_PROTECT_TOOL,
               getFunc = function() return sv["static_shield"] end,
               setFunc = function(value)
                    sv["static_shield"] = value
                    AsylumTracker.ToggleMovable()
                    AsylumTracker.ToggleMovable()
               end,
               default = true,
               requiresReload = true,
               width = "full",
          },
          {
               type = "slider",
               name = AST_SETT_FONT_SIZE,
               tooltip = AST_SETT_PROTECT_SIZE_TOOL,
               getFunc = function() return sv["font_size_sphere"] end,
               setFunc = function(value) sv["font_size_sphere"] = value AsylumTracker.SetFontSize(AsylumTrackerSphereLabel, value) end,
               min = 38,
               max = 72,
               step = 2,
               default = 48,
               width = "full",
               disabled = function() return not sv["static_shield"] end,
          },
          {
               type = "slider",
               name = AST_SETT_SCALE,
               tooltip = AST_SETT_PROTECT_SCALE_TOOL,
               warning = AST_SETT_SCALE_WARN,
               getFunc = function() return sv["sphere_scale"] end,
               setFunc = function(value) sv["sphere_scale"] = value AsylumTracker.SetScale(AsylumTrackerSphereLabel, value) end,
               min = 0.5,
               max = 2,
               step = 0.1,
               default = 1,
               width = "full",
               disabled = function() return not sv["static_shield"] end,
          },
          {
               type = "colorpicker",
               name = AST_SETT_COLOR_1,
               tooltip = AST_SETT_PROTECT_COLOR_1_TOOL,
               getFunc = function() return unpack(sv["color_sphere"]) end,
               setFunc = function(r, g, b, a)
                    sv["color_sphere"] = {r, g, b, a}
                    AsylumTrackerSphereLabel:SetColor(unpack(sv["color_sphere"]))
                    AsylumTracker.ToggleMovable() AsylumTracker.ToggleMovable()
               end,
               width = "full",
               disabled = function() return not sv["static_shield"] end,
          },
          {
               type = "colorpicker",
               name = AST_SETT_COLOR_2,
               tooltip = AST_SETT_PROTECT_COLOR_2_TOOL,
               getFunc = function() return unpack(sv["color_sphere2"]) end,
               setFunc = function(r, g, b, a)
                    sv["color_sphere2"] = {r, g, b, a}
                    AsylumTracker.ToggleMovable() AsylumTracker.ToggleMovable()
               end,
               width = "full",
               disabled = function() return not sv["static_shield"] end,
          },
          {
               type = "checkbox",
               name = AST_SETT_PROTECT_MESSAGE,
               tooltip = AST_SETT_PROTECT_MESSAGE_TOOL,
               getFunc = function() return sv["sphere_message_toggle"] end,
               setFunc = function(value)
                    sv["sphere_message_toggle"] = value
                    AsylumTracker.ToggleMovable()
                    AsylumTracker.ToggleMovable()
               end,
               default = true,
               requiresReload = true,
               width = "full",
          },
          {
               type = "editbox",
               name = "",
               getFunc = function() return sv["sphere_message"] end,
               setFunc = function(value)
                    sv["sphere_message"] = value
                    ZO_CreateStringId("AST_NOTIF_PROTECTOR", value)
               end,
               width = "full",
               disabled = function() return not sv["sphere_message_toggle"] end,
          },
          {
               type = "header",
               width = "full",
          },
          {
               type = "checkbox",
               name = AST_SETT_JUMP,
               tooltip = AST_SETT_JUMP_TOOL,
               getFunc = function() return sv["teleport_strike"] end,
               setFunc = function(value)
                    sv["teleport_strike"] = value
                    AsylumTracker.ToggleMovable()
                    AsylumTracker.ToggleMovable()
               end,
               default = false,
               requiresReload = true,
               width = "full",
          },
          {
               type = "slider",
               name = AST_SETT_FONT_SIZE,
               tooltip = AST_SETT_JUMP_SIZE_TOOL,
               getFunc = function() return sv["font_size_teleport_strike"] end,
               setFunc = function(value) sv["font_size_teleport_strike"] = value AsylumTracker.SetFontSize(AsylumTrackerTeleportStrikeLabel, value) end,
               min = 38,
               max = 72,
               step = 2,
               default = 48,
               width = "full",
               disabled = function() return not sv["teleport_strike"] end,
          },
          {
               type = "slider",
               name = AST_SETT_SCALE,
               tooltip = AST_SETT_JUMP_SCALE_TOOL,
               warning = AST_SETT_SCALE_WARN,
               getFunc = function() return sv["teleport_strike_scale"] end,
               setFunc = function(value) sv["teleport_strike_scale"] = value AsylumTracker.SetScale(AsylumTrackerTeleportStrikeLabel, value) end,
               min = 0.5,
               max = 2,
               step = 0.1,
               default = 1,
               width = "full",
               disabled = function() return not sv["teleport_strike"] end,
          },
          {
               type = "colorpicker",
               name = AST_SETT_COLOR,
               tooltip = AST_SETT_JUMP_COLOR_TOOL,
               getFunc = function() return unpack(sv["color_teleport_strike"]) end,
               setFunc = function(r, g, b, a)
                    sv["color_teleport_strike"] = {r, g, b, a}
                    AsylumTrackerTeleportStrikeLabel:SetColor(unpack(sv["color_teleport_strike"]))
                    AsylumTracker.ToggleMovable() AsylumTracker.ToggleMovable()
               end,
               width = "full",
               disabled = function() return not sv["teleport_strike"] end,
          },
          {
               type = "header",
               width = "full",
          },
          {
               type = "checkbox",
               name = AST_SETT_BOLTS,
               tooltip = AST_SETT_BOLTS_TOOL,
               getFunc = function() return sv["oppressive_bolts"] end,
               setFunc = function(value)
                    sv["oppressive_bolts"] = value
                    AsylumTracker.ToggleMovable()
                    AsylumTracker.ToggleMovable()
               end,
               default = false,
               requiresReload = true,
               width = "full",
          },
          {
               type = "slider",
               name = AST_SETT_FONT_SIZE,
               tooltip = AST_SETT_BOLTS_SIZE_TOOL,
               getFunc = function() return sv["font_size_oppressive_bolts"] end,
               setFunc = function(value) sv["font_size_oppressive_bolts"] = value AsylumTracker.SetFontSize(AsylumTrackerOppressiveBoltsLabel, value) end,
               min = 38,
               max = 72,
               step = 2,
               default = 48,
               width = "full",
               disabled = function() return not sv["oppressive_bolts"] end,
          },
          {
               type = "slider",
               name = AST_SETT_SCALE,
               tooltip = AST_SETT_BOLTS_SCALE_TOOL,
               warning = AST_SETT_SCALE_WARN,
               getFunc = function() return sv["oppressive_bolts_scale"] end,
               setFunc = function(value) sv["oppressive_bolts_scale"] = value AsylumTracker.SetScale(AsylumTrackerOppressiveBoltsLabel, value) end,
               min = 0.5,
               max = 2,
               step = 0.1,
               default = 1,
               width = "full",
               disabled = function() return not sv["oppressive_bolts"] end,
          },
          {
               type = "colorpicker",
               name = AST_SETT_COLOR,
               tooltip = AST_SETT_BOLTS_COLOR_TOOL,
               getFunc = function() return unpack(sv["color_oppressive_bolts"]) end,
               setFunc = function(r, g, b, a)
                    sv["color_oppressive_bolts"] = {r, g, b, a}
                    AsylumTrackerOppressiveBoltsLabel:SetColor(unpack(sv["color_oppressive_bolts"]))
                    AsylumTracker.ToggleMovable() AsylumTracker.ToggleMovable()
               end,
               width = "full",
               disabled = function() return not sv["oppressive_bolts"] end,
          },
          {
               type = "editbox",
               name = AST_SETT_INTTERUPT,
               tooltip = AST_SETT_INTTERUPT_TOOL,
               getFunc = function() return sv["interrupt_message"] end,
               setFunc = function(value) sv["interrupt_message"] = value end,
               width = "full",
               disabled = function() return not sv["oppressive_bolts"] end,
          },
          {
               type = "header",
               width = "full",
          },
          {
               type = "checkbox",
               name = AST_SETT_STEAM,
               tooltip = AST_SETT_STEAM_TOOL,
               getFunc = function() return sv["scalding_roar"] end,
               setFunc = function(value)
                    sv["scalding_roar"] = value
                    AsylumTracker.ToggleMovable()
                    AsylumTracker.ToggleMovable()
               end,
               default = false,
               requiresReload = true,
               width = "full",
          },
          {
               type = "slider",
               name = AST_SETT_FONT_SIZE,
               tooltip = AST_SETT_STEAM_SIZE_TOOL,
               getFunc = function() return sv["font_size_scalding_roar"] end,
               setFunc = function(value) sv["font_size_scalding_roar"] = value AsylumTracker.SetFontSize(AsylumTrackerSteamLabel, value) end,
               min = 38,
               max = 72,
               step = 2,
               default = 48,
               width = "full",
               disabled = function() return not sv["scalding_roar"] end,
          },
          {
               type = "slider",
               name = AST_SETT_SCALE,
               tooltip = AST_SETT_STEAM_SCALE_TOOL,
               warning = AST_SETT_SCALE_WARN,
               getFunc = function() return sv["scalding_roar_scale"] end,
               setFunc = function(value) sv["scalding_roar_scale"] = value AsylumTracker.SetScale(AsylumTrackerSteamLabel, value) end,
               min = 0.5,
               max = 2,
               step = 0.1,
               default = 1,
               width = "full",
               disabled = function() return not sv["scalding_roar"] end,
          },
          {
               type = "colorpicker",
               name = AST_SETT_COLOR,
               tooltip = AST_SETT_STEAM_COLOR_TOOL,
               getFunc = function() return unpack(sv["color_scalding_roar"]) end,
               setFunc = function(r, g, b, a)
                    sv["color_scalding_roar"] = {r, g, b, a}
                    AsylumTrackerSteamLabel:SetColor(unpack(sv["color_scalding_roar"]))
                    AsylumTracker.ToggleMovable() AsylumTracker.ToggleMovable()
               end,
               width = "full",
               disabled = function() return not sv["scalding_roar"] end,
          },
          {
               type = "header",
               width = "full",
          },
          {
               type = "checkbox",
               name = AST_SETT_FIRE,
               tooltip = AST_SETT_FIRE_TOOL,
               getFunc = function() return sv["trial_by_fire"] end,
               setFunc = function(value)
                    sv["trial_by_fire"] = value
                    AsylumTracker.ToggleMovable()
                    AsylumTracker.ToggleMovable()
               end,
               default = false,
               requiresReload = true,
               width = "full",
          },
          {
               type = "slider",
               name = AST_SETT_FONT_SIZE,
               tooltip = AST_SETT_FIRE_SIZE_TOOL,
               getFunc = function() return sv["font_size_fire"] end,
               setFunc = function(value) sv["font_size_fire"] = value AsylumTracker.SetFontSize(AsylumTrackerFireLabel, value) end,
               min = 38,
               max = 72,
               step = 2,
               default = 48,
               width = "full",
               disabled = function() return not sv["trial_by_fire"] end,
          },
          {
               type = "slider",
               name = AST_SETT_SCALE,
               tooltip = AST_SETT_FIRE_SCALE_TOOL,
               warning = AST_SETT_SCALE_WARN,
               getFunc = function() return sv["fire_scale"] end,
               setFunc = function(value) sv["fire_scale"] = value AsylumTracker.SetScale(AsylumTrackerFireLabel, value) end,
               min = 0.5,
               max = 2,
               step = 0.1,
               default = 1,
               width = "full",
               disabled = function() return not sv["trial_by_fire"] end,
          },
          {
               type = "colorpicker",
               name = AST_SETT_COLOR,
               tooltip = AST_SETT_FIRE_COLOR_TOOL,
               getFunc = function() return unpack(sv["color_fire"]) end,
               setFunc = function(r, g, b, a)
                    sv["color_fire"] = {r, g, b, a}
                    AsylumTrackerFireLabel:SetColor(unpack(sv["color_fire"]))
                    AsylumTracker.ToggleMovable() AsylumTracker.ToggleMovable()
               end,
               width = "full",
               disabled = function() return not sv["trial_by_fire"] end,
          },
          {
               type = "header",
               width = "full",
          },
          {
               type = "checkbox",
               name = AST_SETT_MAIM,
               tooltip = AST_SETT_MAIM_TOOL,
               getFunc = function() return sv["maim"] end,
               setFunc =
               function(value)
                    sv["maim"] = value
                    AsylumTracker.ToggleMovable()
                    AsylumTracker.ToggleMovable()
               end,
               default = false,
               requiresReload = true,
               width = "full",
          },
          {
               type = "slider",
               name = AST_SETT_FONT_SIZE,
               tooltip = AST_SETT_MAIM_SIZE_TOOL,
               getFunc = function() return sv["font_size_maim"] end,
               setFunc = function(value) sv["font_size_maim"] = value AsylumTracker.SetFontSize(AsylumTrackerMaimLabel, value) end,
               min = 38,
               max = 72,
               step = 2,
               default = 48,
               width = "full",
               disabled = function() return not sv["maim"] end,
          },
          {
               type = "slider",
               name = AST_SETT_SCALE,
               tooltip = AST_SETT_MAIM_SCALE_TOOL,
               warning = AST_SETT_SCALE_WARN,
               getFunc = function() return sv["maim_scale"] end,
               setFunc = function(value) sv["maim_scale"] = value AsylumTracker.SetScale(AsylumTrackerMaimLabel, value) end,
               min = 0.5,
               max = 2,
               step = 0.1,
               default = 1,
               width = "full",
               disabled = function() return not sv["maim"] end,
          },
          {
               type = "colorpicker",
               name = AST_SETT_COLOR,
               tooltip = AST_SETT_MAIM_COLOR_TOOL,
               getFunc = function() return unpack(sv["color_maim"]) end,
               setFunc = function(r, g, b, a)
                    sv["color_maim"] = {r, g, b, a}
                    AsylumTrackerMaimLabel:SetColor(unpack(sv["color_maim"]))
                    AsylumTracker.ToggleMovable() AsylumTracker.ToggleMovable()
               end,
               width = "full",
               disabled = function() return not sv["maim"] end,
          },
     }
     LAM2:RegisterOptionControls(AsylumTracker.name .. "Settings", Settings)
end
