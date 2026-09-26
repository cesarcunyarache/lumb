// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lumb/config/colors/app_colors.dart';
import 'package:lumb/domain/entities/session.dart';
import 'package:lumb/presentation/blocs/cubits/session_cubit.dart';
import 'package:lumb/presentation/blocs/session/session_bloc.dart';
import 'package:lumb/presentation/blocs/session/session_event.dart';
import 'package:lumb/presentation/blocs/session/session_state.dart';

// ignore: must_be_immutable
class QuestionSessionFeedback extends StatefulWidget {
  Session session;
  QuestionSessionFeedback({
    super.key,
    required this.session,
  });

  @override
  State<QuestionSessionFeedback> createState() => _QuestionSessionState();
}

class _QuestionSessionState extends State<QuestionSessionFeedback> {
  double _sliderValue = 0.0;
  double _sliderQ2 = 0.0;

  final Map<double, String> _painLevels = {
    0: 'Nada de mejora',
    1: 'Muy poco mejorado',
    2: 'Algo mejorado',
    3: 'Bastante mejorado',
    4: 'Totalmente mejorado',
  };

  final Map<double, String> _frequencyLevels = {
    0: 'Nada de mejora',
    1: 'Muy poco mejorado',
    2: 'Algo mejorado',
    3: 'Bastante mejorado',
    4: 'Totalmente mejorado',
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
/*     Color currentColorQ2 = _painColors[_sliderQ2] ?? Colors.grey; */

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Form(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const Text(
                    'Queremos saber cómo te sientes después de la sesión. Responde las siguientes preguntas para ajustar tu tratamiento.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    '1. ¿En qué medida ha disminuido su dolor en la zona lumbar después de haber finalizado la sesión con el parche térmico?',
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
                  ElevatedButton(
                    onPressed: () {
                      widget.session.temperature =
                          BlocProvider.of<SessionCubit>(context)
                              .state
                              .temperature;
                      widget.session.status = SessionStatus.finished;
                      widget.session.question = _sliderValue.toInt().toString();
              

                    

                     

                    
                        context
                            .read<SessionBloc>()
                            .add(UpdateSessionEvent(  widget.session));
                     

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
