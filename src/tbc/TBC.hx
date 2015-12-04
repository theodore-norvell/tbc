package tbc;

/** An interface representing processes computing values of type A */
interface ProcessI<A> {

    /** Returns a process that executes by
    * first executing this process to get a values x:A
    * and then executing f(x).
    **/
    public function bind<B>( f : A -> Process<B> ) : Process<B> ;

    /** Returns a process that executes by
    * first executing this process and
     * then executing b.
    **/
    public function sc<B>( b : Process<B> ) : Process<B> ;

    /** Run or execute the process. */
    public function go(  f : A -> Void ) : Void ;
}

/** A type representing processes computing values of type A.
*   This abstract type adds operators > and >= to interface ProcessI<A>.
**/
abstract Process<A>( ProcessI<A> ) to ProcessI<A> from ProcessI<A> {

    public inline function new(p : ProcessI<A>) {
        this = p;
    }

    /** See ProcessI.bind */
    @:op( A >= B )
    public inline function bind<B>( f : A -> Process<B> ) : Process<B> {
        return new Process<B>( (this:ProcessI<A>).bind( (f:A ->ProcessI<B>) ) ) ;
    }

    /** See ProcessI.sc */
    @:op( A > B )
    public inline function sc<B>( q : Process<B> ) : Process<B> {
        return new Process<B>( (this:ProcessI<A>).sc( (q:Process<B>) ) ) ;
    }

    /** See ProcessI.go */
    public inline function go( k : A -> Void ) {
        (this:ProcessI<A>).go(k) ; }
}

/** An "abstract class" for processes.
*    Defines .bind and .sc. Leaves .go "abstract".
*    New Process types will generally extend this class
*    while overriding the .go method.
**/
class ProcessA<A> implements ProcessI<A> {

    /** See ProcessI.bind */
    public function bind<B>( f : A -> Process<B> ) : Process<B> {
        return new ThenP( this, f ) ;
    }

    /** See ProcessI.sc */
    public function sc<B>( q : Process<B> ) : Process<B> {
        return new ThenP( this, function(a:A) { return q; } ) ;
    }

    /** See ProcessI.go */
    public function go( k : A -> Void ) {
        throw "go is not defined in "+this ; }
}

/** A process that executes two processes sequentially. */
private class ThenP<A,B> extends ProcessA<B> {
    var _left : Process<A> ;
    var _right : A -> Process<B> ;

    public function new( left : Process<A>, right : A -> Process<B> ) {
       _left = left ; _right = right ; }

    public override function go( f : B -> Void ) {
        _left.go( function(a:A) _right(a).go( f ) ) ; }
}

/** A process that calls a function. */
private class ExecP<A> extends ProcessA<A> {
    var _f : Void -> A ;

    public function new( f : Void -> A ) {
       _f = f ; }

    public override function go( k : A -> Void ) {
        k(_f()); }
}

/** Guards return a Disabler when enabled.
*    The Disabler is used to disable the guard.
**/
interface Disabler {
    public function disable() : Void ;
}

/** An interface for Guards.
*
**/
interface GuardI<E> {
    /** Enable the guard.
    * When fired, the guard will execute k. **/
    public function enable( k : E -> Void ) : Disabler  ;
    /** Create a guarded process. **/
    public function guarding<A>( k : E -> Process<A> ) : GuardedProcess<A> ;
    /** Create a guarded process. **/
    public function andThen<A>( p : Process<A> ) : GuardedProcess<A> ;
    /** Create a guard that is conditional on some condition. */
    public function filter( c : E -> Bool ) : GuardI<E> ;
}

/** An abstract type that enhances GuardI<E> by adding
* operator overloads >> and && and & .
*
**/
abstract Guard<E>( GuardI<E> ) to GuardI<E> from GuardI<E> {

    public inline function new(g : GuardI<E>) {
        this = g;
    }

    /** See GuardI.enable **/
    public inline function enable( k : E -> Void ) : Disabler {
        return (this:GuardI<E>).enable( k ) ; }

    /** See GuardI.guarding **/
    @:op( A >> B )
    public inline function guarding<A>( k : E -> Process<A> )
        : GuardedProcess<A> {
        return (this:GuardI<E>).guarding( k ) ;
    }

    /** See GuardI.andThen **/
    @:op( A && B )
    public function andThen<A>( p : Process<A> ) : GuardedProcess<A> {
        return (this:GuardI<E>).andThen( p ) ;
    }

    /** See GuardI.filter **/
    @:op( A & B )
    public function filter( c : E -> Bool ) : Guard<E> {
        return (this:GuardI<E>).filter( c ) ;
    }
}


