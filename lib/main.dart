

import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:beamsbistro/Views/Pages/dualdisplay/dualdisplay.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:window_manager/window_manager.dart';
import 'Views/Pages/Loading/loadingPage.dart';

void main() async{
  await init();
  runApp(MyApp());

  // if(Platform.isWindows){
  //   windowManager.waitUntilReadyToShow().then((_) async{
  //     await windowManager.setAsFrameless();
  //   });
  // }

}

Future init() async {
  // if(!kIsWeb){
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  // }

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return OKToast(
        position: ToastPosition.bottom,
        child:MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bistro',
          home: Directionality(
              textDirection: TextDirection.ltr  ,
              child: Loading()),
        )
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

