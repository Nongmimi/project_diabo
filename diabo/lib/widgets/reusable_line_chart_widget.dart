import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReusableLineChartWidget extends StatelessWidget {
  final List<FlSpot> spots; // จุดข้อมูลบนกราฟ
  final Color lineColor; // สีของเส้นกราฟ
  final double lineWidth; // ความหนาของเส้นกราฟ
  final Color borderColor; // สีของกรอบกราฟ
  final double borderWidth; // ความหนาของเส้นกรอบ
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;

  const ReusableLineChartWidget({
    Key? key,
    required this.spots,
    this.lineColor = const Color.fromARGB(255, 97, 131, 216),
    this.lineWidth = 2.0,
    this.borderColor = Colors.black,
    this.borderWidth = 2.0,
    this.minX = 0,
    this.maxX = 14,
    this.minY = 0,
    this.maxY = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(
          drawHorizontalLine: true,
          drawVerticalLine: false,
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1, // เพิ่มขึ้นทีละ 1
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1, // เพิ่มขึ้นทีละ 1
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(drawBelowEverything: false),
          topTitles: AxisTitles(drawBelowEverything: false),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: borderColor, width: borderWidth),
            left: BorderSide(color: borderColor, width: borderWidth),
          ),
        ),
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            color: lineColor,
            barWidth: lineWidth,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
