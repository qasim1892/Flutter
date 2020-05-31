
import 'dart:async';

import 'package:flutter/material.dart';

class Bloc {
  StreamController<Widget> _bodyController=new StreamController<Widget>();
  Function get changeBody=>_bodyController.sink.add;
  Stream<Widget> get bodyStream=>_bodyController.stream;
  
  void dispose(){
    _bodyController.close();
  }
}
Bloc bloc=new Bloc();
