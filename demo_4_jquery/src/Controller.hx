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
import jQuery.JQuery ;
import jQuery.Event ;


class Controller {

    static public function main() { 
        var win = Browser.window ;
        var doc = win.document ;
        var body = doc.body ;
        body.onload = Controller.onload ; 
    }

    static public function onload() {
        var win = Browser.window ;
        var doc = win.document ;

        Log.trace("Last compiled " + CompileTime.get() );
        Log.trace("Started at " + Date.now() );
        var body = new JQuery("body") ;
        var p =
            loop  (
                await(
                    upKey(body) && up()
                ,
                    downKey(body) && down()
                )
            ) ;
        p.go( function(x:Triv) {} ) ; // Execute p
    }

    static function upKey( els : JQuery ) : Guard<Event> {
        function isUpKey( ev : Event ) : Bool {
            var kev = cast(ev, KeyboardEvent) ;
            return kev.keyCode == 38 ; }
        return jqEvent( els, "keydown" ) & isUpKey ;
    }

    static function downKey( els : JQuery ) : Guard<Event> {
        function isDownKey( ev : Event ) : Bool {
            var kev = cast(ev, KeyboardEvent) ;
            return kev.keyCode == 40 ; }
        return jqEvent( els, "keydown" ) & isDownKey ;
    }

    static function up( ) : Process<Triv> {
        return exec( function() {Log.trace("up"); return null ; } ) ;
    }

    static function down( ) : Process<Triv> {
        return exec( function() {Log.trace("down"); return null ; } ) ;
    }
}
