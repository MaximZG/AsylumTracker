local AsylumTracker = AsylumTracker

function AsylumTracker.ToggleMovable()
     AsylumTracker.isMovable = not AsylumTracker.isMovable
     if AsylumTracker.isMovable then
          local hex_olms_hp = AsylumTracker.RGBToHex(unpack(AsylumTracker.sv["color_olms_hp"]))
          local hex_olms_hp2 = AsylumTracker.RGBToHex(unpack(AsylumTracker.sv["color_olms_hp2"]))
          AsylumTrackerOlmsHPLabel:SetText("|c" .. hex_olms_hp .. GetString(AST_PREVIEW_OLMS_HP_1) .. "|r|c" .. hex_olms_hp2 .. GetString(AST_PREVIEW_OLMS_HP_2) .. "|r")
          local hex_storm = AsylumTracker.RGBToHex(unpack(AsylumTracker.sv["color_storm"]))
          local hex_storm2 = AsylumTracker.RGBToHex(unpack(AsylumTracker.sv["color_storm2"]))
          AsylumTrackerStormLabel:SetText("|c" .. hex_storm .. GetString(AST_PREVIEW_STORM_1) .. "|r|c" .. hex_storm2 .. GetString(AST_PREVIEW_STORM_2) .. "|r")
          AsylumTrackerBlastLabel:SetText(GetString(AST_PREVIEW_BLAST))
          local hex_sphere = AsylumTracker.RGBToHex(unpack(AsylumTracker.sv["color_sphere"]))
          local hex_sphere2 = AsylumTracker.RGBToHex(unpack(AsylumTracker.sv["color_sphere2"]))
          AsylumTrackerSphereLabel:SetText("|c" .. hex_sphere .. GetString(AST_PREVIEW_SPHERE_1) .. "|r|c" .. hex_sphere2 .. GetString(AST_PREVIEW_SPHERE_2) .. "|r")
          AsylumTrackerTeleportStrikeLabel:SetText(GetString(AST_PREVIEW_JUMP))
          AsylumTrackerOppressiveBoltsLabel:SetText(GetString(AST_PREVIEW_BOLTS))
          AsylumTrackerFireLabel:SetText(GetString(AST_PREVIEW_FIRE))
          AsylumTrackerSteamLabel:SetText(GetString(AST_PREVIEW_STEAM))
          AsylumTrackerMaimLabel:SetText(GetString(AST_PREVIEW_MAIM))
          AsylumTrackerChargesLabel:SetText(GetString(AST_PREVIEW_CHARGES))

          AsylumTrackerOlmsHPBackdrop:SetHidden(false) AsylumTrackerOlmsHP:SetDimensions(AsylumTrackerOlmsHPLabel:GetTextWidth(), AsylumTrackerOlmsHPLabel:GetTextHeight())
          AsylumTrackerStormBackdrop:SetHidden(false) AsylumTrackerStorm:SetDimensions(AsylumTrackerStormLabel:GetTextWidth(), AsylumTrackerStormLabel:GetTextHeight())
          AsylumTrackerBlastBackdrop:SetHidden(false) AsylumTrackerBlast:SetDimensions(AsylumTrackerBlastLabel:GetTextWidth(), AsylumTrackerBlastLabel:GetTextHeight())
          AsylumTrackerSphereBackdrop:SetHidden(false) AsylumTrackerSphere:SetDimensions(AsylumTrackerSphereLabel:GetTextWidth(), AsylumTrackerSphereLabel:GetTextHeight())
          AsylumTrackerTeleportStrikeBackdrop:SetHidden(false) AsylumTrackerTeleportStrike:SetDimensions(AsylumTrackerTeleportStrikeLabel:GetTextWidth(), AsylumTrackerTeleportStrikeLabel:GetTextHeight())
          AsylumTrackerOppressiveBoltsBackdrop:SetHidden(false) AsylumTrackerOppressiveBolts:SetDimensions(AsylumTrackerOppressiveBoltsLabel:GetTextWidth(), AsylumTrackerOppressiveBoltsLabel:GetTextHeight())
          AsylumTrackerFireBackdrop:SetHidden(false) AsylumTrackerFire:SetDimensions(AsylumTrackerFireLabel:GetTextWidth(), AsylumTrackerFireLabel:GetTextHeight())
          AsylumTrackerSteamBackdrop:SetHidden(false) AsylumTrackerSteam:SetDimensions(AsylumTrackerSteamLabel:GetTextWidth(), AsylumTrackerSteamLabel:GetTextHeight())
          AsylumTrackerMaimBackdrop:SetHidden(false) AsylumTrackerMaim:SetDimensions(AsylumTrackerMaimLabel:GetTextWidth(), AsylumTrackerMaimLabel:GetTextHeight())
          AsylumTrackerChargesBackdrop:SetHidden(false) AsylumTrackerCharges:SetDimensions(AsylumTrackerChargesLabel:GetTextWidth(), AsylumTrackerChargesLabel:GetTextHeight())

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
          AsylumTrackerOlmsHPBackdrop:SetHidden(true) AsylumTrackerOlmsHP:SetDimensions(AsylumTrackerOlmsHPLabel:GetTextWidth(), AsylumTrackerOlmsHPLabel:GetTextHeight())
          AsylumTrackerStormBackdrop:SetHidden(true) AsylumTrackerStorm:SetDimensions(AsylumTrackerStormLabel:GetTextWidth(), AsylumTrackerStormLabel:GetTextHeight())
          AsylumTrackerBlastBackdrop:SetHidden(true) AsylumTrackerBlast:SetDimensions(AsylumTrackerBlastLabel:GetTextWidth(), AsylumTrackerBlastLabel:GetTextHeight())
          AsylumTrackerSphereBackdrop:SetHidden(true) AsylumTrackerSphere:SetDimensions(AsylumTrackerSphereLabel:GetTextWidth(), AsylumTrackerSphereLabel:GetTextHeight())
          AsylumTrackerTeleportStrikeBackdrop:SetHidden(true) AsylumTrackerTeleportStrike:SetDimensions(AsylumTrackerTeleportStrikeLabel:GetTextWidth(), AsylumTrackerTeleportStrikeLabel:GetTextHeight())
          AsylumTrackerOppressiveBoltsBackdrop:SetHidden(true) AsylumTrackerOppressiveBolts:SetDimensions(AsylumTrackerOppressiveBoltsLabel:GetTextWidth(), AsylumTrackerOppressiveBoltsLabel:GetTextHeight())
          AsylumTrackerFireBackdrop:SetHidden(true) AsylumTrackerFire:SetDimensions(AsylumTrackerFireLabel:GetTextWidth(), AsylumTrackerFireLabel:GetTextHeight())
          AsylumTrackerSteamBackdrop:SetHidden(true) AsylumTrackerSteam:SetDimensions(AsylumTrackerSteamLabel:GetTextWidth(), AsylumTrackerSteamLabel:GetTextHeight())
          AsylumTrackerMaimBackdrop:SetHidden(true) AsylumTrackerMaim:SetDimensions(AsylumTrackerMaimLabel:GetTextWidth(), AsylumTrackerMaimLabel:GetTextHeight())
          AsylumTrackerChargesBackdrop:SetHidden(true) AsylumTrackerCharges:SetDimensions(AsylumTrackerChargesLabel:GetTextWidth(), AsylumTrackerChargesLabel:GetTextHeight())

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