/** An "abstract class" for guards.
* Guard types generally extend this class while overriding
* .enable.
**/
class GuardA<E> implements GuardI<E> {
    public function enable( k : E -> Void ) : Disabler {
        throw "Method enable not overridden in " + this ; return null ; }

    public function guarding<A>( k : E -> Process<A> ) : GuardedProcess<A> {
        return new GuardedProcessC<A,E>( this, k ) ; }

    public function andThen<A>( p : Process<A> ) : GuardedProcess<A> {
        return this.guarding( function( ev : E ) { return p ; } ) ; }

    public function filter( c : E -> Bool ) : GuardI<E> {
        return new FliteredGuard<E>( this, c ) ; }
}

class FliteredGuard<E> extends GuardA<E> {
    var _guard : Guard<E> ;
    var _filter : E -> Bool ;
    public function new( guard: Guard<E>, c : E -> Bool ) {
        _guard = guard ; _filter = c ; }

    override public function enable( k : E -> Void ) : Disabler {
        return _guard.enable(
            // The event handler passed to the guard does nothing
            // if _filter(b) is false.
            function( b : E) {
                if( _filter(b) ) { k(b) ; } else {}
            }) ; }
}


/** Interface for guarded processes.
*
**/
interface GuardedProcessI<A> {
    /** Returns a process that executes by
    * first executing this process to get a values x:A
    * and then executing f(x).
    **/
    public function bind<B>( f : A -> Process<B> ) : GuardedProcess<B> ;

    /** Returns a process that executes by
    * first executing this process and
     * then executing b.
    **/
    public function sc<B>( b : Process<B> ) : GuardedProcess<B> ;

    /** Make a choice of two guarded processes.
    **/
    public function orElse( gp : GuardedProcessI<A> ) : GuardedProcessI<A> ;


/** Enable the guarded process.
    * If an enabled guarded process fires, it executes the first routine first,
    * then it executes itself, finally it calls k with the result.
    **/
    public function enable( first : Void -> Void, k : A -> Void ) : Disabler ;

}

abstract GuardedProcess<A>( GuardedProcessI<A> )
to GuardedProcessI<A> from GuardedProcessI<A> {

    public inline function new(gp : GuardedProcessI<A>) {
        this = gp;
    }

    /** See GuardedProcessI.bind */
    @:op( A >= B )
    public inline function bind<B>( f : A -> Process<B> ) : GuardedProcess<B> {
        return new GuardedProcess<B>( (this:GuardedProcessI<A>).bind( (f:A -> Process<B>) ) ) ;
    }

    /** See GuardedProcessI.sc */
    @:op( A > B )
    public inline function sc<B>( q : Process<B> ) : GuardedProcess<B> {
        return new GuardedProcess<B>( (this:GuardedProcessI<A>).sc( (q:Process<B>) ) ) ;
    }

    /** See GuardedProcessI.orElse */
    @:op( A || B )
    public inline function orElse( gp : GuardedProcess<A> ) : GuardedProcess<A> {
        return new GuardedProcess<A>( (this:GuardedProcessI<A>).orElse( (gp : GuardedProcess<A>) ) ) ;
    }

    public inline function enable( first : Void -> Void, k : A -> Void ) : Disabler {
        return (this:GuardedProcessI<A>).enable( first, k) ;
    }
}

/** An "abstract class" for guarded processes. 
* "Concrete guarded process classes will extend off this class while
* overriding the enable method.
**/
class GuardedProcessA<A> implements GuardedProcessI<A>{
    /** Returns a process that executes by
    * first executing this process to get a values x:A
    * and then executing f(x).
    **/
    public function bind<B>( f : A -> Process<B> ) : GuardedProcess<B> {
        return new ThenGP<A,B>( this, f ) ;
    }

    /** Returns a process that executes by
    * first executing this process and
     * then executing b.
    **/
    public function sc<B>( b : Process<B> ) : GuardedProcess<B> {
        return new ThenGP<A,B>( this, function(a:A){ return b;} ) ;
    }

    /** Make a choice of two guarded processes.
    **/
    public function orElse( gp : GuardedProcessI<A> ) : GuardedProcessI<A> {
        return new ChoiceGP<A>( this, gp ) ;
    }

    /** Enable the guard associated with the guarded process. */
    public function enable( first : Void -> Void, k : A -> Void ) : Disabler  {
        throw "enable is not defined in "+this ; }
}

