import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class ViewPlot extends StatefulWidget {
  List<double> data;
  List<String> dates;
  String title;

  ViewPlot(this.title,this.data,this.dates,{Key? key}) : super(key: key);

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
    for (int i = 0; i < widget.data.length; i++)
    {
      int num = i+1;
      chartData.add(_ChartData(num, widget.data[i],widget.dates[i]));
    }
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
            series: <LineSeries<_ChartData , dynamic>>[
              LineSeries<_ChartData , dynamic>(
                      dataSource: chartData,
                      xValueMapper: (_ChartData points, _) => points.x,
                      yValueMapper: (_ChartData points, _) => points.y,
                      dataLabelMapper: (_ChartData points, _) => points.d,
                      // Enable data label
                      dataLabelSettings: const DataLabelSettings(isVisible: true,
                        angle: 45,
                      ),
                      markerSettings:const MarkerSettings(
                          isVisible: true
                      ),
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
  _ChartData(this.x, this.y,this.d);
  final int x;
  final double y;
  final String d;
}

