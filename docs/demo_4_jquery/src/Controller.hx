package ;

import haxe.Log ;
import tbc.TBC.Process ;
import tbc.TBC.Guard ;
import tbc.TBC.Triv ;
import tbc.TBC.Pair ;
import tbc.TBC.* ;
import tbc.TBCTime.*;
import tbc.TBCJQuery.*;

import js.Browser ;
import js.html.KeyboardEvent ;

/** This module requires Andy Li's JQuery extern library */
import js.jquery.JQuery ;
import js.jquery.Event ;


class Controller {

    static public function main() { 
        var win = Browser.window ;
        var doc = win.document ;
        var body = doc.body ;
        body.onload = Controller.onload ;

    }

    static private var w = 100.0 ;
    static private var square : JQuery ;

    static public function onload() {
        var win = Browser.window ;
        var doc = win.document ;

        Log.trace("Last compiled " + CompileTime.get() );
        Log.trace("Started at " + Date.now() );

        square = new JQuery("#square") ;
        square.css("display", "block") ;
        square.css("background-color", "red") ;
        square.css("width", w) ;
        square.css("height", w) ;

        var body = new JQuery("body") ;
        var p =
            loop  (
                await(
                    upKey(body) >= preventDefault > exec( bigger )
                ,
                    downKey(body) >= preventDefault > exec( smaller )
                )
            ) ;
        // Execute p
        p.go( function(x:Triv) {},
              function( ex : Dynamic ) trace( "Exception " + ex ) ) ;
    }

    static function whichIs( k : Int ) {
        return function( ev : Event ) : Bool {
            var kev : Dynamic = cast ev ;
            return kev.which == k ; } }

    static function upKey( els : JQuery ) : Guard<Event> {
        return jqEvent( els, "keydown" ) & whichIs(38) ;
    }

    static function downKey( els : JQuery ) : Guard<Event> {
        return jqEvent( els, "keydown" ) & whichIs(40) ;
    }

    static function bigger( ) {
        w *= 1.2 ;
        square.css("width", w) ;
        square.css("height", w) ;
        return null ;
    }

    static function smaller( ) {
        w /= 1.2 ;
        square.css("width", w) ;
        square.css("height", w) ;
        return null ;
    }
}
