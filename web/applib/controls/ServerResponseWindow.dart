library ServerResponseWindow;

import 'dart:html';
import '../View.dart';

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
