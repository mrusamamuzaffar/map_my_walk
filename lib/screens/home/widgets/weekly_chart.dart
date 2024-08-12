import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Replace with your own configuration files
import '../../../configs/app_theme.dart';
import '../../../configs/ui_props.dart';

class ChallengesChart extends StatelessWidget {
  const ChallengesChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(milliseconds: 300),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: UIProps.topBoth50,
            color: AppTheme.c.primaryDark,
            boxShadow: [
              BoxShadow(
                color: AppTheme.c.accent.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 8,
              ),
            ],
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('challenges')
                .orderBy('points', descending: true)
                .limit(3)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              var docs = snapshot.data!.docs;
              var maxYValue = docs.map((doc) {
                var points = doc['points'];
                return (points is int) ? points.toDouble() : points as double;
              }).reduce((value, element) => value > element ? value : element) + 5.0;

              return BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: false,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final index = value.toInt();
                          final title = docs[index]['title'] as String;
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 4.0,
                            child: Text(title, style: const TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.bold, fontSize: 16)),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxYValue,
                  barGroups: docs.asMap().entries.map((entry) {
                    var points = entry.value['points'];
                    var pointsDouble = (points is int) ? points.toDouble() : points as double;
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: pointsDouble,
                          gradient: _barsGradient,
                            width: 20
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      AppTheme.c.accent,
      AppTheme.c.primary,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}
