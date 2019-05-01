package ;

import Date ;
import haxe.macro.Context;

class CompileTime {
    public macro static function get() {
        var date = Date.now().toString();
        return Context.makeExpr(date, Context.currentPos());
    }
}
