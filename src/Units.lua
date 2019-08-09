local AsylumTracker = AsylumTracker
local EM = EVENT_MANAGER
local ASYLUM_SANCTORIUM = 1000

AsylumTracker.unitIds = {}

local function OnEffectChanged(_, _, _, _, _, _, _, _, _, _, _, _, _, unitName, unitId)
	if GetZoneNameById(ASYLUM_SANCTORIUM) == GetUnitZone("player") then
		unitName = zo_strformat("<<1>>", unitName)
		if unitName ~= "Offline" then
			if not AsylumTracker.unitIds[unitId] then
				AsylumTracker.unitIds[unitId] = unitName
				AsylumTracker.dbgunits(unitName .. " [" .. unitId .. "] has been added to unitIds")
			end
		end
	end
end

function AsylumTracker.GetNameForUnitId(unitId)
	return AsylumTracker.unitIds[unitId] or ""
end

function AsylumTracker.RegisterUnitIndexing()
	EM:RegisterForEvent(AsylumTracker.name .. "_Units_Effect_Changed", EVENT_EFFECT_CHANGED, OnEffectChanged)
end
