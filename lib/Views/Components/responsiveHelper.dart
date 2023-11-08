import 'package:flutter/material.dart';


class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tab;
  final Widget windows;
  const ResponsiveWidget({Key? key, required this.mobile, required this.tab, required this.windows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      if(constraints.maxWidth  < 630){
        return mobile;
      }else if(constraints.maxWidth  < 810){
        return tab;
      }else{
        return windows;
      }
    });

  }
}

class ResponsiveWidgetAlert extends StatelessWidget {
  final Widget mobile;
  final Widget tab;
  final Widget windows;
  const ResponsiveWidgetAlert({Key? key, required this.mobile, required this.tab, required this.windows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      if(constraints.maxWidth  < 500){
        return mobile;
      }else if(constraints.maxWidth  < 700){
        return tab;
      }else{
        return windows;
      }
    });

  }
}
