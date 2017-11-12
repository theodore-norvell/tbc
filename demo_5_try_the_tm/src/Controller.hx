package ;

import js.html.HTMLDocument;
import haxe.Log ;

import js.Browser ;
import js.html.Document ;
import js.html.Event ;
import js.html.Element ;

import tbc.TBC.Process ;
import tbc.TBC.Triv ;
import tbc.TBC.* ;
import tbc.TBCHTML.*;
import tbc.TBCTime.* ;

class Controller {

    static public function main() { 
        win = Browser.window ;
        doc = win.document ;
        var body = doc.body ;
        body.onload = Controller.onload ;

    }

    static var CPP = 0 ;
    static var JAVA = 1 ;

    static var win : js.html.Window ;
    static var doc : HTMLDocument ;
    static var topContainer : Element ;
    static var editorContainerContainerContainer : Element ;
    static var tmContainer : Element ;
    static var editButton : Element ;
    static var warning : Element ;
    static var dismissWarning : Element ;
    static var loadWarning : Element ;
    static var radio : Array<Element> = new Array<Element>() ;
    static var editorContainer : Array<Element> = new Array<Element>() ;
    static var textArea : Array<Element> = new Array<Element>()  ;
    static var editor : Array<Element> = new Array<Element>()  ;
    static var runButton : Array<Element> = new Array<Element>() ;



    static function showPopup(e : Element ) {
        e.setAttribute("class", "popup visible");
    }

    static function hidePopup(e : Element ) {
        e.setAttribute("class", "popup hidden");
    }

    static function clearWarning() {
        hidePopup( warning ) ;
    }

    static function showPopupP(e : Element ) { return
        exec(function(){ showPopup(e); return null; }) ;
    }

    static function hidePopupP(e : Element ) { return
        exec(function(){ hidePopup(e); return null; }) ;
    }

    static function out(str : String ) : Process<Triv> { return
        exec(function(){Log.trace(str); return null;}) ;
    }

    static function show(e : Element ) : Process<Triv> { return
        out("Showing") >
        exec(function(){e.style.visibility = "visible"; return null;}) ;
    }

    static function hide(e : Element ) : Process<Triv> { return
        out("hiding") >
        exec(function(){e.style.visibility = "hidden"; return null;}) ;
    }

    static function showTM( ) : Process<Triv> { return
        out("showing TM") >
        exec( function(){
            tmContainer.setAttribute("class","onTop") ;
            editorContainerContainerContainer.setAttribute("class","onBottom") ;
            return null;}) >
        pause( 2000 );
    }

    static function hideTM( ) : Process<Triv> { return
        out( "hiding TM" ) >
        exec( function(){
            editorContainerContainerContainer.setAttribute("class","onTop") ;
            tmContainer.setAttribute("class","onBottom") ;
            return null;}) >
        pause( 2000 ) ;
    }

    static function rotateVisible(e : Element ) : Process<Triv> { return
        out("Rotate to visible") >
        exec(function(){
            e.style.transform = "rotateY(0deg)" ;
            (cast e.style).WebkitTransform = "rotateY(0deg)" ;
            return null;}) ;
    }

    static function rotateInVisible(e : Element ) : Process<Triv> { return
        out("Rotate to invisible") >
        exec(function(){
            e.style.transform = "rotateY(90deg)" ;
            (cast e.style).WebkitTransform = "rotateY(90deg)" ;
            return null;}) ;
    }

    static function swap( oldContainer : Element, newContainer : Element, editor : Element) { return
        rotateInVisible( oldContainer ) >
        pause(300) >
        hide( oldContainer ) >
        pause(300) >
        show( newContainer ) >
        rotateVisible( newContainer ) ;
    }

    static function showEditor( toLang : Int ) { return
        show(topContainer) >
        swap( editorContainer[1-toLang], editorContainer[toLang], editor[toLang] ) ;
    }

