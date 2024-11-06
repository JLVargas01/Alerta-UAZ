import 'package:alerta_uaz/application/setting/setting_bloc.dart';
import 'package:alerta_uaz/application/setting/setting_event.dart';
import 'package:alerta_uaz/application/setting/setting_state.dart';
import 'package:alerta_uaz/domain/model/setting_model.dart';
import 'package:alerta_uaz/presentation/widget/dropdown_button_widget.dart';
import 'package:alerta_uaz/presentation/widget/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    context.read<SettingBloc>().add(LoadSetting());
  }

  void _onSettingChange() {
    setState(() {
      _hasChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: BlocListener<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is SettingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: BlocBuilder<SettingBloc, SettingState>(
          builder: (context, state) {
            if (state is Settingloading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SettingLoaded) {
              return buildPage(context, state.settings);
            } else if (state is SettingSaved) {
              return buildPage(context, state.settings);
            } else {
              return const Center(
                child: Text('Configuración no disponible'),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildPage(BuildContext context, Settings settings) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Configura la sensibilidad.'),
          DropdownButtonWidget(
            items: const ['Alto', 'Medio', 'Bajo'],
            initialValue: settings.getSensitivity,
            onChange: (dynamic newValue) {
              settings.setSensitivity(newValue as String);
              _onSettingChange();
            },
          ),
          const SizedBox(height: 30),
          const Text('Tiempo mínimo para activar la alerta (segundos).'),
          SliderWidget(
            initialValue: settings.getMinTime,
            min: 3.0,
            max: 10.0,
            division: 7,
            onChange: (double newValue) {
              settings.setMinTime(newValue);
              _onSettingChange();
            },
          ),
          const SizedBox(height: 30),
          const Text('Cantidad de shake para activar la alerta'),
          SliderWidget(
            initialValue: settings.getShakeAmount,
            min: 3.0,
            max: 10.0,
            division: 7,
            onChange: (double newValue) {
              settings.setShakeAmount(newValue);
              _onSettingChange();
            },
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pushNamed(context, "/shake");
              //   },
              //   child: const Text('Probar'),
              // ),
              ElevatedButton(
                  onPressed: _hasChanges
                      ? () {
                          context.read<SettingBloc>().add(LoadSetting());
                          setState(() {
                            _hasChanges = false;
                          });
                        }
                      : null,
                  child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: _hasChanges
                    ? () {
                        context
                            .read<SettingBloc>()
                            .add(SaveSetting(settings: settings));
                        setState(() {
                          _hasChanges = false;
                        });
                      }
                    : null,
                child: const Text('Guardar'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
