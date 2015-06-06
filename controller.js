(function (console) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var Controller = function() { };
Controller.__name__ = true;
Controller.main = function() {
	var win = window;
	var doc = win.document;
	var body = doc.body;
	body.onload = Controller.onload;
};
Controller.f = function() {
	haxe_Log.trace("X",{ fileName : "Controller.hx", lineNumber : 27, className : "Controller", methodName : "f"});
};
Controller.outX = function() {
	haxe_Log.trace("XX",{ fileName : "Controller.hx", lineNumber : 28, className : "Controller", methodName : "outX"});
	return null;
};
Controller.outY = function() {
	haxe_Log.trace("Y",{ fileName : "Controller.hx", lineNumber : 29, className : "Controller", methodName : "outY"});
	return null;
};
Controller.out0 = function(ev) {
	haxe_Log.trace("0",{ fileName : "Controller.hx", lineNumber : 30, className : "Controller", methodName : "out0"});
	return tbc_TBC.skip();
};
Controller.out1A = function(ev) {
	haxe_Log.trace("1A",{ fileName : "Controller.hx", lineNumber : 31, className : "Controller", methodName : "out1A"});
	return tbc_TBC.skip();
};
Controller.out1B = function(ev) {
	haxe_Log.trace("1B",{ fileName : "Controller.hx", lineNumber : 32, className : "Controller", methodName : "out1B"});
	return tbc_TBC.skip();
};
Controller.out2 = function(ev) {
	haxe_Log.trace("2",{ fileName : "Controller.hx", lineNumber : 33, className : "Controller", methodName : "out2"});
	return tbc_TBC.skip();
};
Controller.tooLate = function(triv) {
	haxe_Log.trace("too slow",{ fileName : "Controller.hx", lineNumber : 34, className : "Controller", methodName : "tooLate"});
	return tbc_TBC.skip();
};
Controller.nagTheUser = function() {
	haxe_Log.trace("Hurry up",{ fileName : "Controller.hx", lineNumber : 36, className : "Controller", methodName : "nagTheUser"});
	return null;
};
Controller.thankTheUser = function() {
	haxe_Log.trace("Thankyou",{ fileName : "Controller.hx", lineNumber : 38, className : "Controller", methodName : "thankTheUser"});
	return null;
};
Controller.tryEx = function() {
	return tbc_TBC.exec(Controller.f);
};
Controller.tryPar = function() {
	return tbc_TBC.par((function($this) {
		var $r;
		var this1;
		{
			var this2 = tbc_TBC.exec(Controller.outX);
			var q1 = tbc_TBCTime.pause(2000);
			var p = this2.sc(q1);
			this1 = p;
		}
		var q = tbc_TBC.exec(Controller.outX);
		$r = (function($this) {
			var $r;
			var p1 = this1.sc(q);
			$r = p1;
			return $r;
		}($this));
		return $r;
	}(this)),(function($this) {
		var $r;
		var this3;
		{
			var this4 = tbc_TBC.exec(Controller.outY);
			var p2 = this4.bind(function(a) {
				return tbc_TBCTime.pause(1999);
			});
			this3 = p2;
		}
		$r = (function($this) {
			var $r;
			var p3 = this3.bind(function(a1) {
				return tbc_TBC.exec(Controller.outY);
			});
			$r = p3;
			return $r;
		}($this));
		return $r;
	}(this)));
};
Controller.tryOverloading = function() {
	var this1;
	var this2 = tbc_TBC.exec(Controller.outX);
	var q1 = tbc_TBCTime.pause(2000);
	var p = this2.sc(q1);
	this1 = p;
	var q = tbc_TBC.exec(Controller.outX);
	var p1 = this1.sc(q);
	return p1;
};
Controller.useCase = function() {
	return tbc_TBC.loop((function($this) {
		var $r;
		var this1;
		{
			var this3;
			var this5 = tbc_TBC.await((function($this) {
				var $r;
				var this4 = tbc_TBCHTML.click(Controller.b0);
				$r = this4.guarding(Controller.out0);
				return $r;
			}($this)));
			var q2 = tbc_TBC.await((function($this) {
				var $r;
				var this6 = tbc_TBCHTML.click(Controller.b1a);
				$r = this6.guarding(Controller.out1A);
				return $r;
			}($this)),(function($this) {
				var $r;
				var this7 = tbc_TBCHTML.click(Controller.b1b);
				$r = this7.guarding(Controller.out1B);
				return $r;
			}($this)),(function($this) {
				var $r;
				var this8 = tbc_TBCTime.timeout(2000);
				$r = this8.guarding(Controller.tooLate);
				return $r;
			}($this)));
			var p = this5.sc(q2);
			this3 = p;
			var q1 = tbc_TBCTime.pause(1000);
			var p1 = this3.sc(q1);
			this1 = p1;
		}
		var q = tbc_TBC.await((function($this) {
			var $r;
			var this2 = tbc_TBCHTML.click(Controller.b2);
			$r = this2.guarding(Controller.out2);
			return $r;
		}($this)));
		$r = (function($this) {
			var $r;
			var p2 = this1.sc(q);
			$r = p2;
			return $r;
		}($this));
		return $r;
	}(this)));
};
Controller.nag = function(triv) {
	return tbc_TBC.await(tbc__$TBC_Guard_$Impl_$.andThen(tbc_TBCHTML.click(Controller.b0),tbc_TBC.exec(Controller.thankTheUser)),tbc__$TBC_Guard_$Impl_$.andThen(tbc_TBCTime.timeout(1000),(function($this) {
		var $r;
		var this1 = tbc_TBC.exec(Controller.nagTheUser);
		$r = (function($this) {
			var $r;
			var p = this1.bind(Controller.nag);
			$r = p;
			return $r;
		}($this));
		return $r;
	}(this))));
};
Controller.onload = function() {
	var win = window;
	var doc = win.document;
	Controller.b0 = js_Boot.__cast(doc.getElementById("button:zero") , HTMLButtonElement);
	Controller.b1a = js_Boot.__cast(doc.getElementById("button:oneA") , HTMLButtonElement);
	Controller.b1b = js_Boot.__cast(doc.getElementById("button:oneB") , HTMLButtonElement);
	Controller.b2 = js_Boot.__cast(doc.getElementById("button:two") , HTMLButtonElement);
	haxe_Log.trace("hello",{ fileName : "Controller.hx", lineNumber : 79, className : "Controller", methodName : "onload"});
	var this1 = Controller.nag(null);
	this1.go(function(x) {
	});
};
var List = function() {
	this.length = 0;
};
List.__name__ = true;
List.prototype = {
	add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,__class__: List
};
Math.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var haxe_Log = function() { };
haxe_Log.__name__ = true;
haxe_Log.trace = function(v,infos) {
	js_Boot.__trace(v,infos);
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
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe_Timer
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
};
js_Boot.__trace = function(v,i) {
	var msg;
	if(i != null) msg = i.fileName + ":" + i.lineNumber + ": "; else msg = "";
	msg += js_Boot.__string_rec(v,"");
	if(i != null && i.customParams != null) {
		var _g = 0;
		var _g1 = i.customParams;
		while(_g < _g1.length) {
			var v1 = _g1[_g];
			++_g;
			msg += "," + js_Boot.__string_rec(v1,"");
		}
	}
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js_Boot.__unhtml(msg) + "<br/>"; else if(typeof console != "undefined" && console.log != null) console.log(msg);
};
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js_Boot.__nativeClassName(o);
		if(name != null) return js_Boot.__resolveNativeClass(name);
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js_Boot.__cast = function(o,t) {
	if(js_Boot.__instanceof(o,t)) return o; else throw new js__$Boot_HaxeError("Cannot cast " + Std.string(o) + " to " + Std.string(t));
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return (Function("return typeof " + name + " != \"undefined\" ? " + name + " : null"))();
};
var tbc_ProcessI = function() { };
tbc_ProcessI.__name__ = true;
tbc_ProcessI.prototype = {
	__class__: tbc_ProcessI
};
var tbc__$TBC_Process_$Impl_$ = {};
tbc__$TBC_Process_$Impl_$.__name__ = true;
tbc__$TBC_Process_$Impl_$._new = function(p) {
	return p;
};
tbc__$TBC_Process_$Impl_$.bind = function(this1,f) {
	var p = this1.bind(f);
	return p;
};
tbc__$TBC_Process_$Impl_$.sc = function(this1,q) {
	var p = this1.sc(q);
	return p;
};
tbc__$TBC_Process_$Impl_$.go = function(this1,k) {
	this1.go(k);
};
var tbc_ProcessA = function() { };
tbc_ProcessA.__name__ = true;
tbc_ProcessA.__interfaces__ = [tbc_ProcessI];
tbc_ProcessA.prototype = {
	bind: function(f) {
		return new tbc__$TBC_ThenP(this,f);
	}
	,sc: function(q) {
		return new tbc__$TBC_ThenP(this,function(a) {
			return q;
		});
	}
	,go: function(k) {
		throw new js__$Boot_HaxeError("go is not defined in " + Std.string(this));
	}
	,__class__: tbc_ProcessA
};
var tbc__$TBC_ThenP = function(left,right) {
	this._left = left;
	this._right = right;
};
tbc__$TBC_ThenP.__name__ = true;
tbc__$TBC_ThenP.__super__ = tbc_ProcessA;
tbc__$TBC_ThenP.prototype = $extend(tbc_ProcessA.prototype,{
	go: function(f) {
		var _g = this;
		this._left.go(function(a) {
			var this1 = _g._right(a);
			this1.go(f);
		});
	}
	,__class__: tbc__$TBC_ThenP
});
var tbc_UnitP = function(f) {
	this._f = f;
};
tbc_UnitP.__name__ = true;
tbc_UnitP.__super__ = tbc_ProcessA;
tbc_UnitP.prototype = $extend(tbc_ProcessA.prototype,{
	go: function(k) {
		k(this._f());
	}
	,__class__: tbc_UnitP
});
var tbc_Disabler = function() { };
tbc_Disabler.__name__ = true;
tbc_Disabler.prototype = {
	__class__: tbc_Disabler
};
var tbc_GuardI = function() { };
tbc_GuardI.__name__ = true;
tbc_GuardI.prototype = {
	__class__: tbc_GuardI
};
var tbc__$TBC_Guard_$Impl_$ = {};
tbc__$TBC_Guard_$Impl_$.__name__ = true;
tbc__$TBC_Guard_$Impl_$._new = function(g) {
	return g;
};
tbc__$TBC_Guard_$Impl_$.enable = function(this1,k) {
	return this1.enable(k);
};
tbc__$TBC_Guard_$Impl_$.guarding = function(this1,k) {
	return this1.guarding(k);
};
tbc__$TBC_Guard_$Impl_$.andThen = function(this1,p) {
	return this1.andThen(p);
};
var tbc_GuardA = function() { };
tbc_GuardA.__name__ = true;
tbc_GuardA.__interfaces__ = [tbc_GuardI];
tbc_GuardA.prototype = {
	enable: function(k) {
		throw new js__$Boot_HaxeError("Method enable not overridden in " + Std.string(this));
		return null;
	}
	,guarding: function(k) {
		return new tbc__$TBC_GuardedProcessC(this,k);
	}
	,andThen: function(p) {
		return this.guarding(function(ev) {
			return p;
		});
	}
	,__class__: tbc_GuardA
};
var tbc_GuardedProcess = function() { };
tbc_GuardedProcess.__name__ = true;
tbc_GuardedProcess.prototype = {
	__class__: tbc_GuardedProcess
};
var tbc__$TBC_GuardedProcessC = function(guard,f) {
	this._guard = guard;
	this._f = f;
};
tbc__$TBC_GuardedProcessC.__name__ = true;
tbc__$TBC_GuardedProcessC.__interfaces__ = [tbc_GuardedProcess];
tbc__$TBC_GuardedProcessC.prototype = {
	enable: function(first,k) {
		var _g = this;
		return this._guard.enable(function(b) {
			first();
			var this1 = _g._f(b);
			this1.go(k);
		});
	}
	,__class__: tbc__$TBC_GuardedProcessC
};
var tbc_AwaitP = function(a) {
	this.gps = a;
};
tbc_AwaitP.__name__ = true;
tbc_AwaitP.__super__ = tbc_ProcessA;
tbc_AwaitP.prototype = $extend(tbc_ProcessA.prototype,{
	go: function(k) {
		var disablers = [];
		var disable = function() {
			var _g = 0;
			while(_g < disablers.length) {
				var d = disablers[_g];
				++_g;
				d.disable();
			}
		};
		var _g_head = this.gps.h;
		var _g_val = null;
		while(_g_head != null) {
			var gp;
			gp = (function($this) {
				var $r;
				_g_val = _g_head[0];
				_g_head = _g_head[1];
				$r = _g_val;
				return $r;
			}(this));
			var d1 = gp.enable(disable,k);
			disablers.push(d1);
		}
	}
	,__class__: tbc_AwaitP
});
var tbc_Par2P = function(p,q) {
	this._p = p;
	this._q = q;
};
tbc_Par2P.__name__ = true;
tbc_Par2P.__super__ = tbc_ProcessA;
tbc_Par2P.prototype = $extend(tbc_ProcessA.prototype,{
	go: function(k) {
		var result = new tbc_Pair();
		var completed = 0;
		this._p.go(function(a) {
			result._left = a;
			completed++;
			if(completed == 2) k(result);
		});
		this._q.go(function(b) {
			result._right = b;
			completed++;
			if(completed == 2) k(result);
		});
	}
	,__class__: tbc_Par2P
});
var tbc_Triv = { __ename__ : true, __constructs__ : [] };
var tbc_Pair = function() {
};
tbc_Pair.__name__ = true;
tbc_Pair.prototype = {
	__class__: tbc_Pair
};
var tbc_TBC = function() { };
tbc_TBC.__name__ = true;
tbc_TBC.toss = function() {
	return function(x) {
		return tbc_TBC.unit(null);
	};
};
tbc_TBC.skip = function() {
	return tbc_TBC.unit(null);
};
tbc_TBC.unit = function(a) {
	return new tbc_UnitP(function() {
		return a;
	});
};
tbc_TBC.exec = function(f) {
	return new tbc_UnitP(f);
};
tbc_TBC.par = function(p,q) {
	return new tbc_Par2P(p,q);
};
tbc_TBC.loop = function(p) {
	var p1 = p.bind(function(a) {
		return tbc_TBC.loop(p);
	});
	return p1;
};
tbc_TBC.awaitAny = function(list) {
	return new tbc_AwaitP(list);
};
tbc_TBC.await = function(gp0,gp1,gp2,gp3,gp4,gp5) {
	var list = new List();
	list.add(gp0);
	if(gp1 != null) list.add(gp1);
	if(gp2 != null) list.add(gp2);
	if(gp3 != null) list.add(gp3);
	if(gp4 != null) list.add(gp4);
	if(gp5 != null) list.add(gp5);
	return new tbc_AwaitP(list);
};
var tbc__$TBCHTML_ButtonDisabler = function(el) {
	this._el = el;
};
tbc__$TBCHTML_ButtonDisabler.__name__ = true;
tbc__$TBCHTML_ButtonDisabler.__interfaces__ = [tbc_Disabler];
tbc__$TBCHTML_ButtonDisabler.prototype = {
	disable: function() {
		this._el.onclick = null;
		this._el.disabled = true;
	}
	,__class__: tbc__$TBCHTML_ButtonDisabler
};
var tbc_ClickG = function(el) {
	this._el = el;
};
tbc_ClickG.__name__ = true;
tbc_ClickG.__super__ = tbc_GuardA;
tbc_ClickG.prototype = $extend(tbc_GuardA.prototype,{
	enable: function(k) {
		this._el.onclick = k;
		this._el.disabled = false;
		return new tbc__$TBCHTML_ButtonDisabler(this._el);
	}
	,__class__: tbc_ClickG
});
var tbc_TBCHTML = function() { };
tbc_TBCHTML.__name__ = true;
tbc_TBCHTML.click = function(el) {
	return new tbc_ClickG(el);
};
var tbc__$TBCTime_MyTimer = function(timeInMiliSecs,k) {
	var _g = this;
	this.timer = new haxe_Timer(timeInMiliSecs);
	this.timer.run = function() {
		_g.timer.stop();
		k(null);
	};
};
tbc__$TBCTime_MyTimer.__name__ = true;
tbc__$TBCTime_MyTimer.__interfaces__ = [tbc_Disabler];
tbc__$TBCTime_MyTimer.prototype = {
	disable: function() {
		this.timer.stop();
	}
	,__class__: tbc__$TBCTime_MyTimer
};
var tbc_TimeOutGuard = function(timeInMiliSecs) {
	this._timeInMiliSecs = timeInMiliSecs;
};
tbc_TimeOutGuard.__name__ = true;
tbc_TimeOutGuard.__super__ = tbc_GuardA;
tbc_TimeOutGuard.prototype = $extend(tbc_GuardA.prototype,{
	enable: function(k) {
		return new tbc__$TBCTime_MyTimer(this._timeInMiliSecs,k);
	}
	,__class__: tbc_TimeOutGuard
});
var tbc_TBCTime = function() { };
tbc_TBCTime.__name__ = true;
tbc_TBCTime.pause = function(delayInMiliSecs) {
	return tbc_TBC.await(tbc__$TBC_Guard_$Impl_$.andThen(tbc_TBCTime.timeout(delayInMiliSecs),tbc_TBC.skip()));
};
tbc_TBCTime.later = function() {
	return tbc_TBCTime.pause(0);
};
tbc_TBCTime.timeout = function(delayInMiliSecs) {
	return new tbc_TimeOutGuard(delayInMiliSecs);
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
js_Boot.__toStr = {}.toString;
Controller.main();
})(typeof console != "undefined" ? console : {log:function(){}});
