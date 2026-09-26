import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumb/presentation/blocs/session/session_bloc.dart';
import 'package:lumb/presentation/blocs/session/session_event.dart';
import 'package:lumb/presentation/blocs/session/session_state.dart';
import 'package:lumb/presentation/screen/home/widgets/question_session.dart';
import 'package:lumb/presentation/screen/home/widgets/session_list.dart';

class SessionContainer extends StatefulWidget {
  const SessionContainer({super.key});

  @override
  State<SessionContainer> createState() => _SessionContainerState();
}

class _SessionContainerState extends State<SessionContainer> {
  @override
  void initState() {
    super.initState();
    context.read<SessionBloc>().add(GetSessionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildContent(state),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return const Text(
      "Sesiones",
      style: TextStyle(
        height: 1.1,
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildContent(SessionState state) {
    switch (state.status) {
      case SessionBlocStatus.loading:
      case SessionBlocStatus.initial:
        return _buildLoadingIndicator();
      case SessionBlocStatus.failure:
        return _buildErrorState(state.errorMessage);
      case SessionBlocStatus.success:
        if (state.sessions.isEmpty) {
          return _buildEmptyState();
        } else {
          return _buildSessionList(state);
        }
      default:
        return _buildErrorState(state.errorMessage);
    }
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 3),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Center(
        child: Column(
          children: [
            const Text(
              "No hay sesiones disponibles.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {

                showModalBottomSheet(
                    backgroundColor: Colors.white,
                    
                    showDragHandle: true,
                      context: context,
                      builder: (build) {
                        return const QuestionSession();
                      });
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String? errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          Text(
            errorMessage ?? "Ocurrió un error al cargar las sesiones.",
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<SessionBloc>().add(GetSessionsEvent());
            },
            child: const Text("Reintentar"),
          ),
        ],
      ),
    );
  }

  /*  Widget _buildSessionList(SessionState state) {
    return Column(
      children: state.sessions.asMap().entries.map((entry) {
        final index = entry.key;
        final session = entry.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SessionCard(
            title: "Día ${index + 1}",
            session: session,
          ),
        );
      }).toList(),
    );
  } */

  Widget _buildSessionList(SessionState state) {
    return SessionList(
      sessions: state.sessions,
    );
  }
}
