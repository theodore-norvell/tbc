package ;

import tbc.TBCSeq.* ;

import tbc.TBC.Process ;
import tbc.TBC.* ;

class TestSeqMacro extends haxe.unit.TestCase  {
    function testSeqMacro0() {
        var p : Process<Int> 
        = seq(
            (var y : Int = unit(4)),
            (final x = unit(3)),
            unit(x+y)
        ) ;
        var result : String ;
        p.go( function( i: Int ){
                result = if( i==7 ) "7" else result = "huh" ; },
              function( ex : Dynamic ){ result = "abnormal " + ex; } ) ;
        assertEquals( "7", result ) ;
    }
}
