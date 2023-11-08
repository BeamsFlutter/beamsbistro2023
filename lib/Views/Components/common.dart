import 'package:auto_size_text/auto_size_text.dart';
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:beamsbistro/main.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';



//------------------------------------------------------Text Styles

Text ph1(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor), );
Text sh1(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 20,color: SecondaryColor), );

Text hh(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 25,color: PrimaryText), );

Text h1(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryText), );
Text h2(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 18,color: PrimaryText), );
Text h3(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 17,color: PrimaryText), );

Text hl1(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontSize: 25,color: PrimaryText), );
Text hl2(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontSize: 22,color: PrimaryText), );
Text hl3(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontSize: 20,color: PrimaryText), );

Text hs1(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 25,color: titleSubText), );
Text hs2(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 22,color: titleSubText), );
Text hs3(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 20,color: titleSubText), );

Text c1(text,color) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 25,color: color), );
Text c2(text,color) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 22,color: color), );
Text c3(text,color) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 20,color: color), );

Text ch(text,color) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 30,color: color), );
Text tc(text,color,double size) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: size,color: color), );
Text tc1(text,color,double size) => Text(text,style: GoogleFonts.poppins(fontSize: size,color: color,fontWeight: FontWeight.w500,), );
Text ts(text,color,double size) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontSize: size,color: color), );

Text s1(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 18,color: titleSubText), );
Text ss1(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 18,color: SecondaryColor), );
Text s2(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 16,color: titleSubText), );
Text s3(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 14,color: titleSubText), );
Text s4(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 12,color: titleSubText), );

Text sl3(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontSize: 14,color: titleSubText), );
Text sl4(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontSize: 12,color: titleSubText), );

Text iName(text,sts,priority) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontSize: 14,fontWeight: FontWeight.bold,color: sts == 'V'? Colors.red:( priority == 1? Colors.red : priority == 0? Colors.black : Colors.black ) ,decoration: sts == 'C'?TextDecoration.lineThrough:TextDecoration.none),);
Text lName(text,sts,priority) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontSize: 15,fontWeight: FontWeight.bold,color: priority == 1? Colors.red : priority == 0? Colors.black : Colors.black ,decoration: sts == 'C'?TextDecoration.lineThrough:TextDecoration.none),);

Text tc_normal(text, color, double size) => Text(text, style: TextStyle(fontFamily: 'Roboto', fontSize: size, color: color),);

Text tcn(text,color,double size) => Text(text,style: GoogleFonts.poppins(fontSize: size,color: color), );
Text tcl(text,color,double size) => Text(mfnLng(text),style: GoogleFonts.poppins(fontSize: size,color: color), );
Text th(text,color,double size) => Text(text,style: GoogleFonts.poppins(fontSize: size,color: color,fontWeight: FontWeight.bold), );

//-----------------------------------Menu Text

Text menuNameH(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontSize: 20,color: PrimaryText),);
Text menuNameS(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontSize: 14,color: PrimaryText),);
Text catH(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 16,color: Colors.blue),);
Text catS(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 13,color: PrimaryColor),);
Text descH(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 10,color: titleSubText),);
Text descC(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 8,color: titleSubText),);
Text priceH(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 20,color: PrimaryColor),);
Text priceS(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 15,color: titleSubText),);


//----------------------------------------------Table Text

Text tabH(text) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 30,color: Colors.black),);



//-------------------------------------------------Box Decarations
BoxDecoration boxOutlineInput(enablests, focusSts) => BoxDecoration(
    color: Colors.white,
    border: Border.all(
        color: enablests
            ? (focusSts ? PrimaryColor : Colors.black.withOpacity(0.5))
            : Colors.grey.withOpacity(0.5),
        width: 0.9,
    ),
    borderRadius: const BorderRadius.all(Radius.circular(5)),
);
BoxDecoration boxDecorationC(
    color,
    double l1,
    double l2,
    double r1,
    double r2,
    ) =>
    BoxDecoration(
        color: color,
        boxShadow: [
            BoxShadow(
                color: Colors.blueAccent.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
                offset: Offset(4, 4),
            ),
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(l1),
            topRight: Radius.circular(l2),
            bottomLeft: Radius.circular(r1),
            bottomRight: Radius.circular(r2)),
    );

