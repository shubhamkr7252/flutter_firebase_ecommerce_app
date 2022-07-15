import 'package:flutter/material.dart';

import '../../../theme/size.dart';

class ProfileOptionsTile extends StatelessWidget {
  const ProfileOptionsTile({
    Key? key,
    required IconData icon,
    required IconData iconOutline,
    required String title,
    required Function onTap,
  })  : _icon = icon,
        _iconOutline = iconOutline,
        _title = title,
        _onTap = onTap,
        super(key: key);

  final IconData _icon;
  final IconData _iconOutline;
  final String _title;
  final Function _onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
      onTap: () {
        _onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius:
                BorderRadius.circular(SizeConfig.screenHeight! * .01)),
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.all(SizeConfig.screenHeight! * .025),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            Stack(
              children: [
                Icon(
                  _icon,
                  size: SizeConfig.screenWidth! * .115,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                Icon(
                  _iconOutline,
                  size: SizeConfig.screenWidth! * .115,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
