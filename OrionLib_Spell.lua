--------------------------------------------------------
-- This file is part of the Orion Library.
--
-- Provides spell related helper function, like name-to-id conversion, cast evaluation, and much more
--------------------------------------------------------
require "Window"
require "GameLib"

local OrionLib = Apollo.GetAddon("OrionLib")
OrionLib.Spell = {}
OrionLib.Spell.__index = OrionLib.Spell
OrionLib.Spell.tSpellCache = {}
