package tbc;

import haxe.ds.Vector ;
import haxe.CallStack ;

/** An interface representing processes computing values of type A */
@:expose
interface ProcessI<A> {

    /** Returns a process that executes by
    * first executing this process to get a values x:A
    * and then executing f(x).
    **/
    public function bind<B>( f : A -> Process<B> ) : Process<B> ;

    /** Returns a process that executes by
    * first executing this process to get a values x:A
    * and running that result through the function.
    **/
    public function map<B>( f : A -> B ) : Process<B> ;

    /** Returns a process that executes by
    * first executing this process and
     * then executing b.
    **/
    public function sc<B>( b : Process<B> ) : Process<B> ;

    /** Run the process. */
    public function go(  k : A -> Void, h : Dynamic -> Void ) : Void ;

    /** Run the process. Results are ignored, exceptions are printed. */
    public function run( ) : Void ;
}

/** A type representing processes computing values of type A.
*   This abstract type adds operators > and >= to interface ProcessI<A>.
**/
@:expose
abstract Process<A>( ProcessI<A> ) to ProcessI<A> from ProcessI<A> {

    public inline function new(p : ProcessI<A>) {
        this = p;
    }

    /** See ProcessI.bind */
    @:op( A >= B )
    public inline function bind<B>( f : A -> Process<B> ) : Process<B> {
        return new Process<B>( (this:ProcessI<A>).bind( (f:A ->ProcessI<B>) ) ) ;
    }

    /** See ProcessI.map */
    public inline function map<B>( f : A -> B ) : Process<B> {
        return new Process<B>( (this:ProcessI<A>).map( f ) ) ;
    }

    /** See ProcessI.sc */
    @:op( A > B )
    public inline function sc<B>( q : Process<B> ) : Process<B> {
        return new Process<B>( (this:ProcessI<A>).sc( (q:Process<B>) ) ) ;
    }

    /** See ProcessI.go */
    public inline function go( k : A -> Void, h : Dynamic -> Void ) {
        (this:ProcessI<A>).go(k, h) ; }

    /** See ProcessI.run */
    public function run( ) : Void {
        (this:ProcessI<A>).run() ; }
}

/** An "abstract class" for processes.
*    Defines .bind and .sc. Leaves .go "abstract".
*    New Process types will generally extend this class
*    while overriding the .go method.
**/
@:expose
class ProcessA<A> implements ProcessI<A> {

    /** See ProcessI.bind */
    public function bind<B>( f : A -> Process<B> ) : Process<B> {
        return new ThenP( this, f ) ;
    }

    /** See ProcessI.map */
    public function map<B>( f : A -> B ) : Process<B> {
        var f1 = function(a:A){ return
                      new ExecP<B>( function() { return
                                        f(a) ; } ) ; }
        return new ThenP( this, f1 ) ;
    }

    /** See ProcessI.sc */
    public function sc<B>( q : Process<B> ) : Process<B> {
        return new ThenP( this, function(a:A) { return q; } ) ;
    }

    static private function printStack() : Void {
        trace( CallStack.toString( CallStack.exceptionStack() ) ) ;
    }

    /** Run the process. Results are ignored, exceptions are printed. */
    public function run( ) : Void {
        go( (a:A) -> {}, 
            (ex:Dynamic)-> {
                trace( "Process throws uncaught exception " + ex ) ;
                trace( CallStack.toString( CallStack.exceptionStack() ) ) ;
            } ) ;
              
    }

    /** See ProcessI.go */
    public function go( k : A -> Void, h : Dynamic -> Void ) {
        h( "go is not defined in "+this ) ; }
}

/** A process that executes two processes sequentially. */
private class ThenP<A,B> extends ProcessA<B> {
    var _left : Process<A> ;
    var _right : A -> Process<B> ;

    public function new( left : Process<A>, right : A -> Process<B> ) {
        _left = left ; _right = right ; }

    public override function go( f : B -> Void, h : Dynamic -> Void ) {
        _left.go( function(a:A) _right(a).go(f, h), h) ; }
}

/** A process that calls a function. */
private class ExecP<A> extends ProcessA<A> {
    var _f : Void -> A ;

    public function new( f : Void -> A ) {
       _f = f ; }

    public override function go( k : A -> Void, h : Dynamic -> Void ) {
        try k(_f()) catch( ex : Dynamic ) { h(ex) ; } ; }
}

