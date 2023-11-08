
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';


class AddTable extends StatefulWidget {
  const AddTable({Key? key}) : super(key: key);

  @override
  _AddTableState createState() => _AddTableState();
}

class _AddTableState extends State<AddTable> {

  var tableChairs = 0;
  var tableType = '';
  var tableName = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: navigationAppBar(context,fnPageBack),
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          padding: pagePadding(),
          margin: pageMargin(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: size.height * 0.8,
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     // tableSquare(8, tableName, 'N', tableChairs),
                      gapHC(50),
                      GestureDetector(
                        onTap: (){

                          fnUpdateChair();
                        },
                        child: Container(
                          height: 60,
                          width: 300,
                          decoration: boxDecoration(Colors.red, 20),
                          child: Center(
                            child: tc('ADD CHAIR',Colors.white,20),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  fnUpdateChair(){
    setState(() {
      tableChairs = tableChairs + 1;
    });
  }

  fnPageBack(){

  }
}

