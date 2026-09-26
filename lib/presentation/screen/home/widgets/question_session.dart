import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumb/config/colors/app_colors.dart';
import 'package:lumb/domain/entities/session.dart';
import 'package:lumb/presentation/blocs/session/session_bloc.dart';
import 'package:lumb/presentation/blocs/session/session_event.dart';
import 'package:lumb/presentation/blocs/session/session_state.dart';

class QuestionSession extends StatefulWidget {
  const QuestionSession({super.key});

  @override
  State<QuestionSession> createState() => _QuestionSessionState();
}

class _QuestionSessionState extends State<QuestionSession> {
  double _sliderValue = 0.0;
  double _sliderQ2 = 0.0;

  final Map<double, String> _painLevels = {
    0: 'Muy leve',
    1: 'Leve',
    2: 'Moderado',
    3: 'Fuerte',
    4: 'Muy fuerte',
  };

  final Map<double, String> _frequencyLevels = {
    0: 'Nunca',
    1: 'Rara vez',
    2: 'De vez en cuando',
    3: 'A menudo',
    4: 'Todo el tiempo',
  };

  final Map<double, Color> _painColors = {
    0: Colors.green,
    1: Colors.lightGreen,
    2: Colors.orange,
    3: Colors.deepOrange,
    4: Colors.red,
    5: Colors.redAccent,
  };

  Widget _buildContent(SessionState state) {
    switch (state.status) {
      case SessionBlocStatus.loading:
      case SessionBlocStatus.initial:
        return _buildLoadingIndicator();
      case SessionBlocStatus.failure:
        return _buildErrorState(state.errorMessage);
      case SessionBlocStatus.success:
        return _buildQuestionForm();
      default:
        return _buildErrorState('Estado desconocido');
    }
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(String? errorMessage) {
    return Center(
      child: Text(
        errorMessage ?? 'Ocurrió un error inesperado',
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }

  Widget _buildQuestionForm() {
    Color currentColor = _painColors[_sliderValue] ?? Colors.grey;
    Color currentColorQ2 = _painColors[_sliderQ2] ?? Colors.grey;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          height: MediaQuery.of(context).size.height * 0.4,
          child: Form(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const Text(
                    'Queremos saber cómo te sientes. Responde las siguientes preguntas para ajustar tu tratamiento.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    '1. ¿Qué tan intenso es el dolor en la zona lumbar?',
                    style: TextStyle(
                      fontFamily: 'FiraSans',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Slider(
                          value: _sliderValue,
                          min: 0.0,
                          max: 4.0,
                          divisions: 4,
                          activeColor: AppColors.primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _sliderValue = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 120,
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: currentColor.withOpacity(0.1),
                          border: Border.all(color: currentColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _painLevels[_sliderValue] ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'FiraSans',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: currentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '2. ¿Con qué frecuencia sientes dolor en la zona lumbar?',
                    style: TextStyle(
                        fontFamily: 'FiraSans',
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Slider(
                          value: _sliderQ2,
                          min: 0.0,
                          max: 4.0,
                          divisions: 4,
                          activeColor: AppColors.primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _sliderQ2 = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 120,
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: currentColorQ2.withOpacity(0.1),
                          border: Border.all(color: currentColorQ2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _frequencyLevels[_sliderQ2] ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'FiraSans',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: currentColorQ2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final sessions =
                          context.read<SessionBloc>().state.sessions;

                      final sessionLast =
                          sessions.isNotEmpty ? sessions.last : null;

                      final nextDay = sessionLast?.date
                              .toDate()
                              .add(const Duration(days: 1)) ??
                          DateTime.now();

                      final res = Session.generateTherapySessions(
                        painLevel: _sliderValue.toInt(),
                        frequencyLevel: _sliderQ2.toInt(),
                        startDate: nextDay,
                      );

                      for (final session in res) {
                        context
                            .read<SessionBloc>()
                            .add(AddSessionEvent(session));
                      }

                      Navigator.pop(context);
                    },
                    child: Text(
                      'Enviar',
                      style: GoogleFonts.firaSans(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        return _buildContent(state);
      },
    );
  }
}
