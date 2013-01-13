library MyScriptElement;

import 'dart:html';
import '../View.dart';

class MyScriptElement extends View<ScriptElement> {
  MyScriptElement(ScriptElement elem) : super(elem);
  
  addCarousellFade() {
    elem.src = 'js/fade.js';
  }
}