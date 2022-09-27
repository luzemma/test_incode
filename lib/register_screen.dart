import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_incode/bloc/register/register_bloc.dart';
import 'package:test_incode/onboarding_incode_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registro'),
        ),
        body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildLabel(context,
                    'Completa la información para crear tu cuenta con una wallet llena de beneficios.'),
                _buildMargin(),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Nickname',
                      labelStyle:
                          const TextStyle(color: Colors.white, fontSize: 14),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      )),
                ),
                _buildMargin(),
                _buildLabel(context,
                    'El registro requiere de autenticación mediante una identificación.'),
                _buildMargin(),
                CheckboxListTile(
                    title: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Acepto los términos y condiciones de Incode',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    value: true,
                    onChanged: (newValue) {
                      BlocProvider.of<RegisterBloc>(context)
                          .add(AcceptTerms(newValue!));
                    }),
                _buildMargin(),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const OnboardingIncodeScreen()),
                      );
                    },
                    child: const Text('Iniciar Registro'))
              ],
            )));
  }

  Widget _buildMargin() => const SizedBox(height: 20);
  Widget _buildLabel(BuildContext context, String text) =>
      Text(text, style: Theme.of(context).textTheme.bodyMedium);
}