function AsylumTracker.SetFontSize(control, label, size)
     local path = "EsoUI/Common/Fonts/univers67.otf"
     local outline = "soft-shadow-thick"
     label:SetFont(path .. "|" .. size .. "|" .. outline)
     control:SetDimensions(label:GetTextWidth(), label:GetTextHeight())
end

function AsylumTracker.SetScale(label, scale)
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

     AsylumTrackerOlmsHP:SetAnchor(CENTER, GuiRoot, TOPLEFT, AsylumTracker.sv["olms_hp_offsetX"], AsylumTracker.sv["olms_hp_offsetY"])
     AsylumTrackerStorm:SetAnchor(CENTER, GuiRoot, TOPLEFT, AsylumTracker.sv["storm_offsetX"], AsylumTracker.sv["storm_offsetY"])
     AsylumTrackerBlast:SetAnchor(CENTER, GuiRoot, TOPLEFT, AsylumTracker.sv["blast_offsetX"], AsylumTracker.sv["blast_offsetY"])
     AsylumTrackerSphere:SetAnchor(CENTER, GuiRoot, TOPLEFT, AsylumTracker.sv["sphere_offsetX"], AsylumTracker.sv["sphere_offsetY"])
     AsylumTrackerTeleportStrike:SetAnchor(CENTER, GuiRoot, TOPLEFT, AsylumTracker.sv["teleport_strike_offsetX"], AsylumTracker.sv["teleport_strike_offsetY"])
     AsylumTrackerOppressiveBolts:SetAnchor(CENTER, GuiRoot, TOPLEFT, AsylumTracker.sv["oppressive_bolts_offsetX"], AsylumTracker.sv["oppressive_bolts_offsetY"])
     AsylumTrackerFire:SetAnchor(CENTER, GuiRoot, TOPLEFT, AsylumTracker.sv["fire_offsetX"], AsylumTracker.sv["fire_offsetY"])
     AsylumTrackerSteam:SetAnchor(CENTER, GuiRoot, TOPLEFT, AsylumTracker.sv["steam_offsetX"], AsylumTracker.sv["steam_offsetY"])
     AsylumTrackerMaim:SetAnchor(CENTER, GuiRoot, TOPLEFT, AsylumTracker.sv["maim_offsetX"], AsylumTracker.sv["maim_offsetY"])
     AsylumTrackerCharges:SetAnchor(CENTER, GuiRoot, TOPLEFT, AsylumTracker.sv["exhaustive_charges_offsetX"], AsylumTracker.sv["exhaustive_charges_offsetY"])
end

function AsylumTracker.SavePosition(control, controlAsString)
     local offsets = {
          ["AsylumTrackerOlmsHP"] = {"olms_hp_offsetX", "olms_hp_offsetY"},
          ["AsylumTrackerStorm"] = {"storm_offsetX", "storm_offsetY"},
          ["AsylumTrackerBlast"] = {"blast_offsetX", "blast_offsetY"},
          ["AsylumTrackerSphere"] = {"sphere_offsetX", "sphere_offsetY"},
          ["AsylumTrackerTeleportStrike"] = {"teleport_strike_offsetX", "teleport_strike_offsetY"},
          ["AsylumTrackerOppressiveBolts"] = {"oppressive_bolts_offsetX", "oppressive_bolts_offsetY"},
          ["AsylumTrackerFire"] = {"fire_offsetX", "fire_offsetY"},
          ["AsylumTrackerSteam"] = {"steam_offsetX", "steam_offsetY"},
          ["AsylumTrackerMaim"] = {"maim_offsetX", "maim_offsetY"},
          ["AsylumTrackerCharges"] = {"exhaustive_charges_offsetX", "exhaustive_charges_offsetY"},
     }

     local centerX, centerY = control:GetCenter()
     AsylumTracker.sv[offsets[controlAsString][1]] = centerX
     AsylumTracker.sv[offsets[controlAsString][2]] = centerY
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
