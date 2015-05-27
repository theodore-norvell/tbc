package tbc ;

interface ProcessI<A> {
    public function bind<B>( f : A -> Process<B> ) : Process<B> ;

    public function sc<B>( b : Process<B> ) : Process<B> ;

    public function go(  f : A -> Void ) : Void ;
}

abstract Process<A>( ProcessI<A> ) to ProcessI<A> from ProcessI<A> {

    public inline function new(p : ProcessI<A>) {
        this = p;
    }

    @:op( A >= B )
    public inline function bind<B>( f : A -> Process<B> ) : Process<B> {
        return new Process<B>( (this:ProcessI<A>).bind( (f:A ->ProcessI<B>) ) ) ;
    }

    @:op( A > B )
    public inline function sc<B>( q : Process<B> ) : Process<B> {
        return new Process<B>( (this:ProcessI<A>).sc( (q:Process<B>) ) ) ;
    }

    public inline function go( k : A -> Void ) {
        (this:ProcessI<A>).go(k) ; }
}

class ProcessA<A> implements ProcessI<A> {

    public function bind<B>( f : A -> Process<B> ) : Process<B> {
        return new ThenP( this, f ) ;
    }

    public function sc<B>( q : Process<B> ) : Process<B> {
        return new ThenP( this, function(a:A) { return q; } ) ;
    }

    public function go( k : A -> Void ) {
        throw "go is not defined in "+this ; }
}

private class ThenP<A,B> extends ProcessA<B> {
    var _left : Process<A> ;
    var _right : A -> Process<B> ;

    public function new( left : Process<A>, right : A -> Process<B> ) {
       _left = left ; _right = right ; }

    public override function go( f : B -> Void ) { 
        _left.go( function(a:A) _right(a).go( f ) ) ; }
}

class UnitP<A> extends ProcessA<A> {
    var _f : Void -> A ;

    public function new( f : Void -> A ) {
       _f = f ; }

    public override function go( k : A -> Void ) {
        k(_f()); }
}

interface GuardI<E> {
    public function enable( k : E -> Void ) : Void  ;
    public function disable() : Void ; 
    public function guarding<A>( k : E -> Process<A> ) : GuardedProcess<A> ;
    public function andThen<A>( p : Process<A> ) : GuardedProcess<A> ;
    public function asGP( ) : GuardedProcess<Triv> ;
}

abstract Guard<E>( GuardI<E> ) to GuardI<E> from GuardI<E> {

    public inline function new(g : GuardI<E>) {
        this = g;
    }

    public inline function enable( k : E -> Void ) : Void {
        (this:GuardI<E>).enable( k ) ; }

    public inline function disable() : Void {
        (this:GuardI<E>).disable() ; }

    @:op( A >> B )
    public inline function guarding<A>( k : E -> Process<A> )
        : GuardedProcess<A> {
        return (this:GuardI<E>).guarding( k ) ;
    }

    @:op( A && B )
    public function andThen<A>( p : Process<A> ) : GuardedProcess<A> {
        return (this:GuardI<E>).andThen( p ) ;
    }

    public function asGP( ) : GuardedProcess<Triv> {
        return (this:GuardI<E>).asGP( ) ; } 
}

class GuardA<E> implements GuardI<E> {
    public function enable( k : E -> Void ) { 
        throw "Method enable not overridden in " + this ; }

    public function disable() {
        throw "Method disable not overridden in " + this ; }

    public function guarding<A>( k : E -> Process<A> ) : GuardedProcess<A> {
        return new GuardedProcessC<A,E>( this, k ) ; }

    public function andThen<A>( p : Process<A> ) : GuardedProcess<A> {
        return this.guarding( function( ev : E ) { return p ; } ) ; }

    public function asGP<A>( ) : GuardedProcess<Triv> {
        return this.guarding( TBC.toss() ) ; }
}

interface GuardedProcess<A> {

    public function enable( first : Void -> Void, k : A -> Void ) : Void;
        
    public function disable() : Void ;
}

private class  GuardedProcessC<A,E> implements GuardedProcess<A> {
    var _guard : Guard<E> ;
    var _f : E -> Process<A> ;
    public function new( guard: Guard<E>, f : E -> Process<A> ) {
        _guard = guard ; _f = f ; }

    public function enable( first : Void -> Void, k : A -> Void ) {
        _guard.enable(
            function( b : E) {
                first() ; 
                _f(b).go( k ) ; } ) ; }
        
    public function disable() {
        _guard.disable() ; }
} 

class AwaitP<A> extends ProcessA<A> {
    var gps : List<GuardedProcess<A>> ;

    public function new( a : List<GuardedProcess<A>>  ) {
       gps = a ; }

    public override function go( k : A -> Void ) {
        for( gp in gps )
            gp.enable( 
                function( ) { for( gp in gps ) gp.disable() ; },
                k) ; }
}

class Par2P<A,B> extends ProcessA<Pair<A,B>> {
    var _p : Process<A> ;
    var _q : Process<B> ;

    public function new( p : Process<A>, q : Process<B> ) { 
        _p = p ; _q = q ; }

    public override function go( k : Pair<A,B> -> Void ) {
        var result = new Pair<A,B>() ;
        var completed = 0 ;
        _p.go( function( a : A ) : Void {
            result._left = a ;
            completed++ ;
            if( completed == 2 ) k(result) ; } ) ;
        _q.go( function( b : B ) : Void {
            result._right = b ;
            completed++ ;
            if( completed == 2 ) k(result) ; } ) ;
    }
}

enum Triv { } // The only value is null .

class Pair<A,B> {
    public function new( ) { }
    public var _left:A ;
    public var _right:B ; }

class TBC {
    public static function  toss<B>() {
        return function( x : B ) { return unit(null) ; } }

    public static function  skip() {
        return unit(null) ; }

    public static function  unit<A>( a : A ) : Process<A> { 
        return new UnitP<A>( function() { return a ; } ) ; }

    public static function exec<A>( f : Void -> A ) : Process<A> { 
        return new UnitP<A>( f ) ; }

    public static function par<A,B>( p : Process<A>, q : Process<B> )
    : Process<Pair<A,B>> {
        return new Par2P<A,B>( p, q ) ; }

    public static function loop<A>( p : Process<A> ) : Process<Triv> {
        return p.bind( function( a : A ) { return loop(p) ; } ) ; }

    public static function awaitAny<A>( list : List<GuardedProcess<A>> )
    : Process<A> {
        return new AwaitP<A>( list ) ; }

    public static function await<A>(
                                gp0 : GuardedProcess<A>,
                                ?gp1 : GuardedProcess<A>,
                                ?gp2 : GuardedProcess<A>,
                                ?gp3 : GuardedProcess<A>,
                                ?gp4 : GuardedProcess<A>,
                                ?gp5 : GuardedProcess<A> ) : Process<A> {
        var list = new List<GuardedProcess<A>>()  ;
        list.add( gp0 ) ;
        if( gp1 != null ) list.add(gp1) ;
        if( gp2 != null ) list.add(gp2) ;
        if( gp3 != null ) list.add(gp3) ;
        if( gp4 != null ) list.add(gp4) ;
        if( gp5 != null ) list.add(gp5) ;
        return new AwaitP<A>( list ) ; }
}