BoxDecoration boxDecoration(color,double radius) => BoxDecoration(
color: color,
boxShadow: [
    BoxShadow(
    color: Colors.blueAccent.withOpacity(0.2),
    blurRadius: 8,
    spreadRadius: 1,
    offset: Offset(4, 4),
    ),
    ],
    borderRadius: BorderRadius.all(Radius.circular(radius)),
);
BoxDecoration boxOutlineCustom1(color,double radius,borderColor,width) => BoxDecoration(
    color: color,
    border: Border.all(
        color: borderColor,width: width,
    ),
    borderRadius: BorderRadius.all(Radius.circular(radius)),


);
BoxDecoration boxBaseDecoration(color,double radius) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.all(Radius.circular(radius)),
);
BoxDecoration boxBaseDecorationC(color,double tl,double tr,double bl,double br) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.only(topLeft: Radius.circular(tl),topRight:Radius.circular(tr) ,bottomLeft:Radius.circular(bl)  ,bottomRight:Radius.circular(br)  ),
);

BoxDecoration boxGradientDecoration(gradientNum,double radius) => BoxDecoration(

    gradient: LinearGradient(
        colors: GradientTemplate
            .gradientTemplate[gradientNum].colors,
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
    ),
    boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(4, 4),
        ),
    ],
    borderRadius: BorderRadius.all(Radius.circular(radius)),
);
BoxDecoration boxGradientDecorationS(gradientNum,double radius) => BoxDecoration(

    gradient: LinearGradient(
        colors: GradientTemplate
            .gradientTemplate[gradientNum].colors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
    ),
    boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(4, 4),
        ),
    ],
    borderRadius: BorderRadius.all(Radius.circular(radius)),
);
BoxDecoration boxGradientDecorationBase(gradientNum,double radius) => BoxDecoration(

    gradient: LinearGradient(
        colors: GradientTemplate
            .gradientTemplate[gradientNum].colors,
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
    ),

    borderRadius: BorderRadius.all(Radius.circular(radius)),
);
BoxDecoration boxGradientMainDecoration(gradientNum,double radius) => BoxDecoration(

    gradient: LinearGradient(
        colors: GradientTemplate
            .gradientTemplate[gradientNum].colors,
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
    ),
    boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(4, 4),
        ),
    ],
    borderRadius: BorderRadius.only(bottomRight: Radius.circular(radius),bottomLeft: Radius.circular(radius)),
);

BoxDecoration boxOutlineDecoration(color,double radius) => BoxDecoration(
    color: color,
    boxShadow: [

    ],
    border: Border.all(
        color: Colors.black87,width: 2.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(radius)),


);

BoxDecoration boxImageDecoration(img,double radius) => BoxDecoration(
    image: DecorationImage(
        image: AssetImage(img),
        fit: BoxFit.fill
    ),
    borderRadius: BorderRadius.all(Radius.circular(radius))
);
BoxDecoration boxImageDecorationC(img,double tl,double tr,double bl,double br,) => BoxDecoration(
    image: DecorationImage(
        image: AssetImage(img),
        fit: BoxFit.cover
    ),
    borderRadius: BorderRadius.only(topLeft:Radius.circular(tl),topRight:Radius.circular(tr),bottomLeft:Radius.circular(bl),bottomRight:Radius.circular(br)),
);

// --------------------------------------------------AppBar

