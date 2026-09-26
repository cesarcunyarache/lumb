import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumb/domain/entities/session.dart';
import 'package:lumb/presentation/blocs/cubits/scroll_cubit.dart';
import 'package:lumb/presentation/screen/home/widgets/question_session.dart';
import 'package:lumb/presentation/widgets/session_card.dart';


class SessionList extends StatefulWidget {
  final List<Session> sessions;

  const SessionList({super.key, required this.sessions});

  @override
  State<SessionList> createState() => _SessionListState();
}

class _SessionListState extends State<SessionList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScrollCubit, int?>(
      builder: (context, focusedIndex) {
        return SizedBox(
          height: 300,
          
          child: ListView.builder(
            itemCount: widget.sessions.length + 1, // Incluye un elemento extra para el botón
            itemBuilder: (context, index) {
              if (index < widget.sessions.length) {
                final session = widget.sessions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SessionCard(
                    title: "Día ${index + 1}",
                    session: session,
                  ),
                );
              } else {
                // Último elemento: el botón para agregar una nueva sesión
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.30),
                  width: 50,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        showDragHandle: true,
                        context: context,
                        builder: (build) {
                          return const QuestionSession();
                        },
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
