import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lumb/config/animations/fade_in_slide.dart';
import 'package:lumb/config/colors/app_colors.dart';
import 'package:lumb/config/common/app_assets.dart';
import 'package:lumb/config/common/app_text_styles.dart';
import 'package:lumb/config/common/text_style_ext.dart';
import 'package:lumb/presentation/blocs/auth/auth_bloc.dart';
import 'package:lumb/presentation/blocs/auth/auth_event.dart';
import 'package:lumb/presentation/blocs/auth/auth_state.dart';
import 'package:lumb/presentation/widgets/auth_button.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isDark = theme.brightness ==
        Brightness
            .dark; // MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final height = size.height;

    return BlocBuilder<AuthBloc, AuthState>(builder: (_, state) {
      if (state is LoadingAuthState) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDart : Colors.white,
          body: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                FadeInSlide(
                  duration: .4,
                  child: SizedBox(
                    height: 71,
                    child: Image.asset(
                      AppAssets.icon,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                FadeInSlide(
                  duration: .5,
                  child: Text(
                    "¡Bienvenido!",
                    style: theme.textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w900,
                        fontFamily: AppTextStyles.fontFamily),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: height * 0.015),
                FadeInSlide(
                  duration: .6,
                  child: Text(
                    "a Lumb IoT: Controla tu parche térmico de manera inteligente.",
                    style: context.tm!.copyWith(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign
                        .center, // Esto centrará el texto dentro del widget
                  ),
                ),
                const SizedBox(height: 30),
                const FadeInSlide(
                  duration: .6,
                  child: Text(
                    "Continua con:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                FadeInSlide(
                  duration: .7,
                  child: LoginButton(
                    icon: Brand(Brands.google, size: 25),
                    text: "Continuar con Google",
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(
                        SignInWithGoogleAuthEvent(
                          context: context,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: height * 0.02),
                FadeInSlide(
                  duration: .9,
                  child: LoginButton(
                    icon: Brand(Brands.facebook, size: 25),
                    text: "Continuar con Facebook",
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(
                        SignInWithFacebookAuthEvent(
                          context: context,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: height * 0.02),
                FadeInSlide(
                  duration: .8,
                  child: LoginButton(
                    icon: Icon(
                      Icons.person_off,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    text: "Continuar Anónimo",
                    onPressed: () {
                      context.push('/home');
                    },
                  ),
                ),
                SizedBox(height: height * 0.02),
                /* FadeInSlide(
              duration: 1.0,
              child: LoginButton(
                icon: Brand(Brands.twitter, size: 25),
                text: "Continue with Twitter",
                onPressed: () {},
              ),
            ), */
                const Spacer(),
                FadeInSlide(
                  duration: 1.1,
                  child: FilledButton(
                    onPressed: () => context.push('/signUp'),
                    style: FilledButton.styleFrom(
                        textStyle: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily),
                        fixedSize: const Size.fromHeight(50),
                        backgroundColor: AppColors.primaryColor),
                    child: Text(
                      "Regístrate",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? AppColors.colorTextDart : Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                FadeInSlide(
                  duration: 1.2,
                  child: FilledButton(
                    onPressed: () => context.push('/signIn'),
                    style: FilledButton.styleFrom(
                      textStyle:
                          const TextStyle(fontFamily: AppTextStyles.fontFamily),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 171, 171, 171),
                        width: .3,
                      ),
                      fixedSize: const Size.fromHeight(50),
                      backgroundColor: isDark
                          ? const Color.fromARGB(255, 20, 20, 20)
                          : Colors.white70,
                    ),
                    child: Text(
                      "Iniciar sesión",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.colorTextDart
                            : AppColors.colorText,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                /* const FadeInSlide(
              duration: 1.0,
              direction: FadeSlideDirection.btt,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Privacy Policy"),
                  Text("   -   "),
                  Text("Terms of Service"),
                ],
              ),
            ), */
                SizedBox(height: height * 0.02),
              ],
            ),
          ),
        );
      }
    });
  }
}
