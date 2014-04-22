--------------------------------------------------------
-- Orion:Lib-1.0
--  + Orion:Unit-1.0
--  + Orion:Spell-1.0
--  + Orion:Util-1.0
--------------------------------------------------------
local OrionLib = {}

--------------------------------------------------------
-- UNIT
--
-- Provides unit related helper function, like 
-- string-to-Unit conversions, aura checking, 
-- and much more.
--------------------------------------------------------
OrionLib.Unit.tUnits = {
	"player"        = GameLib.GetPlayerUnit,
	"target"        = GameLib.GetTargetUnit,
	"focus"         = function() return GameLib.GetPlayerUnit():GetAlternateTarget() end,
	"targettarget"  = function() return GameLib.GetTargetUnit() and GameLib.GetTargetUnit():GetTarget() or nil end
	"focustarget"   = function() return GameLib.GetPlayerUnit():GetAlternateTarget() and GameLib.GetPlayerUnit():GetAlternateTarget():GetTarget() or nil end
}

-- wraps basic Unit objects with our Wrapper functions
function OrionLib.Unit:Get(strIdentifier)
	strIdentifier= strIdentifier:lower()
	if self.tUnits[strIdentifier] ~= nil then
		return OrionLib.Util.JoinTables(self.tUnits[strIdentifier], OrionLib.Unit.Wrapper)
	end
		
	return nil
end

-- wrapper functions
local OrionLib.Unit.Wrapper = {}

-- Aura handling
function OrionLib.Unit.Wrapper:HasAura(iAuraId, bHarmful)
	local strTable = bHarmful and "arHarmful" or "arBeneficial"
	local Auras = self:GetBuffs()
	for i, Aura in ipairs(Auras[strTable]) do
		if Aura.splEffect:GetId() == iAuraId then
			return true
		end
	end
		
	return false
end

function OrionLib.Unit.Wrapper:HasBuff(iAuraId)
	return self:HasAura(iAuraId)
end

function OrionLib.Unit.Wrapper:HasDebuff(iAuraId)
	return self:HasAura(iAuraId, true)
end



--------------------------------------------------------
-- SPELL
--
-- Provides spell related helper function, like 
-- name-to-id conversion, cast evaluation, and much more
--------------------------------------------------------
OrionLib.Spell = {}
OrionLib.Spell._tSpellCache = {}


--------------------------------------------------------
-- UTIL
-- Provides general utilities.
--------------------------------------------------------
OrionLib.Util = {}

function OrionLib.Util.JoinTables(tTable1, tTable2)
	for key, value in pairs(tTable2) do
		tTable1[key] = value
	end
	
	return tTable1
end

--------------------------------------------------------
Apollo.RegisterPackage(OrionLib, "Orion:Lib-1.0", 1, {})
Apollo.RegisterPackage(OrionLib.Util, "Orion:LibUtil-1.0", 1, {"Orion:Lib-1.0"})
Apollo.RegisterPackage(OrionLib.Unit, "Orion:LibUnit-1.0", 1, {"Orion:LibUtil-1.0"})
Apollo.RegisterPackage(OrionLib.Spell, "Orion:LibSpell-1.0", 1, {"Orion:LibUnit-1.0"})