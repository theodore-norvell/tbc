package tbc;

import tbc.TBC.Guard ;
import tbc.TBC.GuardA ;
import tbc.TBC.Disabler ;

class TBCChannel<E> {
    var contents : Array<E> ;
    var size : Int ;
    var start : Int;
    var len : Int  ;

    public function new(size : Int) {
        contents = new Array<E>(size) ;
        this.size = size ;
        start = 0 ;
        len = 0 ;
    }

    public function in() : ChannelInGuard<E> {
        return new ChannelInGuard<E>(this) ;
    }

    public function out( a : E) : ChannelOutGuard<A> {
        return new ChannelOutGuard<E>(this, a) ;
    }


}

class ChannelInGuard<E> extends GuardA<E> {
    var chan : TBCChannel<E> ;

    public function new( chan : TBCChannel<E> ) {
        this.chan = chan ;
    }

    override public function enable( k : E -> Void, h : Dynamic -> Void ) : Disabler {
        // TODO
    }
    override public function guarding<A>( k : E -> Process<A> ) : GuardedProcess<A> {
        return new GuardedProcessC( this, k) ;
    }
}


class ChannelOutGuard<E> extends GuardA< Triv > {
    var chan : TBCChannel<E> ;
    var value : E ;

    public function new( chan : TBCChannel<E>, a : E ) {
        this.chan = chan ;
        this.value = a ;
    }

    override public function enable( k : Triv -> Void, h : Dynamic -> Void ) : Disabler {
        // TODO
    }
    override public function guarding<A>( k : E -> Process<A> ) : GuardedProcess<A> {
        return new GuardedProcessC( this, k) ;
    }
}
