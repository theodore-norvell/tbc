package tbc;

import tbc.TBC.Process ;
import tbc.TBC.Guard ;
import tbc.TBC.GuardA ;
import tbc.TBC.Disabler ;
import tbc.TBC.exec ;

/** This module requires Andy Li's JQuery extern library */
import js.jquery.JQuery ;
import js.jquery.Event ;


private class JQueryDisabler implements Disabler {
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

@:expose
class JQueryG extends GuardA<Event> {
    var _elements : JQuery  ;
    var _eventName : String ;

    public function new( elements : JQuery, eventName : String ) {
        _elements = elements ;
        _eventName = eventName ; }

    override public function enable( k : Event -> Void, h : Dynamic -> Void ) : Disabler  {
        //haxe.Log.trace("enabling:" + _eventName + " on " + _elements);
        _elements.on(_eventName, k) ;
        return new JQueryDisabler( _elements, _eventName, k ) ;
    }
}


@:expose
class TBCJQuery {
    public static function jqEvent( elements : JQuery,
                                    eventName : String )
    : Guard<Event> {
        return new JQueryG( elements, eventName ) ; }

    public static function stopPropagation( ev : Event ) {
        return exec(stopProp(ev)) ; }

    private static function stopProp( ev : Event ) : Void -> Event { return
        function() : Event { ev.stopPropagation() ; return ev ; } }

    public static function preventDefault( ev : Event ) {
        return exec(prevDef(ev)) ; }

    private static function prevDef( ev : Event ) : Void -> Event { return
        function() : Event { ev.preventDefault() ; return ev ; } }
}

