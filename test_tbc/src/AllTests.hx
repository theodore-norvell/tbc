class AllTests {
    static public function main() {
        var r = new haxe.unit.TestRunner();
        r.add(new TestExceptionHandling());
        r.add( new TestSeqMacro() ) ;
        r.run();
    }
}
