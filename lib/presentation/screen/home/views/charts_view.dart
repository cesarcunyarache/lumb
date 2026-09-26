
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumb/config/common/app_text_styles.dart';
import 'package:lumb/presentation/blocs/session/session_bloc.dart';
import 'package:lumb/presentation/blocs/session/session_state.dart';

import 'package:lumb/presentation/widgets/charts/chart_bar.dart';
import 'package:lumb/presentation/widgets/charts/chart_line.dart';
import 'package:lumb/presentation/widgets/charts/chart_workout_progress.dart';

class ChartsView extends StatefulWidget {
  const ChartsView({super.key});

  @override
  State<ChartsView> createState() => _ChartsViewState();
}

class _ChartsViewState extends State<ChartsView> {
  int activeScreen = 1;

  @override
  Widget build(BuildContext context) {
    /*  final width = MediaQuery.of(context).size.width; */

    // final height = MediaQuery.of(context).size.height;

    return BlocBuilder<SessionBloc, SessionState>(builder: (context, state) {

      
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gráficos",
                        style: TextStyle(
                            height: 1.1,
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: AppTextStyles.fontFamily,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.01),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: const Offset(0, 10))
                        ],
                        borderRadius: BorderRadius.circular(15)),
                    child: BarChartSample2(state.sessions),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  

                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.01),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: Offset(0, 10))
                        ],
                        borderRadius: BorderRadius.circular(15)),
                    child: LineChartSample2( sessions: state.sessions,)
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  /* Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.01),
                              spreadRadius: 20,
                              blurRadius: 10,
                              offset: Offset(0, 10))
                        ],
                        borderRadius: BorderRadius.circular(30)),
                    child: BarChartSample1(),
                  ), */
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
