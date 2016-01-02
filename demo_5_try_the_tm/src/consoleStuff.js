// Taken from WebWriter++

function consoleError(message){
	if (typeof console == 'undefined')
		alert(message);
	else
		console.error(message);
}

var debugging = true ;

function consoleDebug(message){
	if (debugging) {
	    if (typeof console == 'undefined')
	    	alert(message);
	    else
		    console.debug(message);
	}
}

function consoleStackTrace(error) {
	if( !error ) error = new Error() ;
	if( error.stack ) {
		consoleError( error.stack.toString() ) ; }
	else {
		consoleError(  "no stack trace available" ) ; }
}