AppBar mainAppBar(logout,fnSysytemInfo) => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: Container(
        margin: EdgeInsets.only(left:10),
        child: Icon(Icons.segment,color: PrimaryText,size: 30,),
    ),
    actions: [
        GestureDetector(
            onTap: (){
                fnSysytemInfo();
            },
            child: Container(
                height: 40,
                width: 50,
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: boxBaseDecoration(Colors.amber, 10),
                child: Icon(Icons.computer_sharp,color: Colors.black,size: 20,),
            ),
        ),
        Container(
            margin: EdgeInsets.only(right:20),
            child:  IconButton(onPressed: (){
                logout();
            }, icon: Icon(Icons.power_settings_new,color: PrimaryColor,size: 30,))
        )

    ],
);
AppBar mainAppBarMobile(logout,title,fnSysytemInfo) => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: Container(
        margin: EdgeInsets.only(left:10),
        child: Icon(Icons.segment,color: PrimaryText,size: 30,),
    ),
    title: tc(title, Colors.black, 17),
    actions: [
        GestureDetector(
            onTap: (){
                fnSysytemInfo();
            },
            child: Container(
                width: 50,
                margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                decoration: boxBaseDecoration(Colors.amber, 10),
                child: Icon(Icons.computer_sharp,color: Colors.black,size: 20,),
            ),
        ),
        Container(
            margin: EdgeInsets.only(right:20),
            child:  IconButton(onPressed: (){
                logout();
            }, icon: Icon(Icons.power_settings_new,color: PrimaryColor,size: 30,))
        )

    ],
);

AppBar navigationAppBar(context,fnPageBack) => AppBar(
    backgroundColor: Colors.white12,
    elevation: 0,
    leading: Container(
        margin: EdgeInsets.only(left:10),
        child: InkWell(
            onTap: (){
                fnPageBack();
            },
            child: Icon(Icons.arrow_back,color: Colors.black,size: 25,),
        ),
    ),
    actions: [
        Container(

        )

    ],
);
AppBar navigationTitleAppBar(context,title,fnPageBack) => AppBar(
    backgroundColor: Colors.white12,
    elevation: 0,
    leading: Container(
        margin: EdgeInsets.only(left:10),
        child: InkWell(
            onTap: (){
                fnPageBack();
            },
            child: Icon(Icons.arrow_back,color: Colors.black,size: 25,),
        ),
    ),
    title: tc(title,Colors.black,25),
    actions: [
        Container(

        )

    ],
);

//----------------------------------------------------margin

EdgeInsets pageMargin() =>  EdgeInsets.only(left: 25,right: 20,top: 0,bottom:0);
EdgeInsets gapMargin() =>  EdgeInsets.only(left: 5,right: 5,top: 0,bottom:0);

//---------------------------------------------------padding

EdgeInsets pagePadding() =>  EdgeInsets.all(10);

//-----------------------------------------------------gap

SizedBox gapH() => SizedBox(height: 20,);
SizedBox gapHC(double h) => SizedBox(height: h,);
SizedBox gapW() => SizedBox(width: 20,);
SizedBox gapWC(double w) => SizedBox(width: w,);


// --------------------------------------------------Screen

Scaffold pageScreen(child,Size size,context,fnPageBack) => Scaffold(
    appBar: navigationAppBar(context,fnPageBack),
    body: SafeArea(
        child: Container(
            height: size.height,
            width: size.width,
            padding: pagePadding(),
            margin: pageMargin(),
            child: SingleChildScrollView(
                child: child,
            ),
        ),
    ),
);
Scaffold pageMenuScreen(child,Size size,context,bottom,fnPageBack) => Scaffold(
    appBar: navigationAppBar(context,fnPageBack),
    bottomNavigationBar: bottom,
    body: SafeArea(
        child: Container(
            height: size.height,
            width: size.width,
            padding: pagePadding(),
            margin: pageMargin(),
            child: SingleChildScrollView(
                child: child,
            ),
        ),
    ),
);

Scaffold pageMenuScreen1(child, Size size, context, bottom, fnPageBack) =>
    Scaffold(
        // appBar: navigationAppBar(context, fnPageBack),
        bottomNavigationBar: bottom,
        body: SafeArea(
            child: Container(
                height: size.height,
                width: size.width,
                padding: pagePadding(),
                margin: pageMargin(),
                child: child,
            ),
        ),
    );
