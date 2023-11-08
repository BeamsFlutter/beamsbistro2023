import 'package:flutter/material.dart';

class LookupLayout extends StatefulWidget {
  final String ? lstrLayoutName;
  final lstrData;
  final String ? lstrSearchVal;
  const LookupLayout({Key ? key,
    this.lstrLayoutName,
    this.lstrData,
    this.lstrSearchVal,
  }) : super(key: key);

  @override
  _LookupLayoutState createState() => _LookupLayoutState();
}

class _LookupLayoutState extends State<LookupLayout> {
  late String lstrLayoutname;
  var lstrData;
  late String lstrSearchVal;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lstrLayoutname = widget.lstrLayoutName!;
    lstrData = widget.lstrData;
    lstrSearchVal = widget.lstrSearchVal!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: getLayout(),
    );
  }
  Widget getLayout(){
    if(lstrLayoutname == ''){
      return Container();
    }else{
      return Container();
    }
  }


}
