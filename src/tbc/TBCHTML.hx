package tbc;

/** Module TCBHTML */

import tbc.TBC.Guard ; 
import tbc.TBC.GuardA ;
import tbc.TBC.Disabler ;
import js.html.* ;
import haxe.Log ;

private class ElementDisabler implements Disabler {
    var _el : Element  ;
    var _removeHandler : Void -> Void ;

    public function new( el : Element, removeHandler : Void -> Void ) {
        _el = el ;
        _removeHandler = removeHandler ;
    }

    public function disable() : Void {
        _removeHandler() ;
        disableElement( ) ;
    }

    function disableElement( ) {
        var el : Dynamic = cast( _el ) ;
        if( el.disabled != null ) el.disabled = true ; }
}



class HTMLEventGuardA extends GuardA<Event> {
    var _el : Element  ;

    public function new( el : Element ) {
        _el = el ; }

    override public function enable( k : Event -> Void, h : Dynamic -> Void ) : Disabler  {
// In future we would like to be able to have multiple enables
// at the same time.
        addHandler(k, h) ;
        enableElement( ) ;
        return new ElementDisabler( _el,
            function() { this.removeHandler(k, h) ; } ) ;
    }

    function enableElement( ) {
        var el : Dynamic = cast( _el ) ;
        if( el.disabled != null ) el.disabled = false ;
    }

    /*abstract*/ function addHandler( k : Event -> Void, h : Dynamic -> Void ) {
        h( "addHandler is not defined in "+this ) ; }

    /*abstract*/ function removeHandler( k : Event -> Void, h : Dynamic -> Void ) {
        h("removeHandler is not defined in "+this ) ; }
}

class ClickG extends HTMLEventGuardA {

    public function new( el : Element ) {
        super(el) ;
    }
    override function addHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.onclick = k ;
    }
    override function removeHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.onclick  = null ;
    }
}

class SubmitG extends HTMLEventGuardA {

    public function new( el : Element ) {
        super(el) ;
    }
    override function addHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.onsubmit = k ;
    }
    override function removeHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.onsubmit  = null ;
    }
}

class KeyPressG extends HTMLEventGuardA {

    public function new( el : Element ) {
        super(el) ;
    }
    override function addHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.onkeypress = k ;
    }
    override function removeHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.onkeypress  = null ;
    }
}

class ChangeG extends HTMLEventGuardA {

    public function new( el : Element ) {
        super(el) ;
    }
    override function addHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.onchange = k ;
    }
    override function removeHandler( k : Event -> Void, h : Dynamic -> Void ) {
        _el.onchange  = null ;
    }
}


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
