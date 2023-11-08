import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarPieDouView extends StatefulWidget {

  final  dataList;
  final String Name;
  const BarPieDouView({Key? key, required this.Name, this.dataList}) : super(key: key);


  @override
  _BarPieDouViewState createState() => _BarPieDouViewState();
}

class _BarPieDouViewState extends State<BarPieDouView> {
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      // Chart title
        title: ChartTitle(text: widget.Name.toString()),
        legend: Legend(isVisible: true),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: widget.dataList);
  }
}
