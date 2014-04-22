--------------------------------------------------------
-- This file is part of the Orion Library.
--
-- Provides unit related helper function, like string-to-Unit conversions, aura checking, and much more.
--------------------------------------------------------

require "Window"
require "GameLib"

local OrionLib = Apollo.GetAddon("OrionLib")
OrionLib.Unit = {}
OrionLib.Unit.__index = OrionLib.Unit

OrionLib.Unit.tUnits = {
	"player"		= GameLib.GetPlayerUnit,
	"target"		= GameLib.GetTargetUnit,
	"focus"  		= function() return nil end, -- nyi
	"targettarget"	= function() return OrionLib.Unit:Get("target"):GetTarget() end
	"focustarget"   = function() return nil end -- nyi
}

-- wraps basic Unit objects with our Wrapper functions
function OrionLib.Unit:Get(sIdentifier)
	sIdentifier = sIdentifier:lower()
	if self.tUnits[sIdentifier] ~= nil then
		local Unit = self.tUnits[sIdentifier]
		local WrappedUnit = OrionLib.Unit.Wrapper
			
		self.wrapped[sIdentifier] = OrionLib.Util.JoinTables(Unit, WrappedUnit)
		return self.wrapped[sIdentifier]
	end
		
	return nil
end

-- wrapper functions
local OrionLib.Unit.Wrapper = {}

-- Aura handling
function OrionLib.Unit.Wrapper:HasAura(iAuraId, bHarmful)
	local sTable = bHarmful and "arHarmful" or "arBeneficial"
	local Auras = self:GetBuffs()
	for i, Aura in ipairs(Auras[sTable]) do
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