import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serene/blocs/sound_bloc.dart';
import 'package:serene/data/repository.dart';
import 'package:serene/model/category.dart';
import 'package:serene/screens/details/details_view.dart';

class CategoryDetailsPage extends StatefulWidget {
  final Category category;

  CategoryDetailsPage({Key key, @required this.category}) : super(key: key);

  @override
  _CategoryDetailsPageState createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
    testDevices: <String>[],
  );
  InterstitialAd createInterstitialAd() {
    return new InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded ||
              event == MobileAdEvent.failedToLoad ||
              event == MobileAdEvent.closed) {}
          print("Interstitial Event : $event");
        });
  }

  @override
  void initState() {
    print("Amit open");
    createInterstitialAd()
      ..load()
      ..show();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SoundBloc(repository: RepositoryProvider.of<DataRepository>(context)),
      child: DetailsView(category: widget.category),
    );
  }
}
