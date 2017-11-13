class AllTests {
    static public function main() {
        var r = new haxe.unit.TestRunner();
        r.add(new TestExceptionHandling());
        r.run();
    }
}
