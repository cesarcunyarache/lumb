import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lumb/config/colors/app_colors.dart';
import 'package:lumb/config/common/app_text_styles.dart';
import 'package:lumb/domain/entities/session.dart';
import 'package:lumb/presentation/blocs/cubits/session_cubit.dart';
import 'package:lumb/presentation/blocs/session/session_bloc.dart';
import 'package:lumb/presentation/blocs/session/session_event.dart';
import 'package:lumb/presentation/screen/control_panel/control_panel_page.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({
    super.key,
    required this.session,
    required this.title,
    this.secundaryColor = Colors.black,
  });

  final Session session;
  final String title;
  final Color secundaryColor;

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final date = session.date.toDate();

    Color backgroundColor;
    Color textColor;

    if (currentDate.year == date.year &&
        currentDate.month == date.month &&
        currentDate.day == date.day) {
      backgroundColor = AppColors.primaryColor;
      textColor = Colors.white;
    } else if (session.status == SessionStatus.pending) {
      if (date.isBefore(currentDate)) {
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[600]!;

        session.status = SessionStatus.missed;
        BlocProvider.of<SessionBloc>(context).add(UpdateSessionEvent(session));
      } else {
        backgroundColor = Colors.white;
        textColor = Colors.black;
      }
    } else if (session.status == SessionStatus.finished ||
        session.status == SessionStatus.missed) {
      backgroundColor = Colors.grey[200]!;
      textColor = Colors.grey[600]!;
    } else {
      backgroundColor = Colors.grey[200]!;
      textColor = Colors.grey[600]!;
    }

    return GestureDetector(
      onTap: session.status == SessionStatus.missed ||
              session.status == SessionStatus.finished ||
              date.isAfter(currentDate)
          ? null
          : () {
              final state = BlocProvider.of<SessionCubit>(context).state;

              if (!state.isActive) {
                // Si no hay sesión activa, navega a cualquier sesión
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  // Actualiza el tiempo para la nueva sesión
                  BlocProvider.of<SessionCubit>(context).updateTime(
                      minutes: session.duration ~/ 60,
                      seconds: 0,
                      temperature: session.temperature,
                      sessionId: session.id,
                      );

                  // Regresa al panel de control
                  return ControlPanelPage(tag: title, session: session);
                }));
              } else {
                // Si hay una sesión activa, solo puede navegar a la sesión con id == 0
                if (state.sessionId == session.id) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ControlPanelPage(tag: title, session: session);
                  }));
                } else {
                  // Aquí puedes mostrar un mensaje o manejar el caso donde no se permite navegar a otras sesiones
                  // Ejemplo con un mensaje:
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "No puedes ingresar a otra sesión mientras haya una activa")),
                  );
                }
              }
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: Colors.grey[300]!, width: 0.6),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  '${session.date.toDate().day}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontFamily: AppTextStyles.fontFamily,
                      color: textColor),
                ),
                Text(
                  DateFormat('MMM').format(session.date.toDate()),
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: AppTextStyles.fontFamily,
                      color: textColor),
                ),
              ],
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 50,
              child: VerticalDivider(
                color: textColor,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTextStyles.fontFamily,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${session.temperature.toInt()} °C  -  ${session.duration ~/ 60} minutos',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontFamily: AppTextStyles.fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            if (session.status == SessionStatus.missed)
              Icon(Icons.alarm_off_outlined,
                  color: Colors.grey[600]!, size: 25),
            if (session.status == SessionStatus.finished)
              Icon(Icons.alarm_on_outlined, color: Colors.grey[600]!, size: 25),
          ],
        ),
      ),
    );
  }
}
