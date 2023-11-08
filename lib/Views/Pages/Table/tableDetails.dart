
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';

class TableDetails extends StatefulWidget {
  const TableDetails({Key? key}) : super(key: key);

  @override
  _TableDetailsState createState() => _TableDetailsState();
}

class _TableDetailsState extends State<TableDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return pageScreen(
        Container(
          child: Column(

          ),
        ),
        size,context,fnBack);
  }
  fnBack(){

  }
}

