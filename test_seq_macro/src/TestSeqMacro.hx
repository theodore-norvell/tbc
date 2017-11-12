package ;

import tbc.TBCSeq.* ;
import tbc.TBC.* ;

class TestSeqMacro {
    static public function main() {
        var x = seq(
            (var y : Int = unit(4)),
            (var x = unit(3)),
            unit(x+y)
        ) ;
    }
}
