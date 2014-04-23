--------------------------------------------------------
-- UTIL
-- Provides general utilities.
--------------------------------------------------------
local OrionLib_Util = {}

function OrionLib_Util.JoinTables(tTable1, tTable2)
	for key, value in pairs(tTable2) do
		tTable1[key] = value
	end
	
	return tTable1
end

Apollo.RegisterPackage(OrionLib_Unit, "Trox:Orion:LibUtil-1.0", 1)