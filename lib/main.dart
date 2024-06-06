import 'package:barbershop2/classes/Estabelecimento.dart';
import 'package:barbershop2/firebase_options.dart';
import 'package:barbershop2/functions/CorteProvider.dart';
import 'package:barbershop2/functions/createAccount.dart';
import 'package:barbershop2/functions/managerScreenFunctions.dart';
import 'package:barbershop2/functions/profileScreenFunctions.dart';
import 'package:barbershop2/functions/providerFilterStrings.dart';
import 'package:barbershop2/functions/rankingProviderHome.dart';
import 'package:barbershop2/functions/twilio_messagesFunctions.dart';
import 'package:barbershop2/functions/userLogin.dart';
import 'package:barbershop2/notifications/firebase_notifications.dart';
import 'package:barbershop2/rotas/Approutes.dart';
import 'package:barbershop2/screen/add/confirmscreen/ConfirmScreenCorte.dart';
import 'package:barbershop2/screen/home/homeScreen01.dart';
import 'package:barbershop2/screen/inicio/initialScreen.dart';
import 'package:barbershop2/screen/login/loginScreen.dart';
import 'package:barbershop2/screen/manager/funcionario/componentes/ConfirmScreenCorte.dart';
import 'package:barbershop2/screen/manager/funcionario/componentes/encaixeScreen.dart';
import 'package:barbershop2/screen/manager/principal/ConfirmScreenCorte.dart';
import 'package:barbershop2/screen/manager/principal/ManagerScreen.dart';
import 'package:barbershop2/screen/manager/funcionario/funcionario_screen.dart';
import 'package:barbershop2/screen/manager/principal/agenda_7dias/agenda7diasscreen.dart';
import 'package:barbershop2/screen/manager/principal/agenda_7dias/confirmCancelCorte.dart';
import 'package:barbershop2/screen/manager/principal/components/agendaDia/pricesandpercentages/PricesAndPercentagens.dart';
import 'package:barbershop2/screen/manager/principal/encaixe/encaixeScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'screen/login/registerAccount.dart';
import 'rotas/verificationLogin.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Chame primeiro aqui ele inicia os widgets
  //so apos dar o start, ele inicia o firebase, aqui o app ja esta carregado e funcionando
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    await FirebaseNotifications().initNotifications();
  } catch (e) {
    print("erro ao iniciar as mensagens");
  }
  try {
    analytics.setAnalyticsCollectionEnabled(true);
    print("Inicializamos o ga4 no app");
  } catch (e) {
    print("run app ativando GA4 deu este erro: ${e}");
  }
  //Crashlist para enviar erros que acontecem no cll do usuario
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MyProfileScreenFunctions(),
        ),
        ChangeNotifierProvider(
          create: (_) => CreateAccount(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserLoginApp(),
        ),
        ChangeNotifierProvider(
          create: (_) => CorteProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RankingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ManagerScreenFunctions(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProviderFilterManager(),
        ),
                ChangeNotifierProvider(
          create: (_) => Twilio_messagesFunction(),
        ),
      ],

      //TESTE DO REPOSITORIO
      child: MaterialApp(
        supportedLocales: const [
          Locale('pt', 'BR'), // Português do Brasil
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.white,
            cancelButtonStyle: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            confirmButtonStyle: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(
                const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: Estabelecimento.nomeLocal,
        routes: {
          AppRoutesApp.VerificationLoginScreen01: (ctx) =>
              const VerificationLoginScreen01(),
          AppRoutesApp.InitialScreenApp: (ctx) => const InitialScreenApp(),
          AppRoutesApp.LoginScreen01: (ctx) => const LoginScreen01(),
          AppRoutesApp.HomeScreen01: (ctx) => const HomeScreen01(),
          AppRoutesApp.RegisterAccountScreen: (ctx) =>
              const RegisterAccountScreen(),
          AppRoutesApp.ConfirmScreenCorte: (ctx) => const ConfirmScreenCorte(),
          AppRoutesApp.ManagerScreenView: (ctx) => const ManagerScreenView(),
          AppRoutesApp.Agenda7DiasScreenManager: (ctx) =>
              const Agenda7DiasScreenManager(),
          AppRoutesApp.ConfirmCancelCorte: (ctx) => const ConfirmCancelCorte(),
          AppRoutesApp.EncaixeScreen: (ctx) => const EncaixeScreen(),
          AppRoutesApp.FuncionarioScreen: (ctx) => const FuncionarioScreen(),
          AppRoutesApp.PricesAndPercentages: (ctx)=> const PricesAndPercentages(),
          AppRoutesApp.ConfirmScreenCorteEncaixeFuncionario: (ctx)=>ConfirmScreenCorteEncaixeFuncionario(),
          AppRoutesApp.EncaixeScreenFuncionario: (ctx)=>EncaixeScreenFuncionario(),
          AppRoutesApp.ConfirmScreenCorteManager: (ctx)=>ConfirmScreenCorteManager(),
        },
      ),
    );
  }
}
