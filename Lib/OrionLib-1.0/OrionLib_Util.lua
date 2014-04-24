--------------------------------------------------------
-- UTIL
-- Provides general utilities.
--------------------------------------------------------
OrionLib = OrionLib or {}
OrionLib.Util = {}

if not table.pack then
	function table.pack(...)
		return {n=select('#', ...); ...}
	end
end

if not table.join then
	function table.join(t1, t2)
		for k,v in pairs(t2) do
			t1[k] = v
		end
	
		return t1
	end
end

function OrionLib.Util.Assert(num, value, type, verify, strMessage, level)
	if type(value) ~= type then
		error(("argument %d expected a '%s', got a '%s'"):format(num,type,type(value)),level or 2)
	end
	if verify and not verify(value) then
		error(("argument %d: '%s' %s"):format(num,value,strMessage),level or 2)
	end
end

function OrionLib.Util.AssertString(num, value)
	OrionLib.Util.Assert(num, value, 'string', nil, nil, 3)
end

Apollo.RegisterPackage(OrionLib.Util, "Trox:Orion:Util-1.0", 1)
