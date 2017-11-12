package tbc;
import tbc.TBC ;
import tbc.TBC.* ;

import haxe.Timer ;

private class MyTimer implements Disabler {
    var timer : Timer ;

    public function new( timeInMiliSecs, k : Triv -> Void ) {
        timer = new Timer( timeInMiliSecs ) ;
        timer.run = function () {
                        timer.stop() ; k(null) ;
                    } ;
    }

    public function disable() : Void {
       timer.stop() ;
    }
}

class TimeOutGuard extends GuardA<Triv> {
    var _timeInMiliSecs : Int ;

    public function new( timeInMiliSecs : Int ) {
        _timeInMiliSecs = timeInMiliSecs ;
    }

    public override function enable( k : Triv -> Void, h : Dynamic -> Void ) : Disabler  {
        return new MyTimer( _timeInMiliSecs,  k ) ;
    }
}

class TBCTime {
    static public function pause( delayInMiliSecs : Int ) 
        : Process<Triv> {
        return await( timeout( delayInMiliSecs ) && skip() ) ; }

    static public function later( ) 
        : Process<Triv> {
        return pause(0) ; }

    static public function timeout( delayInMiliSecs : Int )
        : Guard<Triv> {
        return new TimeOutGuard( delayInMiliSecs ) ;
    }
}

