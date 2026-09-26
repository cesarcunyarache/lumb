import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lumb/config/colors/app_colors.dart';
import 'package:lumb/domain/entities/session.dart';

class BarChartSample2 extends StatefulWidget {
  final List<Session> sessions;

  const BarChartSample2(this.sessions, {super.key});

  final Color leftBarColor = AppColors.primaryColor;
  final Color rightBarColor = Colors.red;
  final Color avgColor = AppColors.primaryColor;

  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();

    // Crear los datos dinámicamente desde las sesiones
    rawBarGroups = widget.sessions.asMap().entries.map((entry) {
      final index = entry.key;
      final session = entry.value;

      // Usa la temperatura para la barra
      final temperature = session.temperature;

      return makeGroupData(
        index, // Índice como identificador del grupo
        temperature, // Usa la temperatura
        0, // Otra métrica si necesitas más barras
      );
    }).toList();

    // Mostrar los grupos iniciales
    showingBarGroups = List.of(rawBarGroups);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 30,
              bottom: 10,
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
           
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 50, // Define un rango adecuado para temperaturas
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => AppColors.primaryColor,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final session = widget.sessions[groupIndex];
                        final date = session.date.toDate();
                        final formattedDate =
                            "${date.day}/${date.month}/${date.year}";
                        return BarTooltipItem(
                          "$formattedDate\n",
                          const TextStyle(color: Colors.white, fontSize: 14),
                          children: [
                            TextSpan(
                              text: "${rod.toY}°C",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        );
                      },
                    ),
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
                        reservedSize: 38,
                        interval: 25, // Intervalo para las etiquetas del eje Y
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
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text("${value.toInt()} °C", style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= widget.sessions.length) return Container();

    final session = widget.sessions[index];
    final date = session.date.toDate();
    final formattedDate = DateFormat.E('es').format(date);
    final dayFormatted = formattedDate.substring(0, 1).toUpperCase() +
        formattedDate.substring(1).toLowerCase();

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(
        dayFormatted,
        style: const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
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
}
