import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GasPriceChart extends StatefulWidget {
  GasPriceChart(
      {super.key,
      required this.yesterdayPriceList,
      required this.todayPriceList});
  List<int> yesterdayPriceList;
  List<int> todayPriceList;
  // final Color leftBarColor = AppColors.contentColorYellow;
  final Color leftBarColor = Colors.grey;
  // final Color rightBarColor = AppColors.contentColorRed;
  final Color rightBarColor = Colors.blue;
  // final Color avgColor =
  //     AppColors.contentColorOrange.avg(AppColors.contentColorRed);
  final Color avgColor = Colors.green;

  @override
  State<StatefulWidget> createState() => GasPriceChartState();
}

class GasPriceChartState extends State<GasPriceChart> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  //
  // BarChartGroupData gasoline = makeGroupData(0, 1443, 1546);
  // BarChartGroupData diesel = makeGroupData(1, 1755, 1810);
  // BarChartGroupData gasolinePlus = makeGroupData(2, 1694, 1750);
  @override
  void didChangeDependencies() {
    debugPrint('didChangeDependencies in gas price chart');
    // setState(() {
    //   gasoline = makeGroupData(0, widget.yesterdayPriceList[0].toDouble(),
    //       widget.todayPriceList[0].toDouble());
    //   diesel = makeGroupData(1, widget.yesterdayPriceList[1].toDouble(),
    //       widget.todayPriceList[1].toDouble());
    //   gasolinePlus = makeGroupData(2, widget.yesterdayPriceList[2].toDouble(),
    //       widget.todayPriceList[2].toDouble());
    // });
    super.didChangeDependencies();
  }

  BarChartGroupData? gasoline;
  BarChartGroupData? diesel;
  BarChartGroupData? gasolinePlus;

  List<BarChartGroupData>? items;

  // BarChartGroupData gasoline =
  //     makeGroupData(0, widget.yesterdayPriceList[0], widget.todayPriceList[0]);
  // BarChartGroupData diesel =
  //     makeGroupData(1, widget.yesterdayPriceList[1], widget.todayPriceList[1]);
  // BarChartGroupData gasolinePlus =
  //     makeGroupData(2, widget.yesterdayPriceList[2], widget.todayPriceList[2]);

  @override
  void initState() {
    super.initState();
    debugPrint('gas price widget init');
    gasoline = makeGroupData(0, widget.yesterdayPriceList[0].toDouble(),
        widget.todayPriceList[0].toDouble());
    diesel = makeGroupData(1, widget.yesterdayPriceList[1].toDouble(),
        widget.todayPriceList[1].toDouble());
    gasolinePlus = makeGroupData(2, widget.yesterdayPriceList[2].toDouble(),
        widget.todayPriceList[2].toDouble());
    // BarChartGroupData gasoline = makeGroupData(0, 1443.1, 1546);
    // BarChartGroupData diesel = makeGroupData(1, 1755, 1810);
    // BarChartGroupData gasolinePlus = makeGroupData(2, 1694, 1750);

    // final barGroup4 = makeGroupData(3, 20, 16);
    // final barGroup5 = makeGroupData(4, 17, 6);
    // final barGroup6 = makeGroupData(5, 19, 1.5);
    // final barGroup7 = makeGroupData(6, 10, 1.5);

    items = [
      gasoline!,
      diesel!,
      gasolinePlus!,
      // barGroup4,
      // barGroup5,
      // barGroup6,
      // barGroup7,
    ];

    rawBarGroups = items!;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // makeTransactionsIcon(),
                  // const SizedBox(
                  //   width: 38,
                  // ),
                  // const Text(
                  //   'Transactions',
                  //   style: TextStyle(color: Colors.white, fontSize: 22),
                  // ),
                  // const SizedBox(
                  //   width: 4,
                  // ),
                  // const Text(
                  //   'state',
                  //   style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                  // ),
                  // Text('Price'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: new BoxDecoration(
                      color: widget.leftBarColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    'Yesterday',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: new BoxDecoration(
                      color: widget.rightBarColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    'Today',
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: 2200,
                    minY: 500,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.grey,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          // debugPrint(
                          //     'group: ${group}, groupIndex: ${groupIndex}, rod: ${rod}, rodIndex: ${rodIndex}');
                          // debugPrint('group x : ${group.x}');
                          // debugPrint('group bars space x : ${group.barsSpace}');
                          // debugPrint('group bar rods : ${group.barRods}');

                          return BarTooltipItem(
                            '<${widget.yesterdayPriceList[group.x].toDouble()}> <${widget.todayPriceList[group.x].toDouble()}>',
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                      touchCallback: (FlTouchEvent event, response) {
                        if (response == null || response.spot == null) {
                          setState(() {
                            touchedGroupIndex = -1;
                            showingBarGroups = List.of(rawBarGroups);
                          });
                          return;
                        }

                        touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                        //
                        // setState(() {
                        //   if (!event.isInterestedForInteractions) {
                        //     touchedGroupIndex = -1;
                        //     showingBarGroups = List.of(rawBarGroups);
                        //     return;
                        //   }
                        //   showingBarGroups = List.of(rawBarGroups);
                        //   if (touchedGroupIndex != -1) {
                        //     var sum = 0.0;
                        //     for (final rod
                        //         in showingBarGroups[touchedGroupIndex]
                        //             .barRods) {
                        //       sum += rod.toY;
                        //     }
                        //     final avg = sum /
                        //         showingBarGroups[touchedGroupIndex]
                        //             .barRods
                        //             .length;
                        //
                        //     showingBarGroups[touchedGroupIndex] =
                        //         showingBarGroups[touchedGroupIndex].copyWith(
                        //       barRods: showingBarGroups[touchedGroupIndex]
                        //           .barRods
                        //           .map((rod) {
                        //         return rod.copyWith(
                        //             toY: avg, color: widget.avgColor);
                        //       }).toList(),
                        //     );
                        //   }
                        // });
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
                          getTitlesWidget: bottomTitles,
                          reservedSize: 42,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 34,
                          interval: 1,
                          getTitlesWidget: leftTitles,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: showingBarGroups,
                    gridData: const FlGridData(show: false),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 1000) {
      text = '1K';
    } else if (value == 1500) {
      text = '1.5K';
    } else if (value == 2000) {
      text = '2K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    // final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];
    List<String> titles = ['gas', 'die', 'gas+'];

    Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}

// class SmallCircle extends Container{
//   SmallCircle({super.key, required this.thisColor});
//   Color thisColor;
//
//   @override
//   // TODO: implement decoration
//   Decoration? get decoration => super.decoration;
//
// }
// Widget bigCircle = new Container(
//   width: 300.0,
//   height: 300.0,
//   decoration: new BoxDecoration(
//     color: Colors.orange,
//     shape: BoxShape.circle,
//   ),
// );
