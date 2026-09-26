// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:lumb/config/animations/fade_in_slide.dart';
import 'package:lumb/config/colors/app_colors.dart';
import 'package:lumb/config/common/app_assets.dart';

import 'package:lumb/config/common/text_style_ext.dart';

import 'package:lumb/presentation/blocs/auth/auth_bloc.dart';
import 'package:lumb/presentation/blocs/auth/auth_event.dart';
import 'package:lumb/presentation/blocs/auth/auth_state.dart';
import 'package:lumb/presentation/widgets/auth_button.dart';
import 'package:lumb/presentation/widgets/button.dart';
import 'package:lumb/presentation/widgets/reactive_text_form_field.dart';
import 'package:lumb/presentation/widgets/reactive_text_form_field_obscure.dart';

import 'package:lumb/presentation/screen/auth/widgets/widgets.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  ValueNotifier<bool> termsCheck = ValueNotifier(false);
  final registerFormKey = GlobalKey<FormState>();
  String? correo = "";
  String? contrasena = "";

  FormGroup buildForm() => fb.group({
        'email': ['', Validators.required, Validators.email],
        'password': [
          '',
          Validators.required,
        ],
      });

  @override
  Widget build(BuildContext context) {
   /*  final isDark = Theme.of(context).brightness == Brightness.dark; */

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
          body:  ReactiveFormBuilder(
            form: buildForm,
            builder: (_, form, child) {
              
              
              return  Center(
            // Centra todo el contenido en el medio
            child: ReactiveForm(
               key: registerFormKey,
                formGroup: form,
              child: SingleChildScrollView(
                // Para permitir el desplazamiento si es necesario
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: 
                ReactiveFormConsumer(builder: (_, form, child) {

                return Column(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Centra el contenido verticalmente
                  children: [
                    FadeInSlide(
                      duration: .4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 71,
                            child: Image.asset(
                              AppAssets.icon,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "Iniciar Sesión",
                            style: context.hm!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto'),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Accede y toma el control de tu bienestar con Lumb. ¡Inicia sesión ahora!",
                            style: context.tm!.copyWith(
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    FadeInSlide(
                          duration: .7,
                          child: ReactiveInputField(
                            formControlName: 'email',
                            label: 'Correo Electrónico',
                            keyboardType: TextInputType.emailAddress,
                            validationMessages: {
                              'required': (error) => 'El correo es obligatorio',
                              'email': (error) => 'Introduce un correo válido',
                            },
                          ),
                        ),
                    const SizedBox(height: 10),
                    FadeInSlide(
                          duration: .7,
                          child: ReactiveInputFieldObscure(
                            formControlName: 'password',
                            label: 'Contraseña',
                            obscureText: true,
                            validationMessages: {
                              'required': (error) =>
                                  'La contraseña es obligatoria',
                              'minLength': (error) =>
                                  'La contraseña debe tener al menos 6 caracteres',
                            },
                          ),
                        ),
                    FadeInSlide(
                      duration: .8,
                      child: Row(
                        children: [
                          const Spacer(),
                          TextButton(
                            onPressed: () => context.push('/'),
                            child: const Text("¿Olvidaste tu contraseña?",
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto")),
                          ),
                        ],
                      ),
                    ),
                    FadeInSlide(
                          duration: 1,
                          direction: FadeSlideDirection.btt,
                          child: ReactiveFormConsumer(
                            builder: (_, form, child) {
                              return CustomFilledButton(
                                onPressed: () {
                                  form.markAllAsTouched();

                                  if (form.valid) {


                                    BlocProvider.of<AuthBloc>(context)
                                        .add(SignInEmailPasswordAuthEvent(
                                      email: form.control('email').value,
                                      password: form.control('password').value,
                                      context: context,
                                    ));
                                  } 
                                },
                                text: 'Iniciar Sesión',
                              );
                            },
                          ),
                        ),
                    const SizedBox(height: 30),
                    FadeInSlide(
                      duration: .9,
                      child: Row(
                        children: [
                          const Expanded(
                              child: Divider(
                            thickness: .3,
                          )),
                          Text(
                            "   O inicia sesión con   ",
                            style: context.tm,
                          ),
                          const Expanded(
                              child: Divider(
                            thickness: .3,
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FadeInSlide(
                            duration: 1,
                            child: LoginButton(
                              icon: Brand(Brands.google, size: 25),
                              text: "Google",
                              onPressed: () {
                                BlocProvider.of<AuthBloc>(context).add(
                                  SignInWithGoogleAuthEvent(
                                    context: context,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                            width:
                                15), // Use SizedBox for spacing between buttons
                        Expanded(
                          child: FadeInSlide(
                            duration: 1.2,
                            child: LoginButton(
                              icon: Brand(Brands.facebook, size: 25),
                              text: "Facebook",
                              onPressed: () {
                                BlocProvider.of<AuthBloc>(context).add(
                                  SignInWithFacebookAuthEvent(
                                    context: context,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    FadeInSlide(
                      duration: .8,
                      child: RichTwoPartsText(
                        text1: "¿Aún no tienes una cuenta? ",
                        text2: "Regístrate",
                        onTap: () {
                          context.pushReplacementNamed('/signUp');
                        },
                      ),
                    ),
                  ],
                );
                }),
              ),
            ),
            );
      })
      
        );
      }
    });
  }

  getEmail(String value) {}
}
