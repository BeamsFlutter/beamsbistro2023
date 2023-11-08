
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/responsiveHelper.dart';
import 'package:beamsbistro/Views/Pages/Login/userLogin.dart';
import 'package:beamsbistro/Views/Pages/Menu/menu.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double mainCardHeight = 125;
    double mobileCardHeight = 90;
    double rowCardHeight = 150;

    return Scaffold(
      appBar: mainAppBar(fnLogout,fnSysytemInfo),
      body: SafeArea(
        child: Container(
          height: size.height * 0.9,
          width: size.width,
          margin: pageMargin(),
          child: SingleChildScrollView(
            child: ResponsiveWidget(
              windows: Container(
                child: Column(
                  children: <Widget>[
                    h1(mfnLng('Pos Window')),
                    TextFormField(
                    )
                  ],
                ),
              ),
              mobile: view(mobileCardHeight, size, rowCardHeight),
              tab : view(mainCardHeight, size, rowCardHeight)
            ),
          ),
        )
      ),
    );
  }

  Column view(double mainCardHeight, Size size, double rowCardHeight) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                gapH(),
                hh('Hi,'),
                hh('Benjamin'),
                gapH(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: mainCardHeight,
                      width: size.width*0.44,
                      padding: pagePadding(),
                      decoration: boxGradientDecoration(12,20),
                      child: mainCardText('Take','Order'),
                    ),
                    gapW(),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Menu()));
                      },
                      child: Container(
                        height: mainCardHeight,
                        width: size.width*0.44,
                        decoration:  boxGradientDecoration(11,20),
                        padding: pagePadding(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                gapH(),
                                h2('Quick'),
                                hh('Order')
                              ],
                            ),
                            Container(
                              height: 80,
                              width: 80,
                              margin: EdgeInsets.only(right: 10),
                              decoration: boxDecoration(Colors.white, 100),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                gapH(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: mainCardHeight,
                      width: size.width*0.44,
                      padding: pagePadding(),
                      decoration:  boxGradientDecoration(12,20),
                      child: mainCardText('Table','Status'),

                    ),
                    gapW(),
                    Container(
                      height: mainCardHeight,
                      width: size.width*0.44,
                      decoration:  boxGradientDecoration(12,20),
                      padding: pagePadding(),
                      child: mainCardText('Table','Reservation'),
                    )
                  ],
                ),
                gapH(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        width: size.width*0.28,
                        height: rowCardHeight,
                        decoration: boxBaseDecoration(greyLight, 10),
                        padding: pagePadding(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Image.asset("assets/icons/dining.png",
                              width: 100,),
                            h2('Dine In')
                          ],
                        ),
                      ),
                    ),
                    gapW(),
                    Container(
                      width: size.width*0.28,
                      height: rowCardHeight,
                      decoration: boxBaseDecoration(greyLight, 10),
                      padding: pagePadding(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Image.asset("assets/icons/takeaway.png",
                            width: 70,),
                          gapH(),
                          h2('Take Away')
                        ],
                      ),
                    ),
                    gapW(),
                    Container(
                      width: size.width*0.28,
                      height: rowCardHeight,
                      decoration: boxBaseDecoration(greyLight, 10),
                      padding: pagePadding(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Image.asset("assets/icons/delivery.png",
                            width: 70,),
                          gapHC(12),
                          h2('Delivery')

                        ],
                      ),
                    )
                  ],
                ),
                gapH(),
                Container(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      h2('Active Order'),
                      ss1('See All')
                    ],
                  ),
                ),
                gapH(),
                Container(
                  height: 185,
                  padding: pagePadding(),
                  decoration: boxBaseDecoration(BaseLight, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          height: 140,
                          width: 350,
                          margin: gapMargin(),
                          padding: pagePadding(),
                          decoration: boxDecoration(Colors.white, 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gapHC(3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  h3('#TB100'),
                                  Container(
                                    height: 25,
                                    padding: EdgeInsets.all(5),
                                    decoration: boxDecoration(Colors.grey, 5),
                                    child: Center(
                                      child: tc('QUEUE',Colors.white,12),
                                    ),
                                  )
                                ],
                              ),
                              gapHC(12),
                              Container(
                                height: 45,
                                child: tc('Biriyani x3 , Tea x3 , Choco x6',Colors.grey,15),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  h1('T1,T2'),
                                  Row(
                                    children: [
                                      s2('12:30 pm '),
                                      Icon(Icons.access_time,size: 20, color: Colors.grey,),
                                      s2(' 00:30'),
                                    ],
                                  )
                                ],
                              )

                            ],
                          ),
                        ),
                        Container(
                          height: 140,
                          width: 350,
                          margin: gapMargin(),
                          padding: pagePadding(),
                          decoration: boxDecoration(Colors.white, 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gapHC(3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  h3('#TB098'),
                                  Container(
                                    height: 25,
                                    padding: EdgeInsets.all(5),
                                    decoration: boxDecoration(SecondaryColor, 5),
                                    child: Center(
                                      child: tc('Preparing',Colors.white,12),
                                    ),
                                  )
                                ],
                              ),
                              gapHC(12),
                              Container(
                                height: 45,
                                child: tc('Tea x3 , Coffe x6',Colors.grey,15),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  h1('T4'),
                                  Row(
                                    children: [
                                      s2('12:22 pm '),
                                      Icon(Icons.access_time,size: 20, color: Colors.grey,),
                                      s2(' 00:16'),
                                    ],
                                  )
                                ],
                              )

                            ],
                          ),
                        ),
                        Container(
                          height: 140,
                          width: 350,
                          margin: gapMargin(),
                          padding: pagePadding(),
                          decoration: boxDecoration(Colors.white, 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gapHC(3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  h3('#TB097'),
                                  Container(
                                    height: 25,
                                    padding: EdgeInsets.all(5),
                                    decoration: boxDecoration(Colors.green, 5),
                                    child: Center(
                                      child: tc('Ready',Colors.white,12),
                                    ),
                                  )
                                ],
                              ),
                              gapHC(12),
                              Container(
                                height: 45,
                                child: tc('Biriyani x3 , Tea x3 , Choco x6',Colors.grey,15),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  h1('T6'),
                                  Row(
                                    children: [
                                      s2('11:48 am '),
                                      Icon(Icons.access_time,size: 20, color: Colors.grey,),
                                      s2(' 00:38'),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 140,
                          width: 350,
                          margin: gapMargin(),
                          padding: pagePadding(),
                          decoration: boxDecoration(Colors.white, 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gapHC(3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  h3('#TB100'),
                                  Container(
                                    height: 25,
                                    padding: EdgeInsets.all(5),
                                    decoration: boxDecoration(Colors.grey, 5),
                                    child: Center(
                                      child: tc('QUEUE',Colors.white,12),
                                    ),
                                  )
                                ],
                              ),
                              gapHC(12),
                              Container(
                                height: 45,
                                child: tc('Biriyani x3 , Tea x3 , Choco x6',Colors.grey,15),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  h1('T1,T2'),
                                  Row(
                                    children: [
                                      s2('12:30 pm '),
                                      Icon(Icons.access_time,size: 20, color: Colors.grey,),
                                      s2(' 00:30'),
                                    ],
                                  )
                                ],
                              )

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                gapH(),
                h2('Order Status'),
                ResponsiveWidget(mobile: h1('Mobile'), tab: h1('Tab'), windows: h1('Window'))
              ],
            );
  }

  Row mainCardText(t1,t2) {
    return Row(
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             gapH(),
             c2(t1,Colors.white),
             ch(t2,Colors.white)
           ],
         ),
       ],
     );
  }

  fnSysytemInfo(){

  }
  fnLogout(){

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => Login()
    ));
  }
}
