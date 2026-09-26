import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumb/config/colors/app_colors.dart';
import 'package:lumb/domain/entities/session.dart';
import 'package:lumb/presentation/blocs/session/session_bloc.dart';
import 'package:lumb/presentation/blocs/session/session_state.dart';
import 'package:lumb/presentation/screen/home/widgets/session_container.dart';
import 'package:table_calendar/table_calendar.dart';

class SessionsView extends StatefulWidget {
  const SessionsView({super.key});

  @override
  State<SessionsView> createState() => _SessionsViewState();
}

class _SessionsViewState extends State<SessionsView> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 5),
                _buildCalendar(state),
                const SizedBox(height: 10),
                const SessionContainer(), // Widget específico
              ],
            ),
          ),
        ),
      );
    });
  }

// Construye el encabezado
  Widget _buildHeader() {
    return const Text(
      "Calendario",
      style: TextStyle(
        height: 1.1,
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

// Construye el calendario con los marcadores
  Widget _buildCalendar(SessionState state) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          if (state.status == SessionBlocStatus.loading ||
              state.status == SessionBlocStatus.initial) {
            return null;
          }
          if (state.sessions.any((session) =>
              isSameDay(day, session.date.toDate()) &&
              session.status.name != 'pending')) {
            final matchedSession = state.sessions.firstWhere(
              (session) =>
                  isSameDay(day, session.date.toDate()) &&
                  session.status.name != 'pending',
            );
            return _buildMarkedDate(day, matchedSession.status);
          }

          return null;
        },
      ),
    );
  }

// Construye un día marcado con un ícono
  Widget _buildMarkedDate(DateTime day, SessionStatus status) {
    return SizedBox(
      width: 20,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            '${day.day}',
            style: const TextStyle(color: Colors.black),
          ),
           Positioned(
            bottom: 32,
            child: Icon(
              status == SessionStatus.finished
                  ? Icons.check
                  : Icons.alarm_off_outlined,
              size: 14,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
