library CarouselContent;

import 'dart:html';
import '../View.dart';

class CarouselContent extends View<DivElement> {
  int counter = 0;
  CarouselContent(DivElement elem) : super(elem);
  
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
  
  compose(var transferObject) {
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
    
    tempList.forEach(this.add);
  }
}