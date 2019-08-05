local AsylumTracker = AsylumTracker
local EM = EVENT_MANAGER

AsylumTracker.unitIds = {}

local function OnEffectChanged(_, _, _, _, _, _, _, _, _, _, _, _, _, unitName, unitId)
	unitName = zo_strformat("<<1>>", unitName)
	if unitName ~= "Offline" then
		AsylumTracker.unitIds[unitId] = unitName
	end
end

function AsylumTracker.GetNameForUnitId(unitId)
	return AsylumTracker.unitIds[unitId] or ""
end

function AsylumTracker.RegisterUnitIndexing()
	EM:RegisterForEvent(AsylumTracker.name .. "_Units_Effect_Changed", EVENT_EFFECT_CHANGED, OnEffectChanged)
end
