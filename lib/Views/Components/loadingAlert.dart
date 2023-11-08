import 'package:flutter/material.dart';

class LoadingAlert{
  Future<void> showLoading(context) async {
    return showDialog<void>(

      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: 100,
            margin: EdgeInsets.only(left: 20,right: 20),
            decoration: BoxDecoration(
              color: Colors.white,

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: Offset(4, 4),
                ),
              ],
              borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft:Radius.circular(20),bottomLeft:Radius.circular(20), bottomRight:Radius.circular(20)  ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.pink,
                ),
                SizedBox(height: 8),
                Text('Loading...'),
              ],
            ),
          )
        );
      },
    );
  }


}