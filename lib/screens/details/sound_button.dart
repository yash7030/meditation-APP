import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:serene/blocs/sound_bloc.dart';
import 'package:serene/config/constants.dart';
import 'package:serene/model/sound.dart';

class SoundButton extends StatefulWidget {
  final Sound sound;

  SoundButton({@required this.sound});

  @override
  State<StatefulWidget> createState() {
    return SoundButtonState();
  }
}

class SoundButtonState extends State<SoundButton> {
  final Color activeColor = Color(0xFF1D2632).withOpacity(0.8);
  final Color inactiveColor = Color(0xFF1D2632).withOpacity(0.2);

  bool active = false;
  double volume = 1;

  @override
  void initState() {
    super.initState();
    active = widget.sound.active;
    volume = widget.sound.volume.toDouble();
    // _loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    _onButtonClick() async {
      setState(() {
        this.active = !active;
      });
      // await interstitialAd.load();

      var i =
          GetStorage().read('click') == null ? 0 : GetStorage().read('click');
      GetStorage().write('click', i + 1);
      print('Click + ${GetStorage().read('click')}');
      if (GetStorage().read('click') == 5) {
        print("Show add");
        // interstitialAd.show();
        GetStorage().erase();
      }
      BlocProvider.of<SoundBloc>(context).add(UpdateSound(
          soundId: widget.sound.id, active: active, volume: volume));
    }

    return Container(
        padding: EdgeInsets.only(top: 10),
        height: 50,
        decoration: BoxDecoration(
            color: active ? Color(0xFFD5E9E8) : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: InkWell(
          splashColor: Colors.black,
          child: Column(
            children: [
              Container(
                height: 40,
                width: 40,
                child: Image.asset(
                  widget.sound.icon,
                  color: active ? activeColor : inactiveColor,
                ),
              ),
              volumeSlider()
            ],
          ),
          onTap: _onButtonClick,
        ));
  }

  Widget volumeSlider() {
    _onVolumeChanged(double volume) {
      setState(() {
        this.volume = volume;
      });
      BlocProvider.of<SoundBloc>(context).add(UpdateSound(
          soundId: widget.sound.id, active: active, volume: volume));
    }

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: activeColor,
        inactiveTrackColor:
            active ? activeColor.withOpacity(0.5) : inactiveColor,
        disabledActiveTrackColor: inactiveColor,
        disabledThumbColor: inactiveColor,
        trackShape: RoundedRectSliderTrackShape(),
        thumbColor: activeColor,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
        overlayColor: activeColor.withOpacity(0.2),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 18.0),
      ),
      child: Slider(
        value: volume,
        min: Constants.minSliderValue,
        max: Constants.maxSliderValue,
        onChanged: active
            ? (double newValue) {
                _onVolumeChanged(newValue.round().toDouble());
              }
            : null,
      ),
    );
  }
}
