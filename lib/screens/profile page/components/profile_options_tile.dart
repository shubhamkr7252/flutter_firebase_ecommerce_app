import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/utils/color_interpolation.dart';

import '../../../theme/size.dart';

class ProfileOptionsTile extends StatelessWidget {
  const ProfileOptionsTile(
      {Key? key,
      required IconData icon,
      required String title,
      required Color bgColor,
      required Function onTap})
      : _icon = icon,
        _title = title,
        _bgColor = bgColor,
        _onTap = onTap,
        super(key: key);

  final IconData _icon;
  final String _title;
  final Color _bgColor;
  final Function _onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Theme.of(context).colorScheme.background,
        child: InkWell(
          borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
          splashColor: _bgColor.withOpacity(0.15),
          highlightColor: _bgColor.withOpacity(0.15),
          onTap: () {
            _onTap();
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? ColorInterpolation.lighten(_bgColor.withOpacity(0.15))
                        : _bgColor.withOpacity(0.15),
                    borderRadius:
                        BorderRadius.circular(SizeConfig.screenHeight! * .01)),
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenWidth! * .325,
              ),
              Positioned(
                left: 0,
                right: -SizeConfig.screenWidth! * .225,
                child: Icon(
                  _icon,
                  size: SizeConfig.screenHeight! * .085,
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? ColorInterpolation.lighten(_bgColor, 0.1)
                      : _bgColor,
                ),
              ),
              Positioned.fill(
                left: SizeConfig.screenWidth! * .03,
                bottom: SizeConfig.screenWidth! * .03,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            SizeConfig.screenHeight! * .01)),
                    child: Text(
                      _title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? ColorInterpolation.lighten(_bgColor, 0.1)
                            : _bgColor,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
