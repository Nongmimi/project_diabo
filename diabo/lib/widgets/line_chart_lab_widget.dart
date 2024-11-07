import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // นำเข้า FlChart

class LineChartLab extends StatelessWidget {
  final List<FlSpot> spots1;
  final List<FlSpot> spots2;

  // รับค่า spots ผ่าน constructor
  const LineChartLab({
    super.key,
    required this.spots1,
    required this.spots2,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(
          drawHorizontalLine: true,
          drawVerticalLine: false,
        ), // กริด
        titlesData: const FlTitlesData(
          rightTitles: AxisTitles(drawBelowEverything: false),
          topTitles: AxisTitles(drawBelowEverything: false),
        ), // ข้อความรอบกรอบ
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color.fromARGB(255, 0, 0, 0),
              width: 2,
            ),
            left: BorderSide(
              color: Color.fromARGB(255, 0, 0, 0),
              width: 2,
            ),
          ),
        ), // เส้นกรอบ
        minX: 0,
        maxX: 12,
        minY: 0,
        maxY: 8,
        lineBarsData:
            _getLineChartBars(), // ใช้ฟังก์ชันภายในเพื่อสร้าง lineBarsData
      ),
    );
  }

  // ฟังก์ชันสำหรับสร้างข้อมูลเส้นกราฟ (lineBarsData)
  List<LineChartBarData> _getLineChartBars() {
    return [
      LineChartBarData(
        spots: spots1, // รับค่า spots1
        barWidth: 3, // ความหนาเส้นกราฟ
        isStrokeCapRound: false,
        dotData: const FlDotData(show: true), // จุดบนกราฟ
        belowBarData: BarAreaData(show: false), // สีใต้กราฟ
      ),
      LineChartBarData(
        spots: spots2, // รับค่า spots2
        barWidth: 3, // ความหนาเส้นกราฟ
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true), // จุดบนกราฟ
        belowBarData: BarAreaData(show: false), // สีใต้กราฟ
      ),
    ];
  }
}
