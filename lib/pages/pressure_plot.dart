import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class PressurePlot extends StatefulWidget {
  List<double> data1;
  List<double> data2;
  List <String> dates;
  String title;

  PressurePlot(this.title,this.data1,this.data2,this.dates,{Key? key}) : super(key: key);

  @override
  State<PressurePlot> createState() => _PressurePlotState();
}

class _PressurePlotState extends State<PressurePlot> {

  List<_ChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    fillData();
  }

  fillData() {
    for (int i = 0; i < widget.data1.length; i++)
    {
      print(widget.dates[i]);
      chartData.add(_ChartData(i+1, widget.data1[i], widget.data2[i],widget.dates[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top : 80),
        child: SingleChildScrollView(
            child: SfCartesianChart(
              legend: Legend(isVisible: true,
                position: LegendPosition.bottom
              ),
              plotAreaBorderWidth: 0,
              title: ChartTitle(text: widget.title),
              primaryXAxis: NumericAxis(
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  interval: 1,
                  majorGridLines: const MajorGridLines(width: 0)),
              series: _getDefaultLineSeries(),
              tooltipBehavior: TooltipBehavior(enable: true),
            ),
        ),
      ),
    );
  }

  List<LineSeries<_ChartData, num>> _getDefaultLineSeries() {
    return <LineSeries<_ChartData, num>>[
      LineSeries<_ChartData, num>(
          dataSource: chartData,
          xValueMapper: (_ChartData points, _) => points.x,
          yValueMapper: (_ChartData points, _) => points.y,
          width: 2,
          name: 'الضغط الإنقباضي',
          dataLabelMapper: (_ChartData points, _) => points.d,
          // Enable data label
          dataLabelSettings: const DataLabelSettings(isVisible: true,
            angle: 45,
          ),
          markerSettings:const MarkerSettings(
              isVisible: true
          ),),
      LineSeries<_ChartData, num>(
          dataSource: chartData,
          width: 2,
          name: 'الضغط الإنبساطي',
          xValueMapper: (_ChartData points, _) => points.x,
          yValueMapper: (_ChartData points, _) => points.y2,
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }

}

class _ChartData {
  _ChartData(this.x, this.y,this.y2,this.d);
  final int x;
  final double y;
  final double y2;
  final String d;
}

