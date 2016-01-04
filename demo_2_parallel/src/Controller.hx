package ;
import haxe.Log ;
import tbc.TBC.Process ;
import tbc.TBC.Triv ;
import tbc.TBC.* ;
import tbc.TBCTime.*;

import js.Browser ;
import js.html.Element ;

class Controller {
    static public function main() { 
        var win = Browser.window ;
        var doc = win.document ;
        var body = doc.body ;
        body.onload = Controller.onload ; 
    }

    static var outbox : Element ;
    static var outStr : String = "" ;

    static function out(str : String) { return
        exec( function() {
            var maxLen = 40 ;
            outStr = outStr + " " + str ;
            var len = outStr.length ;
            if( len > maxLen ) outStr = outStr.substr( len-maxLen ) ;
            outbox.innerHTML = outStr ; return null ;
        }) ;
    }

    static function useCase() : Process<Triv> { return
        loop(
            par(
                out("x0") > pause(1000) > out("x1")
            ,
                out("y0") > pause(1000) > out("y1")
            ) >
            pause(1000)
        ) ; }

    static public function onload() {
        var win = Browser.window ;
        var doc = win.document ;
        outbox = doc.getElementById("outbox") ;
        Log.trace("Last compiled " + CompileTime.get() );
        Log.trace("Started at " + Date.now() );
        useCase().go( function(x:Triv) : Void { }  ) ;
        Log.trace("going");
    }
}