/** A process that tosses an exception. */
private class TossP<A> extends ProcessA<A> {
    var _ex : Dynamic ;

    public function new( ex : Dynamic ) {
        _ex = ex ; }

    public override function go( k : A -> Void, h : Dynamic -> Void ) {
        h( _ex ) ; }
}

/** See documentation under TBC.attempt and TBC.ultimately */
private class AttemptP<A> extends ProcessA<A> {
    var _p : Process<A> ;
    var _f : Dynamic -> Process<A> ;
    var _q : Process<Triv> ;

    public function new( p : Process<A>, f : Dynamic -> Process<A>, q : Process<Triv> ) {
        _p = p ; _f = f ; _q = q ; }

    public override function go( k : A -> Void, h : Dynamic -> Void ) : Void {
        _p.go( function(a:A) {
                   _q.go(function(t:Triv){ k(a) ; }, h) ; },
               function( ex : Dynamic) {
                   _f(ex).go(
                       function( a : A ) {
                           _q.go(function(t:Triv){ k(a) ; }, h) ; },
                       function( ex1 : Dynamic ) {
                           _q.go(function(t:Triv){ h(ex1) ; },
                                 function(ex2:Dynamic){ h(new Pair<Dynamic,Dynamic>(ex1,ex2)) ; } ) ; }
                   ) ; }
        ) ;
    }
}
/** Guards return a Disabler when enabled.
*    The Disabler is used to disable the guard.
**/
@:expose
interface Disabler {
    public function disable() : Void ;
}

/** An interface for Guards.
**/
@:expose
interface GuardI<E> extends GuardedProcessI<E> {


    /** Enable the guard.
    * When fired, the guard will execute k. **/
    public function enable( k : E -> Void, h : Dynamic -> Void ) : Disabler  ;

    /** Create a guarded process. Deprecated in favour of bind. **/
    @:deprecated
    public function guarding<A>( k : E -> Process<A> ) : GuardedProcess<A> ;

    /** Create a guarded process. Deprecated in fovour of sc. **/
    @:deprecated
    public function andThen<A>( p : Process<A> ) : GuardedProcess<A> ;

    /** Create a guard that is conditional on some condition. */
    public function filter( c : E -> Bool ) : GuardI<E> ;
}

/** An abstract type that enhances GuardI<E> by adding
 * operator overloads for >=, >, >>, && and & .
 *
 * Note that all guards are guarded processes and so the following
 * operations are possible where g is a guard: 
 *    g >= f    --wait for event e, then do f(e) 
 *    g > p     --wait for event e, then do p
 *    g || gp   --choose
 *    gp || g   --choose
 *    await( g )  -- wait for event
 * The following operations are particular to guards
 *    g & f   --filter event with predicate f
 *    g >> f  (equivalent to g >= f, but with higher precedence than &)
 *    g && p  (equivalent to g > p, but with lower precedence than >)
 *  TODO. Consider adding a | operator.
**/
@:expose
abstract Guard<E>( GuardI<E> )
    to GuardI<E>
    from GuardI<E>
    to GuardedProcess<E>   // Allows a Guard to be used where a GuardedProcess is expected. E.g. in await.
{
    public inline function new(g : GuardI<E>) {
        this = g;
    }

    /** See GuardI.enable **/
    public inline function enable( k : E -> Void, h : Dynamic -> Void ) : Disabler {
        return (this:GuardI<E>).enable( k, h ) ; }

    /** See GuardI.guarding.
     * Possibly this should be deprecated. Especially as it has higher precedence than & and |. **/
    @:op( A >> B )
    @:deprecated
    public inline function guarding<A>( k : E -> Process<A> )
        : GuardedProcess<A> {
        return (this:GuardI<E>).bind( k ) ;
    }

    /** See GuardI.andThen **/
    @:op( A && B )
    @:deprecated
    public function andThen<A>( p : Process<A> ) : GuardedProcess<A> {
        return (this:GuardI<E>).sc( p ) ;
    }

    /** See GuardI.filter **/
    @:op( A & B )
    public function filter( c : E -> Bool ) : Guard<E> {
        return (this:GuardI<E>).filter( c ) ;
    }

    /* -----------------------* /
    /* Below this line we have methods essentially copied from GuardedProcess<E>. */

    /** See GuardedProcessI.bind */
    @:op( A >= B )
    public inline function bind<B>( f : E -> Process<B> ) : GuardedProcess<B> {
        return new GuardedProcess<B>( (this:GuardI<E>).bind(f) );
    }

    /** See GuardedProcessI.sc */
    @:op( A > B )
    public inline function sc<B>( q : Process<B> ) : GuardedProcess<B> {
        return new GuardedProcess<B>( (this:GuardI<E>).sc( q ) ) ;
    }

    /** See GuardedProcessI.orElse */
    @:op( A || B )
    public inline function orElse( gp : GuardedProcess<E> ) : GuardedProcess<E> {
        return new GuardedProcess<E>( (this:GuardI<E>).orElse( gp ) ) ;
    }

    /** See GuardedProcessI.enableGP */
    public inline function enableGP( first : Void -> Void, k : E -> Void, h : Dynamic -> Void ) : Disabler {
        return (this:GuardI<E>).enableGP( first, k, h) ;
    }

}