//--------------------------------------------Row

Row clockRow(text) => Row(
    children: [
        Icon(Icons.access_time_rounded, size: 15,),
        gapWC(5),
        tcn(text, Colors.black, 15)
    ],
);

Container itemName(name,sts,note,priority) => Container(
    padding:  EdgeInsets.symmetric(horizontal: 10,vertical: sts == 'C' ? 10 : sts == 'V' ? 10 :0) ,
    decoration: boxBaseDecoration(greyLight, 0),
    child: Container(
        margin: EdgeInsets.only(bottom: sts == 'C'? 0: 8,top: sts == 'C'? 0: 8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Expanded(child: iName(name,sts,priority)),
                        sts == 'D' ?
                        Icon(Icons.done_all_sharp,size: 22,color: Colors.grey,) :
                        sts == 'R' ?  Icon(Icons.food_bank_outlined,size: 22,color: Colors.orange,):
                        sts == 'P' ?  Icon(Icons.pending,size: 22,color: Colors.red,):
                        sts == 'V' ?  Icon(Icons.cancel_outlined,size: 22,color: Colors.red,):
                        sts == 'C' ?  Container()
                            :Container()

                    ],
                ),
                note == null || note == ''?Container():
                ts(note,Colors.black,12),
                sts == 'V' ?
                BlinkText(
                    'Canceled,Stop preparation',
                    style: TextStyle(fontSize: 14.0, color: Colors.red),
                    endColor: Colors.amber,
                ):Container(),
            ],
        )
    )
);

Container itemDetail(name,sts,note,priority,pendingChild) => Container(
    padding:  EdgeInsets.symmetric(horizontal: 10,vertical: sts == 'C' ? 10 : sts == 'V' ? 10 :0) ,
    decoration: boxBaseDecoration(greyLight, 0),
    child: Container(
        margin: EdgeInsets.only(bottom: sts == 'C'? 0: 5,top: sts == 'C'? 0: 5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Expanded(child: iName(name,sts,priority)),
                        sts == 'D' ?
                        Icon(Icons.done_all_sharp,size: 20,color: Colors.grey,) :
                        sts == 'R' ?  Icon(Icons.food_bank_outlined,size: 20,color: Colors.amber,):
                        sts == 'P' ? pendingChild :
                        sts == 'C' ?  Container()
                            :Container()

                    ],
                ),
                note == null || note == ''?Container():
                ts(note,Colors.black,12)
            ],
        )
    )
);

//----------------------------Number PRess

GestureDetector numberPress(text,fnOnPress) => GestureDetector(
  onTap: (){
      fnOnPress();
  },
  child: tc(text,titleSubText,50),
);

//------------------------------ CommonChair

Container chairC(mode) => Container(
    height: 15,
    width: 25,
    margin: EdgeInsets.all(3),
    decoration: boxDecoration(getModeChairColor(mode), 5),
);
Container chairR(mode) => Container(
    height: 25,
    width: 15,
    margin:  EdgeInsets.all(3),
    decoration: boxDecoration(getModeChairColor(mode), 5),
);

//-------------------------------TableRound

