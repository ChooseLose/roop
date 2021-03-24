--
local function copy(tbl)
    local copy = {}
    
    for i, v in pairs(tbl) do
        copy[
            type(i) == "table" and table.copy(i) or i
        ] = type(v) == "table" and table.copy(v) or v
    end
    
    return copy
end

--
local function randomString(len)
    local s = ""
    
    for i = 1, len do
        s = s .. string.char( math.random(33, 126) )
    end
    
    return s
end

--
local instances = {}

local instance = {
    __index = function(self, key)
        return instances[self.__id].instance[key]
    end,
    __newindex = function(self, key, value)
        instances[self.__id].instance[key] = value
    end,
    __tostring = function(self)
        local class = instances[self.__id].class
        
        return ('{instance "%s" %s}'):format( class.__name or "", self.__address )
    end,
}

local function newInstance(class)
    local classCopy = copy(class)
    local id = randomString(5)
    
    local ins = {instance = classCopy, class = classCopy}
    instances[id] = ins
    
    local returning = {__id = id, __address = tostring(classCopy)}
    --ins.referal = returning
    -- ^ That line of code will make the returning instance never be garbage collected
    
    setmetatable(returning, instance)
    
    return returning
end

    -- Destroy instance
local function destroyInstance(instance)
    instances[instance.__id] = nil
    
    setmetatable(instance, nil)
    instance.__id = nil
    instance.__address = nil
end
        -- Make instances cooperate with garbage collector
function instance:__gc()
    destroyInstance(self)
end

--
local class = {
    __tostring = function(self)
        return ('{class "%s" %s}'):format( self.__name or "", self.__address  )
    end,
    __call = function(self, ...)
        local instance = newInstance(self)
        
        if instance.init then
            instance:init(...)
        end
        
        return instance
    end,
}

local function newClass(name, tbl)
    tbl = tbl or {}
    
    tbl.__name = name
    tbl.__address = tostring(tbl)
    
    setmetatable(tbl, class)
    
    return tbl
end
