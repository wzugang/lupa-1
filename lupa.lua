#!/usr/bin/env luajit

local __env=setmetatable({},{__index=_G});package.path  = (";;./src/?.lua;./lib/?.lua;"..tostring(package.path).."");
package.cpath = (";;./lib/?.so;"..tostring(package.cpath).."");

_G.newtable = loadstring(("return {...}"));
_G.bit = require(("bit"));

local _10,_11=_G.rawget,_G.rawset;local rawget,rawset=_10,_11;
local _12,_13=_G.getmetatable,_G.setmetatable;local getmetatable,setmetatable=_12,_13;

_G.__class = function(into, name, _from, _with, body) 
   if (#(_from) )==( (0)) then  
      _from[(#(_from) )+( (1))] = Object;
    end 

   local _14=newtable();local _super=_14;
   local _15=newtable();local _class=_15;
   _class.__name = name;
   _class.__from = _from;

   local _16=newtable();local readers=_16;
   local _17=newtable();local writers=_17;

   _class.__readers = readers;
   _class.__writers = writers;

   local _18=newtable(unpack(_from));local queue=_18;
   while  (#(queue) )>( (0))  do local __break repeat 
      local _19=table.remove(queue, (1));local base=_19;
      if (getmetatable(base) )~=( Class) then  
         error(("TypeError: "..tostring(base).." is not a Class"), (2));
       end 
      _from[base] = (true);
      for k,v in __op_each(pairs(base))  do local __break repeat 
         if (_class[k] )==( (nil)) then   _class[k] = v;  end 
         if (_super[k] )==( (nil)) then   _super[k] = v;  end 
       until true if __break then break end end 
      for k,v in __op_each(pairs(base.__readers))  do local __break repeat 
         if (readers[k] )==( (nil)) then   readers[k] = v;  end 
       until true if __break then break end end 
      for k,v in __op_each(pairs(base.__writers))  do local __break repeat 
         if (writers[k] )==( (nil)) then   writers[k] = v;  end 
       until true if __break then break end end 
      if base.__from then  
         for i=(1), #(base.__from)  do local __break repeat 
            queue[(#(queue) )+( (1))] = base.__from[i];
          until true if __break then break end end 
       end 
    until true if __break then break end end 

   _class.__index = function(obj, key) 
      local _20=readers[key];local reader=_20;
      if reader then    do return reader(obj) end  end 
       do return _class[key] end
    end;
   _class.__newindex = function(obj, key, val) 
      local _21=writers[key];local writer=_21;
      if writer then  
         writer(obj, val);
      
      else 
         rawset(obj, key, val);
       end 
    end;
   _class.__apply = function(self,...) 
      local _22=setmetatable(newtable(), self);local obj=_22;
      if (rawget(self, ("__init")) )~=( (nil)) then  
         local _23=obj:__init(...);local ret=_23;
         if (ret )~=( (nil)) then  
             do return ret end
          end 
       end 
       do return obj end
    end;

   setmetatable(_class, Class);

   local _24=setmetatable(_G.Hash({ }), _G.Hash({ __index = into }));local _env=_24;
   if _with then  
      for i=(1), #(_with)  do local __break repeat 
         _with[i]:compose(_env, _class);
       until true if __break then break end end 
    end 

   into[name] = _class;
   body(_env, _class, _super);

    do return _class end
 end;
_G.__trait = function(into, name, _with, body) 
   local _25=newtable();local _trait=_25;
   _trait.__name = name;
   _trait.__body = body;
   _trait.__with = _with;
   setmetatable(_trait, Trait);
   if into then  
      into[name] = _trait;
    end 
    do return _trait end
 end;
_G.__object = function(into, name, _from, _with, body) 
   for i=(1), #(_from)  do local __break repeat 
      if (getmetatable(_from[i]) )~=( Class) then  
         _from[i] = getmetatable(_from[i]);
       end 
    until true if __break then break end end 
   local _26=__class(into, (("#"))..(name), _from, _with, body);local anon=_26;
   local _27=setmetatable(newtable(), anon);local inst=_27;
   into[name] = inst;
    do return inst end
 end;
_G.__method = function(into, name, code) 
   into[name] = code;
 end;
_G.__has = function(into, name, type, def) 
   local _28=(("__set_"))..(name);local setter=_28;
   local _29=(("__get_"))..(name);local getter=_29;
   if type then  
      into[setter] = function(obj, val) 
         do return rawset(obj, name, type(val)) end
       end;
   
   else 
      into[setter] = function(obj, val) 
         do return rawset(obj, name, val) end
       end;
    end 
   into[getter] = function(obj) 
      local _30=rawget(obj, name);local val=_30;
      if (val )==( (nil)) then  
         val= def(obj);
         obj[setter](obj, val);
       end 
       do return val end
    end;
 end;
_G.__rule = function(into, name, patt) 
   if ((name )==( ("__init") ))or(( rawget(into,(1)) )==( (nil))) then  
      into[(1)] = name;
    end 
   into[name] = patt;
   local _31=(("__rule_"))..(name);local rule_name=_31;
   into[(("__get_"))..(name)] = function(self) 
      local _32=rawget(self, rule_name);local _rule=_32;
      if (_rule )==( (nil)) then  
         local _33=newtable();local grmr=_33;
         for k,v in __op_each(pairs(into))  do local __break repeat 
            if (__patt.type(v) )==( ("pattern")) then  
               grmr[k] = v;
             end 
          until true if __break then break end end 
         grmr[(1)] = name;
         _rule= __patt.P(grmr);
         rawset(self, rule_name, _rule);
       end 
       do return _rule end
    end;
 end;

_G.__try = function(_try, _catch) 
   local _34,_35=pcall(_try);local ok,er=_34,_35;
   if not(ok) then   _catch(er);  end 
 end;

_G.__patt = require(("lpeg"));
_G.__patt.setmaxstack((1024));
do 
   local function make_capt_hash(init) 
       do return function(tab) 
         if (init )~=( (nil)) then  
            for k,v in __op_each(init)  do local __break repeat 
               if (tab[k] )==( (nil)) then   tab[k] = v;  end 
             until true if __break then break end end 
          end 
          do return __op_as(tab , Hash) end
       end end
    end
   local function make_capt_array(init) 
       do return function(tab) 
         if (init )~=( (nil)) then  
            for i=(1), #(init)  do local __break repeat 
               if (tab[i] )==( (nil)) then   tab[i] = init[i];  end 
             until true if __break then break end end 
          end 
          do return __op_as(tab , Array) end
       end end
    end

   __patt.Ch = function(patt,init) 
       do return Pattern.__div(__patt.Ct(patt), make_capt_hash(init)) end
    end;
   __patt.Ca = function(patt,init) 
       do return Pattern.__div(__patt.Ct(patt), make_capt_array(init)) end
    end;

   local _36=newtable();local predef=_36;

   predef.nl  = __patt.P(("\n"));
   predef.pos = __patt.Cp();

   local _37=__patt.P((1));local any=_37;
   __patt.locale(predef);

   predef.a = predef.alpha;
   predef.c = predef.cntrl;
   predef.d = predef.digit;
   predef.g = predef.graph;
   predef.l = predef.lower;
   predef.p = predef.punct;
   predef.s = predef.space;
   predef.u = predef.upper;
   predef.w = predef.alnum;
   predef.x = predef.xdigit;
   predef.A = (any )-( predef.a);
   predef.C = (any )-( predef.c);
   predef.D = (any )-( predef.d);
   predef.G = (any )-( predef.g);
   predef.L = (any )-( predef.l);
   predef.P = (any )-( predef.p);
   predef.S = (any )-( predef.s);
   predef.U = (any )-( predef.u);
   predef.W = (any )-( predef.w);
   predef.X = (any )-( predef.x);

   __patt.predef = predef;
   __patt.Def = function(id) 
      if (predef[id] )==( (nil)) then  
         error(("No predefined pattern '"..tostring(id).."'"), (2));
       end 
       do return predef[id] end
    end;
 end

_G.__env = _G;

_G.__import = function(into, _from, what) 
   local _38=__load(_from);local mod=_38;
   if what then  
      for i=(1), #(what)  do local __break repeat 
         into[what[i]] = mod[what[i]];
       until true if __break then break end end 
   
   else 
       do return mod end
    end 
 end;
_G.__export = function(self,...) local what=_G.Array(...)
   for i=(1), #(what)  do local __break repeat 
      self.__export[what[i]] = (true);
    until true if __break then break end end 
 end;

_G.__load = function(_from) 
   local _39=_from;local path=_39;
   if (type(_from) )==( ("table")) then  
      path= table.concat(_from, ("."));
    end 
   local _40=require(path);local mod=_40;
   if (mod )==( (true)) then  
      mod= _G;
      for i=(1), #(_from)  do local __break repeat 
         mod= mod[_from[i]];
       until true if __break then break end end 
    end 
    do return mod end
 end;

_G.__op_as     = setmetatable;
_G.__op_typeof = getmetatable;
_G.__op_yield  = coroutine[("yield")];
_G.__op_throw  = error;

_G.__op_in = function(key, obj) 
    do return (rawget(obj, key) )~=( (nil)) end
 end;
_G.__op_like = function(this, that) 
   for k,v in __op_each(pairs(that))  do local __break repeat 
      if (type(this[k]) )~=( type(v)) then  
          do return (false) end
       end 
      if not(this[k]:isa(getmetatable(v))) then  
          do return (false) end
       end 
    until true if __break then break end end 
    do return (true) end
 end;
_G.__op_spread = function(a) 
   local _41=getmetatable(a);local mt=_41;
   local _42=(mt )and( rawget(mt, ("__spread")));local __spread=_42;
   if __spread then    do return __spread(a) end  end 
    do return unpack(a) end
 end;
_G.__op_each = function(a,...) 
   if (type(a) )==( ("function")) then    do return a,... end  end 
   local _43=getmetatable(a);local mt=_43;
   local _44=(mt )and( rawget(mt, ("__each")));local __each=_44;
   if __each then    do return __each(a) end  end 
    do return pairs(a) end
 end;
_G.__op_lshift = function(a,b) 
   local _45=getmetatable(a);local mt=_45;
   local _46=(mt )and( rawget(mt, ("__lshift")));local __lshift=_46;
   if __lshift then    do return __lshift(a, b) end  end 
    do return bit.lshift(a, b) end
 end;
_G.__op_rshift = function(a,b) 
   local _47=getmetatable(a);local mt=_47;
   local _48=(mt )and( rawget(mt, ("__rshift")));local __rshift=_48;
   if __rshift then    do return __rshift(a, b) end  end 
    do return bit.rshift(a, b) end
 end;
_G.__op_arshift = function(a,b) 
   local _49=getmetatable(a);local mt=_49;
   local _50=(mt )and( rawget(mt, ("__arshift")));local __arshift=_50;
   if __arshift then    do return __arshift(a, b) end  end 
    do return bit.arshift(a, b) end
 end;
_G.__op_bor = function(a,b) 
   local _51=getmetatable(a);local mt=_51;
   local _52=(mt )and( rawget(mt, ("__bor")));local __bor=_52;
   if __bor then    do return __bor(a, b) end  end 
    do return bit.bor(a, b) end
 end;
_G.__op_bxor = function(a,b) 
   local _53=getmetatable(a);local mt=_53;
   local _54=(mt )and( rawget(mt, ("__bxor")));local __bxor=_54;
   if __bxor then    do return __bxor(a, b) end  end 
    do return bit.bxor(a, b) end
 end;
_G.__op_band = function(a,b) 
   local _55=getmetatable(a);local mt=_55;
   local _56=(mt )and( rawget(mt, ("__band")));local __band=_56;
   if __band then    do return __band(a, b) end  end 
    do return bit.band(a, b) end
 end;
_G.__op_bnot = function(a) 
   local _57=getmetatable(a);local mt=_57;
   local _58=(mt )and( rawget(mt, ("__bnot")));local __bnot=_58;
   if __bnot then    do return __bnot(a) end  end 
    do return bit.bnot(a) end
 end;

_G.Type = newtable();
Type.__name = ("Type");
Type.__call = function(self,...) 
    do return self:__apply(...) end
 end;
Type.isa = function(self, that) 
    do return (getmetatable(self) )==( that) end
 end;
Type.can = function(self, key) 
    do return (rawget(self, key) )or( rawget(getmetatable(self), key)) end
 end;
Type.does = function(self, that) 
    do return (false) end
 end;
Type.__index = Type;
Type.__tostring = function(self) 
    do return (("type "))..(((rawget(self, ("__name")) )or( ("Type")))) end
 end;

_G.Class = setmetatable(newtable(), Type);
Class.__tostring = function(self) 
    do return self.__name end
 end;
Class.__index = function(self, key) 
   do return error(("AccessError: no such member '"..tostring(key).."' in "..tostring(self.__name)..""), (2)) end
 end;
Class.__newindex = function(self, key, val) 
   if (type(key) )==( ("string")) then  
      if key:match(("^__get_")) then  
         local _59=key:match(("^__get_(.-)$"));local _k=_59;
         self.__readers[_k] = val;
      
       elseif key:match(("^__set_")) then  
         local _60=key:match(("^__set_(.-)$"));local _k=_60;
         self.__writers[_k] = val;
       end 
    end 
   do return rawset(self, key, val) end
 end;
Class.__call = function(self,...) 
    do return self:__apply(...) end
 end;

_G.Object = setmetatable(newtable(), Class);
Object.__name = ("Object");
Object.__from = newtable();
Object.__with = newtable();
Object.__readers = newtable();
Object.__writers = newtable();
Object.__tostring = function(self) 
    do return ("object "..tostring(getmetatable(self)).."") end
 end;
Object.__index = Object;
Object.isa = function(self, that) 
   local _61=getmetatable(self);local meta=_61;
    do return ((meta )==( that ))or( ((meta.__from )and( ((meta.__from[that] )~=( (nil)))))) end
 end;
Object.can = function(self, key) 
   local _62=getmetatable(self);local meta=_62;
    do return rawget(meta, key) end
 end;
Object.does = function(self, that) 
    do return (self.__with[that.__body] )~=( (nil)) end
 end;

_G.Trait = setmetatable(newtable(), Type);
Trait.__call = function(self,...) local args=_G.Array(...)
   local _63=__trait((nil), self.__name, self.__with, self.__body);local copy=_63;
   local _64=self.compose;local make=_64;
   copy.compose = function(self, into, recv) 
       do return make(self, into, recv, __op_spread(args)) end
    end;
    do return copy end
 end;
Trait.__tostring = function(self) 
    do return (("trait "))..(self.__name) end
 end;
Trait.__index = Trait;
Trait.compose = function(self, into, recv,...) 
   for i=(1), #(self.__with)  do local __break repeat 
      self.__with[i]:compose(into, recv);
    until true if __break then break end end 
   self.__body(into, recv, ...);
   recv.__with[self.__body] = (true);
    do return into end
 end;

_G.Hash = setmetatable(newtable(), Type);
Hash.__name = ("Hash");
Hash.__index = Hash;
Hash.__apply = function(self, table) 
    do return setmetatable((table )or( newtable()), self) end
 end;
Hash.__tostring = function(self) 
   local _65=newtable();local buf=_65;
   for k, v in __op_each(pairs(self))  do local __break repeat 
      local _66;local _v=_66;
      if (type(v) )==( ("string")) then  
         _v= string.format(("%q"), v);
      
      else 
         _v= tostring(v);
       end 
      if (type(k) )==( ("string")) then  
         buf[(#(buf) )+( (1))] = ((k)..(("=")))..(_v);
      
      else 
         buf[(#(buf) )+( (1))] = ("["..tostring(k).."]="..tostring(_v).."");
       end 
    until true if __break then break end end 
    do return ((("{"))..(table.concat(buf, (","))))..(("}")) end
 end;
Hash.__getitem = rawget;
Hash.__setitem = rawset;
Hash.__each = pairs;

_G.Array = setmetatable(newtable(), Type);
Array.__name = ("Array");
Array.__index = Array;
Array.__apply = function(self,...) 
    do return setmetatable(newtable(...), self) end
 end;
Array.__tostring = function(self) 
   local _67=newtable();local buf=_67;
   for i=(1), #(self)  do local __break repeat 
      if (type(self[i]) )==( ("string")) then  
         buf[(#(buf) )+( (1))] = string.format(("%q"), self[i]);
      
      else 
         buf[(#(buf) )+( (1))] = tostring(self[i]);
       end 
    until true if __break then break end end 
    do return ((("["))..(table.concat(buf,(","))))..(("]")) end
 end;
Array.__each = ipairs;
Array.__spread = unpack;
Array.__getitem = rawget;
Array.__setitem = rawset;
Array.unpack = unpack;
Array.insert = table.insert;
Array.remove = table.remove;
Array.concat = table.concat;
Array.sort = table.sort;
Array.each = function(self, block) 
   for i=(1), #(self)  do local __break repeat  block(self[i]);  until true if __break then break end end 
 end;
Array.map = function(self, block) 
   local _68=Array();local out=_68;
   for i=(1), #(self)  do local __break repeat 
      local _69=self[i];local v=_69;
      out[(#(out) )+( (1))] = block(v);
    until true if __break then break end end 
    do return out end
 end;
Array.inject = function(self, block) 
   for i=(1), #(self)  do local __break repeat 
      self[i] = block(self[i]);
    until true if __break then break end end 
    do return self end
 end;
Array.grep = function(self, block) 
   local _70=Array();local out=_70;
   for i=(1), #(self)  do local __break repeat 
      local _71=self[i];local v=_71;
      if block(v) then  
         out[(#(out) )+( (1))] = v;
       end 
    until true if __break then break end end 
    do return out end
 end;
Array.push = function(self, v) 
   self[(#(self) )+( (1))] = v;
 end;
Array.pop = function(self) 
   local _72=self[#(self)];local v=_72;
   self[#(self)] = (nil);
    do return v end
 end;
Array.shift = function(self) 
   local _73=self[(1)];local v=_73;
   for i=(2), #(self)  do local __break repeat 
      self[(i)-((1))] = self[i];
    until true if __break then break end end 
   self[#(self)] = (nil);
    do return v end
 end;
Array.unshift = function(self, v) 
   for i=(#(self))+((1)), (1), -((1))  do local __break repeat 
      self[i] = self[(i)-((1))];
    until true if __break then break end end 
   self[(1)] = v;
 end;
Array.splice = function(self, offset, count,...) local args=_G.Array(...)
   local _74=Array();local out=_74;
   for i=offset, ((offset )+( count ))-( (1))  do local __break repeat 
      out:push(self:remove(offset));
    until true if __break then break end end 
   for i=#(args), (1), -((1))  do local __break repeat 
      self:insert(offset, args[i]);
    until true if __break then break end end 
    do return out end
 end;
Array.reverse = function(self) 
   local _75=Array();local out=_75;
   for i=(1), #(self)  do local __break repeat 
      out[i] = self[(((#(self) )-( i)) )+( (1))];
    until true if __break then break end end 
    do return out end
 end;

_G.Range = setmetatable(newtable(), Type);
Range.__name = ("Range");
Range.__index = Range;
Range.__apply = function(self, min, max, inc) 
   min= assert(tonumber(min), ("range min is not a number"));
   max= assert(tonumber(max), ("range max is not a number"));
   inc= assert(tonumber((inc )or( (1))), ("range inc is not a number"));
    do return setmetatable(newtable(min, max, inc), self) end
 end;
Range.__each = function(self) 
   local _76=self[(3)];local inc=_76;
   local _77=(self[(1)] )-( inc);local cur=_77;
   local _78=self[(2)];local max=_78;
    do return function() 
      cur= (cur )+( inc);
      if (cur )<=( max) then  
          do return cur end
       end 
    end end
 end;
Range.each = function(self, block) 
   for i in __op_each(Range:__each(self))  do local __break repeat 
      block(i);
    until true if __break then break end end 
 end;

_G.Nil = setmetatable(newtable(), Type);
Nil.__name = ("Nil");
Nil.__index = function(self, key) 
   local _79=Type[key];local val=_79;
   if (val )==( (nil)) then  
      error(("TypeError: no such member "..tostring(key).." in type Nil"), (2));
    end 
    do return val end
 end;
debug.setmetatable((nil), Nil);

_G.Number = setmetatable(newtable(), Type);
Number.__name = ("Number");
Number.__index = Number;
Number.__apply = function(self, val) 
   local _80=tonumber(val);local v=_80;
   if (v )==( (nil)) then  
      error(("TypeError: cannot coerce '"..tostring(val).."' to Number"), (2));
    end 
    do return v end
 end;
Number.times = function(self, block) 
   for i=(1), self  do local __break repeat  block(i);  until true if __break then break end end 
 end;
debug.setmetatable((0), Number);

_G.String = setmetatable(string, Type);
String.__name = ("String");
String.__index = String;
String.__apply = function(self, val) 
    do return tostring(val) end
 end;
String.__match = function(a,p) 
    do return __patt.P(p):match(a) end
 end;
String.split = function(str, sep, max) 
   if not(str:find(sep)) then  
       do return Array(str) end
    end 
   if ((max )==( (nil) ))or((  max )<( (1))) then  
      max= (0);
    end 
   local _81=((("(.-)"))..(sep))..(("()"));local pat=_81;
   local _82=(0);local idx=_82;
   local _83=Array();local list=_83;
   local _84;local last=_84;
   for part, pos in __op_each(str:gmatch(pat))  do local __break repeat 
      idx= (idx )+( (1));
      list[idx] = part;
      last= pos;
      if (idx )==( max) then   do __break = true; break end  end 
    until true if __break then break end end 
   if (idx )~=( max) then  
      list[(idx )+( (1))] = str:sub(last);
    end 
    do return list end
 end;
debug.setmetatable((""), String);

_G.Boolean = setmetatable(newtable(), Type);
Boolean.__name = ("Boolean");
Boolean.__index = Boolean;
debug.setmetatable((true), Boolean);

_G.Function = setmetatable(newtable(), Type);
Function.__name = ("Function");
Function.__index = Function;
Function.__apply = function(self, code,...) 
   local _85=_G.Array( ... );local args=_85;
   code= compile(code, ("=eval"), args);
   local _86=assert(loadstring(code, ("=eval")));local func=_86;
    do return func end
 end;
debug.setmetatable(function()   end, Function);

_G.Coroutine = setmetatable(newtable(), Type);
Coroutine.__name = ("Coroutine");
Coroutine.__index = Coroutine;
for k,v in __op_each(pairs(coroutine))  do local __break repeat 
   Coroutine[k] = v;
 until true if __break then break end end 
debug.setmetatable(coroutine.create(function()   end), Coroutine);

_G.Pattern = setmetatable(getmetatable(__patt.P((1))), Type);
Pattern.__call = function(patt, self, subj,...) 
    do return patt:match(subj, ...) end
 end;
Pattern.__match = function(patt, subj) 
    do return patt:match(subj) end
 end;

__class(__env,"Scope",{},{},function(__env,self,super) 
   __has(self,"entries",nil,function(self) return (_G.Hash({ })) end);
   __has(self,"outer",nil,function(self) return (_G) end);
   __method(self,"__init",function(self,outer) 
      self.outer = outer;
    end);
   __method(self,"lookup",function(self,name) 
      if __op_in(name , self.entries) then  
          do return self.entries[name] end
      
       elseif __op_in(("outer") , self) then  
          do return self.outer:lookup(name) end
       end 
    end);
   __method(self,"define",function(self,name, info) 
      self.entries[name] = (info )or( _G.Hash({ }));
    end);
 end);

__class(__env,"Context",{},{},function(__env,self,super) 
   __has(self,"scope",nil,function(self) return (__env.Scope()) end);
   __method(self,"enter",function(self) 
      self.scope = __env.Scope(self.scope);
    end);
   __method(self,"leave",function(self) 
      if __op_in(("outer") , self.scope) then  
         local _87=self.scope.outer;local outer=_87;
         self.scope = outer;
          do return outer end
       end 
      do return error(("no outer scope")) end
    end);
   __method(self,"define",function(self,name, info) 
      do return self.scope:define(name, info) end
    end);
   __method(self,"lookup",function(self,name) 
      do return self.scope:lookup(name) end
    end);
 end);

__object(__env,"Grammar",{},{},function(__env,self,super) 

   local function error_line(src, pos) 
      local _88=(1);local line=_88;
      local _89,_90=(1),pos;local index,limit=_89,_90;
      while (index )<=( limit)  do local __break repeat 
         local _91,_92=src:find(("\n"), index, (true));local s,e=_91,_92;
         if ((s )==( (nil) ))or(( e )>( limit)) then   do __break = true; break end  end 
         index= (e )+( (1));
         line= (line )+( (1));
       until true if __break then break end end 
       do return line end
    end
   local function error_near(src, pos) 
      if ((#(src) )<(( pos )+( (20)))) then  
          do return src:sub(pos) end
      
      else 
          do return (src:sub(pos, (pos )+( (20))))..(("...")) end
       end 
    end
   local function syntax_error(m) 
       do return function(src, pos) 
         local _93,_94=error_line(src, pos),error_near(src, pos);local line,near=_93,_94;
         do return error(("SyntaxError: "..tostring((m)or((""))).." on line "..tostring(line).." near '"..tostring(near).."'")) end
       end end
    end

   local _95=(9);local id_counter=_95;
   local function genid() 
      id_counter=(id_counter)+((1));
       do return (("_"))..(id_counter) end
    end

   local function define(name, ctx, base, type) 
      ctx:define(name, _G.Hash({ base = base, type = type }));
       do return name end
    end
   local function define_const(name, ctx,...) 
      ctx:define(name, ...);
      
   do return  end end
   local function enter(ctx) 
      ctx:enter();
      
   do return  end end
   local function leave(ctx) 
      ctx:leave();
      
   do return  end end

   local function lookup(name, ctx) 
      local _96=ctx:lookup(name);local info=_96;
      if info then  
         if info.base then    do return ((info.base)..((".")))..(name) end  end 
          do return name end
       end 
       do return (("__env."))..(name) end
    end
   local function lookup_or_define(name, ctx) 
      local _97=ctx:lookup(name);local info=_97;
      if not(info) then  
         define(name, ctx, ("__env"));
          do return (("__env."))..(name) end
       end 
      if info.base then  
          do return ((info.base)..((".")))..(name) end
       end 
       do return name end
    end

   local function quote(c)  do return ("%q"):format(c) end  end

   local _98=__patt.P( __patt.P(("\n")) );local nl=_98;
   local _99=__patt.P( __patt.Cs(
       ((-nl* __patt.Def("s"))^0* ((__patt.P(("//")) )/( ("--")))* (-nl* __patt.P(1))^0* nl)
      + ((__patt.P(("/*")) )/( ("--[=[")))* ((__patt.P(("]=]")) )/( ("]\\=]")) + -__patt.P(("*/"))* __patt.P(1))^0* ((__patt.P(("*/")) )/( ("]=]")))
   ) );local comment=_99;
   local _100=__patt.P( -(__patt.Def("alnum") + __patt.P(("_"))) );local idsafe=_100;
   local _101=__patt.P( (comment + __patt.Def("s"))^0 );local s=_101;
   local _102=__patt.P( ((__patt.P((";")) )/( ("")))^-1 );local semicol=_102;
   local _103=__patt.P( (__patt.Def("digit")* __patt.Cs( (__patt.P(("_")) )/( ("")) )^-1)^1 );local digits=_103;
   local _104=__patt.P( (
      __patt.P(("var")) + __patt.P(("function")) + __patt.P(("class")) + __patt.P(("with")) + __patt.P(("like")) + __patt.P(("in"))
      + __patt.P(("nil")) + __patt.P(("true")) + __patt.P(("false")) + __patt.P(("typeof")) + __patt.P(("return")) + __patt.P(("as"))
      + __patt.P(("for")) + __patt.P(("throw")) + __patt.P(("method")) + __patt.P(("has")) + __patt.P(("from")) + __patt.P(("break"))
      + __patt.P(("continue")) + __patt.P(("import")) + __patt.P(("try")) + __patt.P(("catch"))
      + __patt.P(("finally")) + __patt.P(("if")) + __patt.P(("else")) + __patt.P(("yield")) + __patt.P(("rule"))
   )* idsafe );local keyword=_104;

   local _105=_G.Hash({
      [("^^")]  = (4),
      [("*")]   = (5),
      [("/")]   = (5),
      [("%")]   = (5),
      [("+")]   = (6),
      [("-")]   = (6),
      [("~")]   = (6),
      [(">>")]  = (7),
      [("<<")]  = (7),
      [(">>>")] = (7),
      [("&")]   = (8),
      [("^")]   = (9),
      [("|")]   = (10),
      [("<=")]  = (11),
      [(">=")]  = (11),
      [("<")]   = (11),
      [(">")]   = (11),
      [("in")]  = (11),
      [("as")]  = (11),
      [("==")]  = (12),
      [("!=")]  = (12),
      [("&&")]  = (13),
      [("||")]  = (14),
   });local prec=_105;

   local _106=_G.Hash({
      [("!")] = ("not(%s)"),
      [("#")] = ("#(%s)"),
      [("-")] = ("-(%s)"),
      [("~")] = ("__op_bnot(%s)"),
      [("@")] = ("__op_spread(%s)"),
      [("throw")] = ("__op_throw(%s)"),
      [("typeof")] = ("__op_typeof(%s)"),
   });local unrops=_106;

   local _107=_G.Hash({
      [("^^")] = ("(%s)^(%s)"),
      [("*")] = ("(%s)*(%s)"),
      [("/")] = ("(%s)/(%s)"),
      [("%")] = ("(%s)%%(%s)"),
      [("+")] = ("(%s)+(%s)"),
      [("-")] = ("(%s)-(%s)"),
      [("~")] = ("(%s)..(%s)"),
      [(">>")] = ("__op_rshift(%s,%s)"),
      [("<<")] = ("__op_lshift(%s,%s)"),
      [(">>>")] = ("__op_arshift(%s,%s)"),
      [("<=")] = ("(%s)<=(%s)"),
      [(">=")] = ("(%s)>=(%s)"),
      [("<")] = ("(%s)<(%s)"),
      [(">")] = ("(%s)>(%s)"),
      [("in")] = ("__op_in(%s,%s)"),
      [("as")] = ("__op_as(%s,%s)"),
      [("==")] = ("(%s)==(%s)"),
      [("!=")] = ("(%s)~=(%s)"),
      [("&")] = ("__op_band(%s,%s)"),
      [("^")] = ("__op_bxor(%s,%s)"),
      [("|")] = ("__op_bor(%s,%s)"),
      [("&&")] = ("(%s)and(%s)"),
      [("||")] = ("(%s)or(%s)"),
   });local binops=_107;

   local function fold_prefix(o,e) 
      if ((o )==( ("#") ))and( e:match(("^%s*%.%.%.%s*$"))) then  
          do return ("select(\"#\",...)") end
       end 
       do return unrops[o]:format(e) end
    end

   --/*
   local function fold_infix(e) 
      local _108=_G.Array( e[(1)] );local s=_108;
      for i=(2), #(e)  do local __break repeat 
         s[(#(s) )+( (1))] = e[i];
         while (not(binops[s[#(s)]]) )and( s[(#(s) )-( (1))])  do local __break repeat 
            local _109=s[(#(s) )-( (1))];local p=_109;
            local _110=e[(i )+( (1))];local n=_110;
            if ((n )==( (nil) ))or(( prec[p] )<=( prec[n])) then  
               local _111,_112,_113=s:pop(),s:pop(),s:pop();local b,o,a=_111,_112,_113;
               if not(binops[o]) then  
                  error(("bad expression: "..tostring(e)..", stack: "..tostring(s)..""));
                end 
               s:push(binops[o]:format(a, b));
            
            else 
               do __break = true; break end
             end 
          until true if __break then break end end 
       until true if __break then break end end 
       do return s[(1)] end
    end
   --*/

   --[=[ enable for recursive descent expr parsing
   function fold_infix(a,o,b) {
      return binops[o].format(a,b)
   }
   //]=]

   local function make_slot_decl(ctx, name, type, body) 
      if (type )~=( ("nil")) then  
         type= lookup(type, ctx);
          do return ("__has(self,\"%s\",%s,function(self) return %s(%s) end);"):format(name,type,type,body) end
       end 
       do return ("__has(self,\"%s\",%s,function(self) return (%s) end);"):format(name,type,body) end
    end

   local function make_binop_bind(ctx, a1, a2, o, b) 
      a1= __env.Grammar.expr:match(a1, (nil), ctx);
      local _114=ctx:lookup(a1);local info=_114;
      local _115=binops[o];local oper=_115;
      if info.type then  
         local _116=lookup(info.type, ctx);local type=_116;
         oper= ((type)..(("(%s)"))):format(oper);
       end 
       do return a2:format(oper:format(a1,b)) end
    end

   local function make_bind_expr(ctx, l, s1, s2, r) 
      if (#(l) )==( (1)) then  
         local _117=l[(1)]:match(("^([%w_]+)%s*="));local name=_117;
         if name then  
            local _118=ctx:lookup(name);local info=_118;
            if info.type then  
               local _119=lookup(info.type, ctx);local type=_119;
               r[(1)] = ((type)..(("(%s)"))):format(r[(1)]);
             end 
          end 
          do return l[(1)]:format((s2 )..( r:concat((",")))) end
       end 
      local _120=_G.Array( );local t=_120;
      for i=(1), #(l)  do local __break repeat 
         t:push(genid());
         local _121=l[i]:match(("^([%w_]+)%s*="));local name=_121;
         if name then  
            local _122=ctx:lookup(name);local info=_122;
            if info.type then  
               local _123=lookup(info.type, ctx);local type=_123;
               t[i] = ((type)..(("(%s)"))):format(t[i]);
             end 
          end 

         l[i] = l[i]:format(t[i]);
       until true if __break then break end end 
      local _124=_G.Array( );local b=_124;
      b:push(("local %s%s=%s%s;"):format(t:concat((",")), s1, s2, r:concat((","))));
      b:push(l:concat((";")));
       do return b:concat() end
    end 

   local function make_var_decl(ctx, lhs, rhs) 
      rhs= (rhs )or( _G.Array( ));
      local _125=_G.Array( );local tmp=_125;
      local _126=_G.Array( );local buf=_126;

      for i=(1), #(lhs)  do local __break repeat 
         tmp:push(genid());
       until true if __break then break end end 

      if (#(rhs) )>( (0)) then  
         buf:push(("%s=%s"):format(tmp:concat((",")), rhs:concat((","))));
      
      else 
         buf:push(tmp:concat());
       end 

      for i=(1), #(lhs)  do local __break repeat 
         local _127=ctx:lookup(lhs[i]);local info=_127;
         if info.type then  
            local _128=lookup(info.type, ctx);local type=_128;
            tmp[i] = ((type)..(("(%s)"))):format(tmp[i]);
          end 
       until true if __break then break end end 

      buf:push(("local %s=%s;"):format(lhs:concat((",")), tmp:concat((","))));
       do return buf:concat((";")) end
    end

   local function make_params(ctx, list) 
      local _129=_G.Array( );local head=_129;
      if (#(list) )>( (0)) then  
         for i=(1), #(list)  do local __break repeat 
            local _130=list[i];local name=_130;
            if not(name:find(("%.%.%."))) then  
               name= name:match(("^%s*([^%s]+)%s*$"));
               local _131=ctx:lookup(name);local info=_131; 
               if info.type then  
                  local _132=lookup(info.type, ctx);local type=_132;
                  head:push(((((name)..(("=")))..(type))..(("(%s)"))):format(name));
                end 
             end 
          until true if __break then break end end 
         if list[#(list)]:find(("..."), (1), (true)) then  
            local _133=list[#(list)];local last=_133;
            local _134=last:match(("%.%.%.([%w_]+)"));local name=_134;
            list[#(list)] = ("...");
            if name then  
               local _135=ctx:lookup(name);local info=_135; 
               if info.type then  
                  local _136=lookup(info.type, ctx);local type=_136;
                  head:push((("local %s=_G.Array(...):inject(%s)")):format(name,type));
               
               else 
                  head:push(("local %s=_G.Array(...)"):format(name));
                end 
             end 
          end 
       end 
       do return list:concat((",")),head:concat((";")) end
    end

   local function make_return_stmt(ctx, is_lex, expr_list, ret_guard) 
      expr_list= (expr_list )or( _G.Array( ));
      if ret_guard then  
         for i=(1), #(ret_guard)  do local __break repeat 
            local _137=lookup(ret_guard[i], ctx);local type=_137;
            local _138=(expr_list[i] )or( ("nil"));local expr=_138;
            expr_list[i] = ((type)..(("(%s)"):format(expr)));
          until true if __break then break end end 
       end 
      local _139=expr_list:concat((","));local e=_139;
      if is_lex then  
          do return ("do __return = {%s}; return end"):format(e) end
       end 
       do return ("do return %s end"):format(e) end
    end

   local function make_func(c,p,b) 
      local _140,_141=make_params(c, p);local p,h=_140,_141;
       do return ("function(%s) %s%s end"):format(p,h,b) end
    end

   local function make_short_func(c,p,b) 
      if (#(p) )==( (0)) then   p:push(("_"));  end 
      c:define(("_"));
      local _142,_143=make_params(c, p);local p,h=_142,_143;
       do return ("function(%s) %s%s end"):format(p,h,b) end
    end

   local function make_func_decl(c,n,p,b,s) 
      local _144,_145=make_params(c, p);local p,h=_144,_145;
      if ((s )==( ("lexical") ))and(( #(n) )==( (1))) then  
         c.scope.outer:define(n[(1)]);
          do return ("local function %s(%s) %s%s end"):format(n[(1)],p,h,b) end
      
       elseif (#(n) )==( (1)) then  
          do return ("function __env.%s(%s) %s%s end"):format(n[(1)],p,h,b) end
       end 
       do return ("function %s(%s) %s%s end"):format(n:concat((".")),p,h,b) end
    end

   local function make_meth_decl(ctx,n,p,b) 
      p:unshift(("self"));
      local _146,_147=make_params(ctx,p);local p,h=_146,_147;
       do return ("__method(self,%q,function(%s) %s%s end);"):format(n,p,h,b) end
    end

   local function make_trait_decl(c,n,p,w,b) 
      local _148,_149=make_params(c, p);local p,h=_148,_149;
      
      do return ("__trait(__env,%q,{%s},function(__env,self,%s) %s%s end);")
         :format(n,w,p,h,b) end
    end

   local function make_try_stmt(try_body, catch_args, catch_body) 
       do return (
         (((("do local __return;"))..(
         ("__try(function() %s end,function(%s) %s end);") ))..(
         ("if __return then return __op_spread(__return) end")))..(
         (" end"))
      ):format(try_body, (catch_args )or( ("")), (catch_body )or( (""))) end
    end
   local function make_import_stmt(c, n,f) 
      local _150=_G.Array( );local q=_150;
      for i=(1), #(n)  do local __break repeat 
         c:define(n[i], _G.Hash({ base = ("__env") }));
         q[i] = quote(n[i]);
       until true if __break then break end end 
       do return ("__import(__env,%q,{%s});"):format(f, q:concat((","))) end
    end
   local function make_export_stmt(n) 
      local _151=_G.Array( );local b=_151;
      for i=(1), #(n)  do local __break repeat 
         local _152=quote(n[i]);local q=_152;
         b[i] = ("__export[%s]=true;"):format(q);
       until true if __break then break end end 
       do return b:concat(("")) end
    end

   __method(self,"match",function(self,...) 
      do return self.__init:match(...) end
    end);

   __rule(self,"__init",
      __patt.Cs( __patt.V("unit") )* (-__patt.P(1) + __patt.P(syntax_error(("expected <EOF>"))))
   );
   __rule(self,"unit",
      __patt.Cg( __patt.Cc((false)),"set_return")*
      __patt.Cg( __patt.Cc((nil)),"ret_guard")*
      __patt.Cg( __patt.Cc(("global")),"scope")*
      __patt.C( __patt.Def("s")^0* __patt.P(("#!"))* (-nl* __patt.P(1))^0* __patt.Def("s")^0 )^-1* s*
      __patt.Cc(("local __env=setmetatable({},{__index=_G});"))*
      __patt.V("enter")*
      (__patt.Cc(("_G")   )* (__patt.V("ctx") )/( define_const))*
      (__patt.Cc(("__env"))* (__patt.V("ctx") )/( define_const))*
      __patt.Cs( (s* __patt.V("main_body_stmt"))^0* s )*
      __patt.V("leave")*
      __patt.Cc(("return __env;"))
   );

   __rule(self,"ctx", __patt.Carg(1) );
   __rule(self,"enter", (__patt.V("ctx") )/( enter) );
   __rule(self,"leave", (__patt.V("ctx") )/( leave) );

   __rule(self,"main_body_stmt",
       __patt.V("var_decl")
      + __patt.V("func_decl")
      + __patt.V("class_decl")
      + __patt.V("trait_decl")
      + __patt.V("object_decl")
      + __patt.V("import_stmt")
      + __patt.V("statement")
   );
   __rule(self,"statement",
       __patt.V("if_stmt")
      + __patt.V("try_stmt")
      + __patt.V("for_stmt")
      + __patt.V("for_in_stmt")
      + __patt.V("do_while_stmt")
      + __patt.V("while_stmt")
      + __patt.V("break_stmt")
      + __patt.V("continue_stmt")
      + __patt.V("yield_stmt")
      + __patt.V("block_stmt")
      + __patt.V("bind_stmt")
      + __patt.V("call_stmt")
      + -(s* (__patt.P(("}")) + -__patt.P(1)))* __patt.P( syntax_error(("invalid statement")) )
   );
   __rule(self,"call_stmt",
      __patt.Cs( (__patt.Cs(
         __patt.V("primary")* s* (
         __patt.V("invoke_expr") + __patt.P(syntax_error(("expected <invoke_expr>")) )
      ) ) )/( ("%1;"))* semicol )
   );
   __rule(self,"return_stmt",
      __patt.Cs( (__patt.P(("return")) )/( (""))* idsafe* s* (
         __patt.V("ctx")*
         __patt.Cb("set_return")* __patt.Ca( (__patt.V("expr")* (s* __patt.P((","))* s* __patt.V("expr"))^0)^-1 )*
         (__patt.Cb("ret_guard")
         )/( make_return_stmt))
      )
   );
   __rule(self,"yield_stmt",
      __patt.P(("yield"))* idsafe* (__patt.Cs( s* __patt.V("expr_list") ) )/( ("__op_yield(%1);"))* semicol
   );
   __rule(self,"break_stmt",
      __patt.Cs( (__patt.C( __patt.P(("break"))* idsafe ) )/( ("do __break = true; break end")) )
   );
   __rule(self,"continue_stmt",
      __patt.Cs( (__patt.C( __patt.P(("continue"))* idsafe ) )/( ("do break end")) )
   );
   __rule(self,"if_stmt",
      __patt.Cs(
      __patt.P(("if"))* idsafe* s* __patt.V("expr")* __patt.Cc((" then "))* s* __patt.V("block")* (
         (s* ((__patt.C(__patt.P(("else"))* idsafe* s* __patt.P(("if"))* idsafe) )/( (" elseif")))* s*
            __patt.V("expr")* __patt.Cc((" then "))* s* __patt.V("block")
         )^0*
         (s* __patt.P(("else"))* idsafe* s* __patt.V("block")* __patt.Cc((" end ")) + __patt.Cc((" end ")))
      )
      )
   );
   __rule(self,"try_stmt",
      __patt.Cs(
      __patt.P(("try"))* idsafe* s*
      __patt.P(("{"))* __patt.Cs( __patt.V("lambda_body")* s )* (__patt.P(("}")) + __patt.P( syntax_error(("expected '}'")) ))*
      ((s* __patt.P(("catch"))* idsafe* s*
         __patt.P(("("))* s* __patt.Cs( __patt.V("enter")* __patt.V("param") )* s* __patt.P((")"))* s*
         __patt.P(("{"))* __patt.Cs( __patt.V("lambda_body")* s* __patt.V("leave") )* __patt.P(("}"))
      )^-1
      )/( make_try_stmt)
      )
   );
   __rule(self,"import_stmt",
      __patt.Cs( ((__patt.P(("import"))* idsafe* s*
         __patt.V("ctx")* __patt.Ca( __patt.V("name")* (s* __patt.P((","))* s* __patt.V("name"))^0 )* s* __patt.P(("from"))* s* __patt.Cs( __patt.V("name")* (__patt.P(("."))* __patt.V("name"))^0 )
      ) )/( make_import_stmt) )
   );
   __rule(self,"export_stmt",
      __patt.Cs( __patt.P(("export"))* idsafe* s* (__patt.Ca( __patt.V("name_list") ) )/( make_export_stmt) )
   );
   __rule(self,"for_stmt",
      __patt.Cs( __patt.P(("for"))* idsafe* s* __patt.V("param")* s* __patt.P(("="))* s* __patt.V("expr")* s* __patt.P((","))* s* __patt.V("expr")*
         (s* __patt.P((","))* s* __patt.V("expr"))^-1* s* __patt.V("loop_body")
      )
   );
   __rule(self,"for_in_stmt",
      __patt.Cs( __patt.P(("for"))* idsafe* s* __patt.V("param")* (s* __patt.P((","))* s* __patt.V("param"))^0* s* __patt.P(("in"))* idsafe* s*
         ((__patt.V("expr") )/( ("__op_each(%1)")))* s* __patt.V("loop_body")
      )
   );
   __rule(self,"while_stmt",
      __patt.Cs( __patt.P(("while"))* idsafe* s* __patt.V("expr")* s* __patt.V("loop_body") )
   );
   __rule(self,"do_while_stmt",
      __patt.Cs(
         __patt.P(("do"))* idsafe* __patt.Cs( s* __patt.V("loop_body")* s )*
         __patt.P(("while"))* idsafe* (__patt.Cs( s* __patt.V("expr") ) )/( ("repeat %1 until not(%2)"))
      )
   );
   __rule(self,"loop_body",
      ((__patt.P(("{")) )/( (" do local __break repeat ")))* __patt.V("block_body")* s*
      (
         ((__patt.P(("}")) + __patt.P( syntax_error(("expected '}'")) ))
         )/( (" until true if __break then break end end "))
      )
   );

   __rule(self,"block",
      __patt.Cs( ((__patt.P(("{")) )/( ("")))* __patt.V("block_body")* s* (((__patt.P(("}")) + __patt.P( syntax_error(("expected '}'")) )) )/( (""))) )
   );
   __rule(self,"block_stmt",
      __patt.Cs( ((__patt.P(("{")) )/( ("do ")))* __patt.V("block_body")* s* (((__patt.P(("}")) + __patt.P( syntax_error(("expected '}'")) )) )/( (" end"))) )
   );
   __rule(self,"block_body",
      __patt.Cg( __patt.Cc(("lexical")),"scope")*
      __patt.V("enter")*
      (s* __patt.V("block_body_stmt"))^0*
      __patt.V("leave")
   );
   __rule(self,"block_body_stmt",
       __patt.V("var_decl")
      + __patt.V("func_decl")
      + __patt.V("return_stmt")
      + __patt.V("statement")
   );
   __rule(self,"lambda_body",
      __patt.Cg( __patt.Cc((true)),"set_return")*
      __patt.V("block_body")* s
   );

   __rule(self,"var_decl",
      __patt.Cs( __patt.P(("var"))* (idsafe )/( ("local"))* s*
         ((__patt.Cg( __patt.V("ctx")* __patt.Ca( __patt.V("var_list") )* (s* __patt.P(("="))* s* __patt.Ca( __patt.V("expr")* (s* __patt.P((","))* s* __patt.V("expr"))^0 ))^-1,nil) )/( make_var_decl))
      )* semicol
   );
   __rule(self,"var_list",
      (__patt.V("name")* __patt.V("ctx")* __patt.Cc((nil))* ((s* __patt.V("guard_expr"))^-1 )/( define))* (s* __patt.P((","))* s* (__patt.V("name")* __patt.V("ctx")* __patt.Cc((nil))* ((s* __patt.V("guard_expr"))^-1 )/( define)))^0
      --<name> (s "," s <name>)*
   );
   __rule(self,"guard_expr",
      __patt.P((":"))* s* __patt.V("name")
   );
   __rule(self,"guard_list",
      __patt.P((":"))* s* __patt.Cg( __patt.Ca( __patt.V("name")* (s* __patt.P((","))* s* __patt.V("name"))^0 ),"ret_guard")
   );
   __rule(self,"slot_decl",
      __patt.Cs( ((__patt.P(("has"))* idsafe* s* __patt.V("ctx")* __patt.V("name")* (s* __patt.V("guard_expr") + __patt.Cc(("nil")))* (s* __patt.P(("="))* s* __patt.V("expr") + __patt.Cc(("")))* semicol)
         )/( make_slot_decl)
      )
   );
   __rule(self,"meth_decl",
      __patt.Cs( ((__patt.P(("method"))* idsafe* __patt.V("ctx")* s* __patt.V("name")* s*
      __patt.V("enter")*
      (__patt.Cc(("self"))* (__patt.V("ctx") )/( define_const))*
      __patt.P(("("))* s* __patt.V("param_list")* s* __patt.P((")"))* s*
      __patt.V("guard_list")^-1* s*
      __patt.P(("{"))* __patt.Cs( __patt.V("func_body")* s )* __patt.P(("}"))
      ) )/( make_meth_decl) )* __patt.V("leave")
   );
   __rule(self,"func_decl",
      __patt.Cs( ((__patt.P(("function"))* idsafe* __patt.V("ctx")* s* __patt.Ca( __patt.V("name")* (s* __patt.P(("."))* s* __patt.V("name"))^0 )* s*
      __patt.V("enter")*
      __patt.P(("("))* s* __patt.V("param_list")* s* __patt.P((")"))* s*
      __patt.V("guard_list")^-1* s*
      __patt.P(("{"))* __patt.Cs( __patt.V("func_body")* s )* __patt.P(("}"))*
      __patt.Cb("scope")) )/( make_func_decl) )* __patt.V("leave")
   );
   __rule(self,"func_body",
      __patt.Cg( __patt.Cc(("lexical")),"scope")*
      (s* __patt.V("func_body_stmt"))^0
   );
   __rule(self,"func_body_stmt",
       __patt.V("var_decl")
      + __patt.V("func_decl")
      + __patt.V("return_stmt")
      + __patt.V("block_stmt")
      + (((#(__patt.V("expr")* s* __patt.P(("}")))* __patt.V("ctx")* -- last expr implies return
        __patt.Cb("set_return")* __patt.Ca( __patt.V("expr") )*
        __patt.Cb("ret_guard")) )/( make_return_stmt))
      + __patt.V("statement")
   );
   __rule(self,"func",
      __patt.Cs( ((__patt.P(("function"))* idsafe* s* __patt.V("enter")*
      __patt.P(("("))* s* __patt.V("ctx")* __patt.V("param_list")* s* (__patt.P((")")) + __patt.P( syntax_error(("expected ')'")) ))* s*
      __patt.V("guard_list")^-1* s* __patt.P(("{"))*
         __patt.Cs( __patt.V("func_body")* s )*
      (__patt.P(("}")) + __patt.P( syntax_error(("expected '}'")) )))
      )/( make_func) )* __patt.V("leave")
   );
   __rule(self,"short_func",
      ((__patt.P(("->")) )/( ("")))* __patt.V("enter")*
      ((s* __patt.P(("("))* s* __patt.V("ctx")* __patt.V("param_list")* s* __patt.P((")")) + __patt.V("ctx")* __patt.Ca( __patt.Cc(("_"))* (__patt.V("ctx") )/( define_const) ))* s*
      __patt.P(("{"))* __patt.Cs( __patt.V("func_body")* s )* (__patt.P(("}"))
      )/( make_short_func))* __patt.V("leave")
   );
   __rule(self,"class_decl",
      __patt.P(("class"))* idsafe* s* __patt.Cs( __patt.V("name")* __patt.V("ctx")* (__patt.Cc(("__env")) )/( define) )* s*
      (__patt.V("class_from") + __patt.Cc(("")))* s*
      (__patt.V("class_with") + __patt.Cc(("")))* s*
      __patt.P(("{"))* __patt.Cs( __patt.V("class_body")* s )* (__patt.P(("}"))
      )/( ("__class(__env,\"%1\",{%2},{%3},function(__env,self,super) %4 end);"))
   );
   __rule(self,"trait_decl",
      __patt.P(("trait"))* idsafe* s* __patt.V("ctx")* __patt.Cs( __patt.V("name")* __patt.V("ctx")* (__patt.Cc(("__env")) )/( define) )* s*
      (__patt.P(("("))* s* __patt.V("enter")* __patt.V("param_list")* s* __patt.P((")")) + __patt.Cc(("..."))* __patt.Cc(("")))* s*
      (__patt.V("class_with") + __patt.Cc(("")))* s*
      __patt.P(("{"))* __patt.Cs( __patt.V("class_body")* s )* (__patt.P(("}"))
      )/( make_trait_decl)* __patt.V("leave")
   );
   __rule(self,"object_decl",
      __patt.P(("object"))* idsafe* s* __patt.Cs( __patt.V("name")* __patt.V("ctx")* (__patt.Cc(("__env")) )/( define) )* s*
      (__patt.V("class_from") + __patt.Cc(("")))* s*
      (__patt.V("class_with") + __patt.Cc(("")))* s*
      __patt.P(("{"))* __patt.Cs( __patt.V("class_body")* s )* (__patt.P(("}"))
      )/( ("__object(__env,\"%1\",{%2},{%3},function(__env,self,super) %4 end);"))
   );
   __rule(self,"class_body",
      __patt.Cg( __patt.Cc(("lexical")),"scope")*
      __patt.V("enter")*
      (__patt.Cc(("super"))* (__patt.V("ctx") )/( define_const))*
      (__patt.Cc(("self"))*  (__patt.V("ctx") )/( define_const))*
      __patt.Cs( (s* __patt.V("class_body_stmt"))^0 )*
      __patt.V("leave")
   );
   __rule(self,"class_from",
      __patt.P(("from"))* idsafe* s* __patt.Cs( __patt.V("expr")* (s* __patt.P((","))* s* __patt.V("expr"))^0 )
   );
   __rule(self,"class_with",
      __patt.P(("with"))* idsafe* s* __patt.Cs( __patt.V("expr")* (s* __patt.P((","))* s* __patt.V("expr"))^0 )
   );
   __rule(self,"class_body_stmt",
       __patt.V("var_decl")
      + __patt.V("slot_decl")
      + __patt.V("func_decl")
      + __patt.V("rule_decl")
      + __patt.V("meth_decl")
      + __patt.V("statement")
   );
   __rule(self,"rest",
      __patt.Cs( __patt.C(__patt.P(("...")))* __patt.V("param")^-1 )
   );
   __rule(self,"stack",
      __patt.Cs(
       ((__patt.P(("..."))* s* __patt.P(("["))* s* __patt.V("expr")* s* (__patt.P(("]")) + __patt.P( syntax_error(("expected ']'")) ))) )/( ("select(%1,...)"))
      + __patt.C(__patt.P(("...")))
      )
   );
   __rule(self,"param_list",
      __patt.Ca(
       __patt.Cs( __patt.V("param")* s )* (__patt.P((","))* __patt.Cs( s* __patt.V("param")* s ))^0* (__patt.P((","))* __patt.Cs( s* __patt.V("rest")* s ))^-1
      + __patt.V("rest")
      + __patt.Cc((nil))
      )
   );
   __rule(self,"ident",
      __patt.Cs( __patt.V("name")* (__patt.V("ctx") )/( lookup) )
   );
   __rule(self,"param",
      __patt.V("name")* __patt.V("ctx")* __patt.Cc((nil))* ((s* __patt.V("guard_expr"))^-1 )/( define)
   );
   __rule(self,"name",
      __patt.C( -keyword* ((__patt.Def("alpha") + __patt.P(("_")))* (__patt.Def("alnum") + __patt.P(("_")))^0) )
   );
   __rule(self,"name_list",
      __patt.Cs( __patt.V("name")* (s* __patt.P((","))* s* __patt.V("name"))^0 )
   );
   __rule(self,"qname",
      __patt.Cs( __patt.V("ident")* (((__patt.P(("::")) )/( (".")))* __patt.V("name"))^0 )
   );
   __rule(self,"hexadec",
      __patt.P(("-"))^-1* __patt.P(("0x"))* __patt.Def("xdigit")^1
   );
   __rule(self,"decimal",
      __patt.P(("-"))^-1* digits* (__patt.P(("."))* digits)^-1* ((__patt.P(("e"))+__patt.P(("E")))* __patt.P(("-"))^-1* digits)^-1
   );
   __rule(self,"number",
      (__patt.Cs( __patt.V("hexadec") + __patt.V("decimal") ) )/( ("(%1)"))
   );
   __rule(self,"string",
      (__patt.Cs( (__patt.V("qstring") + __patt.V("astring")) ) )/( ("(%1)"))
   );
   __rule(self,"special",
      __patt.Cs(
       (__patt.P(("\n"))  )/( ("\\\n"))
      + (__patt.P(("\\$")) )/( ("$"))
      + __patt.P(("\\\\"))
      + __patt.P(("\\"))* __patt.P(1)
      )
   );
   __rule(self,"qstring",
       (__patt.P(("\"\"\"")) )/( ("\""))* __patt.Cs( (
          __patt.V("string_expr")
         + __patt.Cs( (__patt.V("special") + -__patt.P(("\"\"\""))*((__patt.P(("\"")) )/( ("\\\""))) + -(__patt.V("string_expr") + __patt.P(("\"\"\"")))* __patt.P(1))^1 )
      )^0 )* ((__patt.P(("\"\"\"")) )/( ("\"")) + __patt.P( syntax_error(("expected '\"\"\"'")) ))
      + __patt.P(("\""))* __patt.Cs( (
          __patt.V("string_expr")
         + __patt.Cs( (__patt.V("special") + -(__patt.V("string_expr") + __patt.P(("\"")))* __patt.P(1))^1 )
      )^0 )* (__patt.P(("\"")) + __patt.P( syntax_error(("expected '\"'")) ))
   );
   __rule(self,"astring",
      (__patt.Cs(
          ((__patt.P(("'''")) )/( ("")))* (__patt.P(("\\\\")) + __patt.P(("\\'")) + (-__patt.P(("'''"))* __patt.P(1)))^0* ((__patt.P(("'''")) )/( ("")))
         + ((__patt.P(("'"))   )/( ("")))* (__patt.P(("\\\\")) + __patt.P(("\\'")) + (-__patt.P(("'"))*   __patt.P(1)))^0* ((__patt.P(("'"))   )/( ("")))
      ) )/( quote)
   );
   __rule(self,"string_expr",
      ((__patt.P(("${")) )/( ("\"..")))* __patt.Cs( s* ((__patt.V("expr") )/( ("tostring(%1)")))* s )* ((__patt.P(("}")) )/( ("..\"")))
   );
   __rule(self,"vnil",
      __patt.Cs( __patt.C( __patt.P(("nil")) )* (idsafe )/( ("(nil)")) )
   );
   __rule(self,"vtrue",
      __patt.Cs( __patt.C( __patt.P(("true")) )* (idsafe )/( ("(true)")) )
   );
   __rule(self,"vfalse",
      __patt.Cs( __patt.C( __patt.P(("false")) )* (idsafe )/( ("(false)")) )
   );
   __rule(self,"range",
      __patt.Cs( ((
         __patt.P(("["))* s* __patt.V("expr")* s* __patt.P((":"))* s* __patt.V("expr")* ( s* __patt.P((":"))* s* __patt.V("expr") + __patt.Cc(("1")) )* s* __patt.P(("]"))
      ) )/( ("_G.Range(%1,%2,%3)")) )
   );
   __rule(self,"array",
      __patt.Cs(
         ((__patt.P(("[")) )/( ("_G.Array(")))* s*
         (__patt.V("array_elements") + __patt.Cc(("")))* s*
         ((__patt.P(("]")) )/( (")")) + __patt.P(syntax_error(("expected ']'"))))
      )
   );
   __rule(self,"array_elements",
      __patt.V("expr")* ( s* __patt.P((","))* s* __patt.V("expr") )^0* (s* ((__patt.P((",")) )/( (""))))^-1
   );
   __rule(self,"hash",
      __patt.Cs(
         ((__patt.P(("{")) )/( ("_G.Hash({")))* s*
         (__patt.V("hash_pairs") + __patt.Cc(("")))* s*
         ((__patt.P(("}")) )/( ("})")) + __patt.P(syntax_error(("expected '}'"))))
      )
   );
   __rule(self,"hash_pairs",
      __patt.V("hash_pair")* (s* __patt.P((","))* s* __patt.V("hash_pair"))^0* (s* __patt.P((",")))^-1
   );
   __rule(self,"hash_pair",
      (__patt.V("name") + __patt.P(("["))* s* __patt.V("expr")* s* (__patt.P(("]")) + __patt.P(syntax_error(("expected ']'")))))* s*
      __patt.P(("="))* s* __patt.V("expr")
   );
   __rule(self,"primary",
       __patt.V("ident")
      + __patt.V("range")
      + __patt.V("number")
      + __patt.V("string")
      + __patt.V("vnil")
      + __patt.V("vtrue")
      + __patt.V("vfalse")
      + __patt.V("stack")
      + __patt.V("array")
      + __patt.V("hash")
      + __patt.V("func")
      + __patt.V("short_func")
      + __patt.V("pattern")
      + __patt.P(("("))* s* __patt.V("expr")* s* (__patt.P((")")) + __patt.P( syntax_error(("expected ')'")) ))
   );
   __rule(self,"paren_expr",
      __patt.P(("("))* s* ( __patt.V("expr_list") + __patt.Cc(("")) )* s* (__patt.P((")")) + __patt.P( syntax_error(("expected ')'")) ))
   );
   __rule(self,"member_expr",
      __patt.Cs(
       __patt.P(("."))* s* (__patt.V("name") )/( (".%1"))
      + __patt.P(("["))* s* __patt.V("expr")* s* (__patt.P(("]")) + __patt.P( syntax_error(("expected ']'")) ))
      )
   );
   __rule(self,"method_expr",
      __patt.Cs(
       ((__patt.P((".")) )/( (":")) + (__patt.P(("::")) )/( (".")))* s* __patt.V("name")* s* (__patt.V("short_expr") + __patt.V("paren_expr"))
      )
   );
   __rule(self,"access_expr",
      __patt.Cs(
       __patt.V("invoke_expr")* s* __patt.V("access_expr")
      + __patt.V("member_expr")
      )
   );
   __rule(self,"invoke_expr",
      __patt.Cs(
       (
          __patt.V("method_expr")
         + __patt.V("member_expr")
         + __patt.V("short_expr")
         + __patt.V("paren_expr")
      )* s* __patt.V("invoke_expr")
      + __patt.V("method_expr")
      + __patt.V("short_expr")
      + __patt.V("paren_expr")
      )
   );
   __rule(self,"short_expr",
      ((__patt.P(("->")) )/( ("(")))*
      __patt.V("enter")*
      ((s* __patt.P(("("))* s* __patt.V("ctx")* __patt.V("param_list")* s* __patt.P((")")) + __patt.V("ctx")* __patt.Ca( __patt.Cc(("_"))* (__patt.V("ctx") )/( define_const) ))* s*
      __patt.P(("{"))* __patt.Cs( __patt.V("func_body")* s )* (__patt.P(("}"))
      )/( make_short_func))* __patt.Cc((")"))* __patt.V("leave")
   );
   __rule(self,"suffix_expr",
       __patt.V("invoke_expr")
      + __patt.V("access_expr")
   );
   __rule(self,"term",
      __patt.Cs( __patt.V("primary")* (s* __patt.V("suffix_expr"))^0 )
   );
   __rule(self,"expr_list",
      __patt.Cs( __patt.V("expr")* (s* __patt.P((","))* s* __patt.V("expr"))^0 )
   );
   __rule(self,"expr",
      __patt.Cs( (__patt.V("infix_expr") + __patt.V("prefix_expr"))* (
         s* ((__patt.P(("?")) )/( (" and ")))* s* __patt.V("expr")* s* ((__patt.P((":")) )/( (" or ")))* s* __patt.V("expr")
      )^-1 )
   );

   --/*
   local _153=__patt.P((
      __patt.P(("+")) + __patt.P(("-")) + __patt.P(("~")) + __patt.P(("^^")) + __patt.P(("*")) + __patt.P(("/")) + __patt.P(("%")) + __patt.P(("^")) + __patt.P((">>>")) + __patt.P((">>")) + __patt.P(("<<"))
      + __patt.P(("||")) + __patt.P(("&&")) + __patt.P(("|")) + __patt.P(("&")) + __patt.P(("==")) + __patt.P(("!=")) + __patt.P((">="))+ __patt.P(("<=")) + __patt.P(("<")) + __patt.P((">"))
      + (__patt.P(("as")) + __patt.P(("in")))* idsafe
   ));local binop_patt=_153;

   __rule(self,"infix_expr",
      (__patt.Ca( __patt.Cs( __patt.V("prefix_expr")* s )* (
         __patt.C( binop_patt )*
         __patt.Cs( s* __patt.V("prefix_expr")* (#(s* binop_patt)* s)^-1 )
      )^1 ) )/( fold_infix)
   );
   --*/

   --[=[
   // recursive descent is faster for stock Lua, but LJ2 is faster
   // with shift-reduce, so right now I'm biased towards LJ2 ;)
   rule infix_expr {
      {~ <bool_or_expr> ~}
   }
   function make_infix_expr(oper, term) {
      / (({~ term (&(s oper) s)? ~} {: {oper} {~ s term ~} :}*) ~> fold_infix) /
   }
   rule bool_or_expr {
      <{ make_infix_expr(/"||"/, /<bool_and_expr>/ }>
   }
   rule bool_and_expr {
      <{ make_infix_expr(/"&&"/, /<bit_or_expr>/ }>
   }
   rule bit_or_expr {
      <{ make_infix_expr(/"|"/,  /<bit_xor_expr>/ }>
   }
   rule bit_xor_expr {
      <{ make_infix_expr(/"^"/,  /<bit_and_expr>/ }>
   }
   rule bit_and_expr {
      <{ make_infix_expr(/"&"/,  /<equals_expr>/ }>
   }
   rule equals_expr {
      <{ make_infix_expr(/"=="|"!="/, /<cmp_expr>/ }>
   }
   rule cmp_expr {
      <{ make_infix_expr(/"<="|">="|"<"|">"/, /<shift_expr>/ }>
   }
   rule shift_expr {
      <{ make_infix_expr(/">>>"|">>"|"<<"|("as"|"in") idsafe/, /<add_expr>/ }>
   }
   rule add_expr {
      <{ make_infix_expr(/"+"|"-"|"~"/, /<mul_expr>/ }>
   }
   rule mul_expr {
      <{ make_infix_expr(/"*"|"/"|"%"/, /<pow_expr>/ }>
   }
   rule pow_expr {
      <{ make_infix_expr(/"^^"/, /<prefix_expr>/ }>
   }
   //]=]

   __rule(self,"prefix_expr",
      (__patt.Cg( __patt.C(
          __patt.P(("@")) + __patt.P(("!")) + __patt.P(("#")) + __patt.P(("-")) + __patt.P(("~"))
         + (__patt.P(("throw")) + __patt.P(("typeof")))* idsafe
      )* s* __patt.V("prefix_expr"),nil) )/( fold_prefix)
      + __patt.Cs( s* __patt.V("term") )
   );

   -- binding expression rules
   __rule(self,"bind_stmt",
      __patt.Cs( ((__patt.V("bind_expr") + __patt.V("bind_binop_expr")) )/( ("%1;"))* semicol )
   );
   __rule(self,"bind_expr",
      __patt.Cs( __patt.V("ctx")* __patt.Ca( __patt.V("bind_list") )* __patt.C(s)* __patt.P(("="))* __patt.C(s)* ((
          __patt.Ca( __patt.V("expr")* (s* __patt.P((","))* s* __patt.V("expr"))^0 )
         + __patt.P(syntax_error(("bad right hand <expr>")))
      ) )/( make_bind_expr) )
   );
   __rule(self,"bind_binop",
      __patt.C( __patt.P(("+")) + __patt.P(("-")) + __patt.P(("*")) + __patt.P(("/")) + __patt.P(("%")) + __patt.P(("||")) + __patt.P(("|"))+ __patt.P(("&&"))
      + __patt.P(("&")) + __patt.P(("^^")) + __patt.P(("^")) + __patt.P(("~")) + __patt.P((">>>")) + __patt.P((">>")) + __patt.P(("<<"))
      )* __patt.P(("="))
   );
   __rule(self,"bind_binop_expr",
      __patt.Cs( __patt.V("ctx")* __patt.C( __patt.V("bind_term")* s )* __patt.V("bind_binop")* s* (__patt.V("expr") )/( make_binop_bind) )
   );
   __rule(self,"bind_list",
      __patt.V("bind_term")* (s* __patt.P((","))* s* __patt.V("bind_term"))^0
   );
   __rule(self,"bind_term",
      __patt.Cs(
       __patt.V("primary")* (s* __patt.V("bind_member"))^1
      + (__patt.Cs( __patt.V("name")* (__patt.V("ctx") )/( lookup_or_define) ) )/( ("%1=%%s"))
      )
   );
   __rule(self,"bind_member",
      __patt.Cs(
       __patt.V("suffix_expr")* s* __patt.V("bind_member")
      + __patt.V("bind_suffix")
      )
   );
   __rule(self,"bind_suffix",
      __patt.Cs(
       __patt.P(("."))* (__patt.Cs( s* __patt.V("name")* s ) )/( (".%1=%%s"))
      + __patt.P(("["))* __patt.Cs( s* __patt.V("expr")* s )* __patt.P(("]"))* (__patt.C(s) )/( ("[%1]%2=%%s"))
      )
   );

   -- PEG grammar and pattern rules
   __rule(self,"pattern",
      __patt.P(("/"))* __patt.Cs( s* __patt.V("rule_alt")* s )* (__patt.P(("/")) )/( ("__patt.P(%1)"))
   );
   __rule(self,"rule_decl",
      __patt.P(("rule"))* idsafe* s* __patt.V("name")* s* __patt.P(("{"))* __patt.Cs( s* __patt.V("rule_body")* s )* (__patt.P(("}"))
      )/( ("__rule(self,\"%1\",%2);"))
   );
   __rule(self,"rule_body",
      __patt.V("rule_alt") + __patt.Cc(("__patt.P(nil)"))
   );
   __rule(self,"rule_alt",
      __patt.Cs( ((__patt.P(("|")) )/( (""))* s)^-1* __patt.V("rule_seq")* (s* ((__patt.P(("|")) )/( ("+")))* s* __patt.V("rule_seq"))^0 )
   );
   __rule(self,"rule_seq",
      (__patt.Ca( __patt.Cs( s* __patt.V("rule_suffix") )^1 ) )/( function(a)  do return a:concat(("*")) end  end)
   );
   __rule(self,"rule_rep",
      __patt.Cs( (__patt.P(("+")) )/( ("^1")) + (__patt.P(("*")) )/( ("^0")) + (__patt.P(("?")) )/( ("^-1")) + __patt.P(("^"))*s*(__patt.P(("+"))+__patt.P(("-")))^-1*s*((__patt.R("09")))^1 )
   );
   __rule(self,"rule_prefix",
      __patt.Cs( (((__patt.P(("&")) )/( ("#"))) + ((__patt.P(("!")) )/( ("-"))))* (__patt.Cs( s* __patt.V("rule_prefix") ) )/( ("%1%2"))
      + __patt.V("rule_primary")
      )
   );

   local _154=__patt.P( __patt.P(("->")) + __patt.P(("~>")) + __patt.P(("=>")) );local prod_oper=_154;

   __rule(self,"rule_suffix",
      __patt.Cf((__patt.Cs( __patt.V("rule_prefix")* (#(s* prod_oper)* s)^-1 )*
      __patt.Cg( __patt.C(prod_oper)* __patt.Cs( s* __patt.V("term") ),nil)^0) , function(a,o,b) 
         if (o )==( ("=>")) then  
             do return ("__patt.Cmt(%s,%s)"):format(a,b) end
         
          elseif (o )==( ("~>")) then  
             do return ("__patt.Cf(%s,%s)"):format(a,b) end
         
         else 
             do return ("(%s)/(%s)"):format(a,b) end
          end 
       end)
   );

   __rule(self,"rule_primary",
      ( __patt.V("rule_group")
      + __patt.V("rule_term")
      + __patt.V("rule_class")
      + __patt.V("rule_predef")
      + __patt.V("rule_back_capt")
      + __patt.V("rule_group_capt")
      + __patt.V("rule_sub_capt")
      + __patt.V("rule_const_capt")
      + __patt.V("rule_hash_capt")
      + __patt.V("rule_array_capt")
      + __patt.V("rule_simple_capt")
      + __patt.V("rule_any")
      + __patt.V("rule_ref")
      )* (s* __patt.V("rule_rep"))^0
   );
   __rule(self,"rule_group",
      __patt.Cs( __patt.P(("("))* s* (__patt.V("rule_alt") + __patt.P( syntax_error(("expected <rule_alt>")) ))* s*
         (__patt.P((")")) + __patt.P( syntax_error(("expected ')'")) ))
      )
   );
   __rule(self,"rule_term",
      __patt.Cs( (__patt.V("string") )/( ("__patt.P(%1)")) )
   );
   __rule(self,"rule_class",
      __patt.Cs(
         ((__patt.P(("[")) )/( ("(")))* ((__patt.P(("^")) )/( ("__patt.P(1)-")))^-1*
         ((__patt.Ca( (-__patt.P(("]"))* __patt.V("rule_item"))^1 ) )/( function(a)  do return ((("("))..(a:concat(("+"))))..((")")) end  end))*
         ((__patt.P(("]")) )/( (")")))
      )
   );
   __rule(self,"rule_item",
      __patt.Cs( __patt.V("rule_predef") + __patt.V("rule_range")
      + (__patt.C(__patt.P(1)) )/( function(c)  do return ("__patt.P(%q)"):format(c) end  end)
      )
   );
   __rule(self,"rule_predef",
      __patt.Cs( ((__patt.P(("%")) )/( ("")))* (
          (__patt.C( ((__patt.R("09")))^1 ) )/( ("__patt.Carg(%1)"))
         + (__patt.V("name") )/( ("__patt.Def(\"%1\")"))
      ) )
   );
   __rule(self,"rule_range",
      (__patt.Cs( __patt.P(1)* ((__patt.P(("-")))/(("")))* -__patt.P(("]"))* __patt.P(1) ) )/( function(r)  do return ("__patt.R(%q)"):format(r) end  end)
   );
   __rule(self,"rule_any",
      __patt.Cs( (__patt.P((".")) )/( ("__patt.P(1)")) )
   );
   __rule(self,"rule_ref",
      __patt.Cs(
      ((__patt.P(("<")) )/( ("")))* s*
         ( (__patt.V("name") )/( ("__patt.V(\"%1\")"))
         + __patt.Cs( ((__patt.P(("{")) )/( ("__patt.P(")))* s* __patt.V("expr")* s* ((__patt.P(("}")) )/( (")"))) )
         )* s*
      ((__patt.P((">")) )/( ("")))
      + __patt.V("qname")
      )
   );
   __rule(self,"rule_group_capt",
      __patt.Cs( __patt.P(("{:"))* (((__patt.V("name") )/( quote)* __patt.P((":"))) + __patt.Cc(("nil")))* __patt.Cs( s* __patt.V("rule_alt") )* s* (__patt.P((":}"))
      )/( ("__patt.Cg(%2,%1)"))
      )
   );
   __rule(self,"rule_back_capt",
      __patt.P(("="))* (((__patt.V("name") )/( quote)) )/( ("__patt.Cb(%1)"))
   );
   __rule(self,"rule_sub_capt",
      __patt.P(("{~"))* __patt.Cs( s* __patt.V("rule_alt")* s )* (__patt.P(("~}")) )/( ("__patt.Cs(%1)"))
   );
   __rule(self,"rule_const_capt",
      __patt.P(("{`"))* __patt.Cs( s* __patt.V("expr_list")* s )* (__patt.P(("`}")) )/( ("__patt.Cc(%1)"))
   );
   __rule(self,"rule_hash_capt",
      __patt.P(("{%"))* __patt.Cs( s* __patt.V("rule_alt")* s )* (__patt.P(("%}")) )/( ("__patt.Ch(%1)"))
   );
   __rule(self,"rule_array_capt",
      __patt.P(("{@"))* __patt.Cs( s* __patt.V("rule_alt")* s )* (__patt.P(("@}")) )/( ("__patt.Ca(%1)"))
   );
   __rule(self,"rule_simple_capt",
      __patt.P(("{"))* __patt.Cs( s* __patt.V("rule_alt")* s )* (__patt.P(("}")) )/( ("__patt.C(%1)"))
   );
 end);

_G.compile = function(lupa, name, args) 
   local _155=__env.Context();local ctx=_155;
   ctx:enter();
   for k,v in __op_each(pairs(_G))  do local __break repeat 
      ctx:define(k);
    until true if __break then break end end 
   if args then  
      for i=(1), #(args)  do local __break repeat 
         ctx:define(args[i], _G.Hash({ }));
       until true if __break then break end end 
    end 
   local _156=__env.Grammar:match(lupa, (1), ctx);local lua=_156;
   ctx:leave();
   assert((ctx.scope.outer )==( _G), ("scope is unbalanced"));
   if args then  
       do return ("local "..tostring(args:concat((","))).."=...;"..tostring(lua).."") end
    end 
    do return lua end
 end;

_G.eval = function(src) 
   local _157=assert(loadstring(compile(src),(("=eval:"))..(src)));local eval=_157;
    do return eval() end
 end;

local _163=function(...) local args=_G.Array(...)
   local _158=_G.Hash({ });local opt=_158;
   local _159=(0);local idx=_159;
   local _160=#(args);local len=_160;
   while (idx )<( len)  do local __break repeat 
      idx= (idx )+( (1));
      local _161=args[idx];local arg=_161;
      if (arg:sub((1),(1)) )==( ("-")) then  
         local _162=arg:sub((2));local o=_162;
         if (o )==( ("o")) then  
            idx= (idx )+( (1));
            opt[("o")] = args[idx];
         
          elseif (o )==( ("l")) then  
            opt[("l")] = (true);
         
          elseif (o )==( ("b")) then  
            idx= (idx )+( (1));
            opt[("b")] = args[idx];
         
         else 
            error((("unknown option: "))..(arg), (2));
          end 
      
      else 
         opt[("file")] = arg;
       end 
    until true if __break then break end end 
    do return opt end
 end;local getopt=_163;

local _172=function(...) 
   local _164=getopt(...);local opt=_164;
   local _165=assert(io.open(opt[("file")]));local sfh=_165;
   local _166=sfh:read(("*a"));local src=_166;
   sfh:close();

   local _167=compile(src);local lua=_167;
   if opt[("l")] then  
      io.stdout:write(lua, ("\n"));
      os.exit((0));
    end 

   if opt[("o")] then  
      local _168=io.open(opt[("o")], ("w+"));local outc=_168;
      outc:write(lua);
      outc:close();
   
   else 
      lua= lua:gsub(("^%s*#![^\n]*"),(""));
      local _169=assert(loadstring(lua,(("="))..(opt[("file")])));local main=_169;
      if opt[("b")] then  
         local _170=io.open(opt.b, ("wb+"));local outc=_170;
         outc:write(String.dump(main));
         outc:close();
      
      else 
         local _171=setmetatable(_G.Hash({ }), _G.Hash({ __index = _G }));local main_env=_171;
         setfenv(main, main_env);
         main(opt[("file")], ...);
       end 
    end 
 end;local run=_172;

arg= arg  and  _G.Array( unpack(arg) )  or  _G.Array( );
do 
   -- from strict.lua
   local _173=getmetatable(_G);local mt=_173;
   if (mt )==( (nil)) then  
      mt= newtable();
      setmetatable(_G, mt);
    end 

   mt.__declared = newtable();

   local function what() 
      local _174=debug.getinfo((3), ("S"));local d=_174;
       do return ((d )and( d.what ))or( ("C")) end
    end

   mt.__newindex = function(t, n, v) 
      if not(mt.__declared[n]) then  
         local _175=what();local w=_175;
         if ((w )~=( ("main") ))and(( w )~=( ("C"))) then  
            error(("assign to undeclared variable '"..tostring(n).."'"), (2));
          end 
         mt.__declared[n] = (true);
       end 
      do return rawset(t, n, v) end
    end;

   mt.__index = function(t, n) 
      if (not(mt.__declared[n]) )and(( what() )~=( ("C"))) then  
         error(("variable '"..tostring(n).."' is not declared"), (2));
       end 
       do return rawget(t, n) end
    end;
 end

_G.LUPA_PATH = ("./?.lu;./lib/?.lu;./src/?.lu");
do 
   package.loaders[(#(package.loaders) )+( (1))] = function(modname) 
      local _176=modname:gsub(("%."), ("/"));local filename=_176;
      for path in __op_each(LUPA_PATH:gmatch(("([^;]+)")))  do local __break repeat 
         if (path )~=( ("")) then  
            local _177=path:gsub(("?"), filename);local filepath=_177;
            local _178=io.open(filepath, ("r"));local file=_178;
            if file then  
               local _179=file:read(("*a"));local src=_179;
               local _180=compile(src);local lua=_180;
                do return assert(loadstring(lua, (("="))..(filepath))) end
             end 
          end 
       until true if __break then break end end 
    end;
 end

if arg[(1)] then   run(unpack(arg));  end 
-- vim: ft=lupa

return __env;