Container tableRound(chair,name,mode,oChair,order) =>   Container(
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
                        decoration: boxBaseDecoration(getModeLightColor(chair,oChair,mode), 200),
                        child: Center(
                            child: Container(
                                height: 100,
                                width: 100,
                                decoration: boxBaseDecoration(getModeColor(chair,oChair,mode), 200),
                                child: Center(
                                    child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            tc(name,Colors.white,20),
                                            order == null ? Container():
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                    Icon(Icons.menu,color: Colors.white,size: 15,),
                                                    gapWC(2),
                                                    tc('3',Colors.white,12)
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

Container tableRectangle(chair,name,mode,oChair) =>   Container(
    child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            chair >= 12 ?
            Column(
                children: [
                    chairR(getChairStatus(9,oChair)),
                    chairR(getChairStatus(10,oChair))
                ],
            ) :Container(),
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
                        width: 200,
                        decoration: boxBaseDecoration(getModeLightColor(chair,oChair,mode), 10),
                        child: Center(
                            child: Container(
                                height: 100,
                                width: 170,
                                decoration: boxBaseDecoration(getModeColor(chair,oChair,mode), 10),
                                child: Center(
                                    child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            tc(name,Colors.white,20),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                    Icon(Icons.people,color: Colors.white,size: 15,),
                                                    gapWC(2),
                                                    tc('8',Colors.white,12),
                                                    gapWC(2),
                                                    Icon(Icons.access_time_outlined,color: Colors.white,size: 15,),
                                                    gapWC(2),
                                                    tc('30min',Colors.white,12)
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
            chair >= 12 ?
            Column(
                children: [
                    chairR(getChairStatus(11,oChair)),
                    chairR(getChairStatus(12,oChair))
                ],
            ) :Container(),
        ],
    ),
);

Container tableSquare(chair,name,mode,oChair,order,time,size) =>   Container(
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
                        height: size.width*0.15,
                        width: size.width*0.15,
                        decoration: boxBaseDecoration(getModeLightColor(chair,order,mode), 10),
                        child: Center(
                            child: Container(
                                height: size.width*0.13,
                                width: size.width*0.13,
                                decoration: boxBaseDecoration(getModeColor(chair,order,mode), 10),
                                child: Center(
                                    child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            tc(name,Colors.white,20),
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


getModeColor(chair,oChair,mode){

    Color modeColor= emptyTable;

    if(mode == 'K'){
        modeColor= Colors.blue;
    } else if(mode == 'P'){
        modeColor= fullTable;
    }else if (mode == 'E'){
        modeColor= emptyTable;
    }else if (mode == 'R'){
        modeColor= Colors.orange;
    }else if(mode == "D"){
        modeColor = Colors.blue;
    }

    return modeColor;
}

getModeLightColor(chair,oChair,mode){

    Color modeColor= emptyTableLight;

    if(mode == 'K'){
        modeColor= freeTableLight;
    }else if(mode == 'P'){
        modeColor= fullTableLight;
    }else if (mode == 'E'){
        modeColor= freeTableLight;
    }else if (mode == 'R'){
        modeColor= fullTableLight;
    }else if(mode == "D"){
        modeColor = emptyTableLight;
    }

    return modeColor;
}

getModeChairColor(mode){
    Color modeColor= freeChair;
    if(mode == 'O'){
        modeColor= activeChair;
    }

    return modeColor;
}

getChairStatus(chair,oChair){
    var sts = 'F';
    if(chair <= oChair){
        sts = 'O' ;
    }
    return sts;
}



//---------------- Card

Container floorCard(mode,text) => Container(
height: 50,
padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
margin: EdgeInsets.only(right: 10),
decoration: boxBaseDecoration(mode == 'Y' ? PrimaryColor :SecondarySubColor, 20),
child: Center(
    child: tc(text, mode == 'Y' ? Colors.white : PrimaryText,18),
),
);

Container categoryCard(mode,text) => Container(
    height: 50,
    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
    margin: EdgeInsets.only(left: 10),
    decoration: boxDecoration(mode == 'Y' ? PrimaryColor :SecondarySubColor, 15),
    child: Center(
        child: tc(text, mode == 'Y' ? Colors.white : PrimaryText,18),
    ),
);

Container orderCard(mode,text) => Container(
    height: 50,
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.only(right: 7),
    decoration: boxBaseDecoration(mode == 'Y' ? PrimaryColor :SecondarySubColor, 10),
    child: Center(
        child: tc(text, mode == 'Y' ? Colors.white : PrimaryText,18),
    ),
);



Container posCard(mode,text) => Container(
    height: 40,
    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
    margin: EdgeInsets.only(left: 10),
    decoration: boxBaseDecoration(mode == 'Y' ?SubColor : Colors.white,5),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            tcn(mfnLng(text),  Colors.black,15),
            Container(),
        ],
    ),
);


//---------------------------------------------------------- Line

Container line() => Container(
    height: 1,
    decoration: boxBaseDecoration(Colors.grey, 1),
);
Container lineC(h,color) => Container(
    height: h,
    decoration: boxBaseDecoration(color, 1),
);

//--------------------------------------------------Date


// -------------------- Offline and Online Check ----------------------------


//------------------------------------Animation-------------------------------

AnimationLimiter animColumn(children) => AnimationLimiter(child:
Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: AnimationConfiguration.toStaggeredList(
        duration: const Duration(milliseconds: 200),
        childAnimationBuilder: (widget) => ScaleAnimation(
            child: FadeInAnimation(child: widget),
        ),
        children: children,
    ),
)
);


setDate(mode,DateTime date){
    var dateRtn  = "";
    var formatDate1 = DateFormat('yyyy-MM-dd hh:mm:ss');
    var formatDate2 = DateFormat('yyyy-MM-dd');
    var formatDate3 = DateFormat('yyyy-MM-dd hh:mm');
    var formatDate4 = DateFormat('yyyy-MM-dd hh:mm:ss a');
    var formatDate5 = DateFormat('hh:mm:ss a');
    var formatDate6 = DateFormat('dd-MM-yyyy');
    var formatDate7 = DateFormat('dd-MM-yyyy hh:mm:ss a');
    var formatDate8 = DateFormat('dd-MM-yyyy hh:mm:ss');
    var formatDate9 = DateFormat('dd-MM-yyyy hh:mm');
    var formatDate10 = DateFormat('hh:mm:ss');
    var formatDate11 = DateFormat('hh:mm a');
    var formatDate12 = DateFormat('yyyy-MM-dd');
    var formatDate13 = DateFormat('dd-MMM-yyyy');
    var formatDate14 = DateFormat('MMMM');
    var formatDate15 = DateFormat('dd MMM yyyy');

    try{
        switch(mode){
            case 1:{
                dateRtn =  formatDate1.format(date);
            }
            break;
            case 2:{
                dateRtn =  formatDate2.format(date);
            }
            break;
            case 3:{
                dateRtn =  formatDate3.format(date);
            }
            break;
            case 4:{
                dateRtn =  formatDate4.format(date);
            }
            break;
            case 5:{
                dateRtn =  formatDate5.format(date);
            }
            break;
            case 6:{
                dateRtn =  formatDate6.format(date);
            }
            break;
            case 7:{
                dateRtn =  formatDate7.format(date);
            }
            break;
            case 8:{
                dateRtn =  formatDate8.format(date);
            }
            break;
            case 9:{
                dateRtn =  formatDate9.format(date);
            }
            break;
            case 10:{
                dateRtn =  formatDate10.format(date);
            }
            break;
            case 11:{
                dateRtn =  formatDate11.format(date);
            }
            break;
            case 12:{
                dateRtn =  formatDate12.format(date);
            }
            break;
            case 13:{
                dateRtn =  formatDate13.format(date);
            }
            break;
            case 14:{
                dateRtn =  formatDate14.format(date);
            }
            break;
            case 15:{
                dateRtn =  formatDate15.format(date);
            }
            break;
            default: {
                //statements;
            }
            break;

        }



    }catch(e){
        if (kDebugMode) {
            print(e);
        }
    }

    return dateRtn;

}

//===========================================================MASTER MENU
Widget masterMenu(fnCallBack, mode) {
    return ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    menuCard(
                        Icons.add, fnCallBack, "ADD", mode == "VIEW" ? true : false),
                    menuCard(
                        Icons.save, fnCallBack, "SAVE", mode != "VIEW" ? true : false),
                    menuCard(
                        Icons.edit, fnCallBack, "EDIT", mode == "VIEW" ? true : false),
                    menuCard(Icons.first_page, fnCallBack, "FIRST",
                        mode == "VIEW" ? true : false),
                    menuCard(Icons.navigate_before_sharp, fnCallBack, "BACK",
                        mode == "VIEW" ? true : false),
                    menuCard(Icons.navigate_next_sharp, fnCallBack, "NEXT",
                        mode == "VIEW" ? true : false),
                    menuCard(Icons.last_page_outlined, fnCallBack, "LAST",
                        mode == "VIEW" ? true : false),
                    menuCard(Icons.attach_file, fnCallBack, "ATTACH",
                        mode == "VIEW" ? true : false),
                    menuCard(Icons.delete_sweep_outlined, fnCallBack, "DELETE",
                        mode == "VIEW" ? true : false),
                    menuCard(Icons.access_time_sharp, fnCallBack, "LOG",
                        mode == "VIEW" ? true : false),
                    menuCard(Icons.help, fnCallBack, "HELP", true),
                    menuCard(Icons.cancel, fnCallBack, "CLOSE",
                        mode != "VIEW" ? true : false),
                ],
            ),
        ));
}

Widget menuCard(icon, fnCallBack, mode, pagemode) {
    return Bounce(
        duration: Duration(milliseconds: 110),
        onPressed: () {
            if (pagemode) {
                fnCallBack(mode);
            }
        },
        child: Container(
            margin: EdgeInsets.only(right: 5),
            height: 25,
            width: 40,
            decoration: boxBaseDecoration(Colors.white, 5),
            child: Center(
                child: Icon(
                    icon,
                    size: 15,
                    color: pagemode ? PrimaryColor : greyLight,
                ),
            ),
        ),
    );
}

Widget closeButton() {
    return Container(
        height: 25,
        width: 100,
        decoration: boxDecoration(SubColor, 30),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 12,
                ),
                gapWC(5),
                tcn('CANCEL', Colors.black, 10)
            ],
        ),
    );
}

