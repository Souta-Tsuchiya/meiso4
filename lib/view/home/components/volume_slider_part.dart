import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meiso/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

class VolumeSliderPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.volumeOff),
          Expanded(
            child: Selector<MainViewModel, double>(
              selector: (context, viewModel) => viewModel.sliderVolume,
              builder: (context, volume, child) {
                return Slider(
                  min: 0.0,
                  max: 20.0,
                  inactiveColor: Colors.white60.withOpacity(0.2),
                  activeColor: Colors.white,
                  divisions: 100,
                  label: volume.round().toString(),
                  value: volume,
                  onChanged: (double newVolume) => _changeVolume(context, newVolume),
                );
              },
            ),
          ),
          // ignore: deprecated_member_use
          Icon(FontAwesomeIcons.volumeUp),
        ],
      ),
    );
  }

  _changeVolume(BuildContext context, double newVolume) {
    final viewModel = context.read<MainViewModel>();
    viewModel.changeVolume(newVolume);
  }
}
