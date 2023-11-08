

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';

class ItemDetails extends StatefulWidget {

  final List<dynamic>  lstrDataList;
  final String qty;
  final String note;
  final Function  fnCallBack;

  const ItemDetails({Key? key,  required this.fnCallBack, required this.lstrDataList, required this.qty, required this.note}) : super(key: key);

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {

  Global g = Global();
  ApiCall apiCall = ApiCall();

  var dataList = [];
  var lstrLastInstructions = [];
  late Future<dynamic> futureDetails ;
  var txtNote = TextEditingController();
  var lstrSelectedStkCode = '';
  var lstrSelectedStkDescp = '';
  var lstrSelectedDishGroup = '';
  var lstrSelectedRate = '';
  var lstrSelectedTime = '';
  var lstrKitchenNote = '';
  var lstrSelectedQty = '';
  var lstrSelectedNote= '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPageData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height*0.4,
        width: size.width*0.7,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book),
                  gapW(),
                  h1(lstrSelectedStkDescp.toString())
                ],
              ),
              gapHC(5),
              tc('AED  '+lstrSelectedRate.toString() ,PrimaryColor,15),
              tc('x ' + lstrSelectedQty.toString() ,Colors.black,10),
              gapHC(10),
              s3('Kitchen Note'),
              gapHC(10),
              Row(
                children: [
                  Container(
                    height: 100,
                    width: size.width*0.6,
                    padding: EdgeInsets.all(10),
                    decoration: boxBaseDecoration(greyLight, 10),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 18.0),
                      maxLines: 10,
                      controller: txtNote,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  gapWC(10),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        txtNote.text = '';
                      });
                    },
                    child: Container(
                      decoration: boxBaseDecoration(blueLight, 10),
                      height: 100,
                      width: size.width*0.07,
                      child: Center(
                        child: Icon(Icons.delete_sweep_sharp),
                      ),
                    ),
                  )

                ],
              ),
              gapHC(20),
              g.fnValCheck(lstrLastInstructions)?
              Container(
                height: 100,
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio:  6,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20),
                    itemCount:  lstrLastInstructions.length,
                    itemBuilder: (BuildContext ctx, index) {
                      var dataList = lstrLastInstructions[index];
                      var code = dataList['CODE'] ??'';
                      var descp = dataList['DESCP']??'';
                      var dishGrop = dataList['DISH_GROUP']??'';
                      var sts = true;
                      // if(lstrSelectedDishGroup == dishGrop){
                      //   sts = true;
                      // }

                      return sts ? GestureDetector(
                        onTap: (){
                          fnUpdateNote(descp);
                        },
                        child: Container(
                          height: 30,
                          decoration: boxBaseDecoration(greyLight, 5),
                          padding: EdgeInsets.all(3),
                          child: Center(
                            child: tc(descp.toString(),Colors.black,15),
                          ),
                        ),
                      ):Container() ;
                    }),
              ) : Container(),

              GestureDetector(
                onTap: (){
                  widget.fnCallBack(lstrSelectedStkCode,txtNote.text.toString());
                },
                child: Container(
                  height: 50,
                  decoration: boxDecoration(PrimaryColor, 15),
                  child: Center(
                    child: tc('ADD',Colors.white,20),
                  ),
                ),
              )
            ],
          )
        )
    );
  }

  fnGetPageData(){
    setState(() {
      dataList = widget.lstrDataList;
     // lstrLastInstructions = widget.lstrDataInstructions;
    });

    if(g.fnValCheck(dataList)){
      var itemCode = dataList[0]['DISHCODE'] ??'';
      var itemName = dataList[0]['DISHDESCP']??'';
      var waitingTime = dataList[0]['WAITINGTIME']??'';
      var itemPrice = dataList[0]['PRICE1']??'0.0';
      var dishGroup = dataList[0]['MENUGROUP'];

      setState(() {
        lstrSelectedStkCode = itemCode??'';
        lstrSelectedStkDescp = itemName??'';
        //lstrSelectedDishGroup = dishGroup;
        lstrSelectedRate = itemPrice.toString();
        lstrKitchenNote = '';
        lstrSelectedQty=widget.qty;
        lstrSelectedNote=widget.note;
        txtNote.text = lstrSelectedNote;

      });
      fnGetDetails(lstrSelectedStkCode);

    }

  }
  fnUpdateNote(note){
    setState(() {
      txtNote.text = txtNote.text +'  ' + note.toString();
    });
  }
  fnGetDetails(code){
    futureDetails = apiCall.getComboAddon("KOT", code);
    futureDetails.then((value) => fnInstructionSuccess(value) );
  }
  fnInstructionSuccess(value){
    if(g.fnValCheck(value)){
      setState(() {
        lstrLastInstructions = value;
      });
    }
  }

}
