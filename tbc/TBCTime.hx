package tbc ;
import tbc.TBC ;

import haxe.Timer ;

private class PauseP extends TBC.ProcessA<Triv> {
    var _delay : Int ;

    public function new( delay : Int ) {
       _delay = delay ; }

    public override function go( f : Triv -> Void ) { 
        // The next line creates a timer object and
        // throws it away. The timer will run once after
        // the specified delay.
        Timer.delay( function() { f( null ) ; }, _delay ) ; }

}

class TBCTime {
    static public function pause( delayInMiliSecs : Int ) 
        : Process<Triv> {
        return new PauseP( delayInMiliSecs ) ; }
    static public function later( ) 
        : Process<Triv> {
        return new PauseP( 0 ) ; }
}
