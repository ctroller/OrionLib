local OrionLib = Apollo.GetAddon("OrionLib")
OrionLib.Util = {}
OrionLib.Util.__index = OrionLib.Util


function OrionLib.Util.JoinTables(tTable1, tTable2)
	for key, value in pairs(tTable2) do
		tTable1[key] = value
	end
	
	return tTable1
end