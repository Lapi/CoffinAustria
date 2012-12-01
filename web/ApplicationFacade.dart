import 'dart:html';
import 'dart:core';
import 'package:puremvc/puremvc.dart';

class ApplicationFacade extends Facade implements IFacade{
  static const String STARTUP = "startup";
  static const String LOGIN = "login";
}