    static function getTheTMApplet( ) : Process<Element>{ return
        exec( function() : Element {
            return untyped getTMApplet() ;
        } ) ;
    }

    static function getTextFromCodeMirror( lang : Int ) : Process<String> { return
        exec( function() : String {
            return untyped editor[lang].getValue("\n") ; } ) ;
    }

    static function sendToTM( lang : Int )  : Process<Triv> {
        var fileName = if(lang==CPP) "tryItNow.cpp" else "tryItNow.java" ;
        return
            getTheTMApplet() >=
            function( tm : Element ) : Process<Triv> {
                if( tm == null ) return unit( null ) ;
                else return
                    getTextFromCodeMirror(lang) >=
                    function (src : String ) : Process<Triv> { return
                        exec( function() {
                            try {
                                Log.trace("loadSting"+fileName+": "+src) ;
                                untyped tm.loadString( fileName, src) ;
                                Log.trace("loadString returns") ;
                            }
                            catch( e : Dynamic ) {
                                Log.trace( "Error on send to TM " + e.toString() ) ;
                                // Could use a stack trace here.
                                win.alert( "There was a problem sending the code to the Teaching Machine."
                                + " Try again. If the problem persists, contact Theodore"
                                + " Norvell (theo@mun.ca)" ) ; }
                            return null ;
                        } ) ; } ;
            }
    }

    static function initialState() : Process<Triv> { return
        await(
            change(radio[CPP]) && unit(CPP)
        ||
            change(radio[JAVA]) && unit(JAVA)
        ) >=
        function(lang : Int) { return
            showEditor(lang) >
            editingState(lang) ; } ;
    }

    static function editingState( lang : Int ) { return
        await( changeLang(1-lang) || run(lang) ) ;
    }

    static function changeLang( toLang : Int ) { return
        change(radio[toLang]) &&
        showEditor(toLang) >
        unit(toLang) >= editingState ;
    }

    static function run( lang : Int ) { return
        click(runButton[lang]) &&
        showPopupP( loadWarning ) >
        showTM() >
        sendToTM(lang) >
        hidePopupP( loadWarning ) >
        await( click(editButton) && hideTM() ) >
        unit(lang) >= editingState ;
    }

    static public function onload() {
        warning = doc.getElementById("warning") ;
        dismissWarning = doc.getElementById("dismissWarning") ;
        loadWarning = doc.getElementById("loadWarning") ;
        topContainer = doc.getElementById("topContainer") ;
        editorContainerContainerContainer = doc.getElementById("editorContainerContainerContainer") ;
        tmContainer = doc.getElementById("teachingMachineContainer") ;
        editButton = doc.getElementById("editButton") ;
        radio[CPP] = doc.getElementById("cppRadio") ;
        (cast radio[CPP]).checked = false ;
        radio[JAVA] = doc.getElementById("javaRadio") ;
        (cast radio[JAVA]).checked = false ;
        editorContainer[CPP] = doc.getElementById('cppEditorContainer') ;
        editorContainer[JAVA] = doc.getElementById('javaEditorContainer') ;
        textArea[CPP] = doc.getElementById('cppTextArea') ;
        textArea[JAVA] = doc.getElementById('javaTextArea') ;
        untyped editor[CPP] =  CodeMirror.fromTextArea(textArea[CPP], {mode: "text/x-c++src" } );
        untyped editor[JAVA] =  CodeMirror.fromTextArea(textArea[JAVA], {mode: "text/x-java" } );
        runButton[CPP] = doc.getElementById('runCPPButton') ;
        runButton[JAVA] = doc.getElementById('runJavaButton') ;


        untyped setTMReadyCallBack( clearWarning ) ;
        dismissWarning.onclick = clearWarning ;

        Log.trace("Last compiled " + CompileTime.get() );
        Log.trace("Started at " + Date.now() );
        var p = initialState() ;
        p.go( function(x:Triv) {},
                       function( ex : Dynamic ) trace( "Exception " + ex ) ) ; // Execute p
    }
}
