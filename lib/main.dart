
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/UI/Screens/home.dart';
import 'package:todo_app/UI/Screens/splash.dart';
import 'package:todo_app/UI/utils/app_theme.dart';
import 'package:todo_app/cashe/cash_data.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/provider/language_provider.dart';
import 'package:todo_app/provider/tasks_provider.dart';
import 'package:todo_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/views/sign%20in_screen/sign_in.dart';
import 'package:todo_app/views/signup_screen/sign_up.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await CashData.cacheInitialization(); 

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String savedLanguage = CashData.getData(key: "lang") ?? "en";
  String savedTheme = CashData.getData(key: "theme") ?? "light";

  ThemeMode savedAppTheme =
      savedTheme == "dark" ? ThemeMode.dark : ThemeMode.light;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ThemeProvider(initialAppTheme: savedAppTheme)),
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(initialLanguage: savedLanguage),
        ),
        ChangeNotifierProvider(create: (context) => TasksProvider()),
        ChangeNotifierProvider(create: (context) => LocalAuthProvider()),
      ],
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of(context)!;
    LanguageProvider languageProvider = Provider.of(context)!;
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageProvider.selectedLanguage),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.appTheme,
      debugShowCheckedModeBanner: false,
      routes: {
        Splash.routeName: (context) => const Splash(),
        Home.routeName: (context) => const Home(),
        SignIn.routeName: (context) => const SignIn(),
        SignUp.routeName: (context) => const SignUp(),
      },
      // ignore: unnecessary_null_comparison
      initialRoute: FirebaseAuth.instance.currentUser?.uid == null
          ? Splash.routeName
          : Home.routeName,
    );
  }
}
