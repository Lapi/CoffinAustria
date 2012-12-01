import 'dart:html';
import 'dart:core';
import 'package:puremvc/puremvc.dart';

InputElement toDoInput;
UListElement toDoList;

// comment
void main() {
  toDoInput = query('#to-do-input');
  toDoList = query('#to-do-list');
  toDoInput.on.change.add(addToDoItem);
  
  //query("#text")
  //..text = "Click me!"
  //..on.click.add(reverseText);
}

void addToDoItem(Event e) {
  var newToDo = new LIElement();
  newToDo.text = toDoInput.value.toString();
  toDoInput.value = '';
  toDoList.elements.add(newToDo);
}

//void reverseText(Event event) {
//  var text = query("#text").text;
//  var buffer = new StringBuffer();
//  for (int i = text.length - 1; i >= 0; i--) {
//    buffer.add(text[i]);
//  }
//  query("#text").text = buffer.toString();
//}
