require "AbilityBook"

--------------------------------------------------------
-- SPELL
--
-- Provides spell related helper function, like 
-- cast evaluation and much more
--------------------------------------------------------
local OrionLib_Spell = {}
local OrionLib_Unit = Apollo.GetPackage("Trox:Orion:LibUnit-1.0")

function OrionLib_Spell:CanCast(strTarget, iSpellId)
	local target = OrionLib_Unit:Get(strTarget)
	if target and not target:IsDead() and target:IsValid() and self:IsSpellKnown(iSpellId) then
		local spell = GameLib.GetSpell(iSpellId)
		if spell and self:IsSpellKnown(iSpellId) and self:GetSpellCooldown(spell) <= 0 then	
			return true
		end
	end
	
	return false
end

function OrionLib_Spell:IsPlayerSpell(iSpellId)
	for i, spellData in ipairs(AbilityBook.GetAbilitiesList()) do
		if spellData.splObject:GetId() == iSpellId then
			return true
		end
	end
	
	return false
end

function OrionLib_Spell:IsSpellKnown(iSpellId)
	for i, spellData in ipairs(AbilityBook.GetAbilitiesList()) do
		if spellData.splObject:GetId() == iSpellId then
			return spellData.known == true
		end
	end
	
	return false
end

function OrionLib_Spell:GetSpellCooldown(spellObj)
	local charges = spellObj:GetAbilityCharges()
	if charges and charges.nChargesMax > 0 then
		return charges.fRechargePercentRemaining * charges.fRechargeTime, charges.fRechargeTime, charges.nChargesRemaining
	else
		return spellObj:GetCooldownRemaining(), spellObj:GetCooldownTime(), 0
	end
end

Apollo.RegisterPackage(OrionLib_Unit, "Trox:Orion:LibSpell-1.0", 1, {"Trox:Orion:LibUnit-1.0"})