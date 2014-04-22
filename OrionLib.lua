local OrionLib = {}

function OrionLib:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 

    return o
end

function OrionLib:Init()
	local bHasConfigureFunction = false
	local strConfigureButtonText = ""
	local tDependencies = {}
	
    Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
end

----------------------------
local OrionLibInst = OrionLib:new()
OrionLibInst:Init()