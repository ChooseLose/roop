local function c(t)local o={}for i,v in pairs(t)do o[type(i)=="table"and c(i)or i]=type(v)=="table"and c(v)or v end return o end local function randomString(l)local s=""for i=1,l do s=s..string.char(math.random(33,126))end return s end local instances={}local instance={__index=function(self,key)return instances[self.__id].instance[key]end,__newindex=function(self,key,value)instances[self.__id].instance[key]=value end,__tostring=function(self)return('{instance "%s" %s}'):format(instances[self.__id].class.__name or"",self.__address)end}local function newInstance(class)local cp=c(class)local id=randomString(5)local ins={instance=cp,class=class}instances[id]=ins local r={__id=id,__address=tostring(cp)}setmetatable(r,instance)return r end local function destroyInstance(instance)instances[instance.__id]=nil setmetatable(instance,nil)instance.__id=nil instance.__address = nil end function instance:__gc()destroyInstance(self)end local class={__tostring=function(self)return ('{class "%s" %s}'):format(self.__name or"",self.__address)end,__call=function(self,...)local instance=newInstance(self)if instance.init then instance:init(...)end return instance end}local function newClass(name,tbl)tbl=tbl or{}tbl.__name=name tbl.__address=tostring(tbl)setmetatable(tbl,class)return tbl end return{class=newClass,destroy=destroyInstance}
