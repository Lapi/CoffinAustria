library coffin;

import 'dart:html';
import 'dart:core';
import 'dart:json';

ServerConnection serverConnection;
ServerResponseWindow serverResponseWindow;
CarousellContent carousellContent;
MyScriptElement myScriptElement;

addCarousellItem(String element) {
  carousellContent.add(element);
}

class CarousellContent extends View<DivElement> {
  int counter = 0;
  CarousellContent(DivElement elem) : super(elem);
  
  add(String element) {
    var path = element.substring(element.indexOf('img', 0), element.length);
    ImageElement img = new ImageElement();
    img.src = path;
    img.alt = 'Dart';
    DivElement item = new DivElement();
    if (counter == 0) {
      item.classes.add('item active'); 
      counter++;
    } else {
      item.classes.add('item');
    }      
    item.children.add(img);
    elem.children.add(item);
  }
}

class MyScriptElement extends View<ScriptElement> {
  MyScriptElement(ScriptElement elem) : super(elem);
  
  addCarousellFade() {
    elem.src = 'js/fade.js';
  }
}

class ServerConnection {
  // Step 7, add webSocket instance field
  WebSocket webSocket;
  String url;

  ServerConnection(this.url) {
    _init();
  }

  send(String from, String message) {
    // Step 5, encode from and message into one JSON string
    var encoded = JSON.stringify({'f': from, 'm': message});
    _sendEncodedMessage(encoded);
  }
      
  getCarousellItems(){
    var encoded = JSON.stringify({'name': 'getCarousellItems'});
    _sendEncodedMessage(encoded);
  }  

  _receivedCarousellItems(transferObject) {
    List<String> tempList = new List<String>();
    var tempString = transferObject['Items'];
    var i = 0;
    while(tempString.contains(',')) {
      if (i == 0) {
       i++;
       tempString = tempString.substring(1, tempString.length);       
      }        
      tempList.add(tempString.substring(0, tempString.indexOf(',', 0)));
      tempString = tempString.substring(tempString.indexOf(',', 0), tempString.length);
      tempString = tempString.substring(2, tempString.length);
    }
    tempList.add(tempString.substring(0, tempString.length - 1));
    
    tempList.forEach(addCarousellItem);
  }

  _sendEncodedMessage(String encodedMessage) {
    // Step 7, send the message over the WebSocket
    if (webSocket != null && webSocket.readyState == WebSocket.OPEN) {
      webSocket.send(encodedMessage);
    } else {
      print('WebSocket not connected, message $encodedMessage not sent');
    }
  }

  _init([int retrySeconds = 2]) {
    bool encounteredError = false;
    
    scheduleReconnect() {
      serverResponseWindow.displayNotice('web socket closed, retrying in $retrySeconds seconds');
      if (!encounteredError) {
        window.setTimeout(() => _init(retrySeconds*2), 1000*retrySeconds);
      }
      encounteredError = true;
    }
    
    // Step 7, connect to the WebSocket, listen for events
    serverResponseWindow.displayNotice("Connecting to Web socket");
    webSocket = new WebSocket(url);

    webSocket.on.open.add((e) {
      serverResponseWindow.displayNotice('Connected');
      composeCarousell();
    });
    webSocket.on.close.add((e) => scheduleReconnect());
    webSocket.on.close.add((e) {
      serverResponseWindow.displayNotice('web socket closed');
    });
    webSocket.on.error.add((e) => scheduleReconnect());
    webSocket.on.error.add((e) {
      serverResponseWindow.displayNotice('Error connecting to ws');
    });
    webSocket.on.message.add((e) {
      print('received message ${e.data}');
      var transferObject = JSON.parse(e.data);
      if (transferObject['Name'] == 'getCarousellItems') {
        _receivedCarousellItems(transferObject);
      }
    });
  }
}

abstract class View<T> {
  final T elem;

  View(this.elem) {
    bind();
  }

  // bind to event listeners
  void bind() { }
}

class ServerResponseWindow extends View<TextAreaElement> {
  ServerResponseWindow(TextAreaElement elem) : super(elem);

  displayMessage(String msg, String from) {
    _display("$from: $msg\n");
  }
  
  displayNotice(String notice) {
    _display("[system]: $notice\n");
  }
  
  _display(String str) {
    elem.text = "${elem.text}$str";
  }
}

void composeCarousell() {
  var items = serverConnection.getCarousellItems();
}

void main() {
  TextAreaElement serverResponseElem = query('#serverResponse');
  DivElement carousell = query('#mainCarousel');
  ScriptElement script = query('#myScript');
  serverResponseWindow = new ServerResponseWindow(serverResponseElem);
  carousellContent = new CarousellContent(carousell);
  
  serverConnection = new ServerConnection("ws://127.0.0.1:1337/ws");
  
  myScriptElement = new MyScriptElement(script);
  myScriptElement.addCarousellFade();
}
