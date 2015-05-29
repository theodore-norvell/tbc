package ;
import tbc.TBC.TBC.* ;
import tbc.TBC.Triv ;
import tbc.TBC.Process ;
import tbc.TBCTime.TBCTime.pause ;

class Main {

    static public function main() : Void {
        var u = unit(42) ;
        var d = pause(2000) ;
        var v = function( z : Int ) : Process<Triv> {
            trace( z ) ;
            return unit(null) ; }
        var w = u.bind(v).sc(d).sc(u).bind(v) ;
        trace("hello") ;
        w.go( function( a : Triv) {} ) ;
        trace( "goodbye" ) ; }
}
