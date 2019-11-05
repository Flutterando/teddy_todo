import 'package:flutter/material.dart';

class NavigateService {

  final _globalKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get globalKey => _globalKey;

  push(Route route){
   return _globalKey.currentState.push(route);
  }

  pushReplacement(Route route){
   return _globalKey.currentState.pushReplacement(route);
  }

  pop([result]){
   return _globalKey.currentState.pop(result);
  }

}
