package tbc;

/** Module TCBHTML */

import tbc.TBC.* ; 
import tbc.TBC.Guard ; 
import tbc.TBC.GuardA ; 
import js.html.* ;

class ClickG extends GuardA<Event> {
    var _el : ButtonElement  ;

    public function new( el : ButtonElement ) {
        _el = el ; }

    override public function enable( k : Event -> Void ) : Void  {
       // In future we would like to be able to have multiple enables
       // at the same time.
        _el.onclick = k ;
        _el.disabled = false ;
    }

    override public function disable() : Void {
       _el.onclick  = null ; 
       _el.disabled = true ;
    }
}


class TBCHTML {
    public static function click( el : ButtonElement ) : Guard<Event>{
        return new ClickG( el ) ; }
}
