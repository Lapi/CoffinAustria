library coffin;

import 'dart:html';
import 'dart:core';
import 'dart:json';
import 'applib/ServerConnection.dart';
import 'applib/controls/ServerResponseWindow.dart';
import 'applib/controls/CarouselContent.dart';
import 'applib/controls/MyScriptElement.dart';

ServerConnection serverConnection;
ServerResponseWindow serverResponseWindow;
CarouselContent carouselContent;
MyScriptElement myScriptElement;

void main() {
  TextAreaElement serverResponseElem = query('#serverResponse');
  DivElement carousell = query('#mainCarousel');
  ScriptElement script = query('#myScript');
  serverResponseWindow = new ServerResponseWindow(serverResponseElem);
  carouselContent = new CarouselContent(carousell);
  
  serverConnection = new ServerConnection("ws://127.0.0.1:1337/ws", serverResponseWindow, carouselContent);
  
  myScriptElement = new MyScriptElement(script);
  myScriptElement.addCarousellFade();
}