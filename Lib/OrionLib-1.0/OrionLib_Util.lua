--------------------------------------------------------
-- UTIL
-- Provides general utilities.
--------------------------------------------------------
OrionLib = OrionLib or {}
OrionLib.Util = {}

function OrionLib.Util.JoinTables(tTable1, tTable2)
	for key, value in pairs(tTable2) do
		tTable1[key] = value
	end
	
	return tTable1
end

Apollo.RegisterPackage(OrionLib.Util, "Trox:Orion:LibUtil-1.0", 1)
