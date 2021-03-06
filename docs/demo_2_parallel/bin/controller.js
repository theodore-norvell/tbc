// Generated by Haxe 4.2.1+bf9ff69
(function ($hx_exports, $global) { "use strict";
$hx_exports["tbc"] = $hx_exports["tbc"] || {};
$hx_exports["tbc"]["_TBC"] = $hx_exports["tbc"]["_TBC"] || {};
var $estr = function() { return js_Boot.__string_rec(this,''); },$hxEnums = $hxEnums || {},$_;
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var CompileTime = function() { };
CompileTime.__name__ = true;
var Controller = function() { };
Controller.__name__ = true;
Controller.main = function() {
	var win = window;
	var doc = win.document;
	var body = doc.body;
	body.onload = Controller.onload;
};
Controller.out = function(str) {
	return tbc_TBC.exec(function() {
		var maxLen = 40;
		Controller.outStr = Controller.outStr + " " + str;
		var len = Controller.outStr.length;
		if(len > maxLen) {
			Controller.outStr = HxOverrides.substr(Controller.outStr,len - maxLen,null);
		}
		Controller.outbox.innerHTML = Controller.outStr;
		return null;
	});
};
Controller.useCase = function() {
	var this1 = Controller.out("x0").sc(tbc_TBCTime.pause(1000));
	var this2 = this1.sc(Controller.out("x1"));
	var this1 = Controller.out("y0").sc(tbc_TBCTime.pause(1000));
	var this3 = this1.sc(Controller.out("y1"));
	var this1 = tbc_TBC.par(this2,this3).sc(tbc_TBCTime.pause(1000));
	return tbc_TBC.loop(this1);
};
Controller.onload = function() {
	var win = window;
	var doc = win.document;
	Controller.outbox = doc.getElementById("outbox");
	haxe_Log.trace("Last compiled " + "2021-05-27 19:45:04",{ fileName : "docs/demo_2_parallel/src/Controller.hx", lineNumber : 46, className : "Controller", methodName : "onload"});
	haxe_Log.trace("Started at " + Std.string(new Date()),{ fileName : "docs/demo_2_parallel/src/Controller.hx", lineNumber : 47, className : "Controller", methodName : "onload"});
	Controller.useCase().go(function(x) {
	},function(ex) {
		haxe_Log.trace("Exception " + Std.string(ex),{ fileName : "docs/demo_2_parallel/src/Controller.hx", lineNumber : 49, className : "Controller", methodName : "onload"});
	});
	haxe_Log.trace("going",{ fileName : "docs/demo_2_parallel/src/Controller.hx", lineNumber : 50, className : "Controller", methodName : "onload"});
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) {
		return undefined;
	}
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(len == null) {
		len = s.length;
	} else if(len < 0) {
		if(pos == 0) {
			len = s.length + len;
		} else {
			return "";
		}
	}
	return s.substr(pos,len);
};
HxOverrides.now = function() {
	return Date.now();
};
Math.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	if(x != null) {
		var _g = 0;
		var _g1 = x.length;
		while(_g < _g1) {
			var i = _g++;
			var c = x.charCodeAt(i);
			if(c <= 8 || c >= 14 && c != 32 && c != 45) {
				var nc = x.charCodeAt(i + 1);
				var v = parseInt(x,nc == 120 || nc == 88 ? 16 : 10);
				if(isNaN(v)) {
					return null;
				} else {
					return v;
				}
			}
		}
	}
	return null;
};
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = true;
var StringTools = function() { };
StringTools.__name__ = true;
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	if(!(c > 8 && c < 14)) {
		return c == 32;
	} else {
		return true;
	}
};
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) ++r;
	if(r > 0) {
		return HxOverrides.substr(s,r,l - r);
	} else {
		return s;
	}
};
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) ++r;
	if(r > 0) {
		return HxOverrides.substr(s,0,l - r);
	} else {
		return s;
	}
};
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
};
var haxe_StackItem = $hxEnums["haxe.StackItem"] = { __ename__:true,__constructs__:null
	,CFunction: {_hx_name:"CFunction",_hx_index:0,__enum__:"haxe.StackItem",toString:$estr}
	,Module: ($_=function(m) { return {_hx_index:1,m:m,__enum__:"haxe.StackItem",toString:$estr}; },$_._hx_name="Module",$_.__params__ = ["m"],$_)
	,FilePos: ($_=function(s,file,line,column) { return {_hx_index:2,s:s,file:file,line:line,column:column,__enum__:"haxe.StackItem",toString:$estr}; },$_._hx_name="FilePos",$_.__params__ = ["s","file","line","column"],$_)
	,Method: ($_=function(classname,method) { return {_hx_index:3,classname:classname,method:method,__enum__:"haxe.StackItem",toString:$estr}; },$_._hx_name="Method",$_.__params__ = ["classname","method"],$_)
	,LocalFunction: ($_=function(v) { return {_hx_index:4,v:v,__enum__:"haxe.StackItem",toString:$estr}; },$_._hx_name="LocalFunction",$_.__params__ = ["v"],$_)
};
haxe_StackItem.__constructs__ = [haxe_StackItem.CFunction,haxe_StackItem.Module,haxe_StackItem.FilePos,haxe_StackItem.Method,haxe_StackItem.LocalFunction];
var haxe_CallStack = {};
haxe_CallStack.callStack = function() {
	return haxe_NativeStackTrace.toHaxe(haxe_NativeStackTrace.callStack());
};
haxe_CallStack.exceptionStack = function(fullStack) {
	if(fullStack == null) {
		fullStack = false;
	}
	var eStack = haxe_NativeStackTrace.toHaxe(haxe_NativeStackTrace.exceptionStack());
	return fullStack ? eStack : haxe_CallStack.subtract(eStack,haxe_CallStack.callStack());
};
haxe_CallStack.toString = function(stack) {
	var b = new StringBuf();
	var _g = 0;
	var _g1 = stack;
	while(_g < _g1.length) {
		var s = _g1[_g];
		++_g;
		b.b += "\nCalled from ";
		haxe_CallStack.itemToString(b,s);
	}
	return b.b;
};
haxe_CallStack.subtract = function(this1,stack) {
	var startIndex = -1;
	var i = -1;
	while(++i < this1.length) {
		var _g = 0;
		var _g1 = stack.length;
		while(_g < _g1) {
			var j = _g++;
			if(haxe_CallStack.equalItems(this1[i],stack[j])) {
				if(startIndex < 0) {
					startIndex = i;
				}
				++i;
				if(i >= this1.length) {
					break;
				}
			} else {
				startIndex = -1;
			}
		}
		if(startIndex >= 0) {
			break;
		}
	}
	if(startIndex >= 0) {
		return this1.slice(0,startIndex);
	} else {
		return this1;
	}
};
haxe_CallStack.equalItems = function(item1,item2) {
	if(item1 == null) {
		if(item2 == null) {
			return true;
		} else {
			return false;
		}
	} else {
		switch(item1._hx_index) {
		case 0:
			if(item2 == null) {
				return false;
			} else if(item2._hx_index == 0) {
				return true;
			} else {
				return false;
			}
			break;
		case 1:
			if(item2 == null) {
				return false;
			} else if(item2._hx_index == 1) {
				var m2 = item2.m;
				var m1 = item1.m;
				return m1 == m2;
			} else {
				return false;
			}
			break;
		case 2:
			if(item2 == null) {
				return false;
			} else if(item2._hx_index == 2) {
				var item21 = item2.s;
				var file2 = item2.file;
				var line2 = item2.line;
				var col2 = item2.column;
				var col1 = item1.column;
				var line1 = item1.line;
				var file1 = item1.file;
				var item11 = item1.s;
				if(file1 == file2 && line1 == line2 && col1 == col2) {
					return haxe_CallStack.equalItems(item11,item21);
				} else {
					return false;
				}
			} else {
				return false;
			}
			break;
		case 3:
			if(item2 == null) {
				return false;
			} else if(item2._hx_index == 3) {
				var class2 = item2.classname;
				var method2 = item2.method;
				var method1 = item1.method;
				var class1 = item1.classname;
				if(class1 == class2) {
					return method1 == method2;
				} else {
					return false;
				}
			} else {
				return false;
			}
			break;
		case 4:
			if(item2 == null) {
				return false;
			} else if(item2._hx_index == 4) {
				var v2 = item2.v;
				var v1 = item1.v;
				return v1 == v2;
			} else {
				return false;
			}
			break;
		}
	}
};
haxe_CallStack.itemToString = function(b,s) {
	switch(s._hx_index) {
	case 0:
		b.b += "a C function";
		break;
	case 1:
		var m = s.m;
		b.b += "module ";
		b.b += m == null ? "null" : "" + m;
		break;
	case 2:
		var s1 = s.s;
		var file = s.file;
		var line = s.line;
		var col = s.column;
		if(s1 != null) {
			haxe_CallStack.itemToString(b,s1);
			b.b += " (";
		}
		b.b += file == null ? "null" : "" + file;
		b.b += " line ";
		b.b += line == null ? "null" : "" + line;
		if(col != null) {
			b.b += " column ";
			b.b += col == null ? "null" : "" + col;
		}
		if(s1 != null) {
			b.b += ")";
		}
		break;
	case 3:
		var cname = s.classname;
		var meth = s.method;
		b.b += Std.string(cname == null ? "<unknown>" : cname);
		b.b += ".";
		b.b += meth == null ? "null" : "" + meth;
		break;
	case 4:
		var n = s.v;
		b.b += "local function #";
		b.b += n == null ? "null" : "" + n;
		break;
	}
};
var haxe_Exception = function(message,previous,native) {
	Error.call(this,message);
	this.message = message;
	this.__previousException = previous;
	this.__nativeException = native != null ? native : this;
	this.__skipStack = 0;
	var old = Error.prepareStackTrace;
	Error.prepareStackTrace = function(e) { return e.stack; }
	if(((native) instanceof Error)) {
		this.stack = native.stack;
	} else {
		var e = null;
		if(Error.captureStackTrace) {
			Error.captureStackTrace(this,haxe_Exception);
			e = this;
		} else {
			e = new Error();
			if(typeof(e.stack) == "undefined") {
				try { throw e; } catch(_) {}
				this.__skipStack++;
			}
		}
		this.stack = e.stack;
	}
	Error.prepareStackTrace = old;
};
haxe_Exception.__name__ = true;
haxe_Exception.caught = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value;
	} else if(((value) instanceof Error)) {
		return new haxe_Exception(value.message,null,value);
	} else {
		return new haxe_ValueException(value,null,value);
	}
};
haxe_Exception.__super__ = Error;
haxe_Exception.prototype = $extend(Error.prototype,{
	unwrap: function() {
		return this.__nativeException;
	}
	,__shiftStack: function() {
		this.__skipStack++;
	}
	,get_stack: function() {
		var _g = this.__exceptionStack;
		if(_g == null) {
			var value = haxe_NativeStackTrace.toHaxe(haxe_NativeStackTrace.normalize(this.stack),this.__skipStack);
			this.setProperty("__exceptionStack",value);
			return value;
		} else {
			var s = _g;
			return s;
		}
	}
	,setProperty: function(name,value) {
		try {
			Object.defineProperty(this,name,{ value : value});
		} catch( _g ) {
			this[name] = value;
		}
	}
});
var haxe_Log = function() { };
haxe_Log.__name__ = true;
haxe_Log.formatOutput = function(v,infos) {
	var str = Std.string(v);
	if(infos == null) {
		return str;
	}
	var pstr = infos.fileName + ":" + infos.lineNumber;
	if(infos.customParams != null) {
		var _g = 0;
		var _g1 = infos.customParams;
		while(_g < _g1.length) {
			var v = _g1[_g];
			++_g;
			str += ", " + Std.string(v);
		}
	}
	return pstr + ": " + str;
};
haxe_Log.trace = function(v,infos) {
	var str = haxe_Log.formatOutput(v,infos);
	if(typeof(console) != "undefined" && console.log != null) {
		console.log(str);
	}
};
var haxe_NativeStackTrace = function() { };
haxe_NativeStackTrace.__name__ = true;
haxe_NativeStackTrace.saveStack = function(e) {
	haxe_NativeStackTrace.lastError = e;
};
haxe_NativeStackTrace.callStack = function() {
	var e = new Error("");
	var stack = haxe_NativeStackTrace.tryHaxeStack(e);
	if(typeof(stack) == "undefined") {
		try {
			throw e;
		} catch( _g ) {
		}
		stack = e.stack;
	}
	return haxe_NativeStackTrace.normalize(stack,2);
};
haxe_NativeStackTrace.exceptionStack = function() {
	return haxe_NativeStackTrace.normalize(haxe_NativeStackTrace.tryHaxeStack(haxe_NativeStackTrace.lastError));
};
haxe_NativeStackTrace.toHaxe = function(s,skip) {
	if(skip == null) {
		skip = 0;
	}
	if(s == null) {
		return [];
	} else if(typeof(s) == "string") {
		var stack = s.split("\n");
		if(stack[0] == "Error") {
			stack.shift();
		}
		var m = [];
		var _g = 0;
		var _g1 = stack.length;
		while(_g < _g1) {
			var i = _g++;
			if(skip > i) {
				continue;
			}
			var line = stack[i];
			var matched = line.match(/^    at ([A-Za-z0-9_. ]+) \(([^)]+):([0-9]+):([0-9]+)\)$/);
			if(matched != null) {
				var path = matched[1].split(".");
				if(path[0] == "$hxClasses") {
					path.shift();
				}
				var meth = path.pop();
				var file = matched[2];
				var line1 = Std.parseInt(matched[3]);
				var column = Std.parseInt(matched[4]);
				m.push(haxe_StackItem.FilePos(meth == "Anonymous function" ? haxe_StackItem.LocalFunction() : meth == "Global code" ? null : haxe_StackItem.Method(path.join("."),meth),file,line1,column));
			} else {
				m.push(haxe_StackItem.Module(StringTools.trim(line)));
			}
		}
		return m;
	} else if(skip > 0 && Array.isArray(s)) {
		return s.slice(skip);
	} else {
		return s;
	}
};
haxe_NativeStackTrace.tryHaxeStack = function(e) {
	if(e == null) {
		return [];
	}
	var oldValue = Error.prepareStackTrace;
	Error.prepareStackTrace = haxe_NativeStackTrace.prepareHxStackTrace;
	var stack = e.stack;
	Error.prepareStackTrace = oldValue;
	return stack;
};
haxe_NativeStackTrace.prepareHxStackTrace = function(e,callsites) {
	var stack = [];
	var _g = 0;
	while(_g < callsites.length) {
		var site = callsites[_g];
		++_g;
		if(haxe_NativeStackTrace.wrapCallSite != null) {
			site = haxe_NativeStackTrace.wrapCallSite(site);
		}
		var method = null;
		var fullName = site.getFunctionName();
		if(fullName != null) {
			var idx = fullName.lastIndexOf(".");
			if(idx >= 0) {
				var className = fullName.substring(0,idx);
				var methodName = fullName.substring(idx + 1);
				method = haxe_StackItem.Method(className,methodName);
			} else {
				method = haxe_StackItem.Method(null,fullName);
			}
		}
		var fileName = site.getFileName();
		var fileAddr = fileName == null ? -1 : fileName.indexOf("file:");
		if(haxe_NativeStackTrace.wrapCallSite != null && fileAddr > 0) {
			fileName = fileName.substring(fileAddr + 6);
		}
		stack.push(haxe_StackItem.FilePos(method,fileName,site.getLineNumber(),site.getColumnNumber()));
	}
	return stack;
};
haxe_NativeStackTrace.normalize = function(stack,skipItems) {
	if(skipItems == null) {
		skipItems = 0;
	}
	if(Array.isArray(stack) && skipItems > 0) {
		return stack.slice(skipItems);
	} else if(typeof(stack) == "string") {
		switch(stack.substring(0,6)) {
		case "Error\n":case "Error:":
			++skipItems;
			break;
		default:
		}
		return haxe_NativeStackTrace.skipLines(stack,skipItems);
	} else {
		return stack;
	}
};
haxe_NativeStackTrace.skipLines = function(stack,skip,pos) {
	if(pos == null) {
		pos = 0;
	}
	if(skip > 0) {
		pos = stack.indexOf("\n",pos);
		if(pos < 0) {
			return "";
		} else {
			return haxe_NativeStackTrace.skipLines(stack,--skip,pos + 1);
		}
	} else {
		return stack.substring(pos);
	}
};
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe_Timer.__name__ = true;
haxe_Timer.prototype = {
	stop: function() {
		if(this.id == null) {
			return;
		}
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
};
var haxe_ValueException = function(value,previous,native) {
	haxe_Exception.call(this,String(value),previous,native);
	this.value = value;
	this.__skipStack++;
};
haxe_ValueException.__name__ = true;
haxe_ValueException.__super__ = haxe_Exception;
haxe_ValueException.prototype = $extend(haxe_Exception.prototype,{
	unwrap: function() {
		return this.value;
	}
});
var haxe_iterators_ArrayIterator = function(array) {
	this.current = 0;
	this.array = array;
};
haxe_iterators_ArrayIterator.__name__ = true;
haxe_iterators_ArrayIterator.prototype = {
	hasNext: function() {
		return this.current < this.array.length;
	}
	,next: function() {
		return this.array[this.current++];
	}
};
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(o.__enum__) {
			var e = $hxEnums[o.__enum__];
			var con = e.__constructs__[o._hx_index];
			var n = con._hx_name;
			if(con.__params__) {
				s = s + "\t";
				return n + "(" + ((function($this) {
					var $r;
					var _g = [];
					{
						var _g1 = 0;
						var _g2 = con.__params__;
						while(true) {
							if(!(_g1 < _g2.length)) {
								break;
							}
							var p = _g2[_g1];
							_g1 = _g1 + 1;
							_g.push(js_Boot.__string_rec(o[p],s));
						}
					}
					$r = _g;
					return $r;
				}(this))).join(",") + ")";
			} else {
				return n;
			}
		}
		if(((o) instanceof Array)) {
			var str = "[";
			s += "\t";
			var _g = 0;
			var _g1 = o.length;
			while(_g < _g1) {
				var i = _g++;
				str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( _g ) {
			haxe_NativeStackTrace.lastError = _g;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		var k = null;
		for( k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) {
			str += ", \n";
		}
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "string":
		return o;
	default:
		return String(o);
	}
};
var tbc_Process = $hx_exports["tbc"]["Process"] = {};
tbc_Process._new = function(p) {
	var this1 = p;
	return this1;
};
tbc_Process.bind = function(this1,f) {
	var this2 = this1.bind(f);
	return this2;
};
tbc_Process.map = function(this1,f) {
	var this2 = this1.map(f);
	return this2;
};
tbc_Process.sc = function(this1,q) {
	var this2 = this1.sc(q);
	return this2;
};
tbc_Process.go = function(this1,k,h) {
	this1.go(k,h);
};
tbc_Process.run = function(this1) {
	this1.run();
};
var tbc_ProcessA = $hx_exports["tbc"]["ProcessA"] = function() { };
tbc_ProcessA.__name__ = true;
tbc_ProcessA.printStack = function() {
	haxe_Log.trace(haxe_CallStack.toString(haxe_CallStack.exceptionStack()),{ fileName : "src/tbc/TBC.hx", lineNumber : 98, className : "tbc.ProcessA", methodName : "printStack"});
};
tbc_ProcessA.prototype = {
	bind: function(f) {
		return new tbc__$TBC_ThenP(this,f);
	}
	,map: function(f) {
		var f1 = function(a) {
			return new tbc__$TBC_ExecP(function() {
				return f(a);
			});
		};
		return new tbc__$TBC_ThenP(this,f1);
	}
	,sc: function(q) {
		return new tbc__$TBC_ThenP(this,function(a) {
			return q;
		});
	}
	,run: function() {
		this.go(function(a) {
		},function(ex) {
			haxe_Log.trace("Process throws uncaught exception " + Std.string(ex),{ fileName : "src/tbc/TBC.hx", lineNumber : 105, className : "tbc.ProcessA", methodName : "run"});
			haxe_Log.trace(haxe_CallStack.toString(haxe_CallStack.exceptionStack()),{ fileName : "src/tbc/TBC.hx", lineNumber : 106, className : "tbc.ProcessA", methodName : "run"});
		});
	}
	,go: function(k,h) {
		h("go is not defined in " + Std.string(this));
	}
};
var tbc__$TBC_ThenP = function(left,right) {
	this._left = left;
	this._right = right;
};
tbc__$TBC_ThenP.__name__ = true;
tbc__$TBC_ThenP.__super__ = tbc_ProcessA;
tbc__$TBC_ThenP.prototype = $extend(tbc_ProcessA.prototype,{
	go: function(f,h) {
		var _gthis = this;
		this._left.go(function(a) {
			_gthis._right(a).go(f,h);
		},h);
	}
});
var tbc__$TBC_ExecP = function(f) {
	this._f = f;
};
tbc__$TBC_ExecP.__name__ = true;
tbc__$TBC_ExecP.__super__ = tbc_ProcessA;
tbc__$TBC_ExecP.prototype = $extend(tbc_ProcessA.prototype,{
	go: function(k,h) {
		try {
			k(this._f());
		} catch( _g ) {
			haxe_NativeStackTrace.lastError = _g;
			var ex = haxe_Exception.caught(_g).unwrap();
			h(ex);
		}
	}
});
var tbc__$TBC_TossP = function(ex) {
	this._ex = ex;
};
tbc__$TBC_TossP.__name__ = true;
tbc__$TBC_TossP.__super__ = tbc_ProcessA;
tbc__$TBC_TossP.prototype = $extend(tbc_ProcessA.prototype,{
	go: function(k,h) {
		h(this._ex);
	}
});
var tbc__$TBC_AttemptP = function(p,f,q) {
	this._p = p;
	this._f = f;
	this._q = q;
};
tbc__$TBC_AttemptP.__name__ = true;
tbc__$TBC_AttemptP.__super__ = tbc_ProcessA;
tbc__$TBC_AttemptP.prototype = $extend(tbc_ProcessA.prototype,{
	go: function(k,h) {
		var _gthis = this;
		this._p.go(function(a) {
			_gthis._q.go(function(t) {
				k(a);
			},h);
		},function(ex) {
			_gthis._f(ex).go(function(a) {
				_gthis._q.go(function(t) {
					k(a);
				},h);
			},function(ex1) {
				_gthis._q.go(function(t) {
					h(ex1);
				},function(ex2) {
					h(new tbc_Pair(ex1,ex2));
				});
			});
		});
	}
});
var tbc_Guard = $hx_exports["tbc"]["Guard"] = {};
tbc_Guard._new = function(g) {
	var this1 = g;
	return this1;
};
tbc_Guard.enable = function(this1,k,h) {
	return this1.enable(k,h);
};
tbc_Guard.guarding = function(this1,k) {
	return this1.bind(k);
};
tbc_Guard.andThen = function(this1,p) {
	return this1.sc(p);
};
tbc_Guard.filter = function(this1,c) {
	return this1.filter(c);
};
tbc_Guard.bind = function(this1,f) {
	var this2 = this1.bind(f);
	return this2;
};
tbc_Guard.sc = function(this1,q) {
	var this2 = this1.sc(q);
	return this2;
};
tbc_Guard.orElse = function(this1,gp) {
	var this2 = this1.orElse(gp);
	return this2;
};
tbc_Guard.enableGP = function(this1,first,k,h) {
	return this1.enableGP(first,k,h);
};
var tbc_GuardedProcessA = $hx_exports["tbc"]["GuardedProcessA"] = function() { };
tbc_GuardedProcessA.__name__ = true;
tbc_GuardedProcessA.prototype = {
	bind: function(f) {
		return new tbc__$TBC_ThenGP(this,f);
	}
	,sc: function(b) {
		return new tbc__$TBC_ThenGP(this,function(a) {
			return b;
		});
	}
	,orElse: function(gp) {
		return new tbc__$TBC_ChoiceGP(this,gp);
	}
	,enableGP: function(first,k,h) {
		h("enableGP is not defined in " + Std.string(this));
		return null;
	}
};
var tbc_GuardA = $hx_exports["tbc"]["GuardA"] = function() { };
tbc_GuardA.__name__ = true;
tbc_GuardA.__super__ = tbc_GuardedProcessA;
tbc_GuardA.prototype = $extend(tbc_GuardedProcessA.prototype,{
	enable: function(k,h) {
		h("Method enable not overridden in " + Std.string(this));
		return null;
	}
	,enableGP: function(first,k,h) {
		return this.enable(function(e) {
			first();
			tbc_TBC.unit(e).go(k,h);
		},h);
	}
	,guarding: function(f) {
		return this.bind(f);
	}
	,andThen: function(p) {
		return this.sc(p);
	}
	,filter: function(c) {
		return new tbc_FliteredGuard(this,c);
	}
});
var tbc_FliteredGuard = $hx_exports["tbc"]["FliteredGuard"] = function(guard,c) {
	this._guard = guard;
	this._filter = c;
};
tbc_FliteredGuard.__name__ = true;
tbc_FliteredGuard.__super__ = tbc_GuardA;
tbc_FliteredGuard.prototype = $extend(tbc_GuardA.prototype,{
	enable: function(k,h) {
		var _gthis = this;
		return this._guard.enable(function(b) {
			if(_gthis._filter(b)) {
				k(b);
			}
		},h);
	}
});
var tbc_GuardedProcess = $hx_exports["tbc"]["GuardedProcess"] = {};
tbc_GuardedProcess._new = function(gp) {
	var this1 = gp;
	return this1;
};
tbc_GuardedProcess.bind = function(this1,f) {
	var this2 = this1.bind(f);
	return this2;
};
tbc_GuardedProcess.sc = function(this1,q) {
	var this2 = this1.sc(q);
	return this2;
};
tbc_GuardedProcess.orElse = function(this1,gp) {
	var this2 = this1.orElse(gp);
	return this2;
};
tbc_GuardedProcess.enableGP = function(this1,first,k,h) {
	return this1.enableGP(first,k,h);
};
var tbc__$TBC_ThenGP = function(gp,f) {
	this._gp = gp;
	this._f = f;
};
tbc__$TBC_ThenGP.__name__ = true;
tbc__$TBC_ThenGP.__super__ = tbc_GuardedProcessA;
tbc__$TBC_ThenGP.prototype = $extend(tbc_GuardedProcessA.prototype,{
	enableGP: function(first,k,h) {
		var _gthis = this;
		return this._gp.enableGP(first,function(a) {
			_gthis._f(a).go(k,h);
		},h);
	}
});
var tbc__$TBC_ChoiceGP = function(gp0,gp1) {
	this._gp0 = gp0;
	this._gp1 = gp1;
};
tbc__$TBC_ChoiceGP.__name__ = true;
tbc__$TBC_ChoiceGP.__super__ = tbc_GuardedProcessA;
tbc__$TBC_ChoiceGP.prototype = $extend(tbc_GuardedProcessA.prototype,{
	enableGP: function(first,k,h) {
		var d0 = this._gp0.enableGP(first,k,h);
		var d1 = this._gp1.enableGP(first,k,h);
		return new tbc__$TBC_ChoiceDisabler(d0,d1);
	}
});
var tbc__$TBC_ChoiceDisabler = function(d0,d1) {
	this._d0 = d0;
	this._d1 = d1;
};
tbc__$TBC_ChoiceDisabler.__name__ = true;
tbc__$TBC_ChoiceDisabler.prototype = {
	disable: function() {
		this._d0.disable();
		this._d1.disable();
	}
};
var tbc__$TBC_AwaitP = function(gp) {
	this._gp = gp;
};
tbc__$TBC_AwaitP.__name__ = true;
tbc__$TBC_AwaitP.__super__ = tbc_ProcessA;
tbc__$TBC_AwaitP.prototype = $extend(tbc_ProcessA.prototype,{
	go: function(k,h) {
		var disabler = null;
		var disable = function() {
			disabler.disable();
		};
		disabler = this._gp.enableGP(disable,k,h);
	}
});
var tbc__$TBC_AltP = function(e,p,q) {
	this._e = e;
	this._p = p;
	this._q = q;
};
tbc__$TBC_AltP.__name__ = true;
tbc__$TBC_AltP.__super__ = tbc_ProcessA;
tbc__$TBC_AltP.prototype = $extend(tbc_ProcessA.prototype,{
	go: function(k,h) {
		var _gthis = this;
		this._e.go(function(b) {
			if(b) {
				_gthis._p.go(k,h);
			} else {
				_gthis._q.go(k,h);
			}
		},h);
	}
});
var tbc__$TBC_Par2P = function(p,q) {
	this._p = p;
	this._q = q;
};
tbc__$TBC_Par2P.__name__ = true;
tbc__$TBC_Par2P.__super__ = tbc_ProcessA;
tbc__$TBC_Par2P.prototype = $extend(tbc_ProcessA.prototype,{
	go: function(k,h) {
		var result = new tbc_Pair();
		var completed = 0;
		this._p.go(function(a) {
			result._left = a;
			completed += 1;
			if(completed == 2) {
				k(result);
			}
		},h);
		this._q.go(function(b) {
			result._right = b;
			completed += 1;
			if(completed == 2) {
				k(result);
			}
		},h);
	}
});
var tbc__$TBC_ParFor = function(n,f) {
	this._n = n;
	this._f = f;
};
tbc__$TBC_ParFor.__name__ = true;
tbc__$TBC_ParFor.__super__ = tbc_ProcessA;
tbc__$TBC_ParFor.prototype = $extend(tbc_ProcessA.prototype,{
	go: function(k,h) {
		var _gthis = this;
		var this1 = new Array(this._n);
		var result = this1;
		var completed = 0;
		var _g = 0;
		var _g1 = this._n;
		while(_g < _g1) {
			var i = [_g++];
			this._f(i[0]).go((function(i) {
				return function(a) {
					result[i[0]] = a;
					completed += 1;
					if(completed == _gthis._n) {
						k(result);
					}
				};
			})(i),h);
		}
	}
});
var tbc_Triv = $hxEnums["tbc.Triv"] = { __ename__:true,__constructs__:null
};
tbc_Triv.__constructs__ = [];
var tbc_Pair = $hx_exports["tbc"]["Pair"] = function(a,b) {
	this._left = a;
	this._right = b;
};
tbc_Pair.__name__ = true;
var tbc_TBC = $hx_exports["tbc"]["TBC"] = function() {
};
tbc_TBC.__name__ = true;
tbc_TBC.skip = function() {
	return tbc_TBC.unit(null);
};
tbc_TBC.unit = function(a) {
	return new tbc__$TBC_ExecP(function() {
		return a;
	});
};
tbc_TBC.exec = function(f) {
	return new tbc__$TBC_ExecP(f);
};
tbc_TBC.par = function(p,q) {
	return new tbc__$TBC_Par2P(p,q);
};
tbc_TBC.parFor = function(n,f) {
	return new tbc__$TBC_ParFor(n,f);
};
tbc_TBC.loop = function(p) {
	var this1 = p.bind(function(a) {
		return tbc_TBC.loop(p);
	});
	return this1;
};
tbc_TBC.alt = function(e,p,q) {
	return new tbc__$TBC_AltP(e,p,q);
};
tbc_TBC.fix = function(f) {
	var p = null;
	var fp = function() {
		if(p == null) {
			return tbc_TBC.toss("TBC Error in fix. Possibly a missing invoke?");
		} else {
			return p;
		}
	};
	p = f(fp);
	return p;
};
tbc_TBC.toss = function(ex) {
	return new tbc__$TBC_TossP(ex);
};
tbc_TBC.attempt = function(p,f,q) {
	if(q == null) {
		q = tbc_TBC.skip();
	}
	return new tbc__$TBC_AttemptP(p,f,q);
};
tbc_TBC.ultimately = function(p,q) {
	var f = function(ex) {
		return tbc_TBC.toss(ex);
	};
	return tbc_TBC.attempt(p,f,q);
};
tbc_TBC.invoke = function(fp) {
	var this1 = tbc_TBC.exec(fp).bind(function(p) {
		return p;
	});
	return this1;
};
tbc_TBC.await = function(gp0,gp1,gp2,gp3,gp4,gp5) {
	var gp = gp0;
	if(gp1 != null) {
		var this1 = gp.orElse(gp1);
		gp = this1;
	}
	if(gp2 != null) {
		var this1 = gp.orElse(gp2);
		gp = this1;
	}
	if(gp3 != null) {
		var this1 = gp.orElse(gp3);
		gp = this1;
	}
	if(gp4 != null) {
		var this1 = gp.orElse(gp4);
		gp = this1;
	}
	if(gp5 != null) {
		var this1 = gp.orElse(gp5);
		gp = this1;
	}
	return new tbc__$TBC_AwaitP(gp);
};
tbc_TBC.prototype = {
	test: function(g1,g2,gp) {
		var a = tbc_TBC.await(g1);
		var this1 = g1.orElse(g2);
		var b = tbc_TBC.await(this1);
		var this1 = g1.orElse(gp);
		var c = tbc_TBC.await(this1);
		var this1 = gp.orElse(g2);
		var d = tbc_TBC.await(this1);
		var this1 = a.sc(b);
		var this2 = this1.sc(c);
		var this1 = this2.sc(d);
		return this1;
	}
};
var tbc__$TBCTime_MyTimer = function(timeInMiliSecs,k) {
	var _gthis = this;
	this.timer = new haxe_Timer(timeInMiliSecs);
	this.timer.run = function() {
		_gthis.timer.stop();
		k(null);
	};
};
tbc__$TBCTime_MyTimer.__name__ = true;
tbc__$TBCTime_MyTimer.prototype = {
	disable: function() {
		this.timer.stop();
	}
};
var tbc_TimeOutGuard = $hx_exports["tbc"]["TimeOutGuard"] = function(timeInMiliSecs) {
	this._timeInMiliSecs = timeInMiliSecs;
};
tbc_TimeOutGuard.__name__ = true;
tbc_TimeOutGuard.__super__ = tbc_GuardA;
tbc_TimeOutGuard.prototype = $extend(tbc_GuardA.prototype,{
	enable: function(k,h) {
		return new tbc__$TBCTime_MyTimer(this._timeInMiliSecs,k);
	}
});
var tbc_TBCTime = $hx_exports["tbc"]["TBCTime"] = function() { };
tbc_TBCTime.__name__ = true;
tbc_TBCTime.pause = function(delayInMiliSecs) {
	return tbc_TBC.await(tbc_Guard.andThen(tbc_TBCTime.timeout(delayInMiliSecs),tbc_TBC.skip()));
};
tbc_TBCTime.later = function() {
	return tbc_TBCTime.pause(0);
};
tbc_TBCTime.timeout = function(delayInMiliSecs) {
	return new tbc_TimeOutGuard(delayInMiliSecs);
};
if(typeof(performance) != "undefined" ? typeof(performance.now) == "function" : false) {
	HxOverrides.now = performance.now.bind(performance);
}
String.__name__ = true;
Array.__name__ = true;
Date.__name__ = "Date";
js_Boot.__toStr = ({ }).toString;
Controller.outStr = "";
Controller.main();
})(typeof exports != "undefined" ? exports : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this, {});
