import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';



//-------------------------------TableRound

Container ctableRound(chair,name,mode,oChair,order,value) =>   Container(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      chair >= 4 ? chairR(getChairStatus(3,oChair)) :Container(),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          chairC(getChairStatus(1,oChair)),
          Container(
              height: 130,
              width: 130,
              decoration: value ==name? boxBaseDecoration(Colors.blueGrey, 200):boxBaseDecoration(getModeLightColor(chair,order,mode), 200),
              child: Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: boxBaseDecoration(getModeColor(chair,oChair,mode), 200),
                  child: Center(
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tc(name,Colors.white,15),
                        order == null ? Container():
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.menu,color: Colors.white,size: 15,),
                            gapWC(2),
                            tc(order.toString(),Colors.white,12)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
          ),
          chairC(getChairStatus(2,oChair)),
        ],

      ),
      chair >= 4 ? chairR(getChairStatus(4,oChair)) :Container(),
    ],
  ),
);

Container ctableRectangle(chair,name,mode,oChair,order,value) =>   Container(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // chair >= 12 ?
      // Column(
      //   children: [
      //     chairR(getChairStatus(9,oChair)),
      //     chairR(getChairStatus(10,oChair))
      //   ],
      // ) :Container(),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              chairC(getChairStatus(1,oChair)),
              chairC(getChairStatus(2,oChair)),
              chairC(getChairStatus(3,oChair)),
              chairC(getChairStatus(4,oChair)),
            ],
          ),
          Container(
              height: 130,
              width: 170,
              decoration: value ==name? boxBaseDecoration(Colors.blueGrey, 10):boxBaseDecoration(getModeLightColor(chair,order,mode), 10),
              child: Center(
                child: Container(
                  height: 100,
                  width: 150,
                  decoration: boxBaseDecoration(getModeColor(chair,oChair,mode), 10),
                  child: Center(
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tc(name,Colors.white,15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people,color: Colors.white,size: 15,),
                            gapWC(2),
                            tc(order.toString(),Colors.white,12),
                            gapWC(2),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              chairC(getChairStatus(5,oChair)),
              chairC(getChairStatus(6,oChair)),
              chairC(getChairStatus(7,oChair)),
              chairC(getChairStatus(8,oChair)),
            ],
          ),
        ],

      ),
      // chair >= 12 ?
      // Column(
      //   children: [
      //     chairR(getChairStatus(11,oChair)),
      //     chairR(getChairStatus(12,oChair))
      //   ],
      // ) :Container(),
    ],
  ),
);

Container ctableSquare(chair,name,mode,oChair,order,time,size,value) =>   Container(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      chair >= 8 ?
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          chairR(getChairStatus(5,oChair)),
          chairR(getChairStatus(6,oChair))
        ],
      ) :chair == 6 ?
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          chairR(getChairStatus(5,oChair))
        ],
      ) :Container(),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              chairC(getChairStatus(1,order)),
              chairC(getChairStatus(2,oChair)),
            ],
          ),
          Container(
              height: size.height*0.12,
              width: size.height*0.12,
              decoration: value ==name? boxBaseDecoration(Colors.blueGrey, 10):boxBaseDecoration(getModeLightColor(chair,order,mode), 10),
              child: Center(
                child: Container(
                  height: size.height*0.11,
                  width: size.height*0.11,
                  decoration: boxBaseDecoration(getModeColor(chair,order,mode), 10),
                  child: Center(
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tc(name,Colors.white,13),
                        order != 0   ?
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.food_bank_outlined,color: Colors.white,size: 15,),
                              tc(order.toString(),Colors.white,15),
                            ],
                          ),
                        ):Container()
                      ],
                    ),
                  ),
                ),
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              chairC(getChairStatus(3,oChair)),
              chairC(getChairStatus(4,oChair)),
            ],
          ),
        ],

      ),
      chair >= 8 ?
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          chairR(getChairStatus(7,oChair)),
          chairR(getChairStatus(8,oChair))
        ],
      ) :chair == 6 ?
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          chairR(getChairStatus(6,oChair))
        ],
      ) :Container(),
    ],
  ),
);


//-----------------------------------colors



