package ;

import haxe.Log ;
import haxe.CallStack ;
import haxe.ds.Vector ;
import tbc.TBC.Process ;
import tbc.TBC.Guard ;
import tbc.TBC.Triv ;
import tbc.TBC.* ;
import tbc.TBCTime.*;
import tbc.TBCJQuery.*;

import js.Browser ;

/** This module requires Andy Li's JQuery extern library */
import js.jquery.JQuery ;
import js.jquery.Event ;

class Controller {

    static public function main() { 
        var win = Browser.window ;
        var doc = win.document ;
        var body = doc.body ;
        body.onload = Controller.onload ;

    }
    
    static private function printStack() : Void {
        trace( CallStack.toString( CallStack.exceptionStack() ) ) ;
    }

    static private var balls : Array<JQuery> = new Array<JQuery>() ;

    static public function onload() {
        var win = Browser.window ;
        var doc = win.document ;

        Log.trace("Last compiled " + CompileTime.get() );
        Log.trace("Started at " + Date.now() );

        var count = 16 ;
        var stage = new JQuery("#stage") ;
        stage.css("position", "relative") ;
        stage.css("border", "thin black solid") ;
        stage.css("width", 500) ;
        stage.css("height", 410) ;
        stage.css( "background-color", "white" ) ;

        for( i in 0...count) {
            var ball = new JQuery("<div></div>") ;
            ball.css( "width", 20 ) ;
            ball.css( "height", 20) ;
            ball.css( "background-color", "black") ;
            ball.css( "position", "absolute") ;
            ball.css( "border-radius", 10) ;
            ball.css( "top", 5 + i*(20 + 5) ) ;
            ball.css( "left", 250-10 ) ;
            stage.append( ball ) ;
            balls.push(ball) ;
        }

        var p = parFor( count, ballBehaviour ) ;
        p.go( function(x:Vector<Triv>) {},
              function( ex : Dynamic ) {
                    trace( "Exception " + ex ) ;
                    printStack() ; }
            ) ;
    }

    static function ballBehaviour( i : Int ) : Process<Triv> {
        var ball = balls[i] ;
        var t = 0 ;
        return loop(
            pause( 60 ) >
            exec( () -> { t = t + 60 ;
                          var x = 250-10 + 100 * Math.cos( t / (512+4*i) ) ;
                          ball.css( "left", x ) ;
                        } ) 
        ) ;
    }


}
