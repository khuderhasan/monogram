import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Blocs/FeedBloc/feed_bloc.dart';
import 'Blocs/FriendsBloc/friends_bloc.dart';
import 'Blocs/RegisterBloc/register_bloc.dart';
import 'Blocs/SignInBloc/sign_in_bloc.dart';
import 'GetIt/main_app.dart';
import 'Providers/main_provider.dart';
import 'Providers/tabs_provider.dart';
import 'Repository/feed_repository.dart';
import 'Repository/friends_repository.dart';
import 'Repository/sign_in_register_repository.dart';
import 'View/splash_screen.dart';
import 'generated/l10n.dart';
import 'locator.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<RegisterBloc>(
        create: (context) =>
            RegisterBloc(signInRegisterRepository: SignInRegisterRepository()),
      ),
      BlocProvider<SignInBloc>(
        create: (context) =>
            SignInBloc(signInRegisterRepository: SignInRegisterRepository()),
      ),
      BlocProvider<FeedBloc>(
        create: (context) => FeedBloc(feedRepository: FeedRepository()),
      ),
      BlocProvider<FriendsBloc>(
        create: (context) =>
            FriendsBloc(friendsRepository: FriendsRepository()),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabsProvider()),
        ChangeNotifierProvider(create: (_) => MainProvider()),
      ],
      child: Consumer<MainProvider>(builder: (context, mainProvider, _) {
        return MaterialApp(
          title: 'Monogram',
          supportedLocales: S.delegate.supportedLocales,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.black,
            appBarTheme: const AppBarTheme(
              actionsIconTheme: IconThemeData(color: Colors.black),
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),
          locale: mainProvider.languageCode != null
              ? Locale(mainProvider.languageCode!)
              : null,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      }),
    );
  }
}
