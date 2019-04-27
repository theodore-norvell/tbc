package ;

import tbc.TBC.Triv ;
import tbc.TBC.Pair ;
import tbc.TBC.Process ;
import tbc.TBC.* ;
import tbc.TBCTime.*;

class Test extends haxe.unit.TestCase  {
    var _expected : Dynamic ;
    var _actual : Dynamic ;
    public function new( expected : Dynamic, actual : Dynamic ) {
        super() ;
        _expected = expected ;
        _actual = actual ; }

    public function testGo() {
        assertEquals( _expected, _actual ) ;
    }
}

class TestExceptionHandling extends haxe.unit.TestCase  {
    public function testNormal() {
        var p = unit( 42 ) ;
        var result = "String" ;
        p.go( function( forty2: Int ){ result = "normal "+forty2; },
              function( ex : Dynamic ){ result = "abnormal" + ex; } ) ;
        assertEquals( "normal 42", result ) ;
    }

    public function testExec() {
        var p = exec( function(){throw "bam!";} ) ;
        var result = "String" ;
        p.go( function( v: Void ){ result = "normal"; },
              function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal bam!", result ) ;
    }

    public function testToss() {
        var p = toss( "boom!") ;
        var result = "String" ;
        p.go( function( v: Void ){ result = "normal"; },
              function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal boom!", result ) ;
    }

    public function testBind0() {
        var p = toss( "boom!").bind( function(a){return unit(42);}) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal"; },
        function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal boom!", result ) ;
    }

    public function testBind1() {
        var p = unit(42).bind( function(a){return toss("boom!");}) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal"; },
        function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal boom!", result ) ;
    }

    public function testMap0() {
        function square( x : Int ){ return x*x ; } ;
        var p = unit(13).map( square ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal "+v; },
              function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "normal 169", result ) ;
    }

    public function testMap1() {
        function oops( x : Int ){ throw "oops" ; return x*x ; } ;
        var p = unit(13).map( oops ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal"; },
              function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal oops", result ) ;
    }

    public function testMap2() {
        function square( x : Int ) return x*x ;
        var p = toss("oops").map( square ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal"; },
              function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal oops", result ) ;
    }

    public function testMap3() {
        function square( x : Int ) return "hello" ;
        var p = toss("oops").map( square ) ;
        var result = "String" ;
        p.go( function( v: String ){ result = "normal "+v; },
        function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal oops", result ) ;
    }

    public function testPar0() {
        var p0 : Process<Int> = unit(42) ;
        var p1 : Process<Int> = toss( "boom!" ) ;
        var p = par( p0, p1 ) ;
        var result = "String" ;
        p.go( function( v: Pair<Int,Int> ){ result = "normal"; },
              function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal boom!", result ) ;
    }

    public function testPar1() {
        var p0 : Process<Int> = unit(42) ;
        var p1 : Process<Int> = toss( "boom!" ) ;
        var p = par( p1, p0 ) ;
        var result = "String" ;
        p.go( function( v: Pair<Int,Int> ){ result = "normal"; },
              function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal boom!", result ) ;
    }

    public function testAttempt0() {
        var rec = function( ex : Dynamic ) { return unit(13) ; }
        var p =  attempt( toss("boom!").sc( unit(42) ), rec ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal "+v; },
        function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "normal 13", result ) ;
    }

    public function testAttempt1() {
        var rec = function( ex : Dynamic ) { return unit(13) ; }
        var p =  attempt( toss("boom!"), rec ).sc( unit(42) ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal "+v; },
              function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "normal 42", result ) ;
    }

    public function testAttempt2() {
        var rec = function( ex : Dynamic ) { return unit(13) ; }
        var p =  attempt( unit(7), rec ).sc( toss("boom!") ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal "+v; },
              function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal boom!", result ) ;
    }

    public function testRetoss() {
        var rec : Dynamic -> Process<Int>
            = function( ex : Dynamic ) { return toss("" + ex + " zap" ) ; }
        var p : Process<Int> =  attempt( toss("zip"), rec ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal "+v; },
              function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal zip zap", result ) ;
    }

    public function testUltimatelySS() {
        var buffer = "" ;
        var setup = function() : Int { buffer = buffer + "setup" ; return 10 ;}
        var teardown = function() { buffer = buffer + " teardown" ; return null ; }
        var p : Process<Int> =  ultimately( exec(setup), exec(teardown) ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal "+v; },
        function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "normal 10", result ) ;
        assertEquals( "setup teardown", buffer ) ;
    }

    public function testUltimatelySF() {
        var buffer = "" ;
        var setup = function() :Int { buffer = buffer + "setup" ; return 10 ;}
        var teardown = function() { buffer = buffer + " teardown" ; return null ; }
        var q : Process<Triv> = exec(teardown) > toss(5) ;
        var p : Process<Int> =  ultimately( exec(setup), q ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal "+v; },
        function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal 5", result ) ;
        assertEquals( "setup teardown", buffer ) ;
    }

    public function testUltimatelyFS() {
        var buffer = "" ;
        var setup = function() :Int { buffer = buffer + "setup" ; return 10 ;}
        var teardown = function() { buffer = buffer + " teardown" ; return null ; }
        var q : Process<Triv> = exec(teardown) ;
        var p : Process<Int> =  ultimately( exec(setup) > toss(9), q ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal "+v; },
        function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal 9", result ) ;
        assertEquals( "setup teardown", buffer ) ;
    }

    public function testUltimatelyFF() {
        var buffer = "" ;
        var setup = function() :Int { buffer = buffer + "setup" ; return 10 ;}
        var teardown = function() { buffer = buffer + " teardown" ; return null ; }
        var q : Process<Triv> = exec(teardown) > toss(5) ;
        var p : Process<Int> =  ultimately( exec(setup) > toss(9), q ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal "+v; },
        function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal { _right => 5, _left => 9 }", result ) ;
        assertEquals( "setup teardown", buffer ) ;
    }

    public function testAttemptSNS() {
        var buffer = "" ;
        var setup = function() :Int { buffer = buffer + "setup" ; return 10 ;}
        var teardown = function() { buffer = buffer + " teardown" ; return null ; }
        var q : Process<Triv> = exec(teardown) ;
        var f = function(ex : Dynamic) : Process<Int> { return unit( 7 ) ; }
        var p : Process<Int> =  attempt( exec(setup), f, q ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal "+v; },
        function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "normal 10", result ) ;
        assertEquals( "setup teardown", buffer ) ;
    }

    public function testAttemptSNF() {
        var buffer = "" ;
        var setup = function() :Int { buffer = buffer + "setup" ; return 10 ;}
        var teardown = function() { buffer = buffer + " teardown" ; return null ; }
        var q : Process<Triv> = exec(teardown) > toss(5);
        var f = function(ex : Dynamic) : Process<Int> { return unit( 7 ) ; }
        var p : Process<Int> =  attempt( exec(setup), f, q ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal "+v; },
        function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal 5", result ) ;
        assertEquals( "setup teardown", buffer ) ;
    }

    public function testAttemptFSS() {
        var buffer = "" ;
        var setup = function() :Int { buffer = buffer + "setup" ; return 10 ;}
        var teardown = function() { buffer = buffer + " teardown" ; return null ; }
        var q : Process<Triv> = exec(teardown) ;
        var f = function(ex : Dynamic) : Process<Int> { return unit( 7 ) ; }
        var p : Process<Int> =  attempt( exec(setup) > toss(9), f, q ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal "+v; },
        function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "normal 7", result ) ;
        assertEquals( "setup teardown", buffer ) ;
    }

    public function testAttemptFSF() {
        var buffer = "" ;
        var setup = function() :Int { buffer = buffer + "setup" ; return 10 ;}
        var teardown = function() { buffer = buffer + " teardown" ; return null ; }
        var q : Process<Triv> = exec(teardown) > toss(5) ;
        var f = function(ex : Dynamic) : Process<Int> { return unit( 7 ) ; }
        var p : Process<Int> =  attempt( exec(setup) > toss(9), f, q ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal "+v; },
        function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal 5", result ) ;
        assertEquals( "setup teardown", buffer ) ;
    }

    public function testAttemptFFS() {
        var buffer = "" ;
        var setup = function() :Int { buffer = buffer + "setup" ; return 10 ;}
        var teardown = function() { buffer = buffer + " teardown" ; return null ; }
        var q : Process<Triv> = exec(teardown) ;
        var f = function(ex : Dynamic) : Process<Int> { return toss( 7 ) ; }
        var p : Process<Int> =  attempt( exec(setup) > toss(9), f, q ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal "+v; },
        function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal 7", result ) ;
        assertEquals( "setup teardown", buffer ) ;
    }

    public function testAttemptFFF() {
        var buffer = "" ;
        var setup = function() :Int { buffer = buffer + "setup" ; return 10 ;}
        var teardown = function() { buffer = buffer + " teardown" ; return null ; }
        var q : Process<Triv> = exec(teardown) > toss(5) ;
        var f = function(ex : Dynamic) : Process<Int> { return toss( 7 ) ; }
        var p : Process<Int> =  attempt( exec(setup) > toss(9), f, q ) ;
        var result = "String" ;
        p.go( function( v: Int ){ result = "normal "+v; },
        function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "abnormal { _right => 5, _left => 7 }", result ) ;
        assertEquals( "setup teardown", buffer ) ;
    }

    public function testTimer0() {
        // This is a bit ugly.  This method
        // should return, but before doing so,
        // it should schedule a testrunner to be
        // run in the future.
        var p = pause(10) > toss("oops") ;
        p.go( function( v: Int ){
                  var r = new haxe.unit.TestRunner();
                  r.add(new Test( "Yikes", ""));
                  r.run() ; },
              function( ex : Dynamic ){
                  var r = new haxe.unit.TestRunner();
                  r.add(new Test("oops", ex));
                  r.run() ; } ) ;
        assertEquals( 4, 2+2 ) ;
    }

    public function testTimer1() {
        // This is a bit ugly.  This method
        // should return, but before doing so,
        // it should schedule a testrunner to be
        // run in the future.
        var p = pause(10) > unit(53) ;
        p.go( function( v: Int ){
            var r = new haxe.unit.TestRunner();
            r.add(new Test( 53, v ) );
            r.run() ; },
        function( ex : Dynamic ) {
            var r = new haxe.unit.TestRunner();
            r.add(new Test("oops", ex));
            r.run() ; } ) ;
        assertEquals( 4, 2+2 ) ;
    }
}
