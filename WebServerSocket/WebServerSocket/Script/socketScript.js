/**
 socketScript.js
 WebServerSocket
 Created by Tolu Oridota on 11/30/2023
 Copyright © 2023 Bryght Labs. All rights reserved.
 */

try {
    
    function startSocket() {
        socket = new WebSocket("ws://127.0.0.1:1999", "SocketBandit");
        //socket = new WebSocket("com.bryghtlab.WebServerSocket://127.0.0.1:1999", "SocketBandit");
        //socket = new WebSocket("ws://localhost", "SocketBandit");
        
        socket.onopen = function(e) {
            try {
                alert("[open] Connection established");
                alert("Sending to server");
                socket.send("My name is John");
                const socketOpen = { msgType: 2 }
                window.webkit.messageHandlers.socketOpen.postMessage(socketOpen);
                window.console.log = captureLog;
            } catch (error) {
                console.error('An open-socket error occurred Local:', error);
                const errorEntity = { msgType: 3, msgMonitor: { isError: true, errMsg: "Socket Open Error: " + error.message, msg: "" } }
                window.webkit.messageHandlers.socketOpenError.postMessage(errorEntity);
                window.console.log = captureLog;
            }
        };
        
        socket.onmessage = function(event) {
            try {
                alert(`[message] Data received from server: ${event.data}`);
                const socketOnMsg = { msgType: 4 }
                window.webkit.messageHandlers.SocketOnMessage.postMessage(socketOnMsg);
                window.console.log = captureLog;
            } catch (error) {
                console.error('An on-msg-socket error occurred:', error);
                const errorEntity = { msgType: 5, msgMonitor: { isError: true, errMsg: "Socket On Message Error Local: " + error.message, msg: "" } }
                window.webkit.messageHandlers.socketOnMessageError.postMessage(errorEntity);
                window.console.log = captureLog;
            }
        };
        
        socket.onclose = function(event) {
            try {
                if (event.wasClean) {
                    alert(`[close] Connection closed cleanly, code=${event.code} reason=${event.reason}`);
                    const cleanSocketClose = { msgType: 6 }
                    window.webkit.messageHandlers.socketOnClose.postMessage(cleanSocketClose);
                    window.console.log = captureLog;
                } else {
                    // e.g. server process killed or network down
                    // event.code is usually 1006 in this case
                    alert('[close] Connection died');
                    const cleanSocketClose = { msgType: 6 }
                    window.webkit.messageHandlers.socketOnClose.postMessage(cleanSocketClose);
                    window.console.log = captureLog;
                }
            } catch (error) {
                console.error('An on-close-socket error occurred:', error);
                const errorEntity = { msgType: 7, msgMonitor: { isError: true, errMsg: "Socket On Close Error Local: " + error.message, msg: "" } }
                window.webkit.messageHandlers.socketOnCloseError.postMessage(errorEntity);
                window.console.log = captureLog;
            }
        };
        
        socket.onerror = function(error) {
            try {
                const errorObj = JSON.stringify(error);
                //alert(`[error]`);
                alert(`[${errorObj}]`);
                console.error('An on-main-error-socket Local:', errorObj);
                const errorEntity = { msgType: 8, msgMonitor: { isError: true, errMsg: "Socket On Main Error Local: " + JSON.stringify(error) + ` code = ${error.code}` + ` reason = ${error.reason}`, msg: "" } }
                window.webkit.messageHandlers.socketMainError.postMessage(errorEntity);
                window.console.log = captureLog;
            } catch (errors) {
                console.error('An on-main-error-socket error occurred in try catch:', errors);
                const errorEntity = { msgType: 8, msgMonitor: { isError: true, errMsg: "Socket On Main Error Local: " + JSON.stringify(errors) + ` code = ${error.code}` + ` reason = ${error.reason}`, msg: "" } }
                window.webkit.messageHandlers.socketMainError.postMessage(errorEntity);
                window.console.log = captureLog;
            }
            
        };
    }
    
    
    
    function captureLog(msg) {
        window.webkit.messageHandlers.webViewLogError.postMessage(msg);
    }
    window.console.log = captureLog;
    
    function log(emoji, type, args) {
        window.webkit.messageHandlers.webViewLogError.postMessage(
          `${emoji} JS ${type}: ${Object.values(args)
          .map(v => typeof(v) === "undefined" ? "undefined" : typeof(v) === "object" ? JSON.stringify(v) : v.toString())
          .map(v => v.substring(0, 3000)) // Limit msg to 3000 chars
          .join(", ")}`
                                                                  )
    }
    
    let originalLog = console.log
    let originalWarn = console.warn
    let originalError = console.error
    let originalDebug = console.debug
    
    console.log = function() { log("📗", "log", arguments); originalLog.apply(null, arguments) }
    console.warn = function() { log("📙", "warning", arguments); originalWarn.apply(null, arguments) }
    console.error = function() { log("📕", "error", arguments); originalError.apply(null, arguments) }
    console.debug = function() { log("📘", "debug", arguments); originalDebug.apply(null, arguments) }
    
    window.addEventListener("error", function(e) {
        log("💥", "Uncaught", [`${e.message} at ${e.filename}:${e.lineno}:${e.colno}`])
    })
    
    
    window.onload = function() {
        startSocket()
    }
    
    window.onerror = function (error) {
        const errorObj = JSON.stringify(error);
        alert(`[window error: ${errorObj}]`);
        console.error('A window error occurred Local:', error);
        const errorEntity = { msgType: 8, msgMonitor: { isError: true, errMsg: "Socket On Window Error Local: " + JSON.stringify(error) + ` code = ${error.code}` + ` reason = ${error.reason}`, msg: "" } }
        window.webkit.messageHandlers.socketMainError.postMessage(errorEntity);
        window.console.log = captureLog;
    }
    
} catch (error) {
    console.error('An StartUp error occurred:', error);
    const errorEntity = { msgType: 0, msgMonitor: { isError: true, errMsg: "StartUp Error: " + error.message, msg: "" } }
    window.webkit.messageHandlers.startUpError.postMessage(errorEntity);
    window.console.log = captureLog;
}
