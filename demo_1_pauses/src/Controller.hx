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

    static var outbox : Element ;
    static var b0 : Element ;
    static var b1a : Element ;
    static var b1b : Element ;
    static var b2 : Element ;

    static function out(str : String) : Process<Triv> { return
        exec( () -> { outbox.innerHTML = str ; null ; }) ;
    }
    static function nagTheUser(  ) {
        return out( "hurry up" ) > pause(500) > out("") ; }

    static function useCase() : Process<Triv> { return
        loop(
            nag( ) >
            await(
                click( b1a ) && out("1A")
            ||
                click( b1b ) && out("1B")
            ||
                timeout( 2000 ) && out( "too slow" )
            ) >
            pause(1000) >
            await( click( b2 ) && out("2") )
        ) ; }

    static function nag() : Process<Triv>{
        function f(repeat : Void -> Process<Triv>) : Process<Triv> { return
            await(
                click(b0) && out("0")
            ||
                timeout( 1500 ) && nagTheUser() > invoke(repeat)
            ) ; }
        return fix( f ) ;
    }

    static public function onload() {
        var win = Browser.window ;
        var doc = win.document ;
        outbox = doc.getElementById("outbox") ;
        b0 = doc.getElementById( "button:zero" ) ;
        b1a = doc.getElementById( "button:oneA" ) ;
        b1b = doc.getElementById( "button:oneB" ) ;
        b2 = doc.getElementById( "button:two" ) ;
        Log.trace("Last compiled " + CompileTime.get() );
        Log.trace("Started at " + Date.now() );
        useCase().go( function(x:Triv) : Void { },
                      function( ex : Dynamic ) trace( "Exception " + ex )  ) ;
        Log.trace("going");
    }
}
