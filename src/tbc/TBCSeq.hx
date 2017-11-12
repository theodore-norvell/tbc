package tbc;

import haxe.macro.Context ;
import haxe.macro.Expr ;
import Date ;

class MFE {
    public macro static function foo( name : String, t : ComplexType ) {
        var e : Expr = macro function( $name ) { return 0 ; }  ;
        return e ; }
}

private typedef Item = {
    var pos : Position ;
    var variableName : String ;
    var variableType : ComplexType ;
    var expr : Expr ;
}

class TBCSeq {

    public macro static function seq( e : Expr, es : Array<Expr> ) {
//        var name = "abc" ;
//        var path = {name: "Int", pack: new Array<String>(), params:null, sub:null} ;
//        var type : ComplexType = TPath( path ) ;
//        var e : Expr = macro function( $name : $type ) { return 0 ; }  ;
//        return e ;

        var date = Date.now().toString();
        trace(date) ;
        es.insert(0, e) ;
        var a = new Array<Item>() ;
        for( e in es ) {
            var pos : Position = e.pos ;
            var edef = extractDef( e ) ;
            switch( edef ) {
                case EVars( vars ) :
                    for( v in vars ) {
                        if( v.expr == null ) {
                            Context.error(
                                "Variables in seq macro must have an initialization expression",
                                pos ) ; }
                        var i : Item = { pos : v.expr.pos,
                                         expr: v.expr,
                                         variableName: v.name,
                                         variableType: v.type } ;
                        a.push(i) ; }
                case _ : {
                    var i : Item = {
                        pos : e.pos,
                        expr: e,
                        variableName: null,
                        variableType: null } ;
                    a.push( i ) ;
                }
            }
        }
        for( i in a ) {
            trace( i.variableName, i.variableType, i.pos, i.expr) ;
        }
        var i = a.length -1 ;
        if( a[i].variableName != null ) {
            Context.error( "Last argument of the seq macro must not be a variable declaration",
                a[i].pos ) ; }
        var result : Expr = a[i].expr ;
        i = i-1 ;
        while( i >= 0 ) {
            if( a[i].variableName != null) {
                var pname = a[i].variableName ;
                if( a[i].variableType == null ) {
                    trace("Generating call to bind ") ;
                    result = macro ( (${a[i].expr}).bind(
                        function( $pname ) {
                            return ${result} ; } ) ) ;
                } else {
                    trace("Generating call to bind with type") ;
                    var ptype = a[i].variableType ;
                    result = macro ( (${a[i].expr}).bind(
                        function( $pname : $ptype ) {
                            return ${result} ; } ) ) ;
                }
            } else {
                trace("Generating call to sc") ;
                result = macro (${a[i].expr}).sc(
                    ${result} ) ;
            }
            result.pos = a[i].pos ;
            i = i-1 ;
        }
        return result ;
    }

    private static function extractDef( e : Expr ) {
        switch( e.expr ) {
            case EParenthesis( e1 ) : return extractDef( e1 ) ;
            case _ : return e.expr ;
        }
    }
}

