import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/utill/images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function onBackPressed;
  final bool isCenter;
  final bool isElevation;
  final bool isTrailing;
  CustomAppBar(
      {@required this.title,
      this.isTrailing = false,
      this.isBackButtonExist = true,
      this.onBackPressed,
      this.isCenter = true,
      this.isElevation = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: poppinsMedium.copyWith(
              fontSize: Dimensions.FONT_SIZE_LARGE,
              color: Theme.of(context).textTheme.bodyText1.color)),
      centerTitle: isCenter ? true : false,
      actions: [
        isTrailing
            ? Row(
                children: [
                  SizedBox(
                    height: 23,
                    width: 23,
                    child: Image(
                      image: AssetImage(Images.blog),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              )
            : SizedBox.shrink()
      ],
      leading: isBackButtonExist
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyText1.color,
              onPressed: () => onBackPressed != null
                  ? onBackPressed()
                  : Navigator.pop(context),
            )
          : SizedBox(),
      backgroundColor: Theme.of(context).cardColor,
      elevation: isElevation ? 2 : 0,
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}
