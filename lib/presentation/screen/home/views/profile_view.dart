import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumb/presentation/blocs/auth/auth_bloc.dart';
import 'package:lumb/presentation/blocs/auth/auth_event.dart';
import 'package:lumb/presentation/blocs/auth/auth_state.dart';

import 'dart:math' as math;

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> rotateY;

  @override
  initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    rotateY = Tween<double>(
      begin: .0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.ease,
    ));
  }

  @override
  void dispose() {
    animationController.dispose(); // Detén y limpia el AnimationController
    super.dispose(); // Llama al dispose del widget padre
  }

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<AuthBloc>(context).getCurrentUser();

    return BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
      if (state is LoadingAuthState) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    final card = Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(user!.photoURL ??
                              'https://res.cloudinary.com/dboweswio/image/upload/v1733521005/lxao0bdwfmdyd1iti0ga.png'),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 4),
                            blurRadius: 4.0,
                          )
                        ],
                      ),
                    );

                    return Transform(
                      transform: Matrix4.rotationY(rotateY.value * math.pi),
                      alignment: Alignment.center,
                      child: card,
                    );
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                user!.displayName != null
                    ? Text(
                        user.displayName!,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const SizedBox(),
                Text(
                  user.email ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(
                      const BorderSide(
                        color: Colors.black12,
                        width: 1,
                      ),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context)
                        .add(SignOutAuthEvent(context: context));
                  },
                  child: const Text(
                    "Cerrar Sesión",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
