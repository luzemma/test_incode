import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_incode/bloc/incode_onboarding/incode_onboarding_bloc.dart';
import 'package:test_incode/bloc/register/register_bloc.dart';
import 'package:test_incode/register_screen.dart';
import 'package:test_incode/repositories/preferences_repository_impl.dart';

final preferencesRepository = PreferencesRepositoryImpl();
Future<void> main() async {
  await dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();

  runApp(RepositoryProvider(
    create: (context) => PreferencesRepositoryImpl(),
    child: MultiBlocProvider(providers: [
      BlocProvider(create: ((context) => RegisterBloc())),
      BlocProvider(
          create: ((context) => IncodeOnboardingBloc(
              preferencesRepository: preferencesRepository))),
    ], child: const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const RegisterScreen(),
    );
  }
}
