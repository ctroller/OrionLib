require "AbilityBook"

--------------------------------------------------------
-- SPELL
--
-- Provides spell related helper function, like 
-- cast evaluation and much more
--------------------------------------------------------
OrionLib = OrionLib or {}
OrionLib.Spell = {}
OrionLib.Unit = OrionLib.Unit or Apollo.GetPackage("Trox:Orion:Unit-1.0").tPackage

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

Apollo.RegisterPackage(OrionLib.Spell, "Trox:Orion:Spell-1.0", 1, {"Trox:Orion:Unit-1.0"})
