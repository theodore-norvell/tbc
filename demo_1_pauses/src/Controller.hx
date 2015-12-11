package ;
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
import js.html.Element ;

class Controller {
    static public function main() { 
        var win = Browser.window ;
        var doc = win.document ;
        var body = doc.body ;
        body.onload = Controller.onload ; 
    }
    static var b0 : Element ;
    static var b1a : Element ;
    static var b1b : Element ;
    static var b2 : Element ;

    static function out0( ev : Event ) { Log.trace( "0" ) ; return skip() ;}
    static function out1A( ev : Event ) { Log.trace( "1A" ) ; return skip() ;}
    static function out1B( ev : Event ) { Log.trace( "1B" ) ; return skip() ;}
    static function out2( ev : Event ) { Log.trace( "2" ) ; return skip() ;}
    static function tooLate( triv : Triv ) { Log.trace( "too slow" ) ; return skip() ;}
    static function nagTheUser(  ) : Triv {
        Log.trace( "Hurry up" ) ; return null ; }
    static function thankTheUser(  ) : Triv {
        Log.trace( "Thankyou" ) ; return null ; }

    static function useCase() : Process<Triv> { return
        loop(
            nag( ) >
            await(
                click( b1a ) >> out1A
            ||
                click( b1b ) >> out1B
            ||
                timeout( 2000 ) >> tooLate
            ) >
            pause(1000) >
            await( click( b2 ) >> out2 ) 
        ) ; }

    static function nag() : Process<Triv>{
        function f(repeat : Void -> Process<Triv>) : Process<Triv> { return
            await(
                click(b0) && exec(thankTheUser)
            ||
                timeout( 1000 ) && exec(nagTheUser) > invoke(repeat)
            ) ; }
        return fix( f ) ;
    }

    static public function onload() {
        var win = Browser.window ;
        var doc = win.document ;
        b0 = doc.getElementById( "button:zero" ) ;
        //b0 = doc.getElementById( "body" ) ;
        b1a = doc.getElementById( "button:oneA" ) ;
        b1b = doc.getElementById( "button:oneB" ) ;
        b2 = doc.getElementById( "button:two" ) ;
        Log.trace("Last compiled " + CompileTime.get() );
        Log.trace("Started at " + Date.now() );
        useCase().go( function(x:Triv) : Void { }  ) ;
        Log.trace("going");
    }
}
