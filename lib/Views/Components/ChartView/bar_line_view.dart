


import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarLineView extends StatefulWidget {
  final  dataList;
  final String Name;
  const BarLineView({Key? key, required this.Name, this.dataList}) : super(key: key);

  @override
  _BarLineViewState createState() => _BarLineViewState();
}

class _BarLineViewState extends State<BarLineView> {

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        // Chart title
        title: ChartTitle(text: widget.Name.toString()),
        // Enable legend
        legend: Legend(isVisible: false),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),

        series: widget.dataList);
  }

}
