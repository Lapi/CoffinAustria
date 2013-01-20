library CoffinController;

import 'dart:json';
import 'ServerConnection.dart';
import 'controls/ServerResponseWindow.dart';
import 'controls/CarouselContent.dart';

class CoffinController {
  ServerConnection serverConnection;
  CarouselContent carouselContent;
  var transferObject;
  
  CoffinController(ServerResponseWindow serverResponseWindow, this.carouselContent) {
    serverConnection = new ServerConnection("ws://127.0.0.1:1337/ws", serverResponseWindow);

    serverConnection.webSocket.on.open.add((e) {
      getCarousellItems();
    });
    
    serverConnection.webSocket.on.message.add((e) {
      print('received message ${e.data}');
      var transferObject = JSON.parse(e.data);
      if (transferObject['Name'] == 'getCarousellItems') {
        receivedCarousellItems(transferObject);
      }
    });
  }
  
  getCarousellItems(){
    
    var encoded = JSON.stringify({'name': 'getCarousellItems'});
    serverConnection.sendEncodedMessage(encoded);
  }

  receivedCarousellItems(transferObject) {
    carouselContent.compose(transferObject);    
  }
}
