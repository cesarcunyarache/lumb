import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumb/domain/entities/device.dart';
import 'package:lumb/presentation/blocs/device/device_bloc.dart';
import 'package:lumb/presentation/blocs/device/device_event.dart';
import 'package:lumb/presentation/widgets/button.dart';
import 'package:lumb/presentation/widgets/reactive_text_form_field.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditDevice extends StatefulWidget {
  final Device device;
  const EditDevice({super.key, required this.device});

  @override
  State<EditDevice> createState() => _EditDeviceState();
}

class _EditDeviceState extends State<EditDevice> {
  final registerFormKey = GlobalKey<FormState>();

  FormGroup buildForm() => fb.group({
        'name': [widget.device.name, Validators.required],
        'description': [widget.device.description, Validators.required],
        'serialNumber': [widget.device.serialNumber, Validators.required],
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(40)),
      height: MediaQuery.of(context).size.height * 0.4,
      child: Center(
        child: ReactiveFormBuilder(
            form: buildForm,
            builder: (_, form, child) {
              return ReactiveForm(
                key: registerFormKey,
                formGroup: form,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ReactiveFormConsumer(builder: (_, form, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ReactiveInputField(
                          formControlName: 'name',
                          label: 'Nombre',
                          validationMessages: {
                            'required': (error) => 'El campo es obligatorio',
                          },
                        ),
                        const SizedBox(height: 10),
                        ReactiveInputField(
                          formControlName: 'description',
                          label: 'Descripción',
                          validationMessages: {
                            'required': (error) => 'El campo es obligatorio',
                          },
                        ),
                        const SizedBox(height: 10),
                        ReactiveInputField(
                          formControlName: 'serialNumber',
                          label: 'Número de serie',
                          disable: true,
                          validationMessages: {
                            'required': (error) => 'El campo es obligatorio',
                          },
                        ),
                        const SizedBox(height: 20),
                        ReactiveFormConsumer(
                          builder: (_, form, child) {
                            return CustomFilledButton(
                              onPressed: () {
                                form.markAllAsTouched();
                                
                                if (form.valid) {
                    
                                  BlocProvider.of<DeviceBloc>(context).add(
                                      UpdateDeviceEvent(Device(
                                          id: widget.device.id,
                                          description:
                                              form.control('description').value,
                                          name: form.control('name').value,
                                          serialNumber: form
                                              .control('serialNumber')
                                              .value,
                                          userId: widget.device.userId)));

                                        Navigator.pop(context);
                                }
                              },
                              text: 'Guardar',
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
                ),
              );
            }),
      ),
    );
  }
}
