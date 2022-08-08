import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class ViewPlot extends StatefulWidget {
  List<double> data;
  String title;

  ViewPlot(this.title,this.data,{Key? key}) : super(key: key);

  @override
  State<ViewPlot> createState() => _ViewPlotState();
}

class _ViewPlotState extends State<ViewPlot> {

  List<_ChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    fillData();
  }

  fillData()
  {
    int i=0;
    widget.data.forEach((e) {
      i++;
      chartData.add(_ChartData(i, e));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top : 80),
        child: SingleChildScrollView(
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            title: ChartTitle(text: widget.title),
            primaryXAxis: NumericAxis(
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                interval: 1,
                majorGridLines: const MajorGridLines(width: 0)),
            series: <LineSeries<_ChartData , num>>[
              LineSeries<_ChartData , num>(
                      dataSource: chartData,
                      xValueMapper: (_ChartData points, _) => points.x,
                      yValueMapper: (_ChartData points, _) => points.y,
                      // Enable data label
                      dataLabelSettings: const DataLabelSettings(isVisible: true)
                  )
            ],
            tooltipBehavior: TooltipBehavior(enable: true),
          )
        ),
      ),
    );
  }

}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final double y;
}

