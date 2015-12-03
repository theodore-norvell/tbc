package ;
import haxe.Log ;
import tbc.TBC.Process ;
import tbc.TBC.Triv ;
import tbc.TBC.* ;
import tbc.TBCTime.*;

import js.Browser ;

class Controller {
    static public function main() { 
        var win = Browser.window ;
        var doc = win.document ;
        var body = doc.body ;
        body.onload = Controller.onload ; 
    }

    static function out( val : String ) : Void -> Triv {
        return function( ) : Triv {
            Log.trace( val ) ;
            return null ; } }

    static function useCase() : Process<Triv> { return
        loop(
            par(
                exec(out("x0")) > pause(1000) > exec(out("x1"))
                ,
                exec(out("y0")) > pause(1000) > exec(out("y1"))
            ) >
            pause(1000)
        ) ; }

    static public function onload() {
        Log.trace("Last compiled " + CompileTime.get() );
        Log.trace("Started at " + Date.now() );
        useCase().go( function(x:Triv) : Void { }  ) ;
        Log.trace("going");
    }
}
