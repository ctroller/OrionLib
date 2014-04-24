require "GameLib"

OrionLib = OrionLib or {}
OrionLib.Unit = {}
OrionLib.Util = OrionLib.Util or Apollo.GetPackage("Trox:Orion:Util-1.0").tPackage

OrionLib.Unit.tUnits = {
	player        = function() return GameLib.GetPlayerUnit() end,
	target        = function() return GameLib.GetTargetUnit() end,
	focus         = function() return GameLib.GetPlayerUnit():GetAlternateTarget() end,
	targettarget  = function() return GameLib.GetTargetUnit() and GameLib.GetTargetUnit():GetTarget() or nil end,
	focustarget   = function() return GameLib.GetPlayerUnit():GetAlternateTarget() and GameLib.GetPlayerUnit():GetAlternateTarget():GetTarget() or nil end
}

-- wraps basic Unit objects with our Wrapper functions
function OrionLib.Unit:Get(strIdentifier)
	OrionLib.Util.AssertString(1, strIdentifier)
	strIdentifier = strIdentifier:lower()
	if self.tUnits[strIdentifier] ~= nil then
		return OrionLib.Util.JoinTables(self.tUnits[strIdentifier], self.Wrapper)
	end
		
	return nil
end

-- wrapper functions
local OrionLib.Unit.Wrapper = {}

-- Aura handling
function OrionLib.Unit.Wrapper:GetAura(iAuraId, bHarmful)
	local strTable = bHarmful and "arHarmful" or "arBeneficial"
	local auras = self:GetBuffs()
	for i, aura in ipairs(auras[strTable]) do
		if aura.splEffect:GetId() == iAuraId then
			return aura
		end
	end
		
	return nil
end


function OrionLib.Unit.Wrapper:HasAura(iAuraId, bHarmful)
	return self:GetAura(iAuraId, bHarmful) ~= nil
end

function OrionLib.Unit.Wrapper:HasBuff(iAuraId)
	return self:HasAura(iAuraId)
end

function OrionLib.Unit.Wrapper:HasDebuff(iAuraId)
	return self:HasAura(iAuraId, true)
end

Apollo.RegisterPackage(OrionLib.Unit, "Trox:Orion:Unit-1.0", 1, {"Trox:Orion:Util-1.0"})
