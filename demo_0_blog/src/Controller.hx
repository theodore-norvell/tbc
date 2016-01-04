package ;
import haxe.Log ;
import Date ;
import tbc.TBC.Process ; 
import tbc.TBC.Triv ;
import tbc.TBC.* ;
import tbc.TBCHTML.*;
import tbc.TBCTime.pause ;

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

    static function out(str : String) { return
        exec( function() {
            outbox.innerHTML = str ; return null ;
        }) ;
    }

    static function useCase() : Process<Triv> { return
        loop(
            await( click( b0 ) && out("0")  ) >
            await(
                click( b1a ) && out("1A")
            ,
                click( b1b ) && out("1B")
            ) >
            await( click( b2 ) && out("2") )
        ) ; }

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
        useCase().go( function(x:Triv) : Void { }  ) ;
        Log.trace("going");
    }
}