/** An "abstract class" for guards.
* Guard types generally extend this class while overriding
* .enable.
**/
@:expose
class GuardA<E> implements GuardI<E> extends GuardedProcessA<E> {
    public function enable( k : E -> Void, h : Dynamic -> Void ) : Disabler {
        h("Method enable not overridden in " + this) ; return null ; }
    
    override
    public function enableGP( first : Void -> Void, k : E -> Void, h : Dynamic -> Void ) : Disabler {
            return enable(
                function( e : E) {
                    first() ;
                    TBC.unit(e).go( k, h ) ; },
                h ) ; }
    
    /** use bind instead */
    @:deprecated
    public function guarding<A>( f : E -> Process<A> ) : GuardedProcess<A> {
        return this.bind(f) ; }

    /** use sc instead */
    @:deprecated
    public function andThen<A>( p : Process<A> ) : GuardedProcess<A> {
        return this.sc( p ) ; }

    public function filter( c : E -> Bool ) : GuardI<E> {
        return new FliteredGuard<E>( this, c ) ; }

    
}

@:expose
class FliteredGuard<E> extends GuardA<E> {
    var _guard : Guard<E> ;
    var _filter : E -> Bool ;

    public function new( guard: Guard<E>, c : E -> Bool ) {
        _guard = guard ; _filter = c ; }

    override public function enable( k : E -> Void, h : Dynamic -> Void ) : Disabler {
        return _guard.enable(
            // The event handler passed to the guard does nothing
            // if _filter(b) is false.
            function( b : E) {
                //haxe.Log.trace("Filtered event fires "+b) ;
                //haxe.Log.trace("Filter is " + _filter(b) ) ;
                if( _filter(b) ) { k(b) ; } else {}
            },
            h) ; }
}


/** Interface for guarded processes.
*  TODO:: Could  GuardedProcessI<A>  extend ProcessI<A> ?
**/
@:expose
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
    public function enableGP( first : Void -> Void, k : A -> Void, h : Dynamic -> Void ) : Disabler ;

}

@:expose
abstract GuardedProcess<A>( GuardedProcessI<A> )
to GuardedProcessI<A> from GuardedProcessI<A> {

    public inline function new(gp : GuardedProcessI<A>) {
        this = gp;
    }

    /** See GuardedProcessI.bind */
    @:op( A >= B )
    public inline function bind<B>( f : A -> Process<B> ) : GuardedProcess<B> {
        return new GuardedProcess<B>( (this:GuardedProcessI<A>).bind( f ) ) ;
    }

    /** See GuardedProcessI.sc */
    @:op( A > B )
    public inline function sc<B>( q : Process<B> ) : GuardedProcess<B> {
        return new GuardedProcess<B>( (this:GuardedProcessI<A>).sc( q ) ) ;
    }

    /** See GuardedProcessI.orElse */
    @:op( A || B )
    public inline function orElse( gp : GuardedProcess<A> ) : GuardedProcess<A> {
        return new GuardedProcess<A>( (this:GuardedProcessI<A>).orElse( gp ) ) ;
    }

    public inline function enableGP( first : Void -> Void, k : A -> Void, h : Dynamic -> Void ) : Disabler {
        return (this:GuardedProcessI<A>).enableGP( first, k, h) ;
    }
}

