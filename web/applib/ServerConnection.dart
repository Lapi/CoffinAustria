library ServerConnection;

import 'dart:html';
import 'dart:json';
import 'controls/ServerResponseWindow.dart';
import 'controls/CarouselContent.dart';

class ServerConnection {
  // Step 7, add webSocket instance field
  WebSocket webSocket;
  String url;
  ServerResponseWindow serverResponseWindow;
  CarouselContent carouselContent;

  ServerConnection(this.url, ServerResponseWindow srw, CarouselContent cc) {
    this.serverResponseWindow = srw;
    this.carouselContent = cc;
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
    carouselContent.compose(transferObject);    
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
      this.getCarousellItems();
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