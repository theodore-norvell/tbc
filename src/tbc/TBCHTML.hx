package tbc;

/** Module TCBHTML */

import tbc.TBC.Guard ; 
import tbc.TBC.GuardA ;
import tbc.TBC.Disabler ;
import js.html.* ;

private class ButtonDisabler implements Disabler {
    var _el : ButtonElement  ;

    public function new( el : ButtonElement ) {
        _el = el ;
    }

    public function disable() : Void {
        _el.onclick  = null ;
        _el.disabled = true ;
    }
}

class ClickG extends GuardA<Event> {
    var _el : ButtonElement  ;

    public function new( el : ButtonElement ) {
        _el = el ; }

    override public function enable( k : Event -> Void ) : Disabler  {
       // In future we would like to be able to have multiple enables
       // at the same time.
        _el.onclick = k ;
        _el.disabled = false ;
        return new ButtonDisabler( _el ) ;
    }
}


class TBCHTML {
    public static function click( el : ButtonElement ) : Guard<Event>{
        return new ClickG( el ) ; }
}
