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
        var body = Browser.window.document.body ;
        body.onload = Controller.onload ; 
    }

    static function show( el : Element ) : Process<Triv> { return 
        exec( () -> {el.style.visibility = "visible"; null;} ) ; }

    static function hide( el : Element ) : Process<Triv> { return 
        exec( () -> {el.style.visibility = "hidden"; null;} ) ; }

    static function getValue( el : InputElement ) : Process<String> { return 
        exec( () -> el.value ) ; }

    static function clearText( el : InputElement ) : Process<Triv> { return 
        exec( () -> {el.value = ""; null;}  ) ; }

    static function putText( el : Element, str : String ) : Process<Triv> { return 
        exec( () -> {el.textContent = str; null;} ) ; }

    static function mainLoop() : Process<Triv> { return 
            loop  (
                clearText( nameBox ) >
                show( nameBox )  >
                show( question ) >
                getAndDisplayAnswer() >
                hide( question ) >
                hide( nameBox ) >
                pause( 1000 )
            ) ; }

    static function getAndDisplayAnswer() : Process<Triv> { return 
            await( enter( nameBox ) && getValue( nameBox ) ) >= (name:String) ->
            hello(name) ; }

    static public function onload() {
        var win = Browser.window ;
        var doc = win.document ;
        nameBox = cast(doc.getElementById( "nameBox" ), InputElement)  ;
        question = doc.getElementById( "question" ) ;
        reply = doc.getElementById( "reply" ) ;

        Log.trace("Last compiled " + CompileTime.get() );
        Log.trace("Started at " + Date.now() );
        
        mainLoop().run() ;
    }

    static function hello( name : String ) : Process<Triv> { return
        putText( reply, "Hello "+name ) ; }

    static function enter( el : Element ) : Guard<Event> {
        function isEnterKey( ev : Event ) : Bool {
            var kev = cast(ev, KeyboardEvent) ;
            return kev.code == "Enter" ; }
        return keypress( nameBox ) & isEnterKey ;
    }

    static function getAndDisplayAnswer1( ) : Process<Triv> {
        function f( top : Void -> Process<Triv> ) : Process<Triv> { return
            await(
                enter( nameBox ) && getValue( nameBox ) >= hello
            ||
                timeout(5000) && flash(question) > invoke(top)
            ) ;
        }
        return fix( f ) ;
    }

    static final flash = ( el : Element ) ->
        hide(el) > pause(100) > show(el) > pause(100) >
        hide(el) > pause(100) > show(el) ;

}
