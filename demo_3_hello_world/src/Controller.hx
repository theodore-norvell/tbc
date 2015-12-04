package ;
import js.html.KeyboardEvent;
import haxe.Log ;
import tbc.TBC.Process ;
import tbc.TBC.Guard ;
import tbc.TBC.Triv ;
import tbc.TBC.Pair ;
import tbc.TBC.* ;
import tbc.TBCTime.*;
import tbc.TBCHTML.*;

import js.Browser ;
import js.html.Event ;
import js.html.Element ;
import js.html.InputElement ;

class Controller {


    static var nameBox : InputElement ;
    static var question : Element ;
    static var reply : Element ;

    static public function main() { 
        var win = Browser.window ;
        var doc = win.document ;
        var body = doc.body ;
        body.onload = Controller.onload ; 
    }

    static function show( el : Element ) : Process<Triv> { return
        exec( function() : Triv {
                el.style.visibility = "visible" ; return null ; } ) ;
    }

    static function hide( el : Element ) : Process<Triv> { return
        exec( function()  : Triv {
                el.style.visibility = "hidden";  return null ; } ) ;
    }

    static function getValue( el : InputElement ) : Process<String> { return
        exec( function()  : String {
            return el.value ; } ) ;
    }

    static function clearText( el : InputElement ) : Process<Triv> { return
        exec( function()  : Triv {
            el.value = "" ; return null ; } ) ;
    }

    static function putText( el : Element, str : String  ) : Process<Triv> { return
        exec( function()  : Triv {
            el.textContent = str ; return null ; } ) ;
    }

    static public function onload() {
        var win = Browser.window ;
        var doc = win.document ;
        nameBox = cast(doc.getElementById( "nameBox" ), InputElement)  ;
        question = doc.getElementById( "question" ) ;
        reply = doc.getElementById( "reply" ) ;

        Log.trace("Last compiled " + CompileTime.get() );
        Log.trace("Started at " + Date.now() );
        var p =
            loop  (
                putText( reply, "" ) >
                clearText( nameBox ) >
                show( nameBox )  >
                show( question ) >
                getAndDisplayAnswer(null) >
                hide( question ) >
                hide( nameBox ) >
                pause( 1000 )
            ) ;
        p.go( function(x:Triv) {} ) ; // Execute p
    }

    static function getAndDisplayAnswer( x : Triv ) : Process<Triv>{
        return
            // Simple non nagging version
            await( enter( nameBox ) && getValue( nameBox ) ) >=
            function( name : String ) : Process<Triv>{ return
                putText( reply, "Hello "+name ) ; } ;
    }

    static function enter( el : Element ) : Guard<Event> {
        function isEnterKey( ev : Event ) : Bool {
            var kev = cast(ev, KeyboardEvent) ;
            return kev.keyCode == 13 || kev.which == 13 ; }
        return keypress( nameBox ) & isEnterKey ;
    }
}