Widget saveButton() {
    return Container(
        height: 25,
        width: 100,
        decoration: boxDecoration(PrimaryColor, 30),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Icon(
                    Icons.save,
                    color: Colors.white,
                    size: 12,
                ),
                gapWC(5),
                tcn('SAVE', Colors.white, 10)
            ],
        ),
    );
}

//============================================================Message

errorMsg(context, msg) {
    PageDialog().showMessage(context, msg, "CLOSE", "E", "");
}

successMsg(context, msg) {
    PageDialog().showMessage(context, msg, "CLOSE", "S", "");
}

warningMsg(context, msg) {
    PageDialog().showMessage(context, msg, "CLOSE", "W", "");
}

infoMsg(context, msg) {
    PageDialog().showMessage(context, msg, "CLOSE", "I", "");
}

customMsg(context, msg, icon) {
    PageDialog().showMessage(context, msg, "CLOSE", "C", icon);
}

msgBox(context, msg, mode, icon) {
    PageDialog().showMessage(context, msg, "", mode, icon);
}

mfnLng(text){
    var g = Global();
    var rtnText = text;
    if(g.fnValCheck(g.wstrLanguage)){
        var data =  g.wstrLanguage.where((element) => element["ENGLISH"].toString().toLowerCase() == text.toString().toLowerCase()).toList();
        try{
            rtnText =  (data[0][g.wstrBistroLng.toString()]??text).toString();
        }catch(e){
            rtnText = text;
        }
    }
    if(rtnText.toString().isEmpty){
        rtnText = text;
    }
    return rtnText.toString();
}

Widget customBButtonFlat(title,bgcolor,forcolor,icon){
    return Container(
        height: 35,
        decoration: boxBaseDecoration(bgcolor, 30),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Icon(icon,color: forcolor,size: 15,),
                gapWC(5),
                tcn(title, forcolor, 12)
            ],
        ),
    );
}
