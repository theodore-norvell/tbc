package tbc;

/** Module TCBHTML */

import tbc.TBC.Guard ; 
import tbc.TBC.GuardA ;
import tbc.TBC.Disabler ;
import js.html.* ;
import haxe.Log ;

private class ElementDisabler implements Disabler {
    var _el : EventTarget  ;
    var _removeHandler : Void -> Void ;

    public function new( el : EventTarget, removeHandler : Void -> Void ) {
        _el = el ;
        _removeHandler = removeHandler ;
    }

    public function disable() : Void {
        _removeHandler() ;
        disableElement( ) ;
    }

    function disableElement( ) {
        var el : Dynamic = cast( _el ) ;
        if( el.tbc_event_handler_counter != null ) {
            if( el.tbc_event_handler_counter > 1 )
                --el.tbc_event_handler_counter ;
            else
                el.tbc_event_handler_counter = null ;
        }
            
        if( el.tbc_event_handler_counter == null
         && el.disabled != null )
            el.disabled = true ; }
}

@:expose
class HTMLEventGuardA extends GuardA<Event> {
    var _el : EventTarget  ;

    public function new( el : EventTarget ) {
        _el = el ; }

    override public function enable( k : Event -> Void, h : Dynamic -> Void ) : Disabler  {
        addHandler(k, h) ;
        enableElement( ) ;
        return new ElementDisabler( _el,
            function() { this.removeHandler(k, h) ; } ) ;
    }

    function enableElement( ) {
        var el : Dynamic = cast( _el ) ;
        if( el.tbc_event_handler_counter ==null ) 
            el.tbc_event_handler_counter = 1 ; 
        else
            el.tbc_event_handler_counter++ ;
        if( el.disabled != null ) el.disabled = false ;
    }

    /*abstract*/ function addHandler( k : Event -> Void, h : Dynamic -> Void ) {
        h( "addHandler is not defined in "+this ) ; }

    /*abstract*/ function removeHandler( k : Event -> Void, h : Dynamic -> Void ) {
        h("removeHandler is not defined in "+this ) ; }
}

@:expose
class ClickG extends HTMLEventGuardA {

    public function new( el : Element ) {
        super(el) ;
    }

    override function addHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.addEventListener( "click", k ) ;
    }
    override function removeHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.removeEventListener( "click", k ) ;
    }
}

@:expose
class SubmitG extends HTMLEventGuardA {

    public function new( el : Element ) {
        super(el) ;
    }
    override function addHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.addEventListener( "submit", k ) ;
    }
    override function removeHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.removeEventListener( "submit", k ) ;
    }
}

@:expose
class KeyPressG extends HTMLEventGuardA {

    public function new( el : Element ) {
        super(el) ;
    }
    override function addHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.addEventListener( "keypress", k ) ;
    }
    override function removeHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.removeEventListener( "keypress", k ) ;
    }
}

@:expose
class ChangeG extends HTMLEventGuardA {

    public function new( el : Element ) {
        super(el) ;
    }
    override function addHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.addEventListener( "change", k ) ;
    }
    override function removeHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.removeEventListener( "change", k ) ;
    }
}


@:expose
class TBCHTML {
    public static function click( el : Element ) : Guard<Event>{
        return new ClickG( el ) ; }

    public static function submit( el : Element ) : Guard<Event>{
        return new SubmitG( el ) ; }

    public static function keypress( el : Element ) : Guard<Event>{
        return new KeyPressG( el ) ; }

    public static function change( el : Element ) : Guard<Event>{
        return new ChangeG( el ) ; }
}
