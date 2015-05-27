import haxe.Log ;
import tbc.TBC.Process ; 
import tbc.TBC.GuardedProcess ; 
import tbc.TBC.Triv ; 
import tbc.TBC.Pair ; 
import tbc.TBC.* ; 
import tbc.TBCTime.*;
import tbc.TBCHTML.*;

import js.Browser ;
import js.html.Event ;
import js.html.ButtonElement ;

class Controller {
    static public function main() { 
        var win = Browser.window ;
        var doc = win.document ;
        var body = doc.body ;
        body.onload = Controller.onload ; 
    }
    static var b0 : ButtonElement ;
    static var b1a : ButtonElement ;
    static var b1b : ButtonElement ;
    static var b2 : ButtonElement ;

    static function f( ) : Void { Log.trace( "X" ) ; }
    static function outX( ) { Log.trace( "XX" ) ; return null ; }
    static function outY( ) { Log.trace( "Y" ) ; return null ; }
    static function out0( ev : Event ) { Log.trace( "0" ) ; return skip() ;}
    static function out1A( ev : Event ) { Log.trace( "1A" ) ; return skip() ;}
    static function out1B( ev : Event ) { Log.trace( "1B" ) ; return skip() ;}
    static function out2( ev : Event ) { Log.trace( "2" ) ; return skip() ;}

    static function tryEx() : Process<Void> { return exec(f) ; }
    static function tryPar() : Process<Pair<Triv,Triv>> { return
        par(
            exec(outX) > pause(2000) > exec(outX)
        ,
            exec(outY) >= function(a) { return pause(1999); }
                       >= function(a) { return exec(outY) ; }
        ) ; }
    static function tryOverloading() : Process<Triv> { return
        exec(outX) > pause(2000) > exec(outX) ; }

    static function useCase() : Process<Triv> { return
        loop(
            await( click( b0 ) >> out0  ) >
            await(
                click( b1a ) >> out1A
            ,
                click( b1b ) >> out1B
            ) >
            pause(1000) >
            await( click( b2 ) >> out2 ) 
        ) ; }

    static public function onload() {
        var win = Browser.window ;
        var doc = win.document ;
        b0 = cast(doc.getElementById( "button:zero" ), ButtonElement) ;
        b1a = cast(doc.getElementById( "button:oneA" ), ButtonElement)  ;
        b1b = cast(doc.getElementById( "button:oneB" ), ButtonElement)  ;
        b2 = cast(doc.getElementById( "button:two" ), ButtonElement)  ;
        Log.trace("hello");
        tryPar().sc(useCase()).go( function(x:Triv) :Int { return 42 ; }  ) ;
    }
}
