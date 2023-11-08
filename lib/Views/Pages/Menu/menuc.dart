
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

   var txtQty = new TextEditingController();
   var lstrQty = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return pageScreen(
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                h1('Menu'),
                gapH(),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      lstrQty = lstrQty +1;
                      txtQty.text =  lstrQty.toString();
                    });
                  },


                  child: Container(
                    height: 150,
                    padding: EdgeInsets.all(10),
                    decoration: boxDecoration(Colors.white, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset("assets/images/food.png",
                              width: 100,height: 100,),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  gapHC(5),
                                  Icon(Icons.album_outlined,color: Colors.red,size: 15,),
                                  menuNameH('Menu Name '),
                                  catH('Category'),
                                  gapHC(6),
                                  clockRow('10 mins'),
                                  gapHC(6),
                                  priceH('25.00')

                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width:100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    maxLength: 3,
                                    controller: txtQty,
                                    onChanged: (value){
                                      setState(() {
                                        lstrQty =  int.parse(value);
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            gapW(),
                           GestureDetector(
                             onTap: (){
                               if(lstrQty !=0 ){
                                 setState(() {
                                   lstrQty = lstrQty -1;
                                   txtQty.text =  lstrQty.toString();
                                 });
                               }
                             },
                             onLongPress: (){
                               setState(() {
                                 lstrQty = 0;
                                 txtQty.text =  lstrQty.toString();
                               });
                             },

                             child:  Container(
                               height: 120,
                               width:100,
                               decoration: boxDecoration(Colors.grey, 5),
                               child: Center(
                                 child: Icon(Icons.remove_circle_outline_outlined,color: Colors.white,size: 50,),
                               ),
                             ),
                           )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                gapH(),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      lstrQty = lstrQty +1;
                      txtQty.text =  lstrQty.toString();
                    });
                  },


                  child: Container(
                    height: 150,
                    padding: EdgeInsets.all(10),
                    decoration: boxDecoration(Colors.white, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset("assets/images/food.png",
                              width: 100,height: 100,),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  gapHC(5),
                                  Icon(Icons.album_outlined,color: Colors.red,size: 15,),
                                  menuNameH('Menu Name '),
                                  catH('Category'),
                                  gapHC(6),
                                  clockRow('10 mins'),
                                  gapHC(6),
                                  priceH('25.00')

                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width:100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    maxLength: 3,
                                    controller: txtQty,
                                    onChanged: (value){
                                      setState(() {
                                        var v = value as int;
                                        lstrQty = v ;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            gapW(),
                            GestureDetector(
                              onTap: (){
                                if(lstrQty !=0 ){
                                  setState(() {
                                    lstrQty = lstrQty -1;
                                    txtQty.text =  lstrQty.toString();
                                  });
                                }
                              },
                              onLongPress: (){
                                setState(() {
                                  lstrQty = 0;
                                  txtQty.text =  lstrQty.toString();
                                });
                              },

                              child:  Container(
                                height: 120,
                                width:100,
                                decoration: boxDecoration(Colors.grey, 5),
                                child: Center(
                                  child: Icon(Icons.remove_circle_outline_outlined,color: Colors.white,size: 50,),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                gapH(),
                Row(
                  children: [
                    Container(
                      height: 220,
                     width: 200,
                     padding: pagePadding(),
                     decoration: boxDecoration(Colors.white, 10),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset("assets/images/food.png",
                              width: 100,height: 80,),
                          ),
                          gapHC(5),
                          Icon(Icons.album_outlined,color: Colors.green,size: 15,),
                          menuNameS('Menu Name '),
                          catS('Category'),
                          gapHC(6),

                          gapHC(6),
                        ],
                      ),
                    )
                  ],
                )
              ],
          ),
        ),size,context,fnPageBack
    );
  }
   fnPageBack(){

   }
}


