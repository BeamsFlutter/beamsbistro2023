
import 'package:beamsbistro/Views/Components/message_box.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common.dart';

class PageDialog{
  Future<void> show(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: size.width*0.9,
                height: size.height*0.63,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        h3(headName),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 30,))
                      ],
                    ),
                    gapHC(5),
                    Container(
                      height: size.height*0.5,
                      child: SingleChildScrollView(
                          child: Column(
                            children: [
                              child
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> showNote(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: size.width*0.9,
                height: size.height*0.53,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          h3(headName),
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 30,))
                        ],
                      ),
                      gapHC(5),
                      Expanded(
                        child: Container(
                          child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  child
                                ],
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                )

            )
        );
      },
    );
  }
  Future<void> showClosing(context,child,headName,close) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: size.width*0.4,
                height: size.height*0.9,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        h3(headName),
                        // IconButton(onPressed: (){
                        //   Navigator.pop(context);
                        //   close();
                        // }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 30,))
                      ],
                    ),
                    gapHC(5),
                    Expanded(
                      child: child,
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> showNoteS(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: size.width*0.53,
                height: size.height*0.53,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          h3(headName),
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 30,))
                        ],
                      ),
                      gapHC(5),
                      Container(
                        height: size.height*0.4,
                        child: SingleChildScrollView(
                            child: Column(
                              children: [
                                child
                              ],
                            )
                        ),
                      )
                    ],
                  ),
                )

            )
        );
      },
    );
  }
  Future<void> showSysytemInfo(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: size.width*0.35,
                height: size.height*0.5,
                decoration: boxDecoration(Colors.white, 30),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        h3(headName),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 30,))
                      ],
                    ),
                    gapHC(5),
                    Expanded(child:  child)
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> showRequest(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 350,
                height: 200,
                decoration: boxDecoration(Colors.white, 30),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        h3(headName),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 30,))
                      ],
                    ),
                    gapHC(5),
                    Expanded(child:  child)
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> showItems(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: size.width*0.8,
                height: size.height*0.8,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        h3(headName),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 30,))
                      ],
                    ),
                    gapHC(5),
                    Container(
                      height: size.height*0.68,
                      child: SingleChildScrollView(
                          child: Column(
                            children: [
                              child
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }

  Future<void> showPos(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return StatefulBuilder(builder: (context,setState){
          return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                  width: 500,
                  height: size.height*0.8,
                  decoration: boxDecoration(Colors.white, 10),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          h3(headName),
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 30,))
                        ],
                      ),
                      gapHC(5),
                      Container(
                        height: size.height*0.65,
                        child: SingleChildScrollView(
                            child: Column(
                              children: [
                                child
                              ],
                            )
                        ),
                      )
                    ],
                  )

              )
          );
        });
      },
    );
  }
  Future<void> showL(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: size.width*0.9,
                height: 700,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tc(headName,Colors.black,15),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 40,))
                      ],
                    ),
                    gapHC(5),
                    Expanded(child: child)
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> showS(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: size.width*0.5,
                height: 700,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        h3(headName),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 40,))
                      ],
                    ),
                    gapHC(5),
                    Expanded(child: child)
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> showPayment(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 500,
                height: 380,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        tc("CARD PAYMENT" , Colors.black, 12),
                      ],
                    ),
                    gapHC(5),
                    Expanded(child: child)
                  ],
                )

            )
        );
      },
    );
  }

  Future<void> deleteDialog(context,fnDelete) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 300,
                height: 200,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        h3('Delete'),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 30,))
                      ],
                    ),
                    gapHC(5),

                    Container(
                      height: 100,
                      width: 300,
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              h3('Do you want to delete ?'),
                              gapHC(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      fnDelete();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 60,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.green, 10),
                                      child: Center(
                                        child: tc('Yes', Colors.white, 15),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> cancelDialog(context,fnCancel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 300,
                height: 200,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        h3('Cancel'),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 30,))
                      ],
                    ),
                    gapHC(5),

                    Container(
                      height: 100,
                      width: 300,
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              h3('Do you want to cancel ?'),
                              gapHC(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      fnCancel();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 60,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.green, 10),
                                      child: Center(
                                        child: tc('Yes', Colors.white, 15),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> clockinDialog(context,fnClockOut,fnLogin,shift,clockInDate) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 500,
                height: 250,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tc(mfnLng('CLOCK-OUT'),Colors.red,18),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 30,))
                      ],
                    ),
                    gapHC(5),
                    Expanded(
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Row(
                               children: [
                                 tc(mfnLng('Your last CLOCK-IN'),Colors.black,18),
                               ],
                             ),
                            gapHC(10),
                            Row(
                              children: [
                                Icon(Icons.query_builder,color: Colors.black.withOpacity(0.8),size: 16,),
                                gapWC(10),
                                tc(shift.toString(),Colors.black.withOpacity(0.8),16),
                              ],
                            ),
                            gapHC(5),
                            Row(
                              children: [
                                Icon(Icons.today_sharp,color: Colors.black.withOpacity(0.8),size: 16,),
                                gapWC(10),
                                tc(clockInDate.toString(),Colors.black.withOpacity(0.8),16),
                              ],
                            ),
                          ],
                        )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            fnClockOut();
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            margin: EdgeInsets.only(right: 5),
                            decoration: boxDecoration(Colors.red, 20),
                            child: Center(
                              child: tc(mfnLng('CLOCK-OUT'), Colors.white, 15),
                            ),
                          ),
                        ),
                        gapW(),
                        GestureDetector(
                          onTap: (){
                            fnLogin();
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            margin: EdgeInsets.only(right: 5),
                            decoration: boxDecoration(Colors.green, 20),
                            child: Center(
                              child: tc(mfnLng('Continue'), Colors.white, 15),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> clockOutDialog(context,fnClockOut,shift,clockInDate) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 500,
                height: 300,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        h3('CLOCK-OUT'),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 30,))
                      ],
                    ),
                    gapHC(5),

                    Container(
                      height: 200,
                      width: 300,
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              h2('Your last CLOCK-IN'),
                              h3(shift.toString()),
                              h3(clockInDate.toString()),
                              gapHC(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      fnClockOut();
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 110,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.red, 10),
                                      child: Center(
                                        child: tc('CLOCK-OUT', Colors.white, 15),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> clearDialog(context,fnClear) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 300,
                height: 200,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        h3('Clear'),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 30,))
                      ],
                    ),
                    gapHC(5),

                    Container(
                      height: 100,
                      width: 300,
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              h3('Do you want to remove items ?'),
                              gapHC(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      fnClear();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 60,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.green, 10),
                                      child: Center(
                                        child: tc('Yes', Colors.white, 15),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> printDialog(context,fnPrint) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 300,
                height: 200,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        h3('Print'),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 30,))
                      ],
                    ),
                    gapHC(5),

                    Container(
                      height: 100,
                      width: 300,
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              h3('Do you want to print ?'),
                              gapHC(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 60,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.red, 10),
                                      child: Center(
                                        child: tc('No', Colors.white, 15),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      fnPrint();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 60,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.green, 10),
                                      child: Center(
                                        child: tc('Yes', Colors.white, 15),
                                      ),
                                    ),
                                  ),

                                ],
                              )
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> saveDialog(context,fnSave) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 300,
                height: 200,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        h3('Save'),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.highlight_remove_sharp,color: PrimaryText,size: 30,))
                      ],
                    ),
                    gapHC(5),

                    Container(
                      height: 100,
                      width: 300,
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              h3('Do you want to save ?'),
                              gapHC(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 60,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.red, 10),
                                      child: Center(
                                        child: tc('No', Colors.white, 15),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      fnSave();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 60,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.green, 10),
                                      child: Center(
                                        child: tc('Yes', Colors.white, 15),
                                      ),
                                    ),
                                  ),

                                ],
                              )
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }

  fnShow(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return CupertinoActivityIndicator(
          animating: true,
          radius: 50,
        );
      },
    );
  }
  closeAlert(BuildContext context){
    Navigator.pop(context);
  }
  Future<void> show_(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                height: 500,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              child
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }

  Future<void> showMessage(context, msg, type, mode, icon) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(

            backgroundColor: Colors.transparent,
            content: icon == ""
                ? MessageBox(msg: msg, type: type, mode: mode)
                : MessageBox(
              msg: msg,
              type: type,
              mode: mode,
              icon: icon,
            ));
      },
    );
  }

}