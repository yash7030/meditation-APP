import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mopub_flutter/mopub_banner.dart';
import 'package:serene/blocs/result_state.dart';
import 'package:serene/blocs/sound_bloc.dart';
import 'package:serene/config/constants.dart';
import 'package:serene/config/dimen.dart';
import 'package:serene/config/typography.dart';
import 'package:serene/model/category.dart';
import 'package:serene/model/sound.dart';
import 'package:serene/screens/details/sound_button.dart';

class DetailsView extends StatefulWidget {
  final Category category;

  DetailsView({Key key, @required this.category}) : super(key: key);

  @override
  _DetailsViewState createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onAfterBuild(context));
  }

  void _onAfterBuild(BuildContext context) {
    BlocProvider.of<SoundBloc>(context)
        .add(FetchSounds(categoryId: widget.category.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // color: Colors.black,
          color: widget.category.color,
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.contain,
          ),
        ),
        child: contentArea(),
      ),
    );
  }

  Widget contentArea() {
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Column(
            children: [
              // Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 0.0, top: 0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          height: 23,
                          width: 23,
                          child: Image.asset(
                            'assets/images/back.png',
                          ),
                        ))),
              ),
              SizedBox(height: Dimen.padding * 6),
              Text(widget.category.title,
                  style: AppTypography.body()
                      .copyWith(fontSize: 25, fontWeight: FontWeight.w500)),
              SizedBox(height: Dimen.padding * 7),

              Expanded(
                child: Container(
                  child: sheetContentArea(),
                ),
              ),
            ],
          ),
          Positioned(
            top: 35,
            left: 160,
            right: 160,
            child: Container(
              // color: Colors.amber,
              child: Image.asset(
                widget.category.icon,
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sheetContentArea() {
    return Padding(
      padding: EdgeInsets.all(Dimen.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              // color: Colors.white10,
              width: 50,
              height: 4,
            ),
          ),
          SizedBox(height: Dimen.padding),
          showSounds()
        ],
      ),
    );
  }

  Widget showSounds() {
    return BlocBuilder<SoundBloc, Result>(builder: (context, state) {
      if (state is Empty) {
        return Center(child: Text('No Sounds Found'));
      }
      if (state is Loading) {
        return Center(child: CircularProgressIndicator());
      }
      if (state is Success) {
        return sheetContent(state.value);
      }
      if (state is Error) {
        return Center(child: Text('Error fetching sounds'));
      }
      return Center(child: Text('No sounds Found'));
    });
  }

  Widget sheetContent(List<Sound> sounds) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text(
          //   "Sounds",
          //   style: AppTypography.body2(),
          // ),
          SizedBox(height: Dimen.padding * 2),
          Expanded(
            child: soundViews(sounds),
          )
        ],
      ),
    );
  }

  Widget soundViews(List<Sound> sounds) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: Dimen.padding,
      mainAxisSpacing: Dimen.padding,
      childAspectRatio: 0.9,
      children: sounds
          .map(
            (sound) => SoundButton(sound: sound),
          )
          .toList(),
    );
  }
}
