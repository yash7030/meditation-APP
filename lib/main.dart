import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:mopub_flutter/mopub.dart';
import 'package:serene/blocs/blocs.dart';
import 'package:serene/blocs/playing_bloc.dart';
import 'package:serene/blocs/sound_bloc.dart';
import 'package:serene/config/constants.dart';
import 'package:serene/data/repository.dart';
import 'package:serene/screens/home/home_page.dart';

import 'blocs/simple_bloc_delegate.dart';

Future<void> main() async {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  // final initFuture = MobileAds.instance.initialize();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // MoPub.init(Constants.mopUbBannerId, testMode: true).then((value) {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<DataRepository>(
      create: (_) => DataRepository(),
      child: BlocProvider(
        create: (context) => CategoryBloc(
            repository: RepositoryProvider.of<DataRepository>(context)),
        child: app(),
      ),
    );
  }

  Widget app() {
    return MaterialApp(
      title: 'Stress Free Meditation Music',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF2C2C2C),
      ).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CategoryBloc(
                repository: RepositoryProvider.of<DataRepository>(context)),
          ),
          BlocProvider(
            create: (context) => PlayingSoundsBloc(
                repository: RepositoryProvider.of<DataRepository>(context)),
          ),
          BlocProvider(
            create: (context) => SoundBloc(
                repository: RepositoryProvider.of<DataRepository>(context)),
          ),
        ],
        child: HomePage(),
      ),
    );
  }
}
