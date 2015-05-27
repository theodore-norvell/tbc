import tbc.TBC ;
import tbc.TBCTime ;

class Main {

    static public function main() : Void {
        var u = TBC.unit(42) ;
        var d = TBCTime.pause(2000, 42) ;
        var v = function( z : Int ) : Process<Dynamic> {
            trace( z ) ;
            return TBC.unit(null) ; }
        var w = u.then(v).sc(d).then(v) ;
        trace("hello") ;
        w.go( function( a : Dynamic ) {} ) ;
        trace( "goodbye" ) ; }
}
