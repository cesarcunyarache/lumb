import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:lumb/config/animations/fade_in_slide.dart';

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

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  ValueNotifier<bool> termsCheck = ValueNotifier(false);
  final registerFormKey = GlobalKey<FormState>();
  String? correo = "";
  String? contrasena = "";
  String? repetirContrasena = "";

  FormGroup buildForm() => fb.group({
        'email': ['', Validators.required, Validators.email],
        'password': [
          '',
          Validators.required,
          Validators.minLength(6),
        ],
        'passwordConfirmation': ['', Validators.required],
        'acceptTerms': FormControl<bool>(
          value: false,
          validators: [Validators.requiredTrue],
        ),
      }, [
        Validators.mustMatch('password', 'passwordConfirmation')
      ]);

  @override
  Widget build(BuildContext context) {
    /* final isDark = Theme.of(context).brightness == Brightness.dark; */

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
          body: ReactiveFormBuilder(
            form: buildForm,
            builder: (_, form, child) {
              /*    final group = form.controls; */
              return Center(
                  child: ReactiveForm(
                key: registerFormKey,
                formGroup: form,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ReactiveFormConsumer(builder: (_, form, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
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
                                "Regístrate",
                                style: context.hm!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Roboto'),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Únete a Lumb y descubre un mundo de bienestar y equilibrio.",
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
                        const SizedBox(height: 10),
                        FadeInSlide(
                          duration: .7,
                          child: ReactiveInputFieldObscure(
                            formControlName: 'passwordConfirmation',
                            label: 'Confirmar Contraseña',
                            obscureText: true,
                            validationMessages: {
                              'required': (error) =>
                                  'La contraseña es obligatoria',
                              'mustMatch': (error) =>
                                  'Las contraseñas no coinciden',
                              // You can add more custom validators if needed
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeInSlide(
                          duration: .8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ReactiveFormField<bool, bool>(
                                formControlName: 'acceptTerms',
                                validationMessages: {
                                  'requiredTrue': (error) =>
                                      'Debe aceptar los Términos y Condiciones.',
                                },
                                builder: (field) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: field.value ?? false,
                                            onChanged: (bool? value) {
                                              field.didChange(value ?? false);
                                            },
                                          ),
                                          RichTwoPartsText(
                                            text1: "Acepto los ",
                                            text2: "Términos y Condiciones.",
                                            onTap: () {
                                              debugPrint(
                                                  "Navegar a términos y condiciones");
                                            },
                                          ),
                                        ],
                                      ),
                                      // Mensaje de error
                                    ],
                                  );
                                },
                                showErrors: (control) =>
                                    control.invalid && control.touched,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeInSlide(
                          duration: 1,
                          direction: FadeSlideDirection.btt,
                          child: ReactiveFormConsumer(
                            builder: (_, form, child) {
                              return CustomFilledButton(
                                onPressed: () {
                                  form.markAllAsTouched();

                                  if (form.valid) {
                                    debugPrint(form.rawValue.toString());

                                    BlocProvider.of<AuthBloc>(context)
                                        .add(SignUpEmailPasswordAuthEvent(
                                      email: form.control('email').value,
                                      password: form.control('password').value,
                                      context: context,
                                    ));
                                  } else {
                                    if (form.control('acceptTerms').value ==
                                        false) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Por favor, acepta los Términos y Condiciones para continuar con el registro.')));
                                    }
                                  }
                                },
                                text: 'Registrar',
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
                                "   O regístrate con   ",
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
                            const SizedBox(width: 15),
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
                            text1: "¿Ya tienes una cuenta? ",
                            text2: "Inicia Sesión",
                            onTap: () {
                              context.pushReplacementNamed('/signIn');
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    );
                  }),
                ),
              ));
            },
          ),
        );
      }
    });
  }
}
