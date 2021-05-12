package tbc;

import haxe.macro.Context ;
import haxe.macro.Expr ;

private typedef Item = {
    var pos : Position ;
    var variableName : String ;
    var variableType : ComplexType ;
    var expr : Expr ;
}

class TBCSeq {

    /**seq macro
     * There must be at least one argument.
     * All arguments must be expressions.
     * Note that variable declarations are considered expressions
     * in Haxe, but they must be eclosed in paranetheses for the
     * parser to allow them as argumnets to a macro.
     * Each expression is either a (parenthesized)
     * variable declaration or not.
     * The last expression must not be a variable declaration.  The translation
     * is as follows
     * <pre>
     *     seq(e)   ---->   e
     *     seq( (var v : T = e), e1, e2, ..., en)
     *              ---->  e.bind( v:T --> seq( e1, e2, ..., en ) )
     *     seq( (var v = e), e1, e2, ..., en)
     *              ---->  e.bind( v --> seq( e1, e2, ..., en ) )
     *     seq( e, e1, e2, ..., en)
     *              ---->  e.sc( seq( e1, e2, ..., en ) )
     * </pre>
     * 
     * TODO: Support final.  Currently Haxe 4 users can write final instead
     * of var, but the macro treats it the same as "var".  This is for
     * compatiblilty with Haxe 4 and becuase I Haxe 4 seems to lack final
     * parameters.
     */
    public macro static function seq( e : Expr, es : Array<Expr> ) {

        //var date = Date.now().toString();
        //trace(date) ;
        es.insert(0, e) ;

        // Make a list of items.
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
        // for( i in a ) {
        //     trace( i.variableName, i.variableType, i.pos, i.expr) ;
        // }
        var i = a.length -1 ;
        if( a[i].variableName != null ) {
            Context.error( "Last argument of the seq macro must not be a variable declaration",
                a[i].pos ) ; }

        // Now work backward through the list of items, generating
        // a result expression.
        var result : Expr = a[i].expr ;
        i = i-1 ;
        while( i >= 0 ) {
            if( a[i].variableName != null) {
                var pname = a[i].variableName ;
                if( a[i].variableType == null ) {
                    // trace("Generating call to bind ") ;
                    result = macro ( (${a[i].expr}).bind(
                        function( $pname ) {
                            return ${result} ; } ) ) ;
                } else {
                    // trace("Generating call to bind with type") ;
                    var ptype = a[i].variableType ;
                    result = macro ( (${a[i].expr}).bind(
                        function( $pname : $ptype ) {
                            return ${result} ; } ) ) ;
                }
            } else {
                // trace("Generating call to sc") ;
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

