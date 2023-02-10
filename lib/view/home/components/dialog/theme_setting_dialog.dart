import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meiso/data_model/meiso_theme.dart';
import 'package:meiso/generated/l10n.dart';
import 'package:meiso/view/common/ripple_widget.dart';
import 'package:meiso/view/home/home_screen.dart';
import 'package:meiso/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

class ThemeSettingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isSubscribed = context.select<MainViewModel, bool>((viewModel) => viewModel.isSubscribed);

    return Padding(
      padding: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0, bottom: 8.0),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 12.0,
              ),
              Text(S.of(context).selectTheme),
              SizedBox(
                height: 12.0,
              ),
              Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: List.generate(
                    meisoThemes.length,
                    (index) => RippleWidget(
                      onTap: () {
                        if(index == THEME_ID_SILENCE || isSubscribed) {
                          _setTheme(context, index);
                        }else{
                          Fluttertoast.showToast(msg: S.of(context).needSubscribe, gravity: ToastGravity.BOTTOM, toastLength: Toast.LENGTH_LONG);
                        }
                        Navigator.pop(context);
                      },
                      child: Opacity(
                        opacity:(index == THEME_ID_SILENCE || isSubscribed) ? 1.0: 0.3,
                        child: GridTile(
                          child: Image.asset(
                            meisoThemes[index].imagePath,
                            fit: BoxFit.cover,
                          ),
                          footer: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                meisoThemes[index].themeName,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 11.0,
            right: 8.0,
            child: RippleWidget(
              onTap: () => Navigator.pop(context),
              // ignore: deprecated_member_use
              child: FaIcon(FontAwesomeIcons.windowClose),
            ),
          ),
        ],
      ),
    );
  }

  _setTheme(BuildContext context, int index) async {
    final viewModel = context.read<MainViewModel>();
    await viewModel.setTheme(index);
  }
}
