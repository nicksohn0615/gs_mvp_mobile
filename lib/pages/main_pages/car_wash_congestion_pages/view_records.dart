import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import '';

class RecordsViewer extends StatefulWidget {
  RecordsViewer({Key? key}) : super(key: key);

  @override
  State<RecordsViewer> createState() => _RecordsViewerState();
}

class _RecordsViewerState extends State<RecordsViewer> {
  final ScrollController scrollController = ScrollController();
  double chartWidth = 500;

  String _selectedDate = '날짜를 선택하세요';
  Future _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selected != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy/MM/dd').format(selected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.black12,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(flex: 35, child: SizedBox()),
                Expanded(
                    flex: 12,
                    child: Center(
                      child: SizedBox(
                          height: 20,
                          child: Text(
                            '${_selectedDate}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? 10
                                    : 14),
                          )),
                    )),
                // Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 2,
                  child: IconButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: Icon(
                        Icons.calendar_today_outlined,
                        size: 30,
                      )),
                ),
                Expanded(
                  flex: 10,
                  child: SizedBox(),
                )
              ],
            ),
          ),
          Center(child: Text('')),
          SizedBox(
            height: 10,
          ),
          RawScrollbar(
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              child: SizedBox(
                  child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                        width: chartWidth, height: 250, child: LineChart1()),
                  ),
                ],
              )),
              scrollDirection: Axis.horizontal,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (chartWidth <= 250) {
                      } else {
                        chartWidth = chartWidth - 50;
                      }
                    });
                  },
                  icon: Icon(Icons.remove_circle_outline)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      chartWidth = 500;
                    });
                  },
                  icon: Icon(Icons.adjust_outlined)),
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (chartWidth >= 1500) {
                      } else {
                        chartWidth = chartWidth + 50;
                      }
                    });
                  },
                  icon: Icon(Icons.add_circle_outline)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class LineChart1 extends StatefulWidget {
  const LineChart1({super.key});

  @override
  State<LineChart1> createState() => _LineChart1State();
}

class _LineChart1State extends State<LineChart1> {
  List<Color> gradientColors = [
    // AppColors.contentColorCyan,
    // AppColors.contentColorBlue,
    Colors.lightBlueAccent,
    Colors.blueGrey
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      showAvg ? avgData() : mainData(),
    );

    //   Stack(
    //   children: <Widget>[
    //     AspectRatio(
    //       aspectRatio: 1.8,
    //       child: Padding(
    //         padding: const EdgeInsets.only(
    //           right: 18,
    //           left: 12,
    //           top: 24,
    //           bottom: 12,
    //         ),
    //         child: LineChart(
    //           showAvg ? avgData() : mainData(),
    //         ),
    //       ),
    //     ),
    //     SizedBox(
    //       width: 44,
    //       height: 30,
    //       child: TextButton(
    //         style: TextButton.styleFrom(backgroundColor: Colors.blue),
    //         onPressed: () {
    //           setState(() {
    //             showAvg = !showAvg;
    //           });
    //         },
    //         child: Text(
    //           'avg',
    //           style: TextStyle(
    //             fontSize: 12,
    //             color: showAvg ? Colors.black87 : Colors.black38,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('11:00', style: style);
        break;
      case 5:
        text = const Text('14:00', style: style);
        break;
      case 8:
        text = const Text('18:00', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10';
        break;
      case 3:
        text = '50';
        break;
      case 5:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.black38,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.black38,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
