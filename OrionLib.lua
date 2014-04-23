require "GameLib"
require "AbilityBook"

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
local OrionLib.Unit = {}

OrionLib.Unit.tUnits = {
	"player"        = GameLib.GetPlayerUnit,
	"target"        = GameLib.GetTargetUnit,
	"focus"         = function() return GameLib.GetPlayerUnit():GetAlternateTarget() end,
	"targettarget"  = function() return GameLib.GetTargetUnit() and GameLib.GetTargetUnit():GetTarget() or nil end
	"focustarget"   = function() return GameLib.GetPlayerUnit():GetAlternateTarget() and GameLib.GetPlayerUnit():GetAlternateTarget():GetTarget() or nil end
}

-- wraps basic Unit objects with our Wrapper functions
function OrionLib.Unit:Get(strIdentifier)
	strIdentifier = strIdentifier:lower()
	if self.tUnits[strIdentifier] ~= nil then
		return OrionLib.Util.JoinTables(self.tUnits[strIdentifier], OrionLib.Unit.Wrapper)
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



--------------------------------------------------------
-- SPELL
--
-- Provides spell related helper function, like 
-- cast evaluation and much more
--------------------------------------------------------
OrionLib.Spell = {}

function OrionLib.Spell:CanCast(strTarget, iSpellId)
	local target = OrionLib.Unit:Get(strTarget)
	if target and not target:IsDead() and target:IsValid() and self:IsSpellKnown(iSpellId) then
		local spell = GameLib.GetSpell(iSpellId)
		if spell and self:IsSpellKnown(iSpellId) and self:GetSpellCooldown(spell) <= 0 then	
			return true
		end
	end
	
	return false
end

function OrionLib.Spell:IsPlayerSpell(iSpellId)
	for i, spellData in ipairs(AbilityBook.GetAbilitiesList()) do
		if spellData.splObject:GetId() == iSpellId then
			return true
		end
	end
	
	return false
end

function OrionLib.Spell:IsSpellKnown(iSpellId)
	for i, spellData in ipairs(AbilityBook.GetAbilitiesList()) do
		if spellData.splObject:GetId() == iSpellId then
			return spellData.known == true
		end
	end
	
	return false
end

function OrionLib.Spell:GetSpellCooldown(spellObj)
	local charges = spellObj:GetAbilityCharges()
	if charges and charges.nChargesMax > 0 then
		return charges.fRechargePercentRemaining * charges.fRechargeTime, charges.fRechargeTime, charges.nChargesRemaining
	else
		return spellObj:GetCooldownRemaining(), spellObj:GetCooldownTime(), 0
	end
end


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
Apollo.RegisterPackage(OrionLib, "Trox:Orion:Lib-1.0", 1, {})
Apollo.RegisterPackage(OrionLib.Util, "Trox:Orion:LibUtil-1.0", 1, {"Trox:Orion:Lib-1.0"})
Apollo.RegisterPackage(OrionLib.Unit, "Trox:Orion:LibUnit-1.0", 1, {"Trox:Orion:LibUtil-1.0"})
Apollo.RegisterPackage(OrionLib.Spell, "Trox:Orion:LibSpell-1.0", 1, {"Trox:Orion:LibUnit-1.0"})