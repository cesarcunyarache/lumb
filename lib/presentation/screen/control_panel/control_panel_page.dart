import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumb/core/utils/slider_utils.dart';
import 'package:lumb/domain/entities/session.dart';
import 'package:lumb/presentation/blocs/cubits/session_cubit.dart';
import 'package:lumb/presentation/screen/control_panel/options_enum.dart';
import 'package:lumb/presentation/screen/control_panel/widgets/option_widget.dart';
import 'package:lumb/presentation/screen/control_panel/widgets/slider/slider_widget.dart';
import 'package:lumb/presentation/screen/control_panel/widgets/temp_widget.dart';

import 'package:lumb/presentation/screen/home/widgets/question_session_feedback.dart';
import 'package:lumb/presentation/widgets/break_dialog.dart';
import 'package:lumb/presentation/widgets/buttons_widget.dart';
import 'package:lumb/presentation/widgets/custom_appbar.dart';
import 'package:lumb/presentation/widgets/timer_widget.dart';
import 'package:lumb/presentation/widgets/work_dialog.dart';
import 'package:rainbow_color/rainbow_color.dart';

class ControlPanelPage extends StatefulWidget {
  final String tag;
  final Session? session;

  const ControlPanelPage({super.key, required this.tag ,this.session});

  @override
  // ignore: library_private_types_in_public_api
  _ControlPanelPageState createState() => _ControlPanelPageState();
}

class _ControlPanelPageState extends State<ControlPanelPage>
    with TickerProviderStateMixin {
  Options option = Options.heat;
  bool isActive = false;
  int speed = 1;
  double temp = 22.85;
  double progressVal = 0.49;
  int selectedOption = 0;
  bool terminateSession = false;

  var activeColor = Rainbow(spectrum: [
    const Color(0xFF33C0BA),
    const Color(0xFF1086D4),
    const Color.fromARGB(255, 237, 176, 8),
    const Color.fromARGB(255, 226, 85, 4),
    const Color(0xFFE4262F)
  ], rangeStart: 0.0, rangeEnd: 1.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionCubit, SessionCubitState>(
        listener: (context, state) {
      if (state.terminateSession) {
       

        showModalBottomSheet(
          backgroundColor: Colors.white,
          showDragHandle: true,
          context: context,
          builder: (build) {
            return QuestionSessionFeedback(session: widget.session!);
          },
        ).whenComplete(() {
          // Reinicia el estado para evitar que vuelva a dispararse
          BlocProvider.of<SessionCubit>(context).updatedTerminateSession(false);
        });
      }
    }, builder: (context, state) {
      return Scaffold(
        body: _buildBody(context),
      );
    });
  }

  Widget _buildBody(BuildContext context) {
    temp = BlocProvider.of<SessionCubit>(context).state.temperature;
    progressVal = normalize(temp, kMinDegree, kMaxDegree);

    terminateSession =
        BlocProvider.of<SessionCubit>(context).state.terminateSession;

    print(BlocProvider.of<SessionCubit>(context).state.terminateSession);

    if (terminateSession) {
      print('terminated');
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: _buildGradient(),
      ),
      child: AnimatedBackground(
        behaviour: _buildParticleBehaviour(),
        vsync: this,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Column(
              children: [
                CustomAppBar(title: widget.tag),
                const SizedBox(height: 20),
                Expanded(child: _buildContent(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _buildGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Colors.white,
        activeColor[progressVal].withOpacity(0.5),
        activeColor[progressVal]
      ],
    );
  }

  RandomParticleBehaviour _buildParticleBehaviour() {
    return RandomParticleBehaviour(
      options: ParticleOptions(
        baseColor: const Color(0xFFFFFFFF),
        opacityChangeRate: 0.25,
        minOpacity: 0.1,
        maxOpacity: 0.3,
        spawnMinSpeed: speed * 60.0,
        spawnMaxSpeed: speed * 120,
        spawnMinRadius: 2.0,
        spawnMaxRadius: 5.0,
        particleCount: isActive ? speed * 150 : 0,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionCubitState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildOptions(),
            selectedOption == 0 ? _buildSlider() : _buildTimer(state),
            selectedOption == 0 ? _buildControls() : _buildButtons(state),
          ],
        );
      },
    );
  }

  Widget _buildOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildOption(Options.heat, 'assets/svg/bright.svg', 35),
        const SizedBox(width: 20),
        _buildOption(Options.timer, 'assets/svg/clock.svg', 32),
      ],
    );
  }

  Widget _buildOption(Options optionType, String icon, double size) {
    return OptionWidget(
      icon: icon,
      isSelected: option == optionType,
      onTap: () => _onOptionSelected(optionType),
      size: size,
    );
  }

  void _onOptionSelected(Options selectedOptionType) {
    setState(() {
      option = selectedOptionType;
      selectedOption = selectedOptionType == Options.heat ? 0 : 1;
    });
  }

  Widget _buildSlider() {
    return SliderWidget(
      progressVal: progressVal,
      color: activeColor[progressVal],
      onChange: (value) {
        setState(() {
          temp = value;
          BlocProvider.of<SessionCubit>(context).updateTemperature(temp);
          progressVal = normalize(value, kMinDegree, kMaxDegree);
        });
      },
    );
  }

  Widget _buildTimer(SessionCubitState state) {
    return Column(
      children: [
        TimerWidget(
          percent: state.percent,
          activeColor: activeColor[progressVal],
          minutes: state.minutes,
          seconds: state.seconds,
          isWorking: state.timerType == TimerType.WORK,
          minutesInSec: state.minutesInSec,
        ),
        const SizedBox(height: 50),
        _buildDialog(state),
      ],
    );
  }

  Widget _buildDialog(SessionCubitState state) {
    return StreamBuilder<TimerType>(
      stream: context.read<SessionCubit>().dialogStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data == TimerType.BREAK
              ? const BreakDialog()
              : const WorkDialog();
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildControls() {
    return Column(
      children: [
        TempWidget(
          temp: temp,
          changeTemp: (val) => setState(() {
            temp = val;
            BlocProvider.of<SessionCubit>(context).updateTemperature(temp);
            progressVal = normalize(val, kMinDegree, kMaxDegree);
          }),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildButtons(SessionCubitState state) {
    return ButtonsWidget(
      timerStarted: state.timerStarted,
      start: () => context.read<SessionCubit>().startTimer(),
      stop: () => context.read<SessionCubit>().stopTimer(),
      restart: () => context.read<SessionCubit>().restartTimer(),
    );
  }
}
