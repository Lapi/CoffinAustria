library coffin;

import 'dart:html';
import 'dart:core';
import 'applib/CoffinController.dart';
import 'applib/controls/ServerResponseWindow.dart';
import 'applib/controls/CarouselContent.dart';
import 'applib/controls/MyScriptElement.dart';

CoffinController coffinController;
ServerResponseWindow serverResponseWindow;
CarouselContent carouselContent;
MyScriptElement myScriptElement;

void main() {
  TextAreaElement serverResponseElem = query('#serverResponse');
  DivElement carousell = query('#mainCarousel');
  ScriptElement script = query('#myScript');
  serverResponseWindow = new ServerResponseWindow(serverResponseElem);
  carouselContent = new CarouselContent(carousell);
  
  coffinController = new CoffinController(serverResponseWindow, carouselContent);
  
  myScriptElement = new MyScriptElement(script);
  myScriptElement.addCarousellFade();
}