/** A guarded process made from a Guard<E> and a function E->Process<A>
*
**/
private class  GuardedProcessC<A,E> extends GuardedProcessA<A> {
    var _guard : Guard<E> ;
    var _f : E -> Process<A> ;
    public function new( guard: Guard<E>, f : E -> Process<A> ) {
        _guard = guard ; _f = f ; }

    override public function enable( first : Void -> Void, k : A -> Void ) : Disabler {
        return _guard.enable(
            function( b : E) {
                first() ;
                _f(b).go( k ) ; } ) ; }
}

/** A guarded process made from a GuardedProcess<A> and a function A->Process<B>.
*
**/
private class  ThenGP<A,B> extends GuardedProcessA<B> {
    var _gp : GuardedProcess<A> ;
    var _f : A -> Process<B> ;

    public function new( gp: GuardedProcess<A>, f : A -> Process<B> ) {
        _gp = gp ;
        _f = f ; }

    override public function enable( first : Void -> Void, k : B -> Void ) : Disabler {
        return _gp.enable(first,
            function( a : A) {
                _f(a).go( k ) ; } ) ; }
}

/** A guarded process made choice of two guarded processes.
*
**/
private class  ChoiceGP<A> extends GuardedProcessA<A> {
    var _gp0 : GuardedProcess<A> ;
    var _gp1 : GuardedProcess<A> ;

    public function new( gp0: GuardedProcess<A>, gp1: GuardedProcess<A> ) {
        _gp0 = gp0 ;
        _gp1 = gp1 ; }

    override public function enable( first : Void -> Void, k : A -> Void ) : Disabler {
        var d0 = _gp0.enable(first, k ) ;
        var d1 = _gp1.enable(first, k ) ;
        return new ChoiceDisabler( d0, d1 ) ;
    }

}

/** Disable two guards. */
private class ChoiceDisabler<A> implements Disabler {
    private var _d0 : Disabler ;
    private var _d1 : Disabler ;

    public function new( d0 : Disabler, d1 : Disabler ) {
        _d0 = d0 ; _d1 = d1 ;
    }

    public function disable() { _d0.disable() ; _d1.disable() ; }
}


/** A process that waits for one of a set of GuardedProcesses to fire.
* As soon as one fires, all are disabled. Then the GuardedProcess
* that fired executes.
**/
class AwaitP<A> extends ProcessA<A> {
    var _gp : GuardedProcess<A> ;

    public function new( gp : GuardedProcess<A>  ) {
       _gp = gp ; }

    public override function go( k : A -> Void ) {
        var disabler : Disabler = null ;
        function disable() {
            disabler.disable() ;
        }
        disabler = _gp.enable( disable, k) ;
    }
}


/** A process made from two process that execute in an interleaved fashion.
*
**/
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


/** A type that has null as its only member.
*
**/
enum Triv { } // The only value is null .


/** A pair of values.
*
**/
class Pair<A,B> {
    public function new( ) { }
    public var _left:A ;
    public var _right:B ; }


/** The main TBC class. Exports various usefull static functions.
*
**/
class TBC {
    private function new( ) { } // Do not instantiate.

    public static function  skip() {
        return unit(null) ; }

    public static function  unit<A>( a : A ) : Process<A> {
        return new ExecP<A>( function() { return a ; } ) ; }

    public static function exec<A>( f : Void -> A ) : Process<A> {
        return new ExecP<A>( f ) ; }

    public static function par<A,B>( p : Process<A>, q : Process<B> )
    : Process<Pair<A,B>> {
        return new Par2P<A,B>( p, q ) ; }

    public static function loop<A>( p : Process<A> ) : Process<Triv> {
        return p.bind( function( a : A ) { return loop(p) ; } ) ; }

//    public static function awaitAny<A>( list : List<GuardedProcess<A>> )
//    : Process<A> {
//        return new AwaitP<A>( list ) ; }

    public static function await<A>(
                                gp0 : GuardedProcess<A>,
                                ?gp1 : GuardedProcess<A>,
                                ?gp2 : GuardedProcess<A>,
                                ?gp3 : GuardedProcess<A>,
                                ?gp4 : GuardedProcess<A>,
                                ?gp5 : GuardedProcess<A> ) : Process<A> {
        var gp = gp0 ;
        if( gp1 != null ) gp = gp || gp1 ;
        if( gp2 != null ) gp = gp || gp2 ;
        if( gp3 != null ) gp = gp || gp3 ;
        if( gp4 != null ) gp = gp || gp4 ;
        if( gp5 != null ) gp = gp || gp5 ;
        return new AwaitP<A>( gp ) ; }
}
