



import 'package:beamsbistro/Views/Components/ChartView/bar_line_view.dart';
import 'package:beamsbistro/Views/Components/ChartView/bar_pd_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BeamsChart{

  fnBlChart(var yColumns,var xColumn,var lstrData, var name, var mode){

     List<ColumnSeries<dynamic, String>> columnData = [];
     List<LineSeries<dynamic, String>> lineData = [];
     List<BarSeries<dynamic, String>> barData = [];
    for (var e in yColumns) {
      var cdata  = ColumnSeries<dynamic, String>(
          dataSource: lstrData,
          xValueMapper: (dynamic lstrData, _) => lstrData[xColumn],
          yValueMapper: (dynamic lstrData, _) => lstrData[e["COLUMN"]],
          name: e["COLUMN"],
          // Enable data label
          dataLabelSettings: DataLabelSettings(isVisible: true));

      var ldata  = LineSeries<dynamic, String>(
          dataSource: lstrData,
          xValueMapper: (dynamic lstrData, _) => lstrData[xColumn],
          yValueMapper: (dynamic lstrData, _) => lstrData[e["COLUMN"]],
          name: e["COLUMN"],
          // Enable data label
          dataLabelSettings: DataLabelSettings(isVisible: true));

      var bdata  = BarSeries<dynamic, String>(
          dataSource: lstrData,
          xValueMapper: (dynamic lstrData, _) => lstrData[xColumn],
          yValueMapper: (dynamic lstrData, _) => lstrData[e["COLUMN"]],
          name: e["COLUMN"],
          // Enable data label
          dataLabelSettings: DataLabelSettings(isVisible: true));

      if(mode == "C"){
        columnData.add(cdata);
      }else if(mode == "B"){
        barData.add(bdata);
      }else if(mode == "L"){
        lineData.add(ldata);
      }
    }
     if(mode == "C"){
       return BarLineView(Name: name,dataList: columnData);
     }else if(mode == "B"){
       return BarLineView(Name: name,dataList: barData);
     }else if(mode == "L"){
       return BarLineView(Name: name,dataList: lineData);
     }
  }

  fnPDChart(var yColumn,var xColumn,var lstrData, var name, var mode){

    List<PieSeries<dynamic, String>> pieList = [];
    List<DoughnutSeries<dynamic, String>> doughnutList = [];
    var pdata  = PieSeries<dynamic, String>(
        dataSource: lstrData,
        xValueMapper: (dynamic mainList, _) =>mainList[xColumn],
        yValueMapper: (dynamic mainList, _) =>mainList[yColumn],
        dataLabelSettings:DataLabelSettings(isVisible : true),
        animationDuration: 1000,
        name: name
    );

    var ddata  = DoughnutSeries<dynamic, String>(
        dataSource: lstrData,
        xValueMapper: (dynamic mainList, _) =>mainList[xColumn],
        yValueMapper: (dynamic mainList, _) =>mainList[yColumn],
        dataLabelSettings:DataLabelSettings(isVisible : true),
        animationDuration: 1000,
        name: name
    );

    if(mode == "P"){
      pieList.add(pdata);
    }else if(mode == "D"){
      doughnutList.add(ddata);
    }
    if(mode == "P"){
      return BarPieDouView(Name: name,dataList: pieList);
    }else if(mode == "D"){
      return BarPieDouView(Name: name,dataList: doughnutList);
    }

  }


}