/** An "abstract class" for guarded processes.
* "Concrete guarded process classes will extend off this class while
* overriding the enableGP method.
**/
@:expose
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
    public function enableGP( first : Void -> Void, k : A -> Void, h : Dynamic -> Void ) : Disabler  {
        h("enableGP is not defined in "+this) ; return null ; }
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

    override public function enableGP( first : Void -> Void, k : B -> Void, h : Dynamic -> Void ) : Disabler {
        return _gp.enableGP(first,
            function( a : A) {
                _f(a).go( k, h ) ; },
            h) ; }
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

    override public function enableGP( first : Void -> Void, k : A -> Void, h : Dynamic -> Void ) : Disabler {
        var d0 = _gp0.enableGP(first, k, h ) ;
        var d1 = _gp1.enableGP(first, k, h ) ;
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
private class AwaitP<A> extends ProcessA<A> {
    var _gp : GuardedProcess<A> ;

    public function new( gp : GuardedProcess<A>  ) {
        _gp = gp ; }

    public override function go( k : A -> Void, h : Dynamic -> Void ) {
        var disabler : Disabler = null ;
        function disable() {
            disabler.disable() ;
        }
        disabler = _gp.enableGP(disable, k, h) ;
    }
}

/** A process representing alternation.
*
**/
private class AltP<A> extends ProcessA<A> {
    var _e : Process<Bool> ;
    var _p : Process<A> ;
    var _q : Process<A> ;

    public function new( e : Process<Bool>, p : Process<A>, q : Process<A> ) {
        _e = e ; _p = p ; _q = q ; }

    public override function go( k : A -> Void, h : Dynamic -> Void ) {
        _e.go( function( b : Bool ) {
                   if( b ) { _p.go( k, h ) ; }
                   else { _q.go( k, h ) ; } },
               h) ; }
}


/** A process made from two process that execute in an interleaved fashion.
*
**/
private class Par2P<A,B> extends ProcessA<Pair<A,B>> {
    var _p : Process<A> ;
    var _q : Process<B> ;

    public function new( p : Process<A>, q : Process<B> ) {
        _p = p ; _q = q ; }

    public override function go( k : Pair<A,B> -> Void, h : Dynamic -> Void ) {
        var result = new Pair<A,B>() ;
        var completed = 0 ;
        _p.go( function( a : A ) : Void {
                   result._left = a ;
                   completed++ ;
                   if( completed == 2 ) k(result) ; },
            h ) ;
        _q.go( function( b : B ) : Void {
                   result._right = b ;
                   completed++ ;
                   if( completed == 2 ) k(result) ; },
            h ) ;
    }
}

/** A process made from bunch of processes run in parallel.
**/
private class ParFor<A> extends ProcessA<Vector<A>> {
    var _n : Int ;
    var _f : Int->Process<A> ;

    public function new( n : Int, f : Int->Process<A> ) {
        _n = n ; _f = f ; }

    public override function go( k : Vector<A> -> Void, h : Dynamic -> Void ) {
        var result = new Vector<A>( _n ) ;
        var completed = 0 ;
        for( i in 0 ... _n ) {
            _f(i).go( function( a : A ) {
                        result[i] = a ;
                        completed++ ;
                        if( completed == _n ) k(result) ; },
                     h ) ; }
    }
}


/** A type that has null as its only member.
*
**/
@:expose
enum Triv { } // The only value is null .


/** A pair of values.
*
**/
@:expose
class Pair<A,B> {
    public function new( ?a:A, ?b:B) { _left = a ; _right = b ; }
    public var _left:A ;
    public var _right:B ; }


/** The main TBC class. Exports various usefull static functions.
*
**/
@:expose
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

    public static function parFor<A>( n : Int, f : Int->Process<A> ) 
    : Process<Vector<A>> {
        return new ParFor<A>( n, f)  ; }

    public static function loop<A>( p : Process<A> ) : Process<Triv> {
        return p.bind( function( a : A ) { return loop(p) ; } ) ; }

    public static function alt<A>( e : Process<Bool>, p : Process<A>, q : Process<A> )
    : Process<A> {
        return new AltP( e, p, q ) ;
    }

    /** Create a looping process from a function.
     * The result is a process p of type Process<A> such that
     * p = f( function( t : Triv ) { return p ; } )
     * It is a precondition that f should not call its argument.
    **/
    public static function fix<A>( f : (Void -> Process<A>) -> Process<A> ) : Process<A> {
        var p : Process<A> = null ;
        function fp() {
            if( p==null )
                return toss("TBC Error in fix. Possibly a missing invoke?") ;
            else
                return p ; }
        p = f( fp ) ;
        return p ;
    }

    /** Toss an exception.
    **/
    public static function toss<A>( ex : Dynamic ) : Process<A> {
        return new TossP<A>(ex) ;
    }

    /** A process that attempts to run p and recovers by running f(ex); in any case q is run finally.
    *  <p> The last argument can be omitted.
    *  <p> To run process attempt(p, f): First p is run.
    *  <ul>
    *      <li> If p succeeds with a,
    *           then attempt(p, f) succeeds with a.
    *      <li> If p fails with ex, and f(ex) succeeds with a,
    *           then attempt(p, f) succeeds with a.
    *      <li> If p fails with ex, and f(ex) fails with ex1,
    *           then attempt(p, f) fails with ex1.
    *  </ul>
    *
    *  <p> To run process attempt(p, f, q): First p is run.
    *  <ul>
    *      <li> If p succeeds with a and q succeeds,
    *           then attempt(p, f, q) succeeds with a.
    *      <li> If p succeeds and q fails with ex2,
    *           then attempt(p, f, q) fails with ex2.
    *      <li> If p fails with ex, and f(ex) succeeds with a, and q succeeds,
    *           then attempt(p, f, q) succeeds with a.
    *      <li> If p fails with ex, and f(ex) succeeds with a, and q fails with ex2,
    *           then attempt(p, f, q) fails with ex2.
    *      <li> If p fails with ex, and f(ex) fails with ex1, and q succeeds,
    *           then attempt(p, f, q) fails with ex1.
    *      <li> If p fails with ex, and f(ex) fails with ex1, and q fails with ex2,
    *           then attempt(p, f, q) fails with a Pair consisting of ex1 on the left and ex2 on the right.
    *  </ul>
    *  <p>
    *  See also TBC.ultimately for a version that allows the exception
    *  handing to be omitted.
    **/
    public static function attempt<A>( p : Process<A>,
                                       f : Dynamic -> Process<A>,
                                       ?q : Process<Triv> ) : Process<A> {
        if( q==null ) q = skip() ;
        return new AttemptP(p, f, q) ;
    }

    /** Finalize
    *   ultimately( p, q ) works as follows. p is run:
    *   <ul>
    *      <li> If p succeeds with a and q succeeds,
    *           then ultimately( p, q ) succeeds with a.
    *      <li> If p succeeds with a and q fails with ex2,
    *           then ultimately( p, q ) fails with ex2.
    *      <li> If p fails with ex and q succeeds,
    *           then ultimately( p, q ) fails with ex.
    *      <li> If p fails with ex and q fails with ex2,
    *           then ultimately( p, q ) fails with a Pair consisting of ex on the left and ex2 on the right.
    *   </ul>
    **/
    public static function ultimately<A>( p : Process<A>, q : Process<Triv> ) : Process<A> {
        var f = function( ex:Dynamic) { return toss(ex) ; } ;
        return attempt( p, f, q) ;
    }

    /** Run the process returned by a function.
    *     invoke(fp) is equivalent to exec(fp).bind(id).
    **/
    public static function invoke<A>( fp : Void -> Process<A> ) : Process<A> {
        // This differs from exec(fp) in type. The result of exec(fp)
        // is a Process<Process<A>>.  So `foo > exec(fp)` would not
        // acually run the result of fp when run.
        // It differs from fp() in the time of the calling of fp.
        // For example in `foo > fp()`, fp is called when before the > operator
        // is executed; in `foo > invoke( fp )`, fp is not called; instead `fp` will
        // be called when process `foo > invoke( fp )` is run.
        //
        // Consdier this example:
        //   static function nag() : Process<Triv>{
        //       function f(repeat : Void -> Process<Triv>) : Process<Triv> { return
        //           await(
        //               click(b0) && out("0")
        //           ||
        //               timeout( 1500 ) && nagTheUser() > invoke( repeat )
        //           ) ; }
        //       return fix( f ) ;
        //   }
        // If we replace invoke( repeat ) with repeat(), then
        //   repeat will be called when f is called.
        // If you peek at the definition of fix, we can see that f is
        // called within the execution of fix and that the result of
        // calling repeat() would then be null.
        return exec(fp) >= function(p : Process<A>) { return p ; } ;
    }

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

    function test(g1 : Guard<Int>, g2 : Guard<Int>, gp : GuardedProcess<Int> ) : Process<Int> {
        var a =  await( g1 ) ;
        var b = await( g1 || g2 ) ;
        var c = await( g1 || gp ) ;
        var d = await( gp || g2 ) ;
        return a > b > c > d ;
    }
}
