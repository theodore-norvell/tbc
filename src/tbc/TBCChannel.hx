package tbc;

import tbc.TBC.Guard ;
import tbc.TBC.GuardA ;
import tbc.TBC.Disabler ;

class TBCChannel<A> {
    var contents : Array<A> ;
    var start : Int;
    var len : Int  ;
    public function new(size : Int) {
        contents = new Array<A>() ;
        start = 0 ;
        len = 0 ;
    }

    public function in() : ChannelInGuard<A> {
        return new ChannelInGuard<A>(this) ;
    }

    public function out( a : A) : ChannelOutGuard<A> {
        return new ChannelOutGuard<A>(this, a) ;
    }
}

class ChannelInGuard<A>
