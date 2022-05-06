import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/profile_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/base/not_login_screen.dart';
import 'package:flutter_grocery/view/screens/auth/login_screen.dart';
import 'package:flutter_grocery/view/screens/home/widget/bottom_navigation.dart';
import 'package:flutter_grocery/view/screens/menu/menu_screen.dart';
import 'package:flutter_grocery/view/screens/menu/widget/custom_drawer.dart';
import 'package:flutter_grocery/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:flutter_grocery/view/screens/profile/profile_edit_screen.dart';
import 'package:flutter_grocery/view/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';

import '../notification/notification_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      Provider.of<ProfileProvider>(context, listen: false)
          .getUserID(context)
          .then((value) => (log(value.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
          child: _isLoggedIn
              ? Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) => Scrollbar(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_LARGE),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(Images.profile_bg),
                                fit: BoxFit.fitHeight)),
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.13,
                                ),
                                Text(
                                  "My Profile",
                                  style: poppinsMedium.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                                      color: ColorResources.getPrimaryColor(
                                          context)),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorResources.getPrimaryColor(
                                              context)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: ListTile(
                                    title: Text(
                                      '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}',
                                      style: poppinsSemiBold.copyWith(
                                          fontSize:
                                              Dimensions.FONT_SIZE_DEFAULT),
                                    ),
                                    subtitle: Text(
                                      '${profileProvider.userInfoModel.email ?? ''}',
                                      style: poppinsSemiBold.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL),
                                    ),
                                    trailing: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  ColorResources.getGreyColor(
                                                      context),
                                              width: 2),
                                          shape: BoxShape.circle),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        // borderRadius: BorderRadius.circular(50),
                                        child: profileProvider.file == null
                                            ? FadeInImage.assetNetwork(
                                                placeholder: Images.placeholder,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                                image:
                                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profileProvider.userInfoModel.image}',
                                                imageErrorBuilder: (c, o, s) =>
                                                    Image.asset(
                                                        Images.placeholder,
                                                        height: 100,
                                                        width: 100,
                                                        fit: BoxFit.cover))
                                            : Image.file(profileProvider.file,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.fill),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: ColorResources
                                                  .getPrimaryColor(context),
                                              border: Border.all(
                                                  color: ColorResources
                                                      .getPrimaryColor(
                                                          context)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(Dimensions
                                                      .PADDING_SIZE_LARGE))),
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  RouteHelper
                                                      .getProfileEditRoute(
                                                    profileProvider
                                                        .userInfoModel.fName,
                                                    profileProvider
                                                        .userInfoModel.lName,
                                                    profileProvider
                                                        .userInfoModel.email,
                                                    profileProvider
                                                        .userInfoModel.phone,
                                                  ),
                                                  arguments: ProfileEditScreen(
                                                      userInfoModel:
                                                          profileProvider
                                                              .userInfoModel),
                                                );
                                              },
                                              child: ListTile(
                                                title: Text(
                                                  "Edit Personal Details",
                                                  style: poppinsMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_DEFAULT,
                                                      color: Colors.white),
                                                ),
                                                trailing: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              )),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: ColorResources
                                                  .getPrimaryColor(context),
                                              border: Border.all(
                                                  color: ColorResources
                                                      .getPrimaryColor(
                                                          context)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    RouteHelper.notification,
                                                    arguments:
                                                        NotificationScreen());
                                              },
                                              child: ListTile(
                                                title: Text(
                                                  "Notifications",
                                                  style: poppinsMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_DEFAULT,
                                                      color: Colors.white),
                                                ),
                                                trailing: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              )),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: ColorResources
                                                  .getPrimaryColor(context),
                                              border: Border.all(
                                                  color: ColorResources
                                                      .getPrimaryColor(
                                                          context)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: ListTile(
                                              title: Text(
                                                "Security",
                                                style: poppinsMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_DEFAULT,
                                                    color: Colors.white),
                                              ),
                                              trailing: IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              )),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: ColorResources
                                                  .getPrimaryColor(context),
                                              border: Border.all(
                                                  color: ColorResources
                                                      .getPrimaryColor(
                                                          context)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) =>
                                                        SignOutConfirmationDialog());
                                              },
                                              child: ListTile(
                                                title: Text(
                                                  "Log Out",
                                                  style: poppinsMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_DEFAULT,
                                                      color: Colors.white),
                                                ),
                                                trailing: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              )),
                                        ),
                                      ]),
                                )
                                /* Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: 12, bottom: 12),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    ColorResources.getGreyColor(
                                                        context),
                                                width: 2),
                                            shape: BoxShape.circle),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: profileProvider.file == null
                                              ? FadeInImage.assetNetwork(
                                                  placeholder:
                                                      Images.placeholder,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                  image:
                                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profileProvider.userInfoModel.image}',
                                                  imageErrorBuilder:
                                                      (c, o, s) => Image.asset(
                                                          Images.placeholder,
                                                          height: 100,
                                                          width: 100,
                                                          fit: BoxFit.cover))
                                              : Image.file(profileProvider.file,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.fill),
                                        )),
                                    Positioned(
                                      right: -10,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            RouteHelper.getProfileEditRoute(
                                              profileProvider
                                                  .userInfoModel.fName,
                                              profileProvider
                                                  .userInfoModel.lName,
                                              profileProvider
                                                  .userInfoModel.email,
                                              profileProvider
                                                  .userInfoModel.phone,
                                            ),
                                            arguments: ProfileEditScreen(
                                                userInfoModel: profileProvider
                                                    .userInfoModel),
                                          );
                                          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileEditScreen(userInfoModel: profileProvider.userInfoModel)));
                                        },
                                        child: Text(
                                          getTranslated('edit', context),
                                          style: poppinsMedium.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_SMALL,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // for name
                                Center(
                                    child: Text(
                                  '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}',
                                  style: poppinsMedium.copyWith(
                                      fontSize:
                                          Dimensions.FONT_SIZE_EXTRA_LARGE),
                                )),

                                //mobileNumber,email,gender
                                SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // for first name section
                                      Text(
                                        getTranslated('mobile_number', context),
                                        style: poppinsRegular.copyWith(
                                            fontSize: Dimensions
                                                .FONT_SIZE_EXTRA_SMALL,
                                            color: ColorResources.getHintColor(
                                                context)),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        '${profileProvider.userInfoModel.phone ?? ''}',
                                        style: poppinsRegular.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_DEFAULT),
                                      ),
                                      Divider(),
                                      SizedBox(height: 25),

                                      // for email section
                                      Text(
                                        getTranslated('email', context),
                                        style: poppinsRegular.copyWith(
                                            fontSize: Dimensions
                                                .FONT_SIZE_EXTRA_SMALL,
                                            color: ColorResources.getHintColor(
                                                context)),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        '${profileProvider.userInfoModel.email ?? ''}',
                                        style: poppinsRegular.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_DEFAULT),
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : NotLoggedInScreen()),
    );
  }
}
