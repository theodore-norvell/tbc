package tbc;

import tbc.TBC.Guard ;
import tbc.TBC.GuardA ;
import tbc.TBC.Disabler ;

/** This module requires Andy Li's JQuery extern library */
import jQuery.JQuery ;
import jQuery.Event ;


private class JQueryDisabler<Event> implements Disabler {
    var _elements : JQuery  ;
    var _eventName : String ;
    var _handler : Event -> Void ;

    public function new( elements : JQuery,
                         eventName : String,
                         handler : Event -> Void ) {
        _elements = elements ;
        _eventName = eventName ;
        _handler = handler ;
    }

    public function disable() : Void {
        _elements.off( _eventName, null , _handler) ;
    }
}

class JQueryG extends GuardA<Event> {
    var _elements : JQuery  ;
    var _eventName : String ;

    public function new( elements : JQuery, eventName : String ) {
        _elements = elements ;
        _eventName = eventName ; }

    override public function enable( k : Event -> Void ) : Disabler  {
        //haxe.Log.trace("enabling:" + _eventName + " on " + _elements);
        _elements.on(_eventName, k) ;
        return new JQueryDisabler( _elements, _eventName, k ) ;
    }
}


class TBCJQuery {
    public static function jqEvent( elements : JQuery,
                                    eventName : String )
    : Guard<Event> {
        return new JQueryG( elements, eventName ) ; }
}

