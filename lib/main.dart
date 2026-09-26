
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lumb/config/routes/router.dart';
import 'package:lumb/domain/repository/auth_repository.dart';
import 'package:lumb/inject_dependecies.dart';
import 'package:lumb/presentation/blocs/auth/auth_bloc.dart';
import 'package:lumb/presentation/blocs/cubits/bluetooth_cubit.dart';
import 'package:lumb/presentation/blocs/cubits/bottom_nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:lumb/config/theme/app_theme.dart';
import 'package:lumb/presentation/blocs/cubits/session_cubit.dart';
import 'package:lumb/presentation/blocs/cubits/scroll_cubit.dart';
import 'package:lumb/presentation/blocs/device/device_bloc.dart';
import 'package:lumb/presentation/blocs/session/session_bloc.dart';
import 'package:lumb/presentation/blocs/user/user_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
 /*  Intl.defaultLocale = 'es_PE'; */

  injectDependencies();
  final isLoggedIn = sl<AuthRepository>().isLoggedIn();

  await initializeDateFormatting('es_PE', null);
  Intl.defaultLocale = 'es_PE'; 
  runApp(
    App(
      initialRoute: isLoggedIn ? '/home' : '/getStarted',
    ),
  );

  
}

class App extends StatelessWidget {
  final String initialRoute;
  const App({
    super.key,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    final router = AppRouter(initialRoute).router;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BottomNavCubit(),
        ),
        BlocProvider(
          create: (context) => ScrollCubit(),
        ),
        BlocProvider<SessionCubit>(create:  (context) => sl()),
        BlocProvider<AuthBloc>(
          create: (context) => sl(),
        ),
        BlocProvider<DeviceBloc>(
          create: (context) => sl(),
        ),
        BlocProvider<SessionBloc>(
          create: (context) => sl(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => sl(),
        ),
        BlocProvider<BluetoothCubit>(
          create: (context) => sl(),
        )
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        routerDelegate: router.routerDelegate,
      ),
    );
  }
}
