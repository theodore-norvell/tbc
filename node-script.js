var hx = require( "./bin/tbc4Node.js" ) ;
var exec = hx.tbc.TBC.exec ;
var pause = hx.tbc.TBCTime.pause ;

function println( str ) {
    return exec( ()=>console.log(str) ) ; }

var p = println( "hello" )
        .sc( pause( 3000 ) )
        .sc( println( "world" ) ) ;