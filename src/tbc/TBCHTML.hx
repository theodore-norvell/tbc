package tbc;

/** Module TCBHTML */

import tbc.TBC.Guard ; 
import tbc.TBC.GuardA ;
import tbc.TBC.Disabler ;
import js.html.* ;

private class ElementDisabler implements Disabler {
    var _el : Element  ;

    public function new( el : Element ) {
        _el = el ;
    }

    public function disable() : Void {
        _el.onclick  = null ;
        disableElement( ) ;
    }

    function disableElement( ) {
        var el : Dynamic = cast( _el ) ;
        if( el.disabled != null ) el.disabled = true ; }
}

class ClickG extends GuardA<Event> {
    var _el : Element  ;

    public function new( el : Element ) {
        _el = el ; }

    override public function enable( k : Event -> Void ) : Disabler  {
       // In future we would like to be able to have multiple enables
       // at the same time.
        _el.onclick = k ;
        enableElement( ) ;
        return new ElementDisabler( _el ) ;
    }

    function enableElement( ) {
        var el : Dynamic = cast( _el ) ;
        if( el.disabled != null ) el.disabled = false ;
    }
}


class TBCHTML {
    public static function click( el : Element ) : Guard<Event>{
        return new ClickG( el ) ; }
}
