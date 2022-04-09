import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/title_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        return category.categoryList != null
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated('category', context),
                            style: poppinsBold.copyWith(fontSize: 18),
                          ),
                          InkWell(
                            child: Text(
                              getTranslated('view_all', context),
                              style: poppinsMedium.copyWith(
                                  fontSize: 12,
                                  color:
                                      ColorResources.getPrimaryColor(context)),
                            ),
                            onTap: () {
                              ResponsiveHelper.isMobilePhone()
                                  ? Provider.of<SplashProvider>(context,
                                          listen: false)
                                      .setPageIndex(1)
                                  : SizedBox();
                              !ResponsiveHelper.isWeb()
                                  ? Navigator.pushNamed(
                                      context, RouteHelper.categorys)
                                  : SizedBox();
                            },
                          )
                        ]),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,

                      itemCount: category.categoryList.length,
                      padding: EdgeInsets.all(2),
                      physics: ScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      // shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        childAspectRatio: 2 / 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          width: 50,
                          height: 100,
                          child: Column(children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  RouteHelper.getCategoryProductsRoute(
                                      category.categoryList[index].id),
                                );
                              },
                              child: Container(
                                height: 60,
                                width: 80,
                                /* decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        ColorResources.getPrimaryColor(context),
                                  ),
                                  color: Colors.white.withOpacity(
                                      Provider.of<ThemeProvider>(context)
                                              .darkTheme
                                          ? 0.05
                                          : 1),
                                ),*/
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: Images.placeholder,
                                    image:
                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${category.categoryList[index].image}',
                                    fit: BoxFit.cover,
                                    imageErrorBuilder: (c, o, s) => Image.asset(
                                        Images.placeholder,
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              ),
                            ),

                            // left: 5,
                            // alignment: Alignment.bottomCenter,
                            Container(
                              width: 70,
                              child: Text(
                                category.categoryList[index].name,
                                style: poppinsMedium.copyWith(fontSize: 10),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ]),
                        );
                      },
                    ),
                  ),
                ],
              )
            : CategoryShimmer();
      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 6,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
      //physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio:
            ResponsiveHelper.isDesktop(context) ? (1 / 1.1) : (1 / 1.2),
        crossAxisCount: ResponsiveHelper.isWeb()
            ? 6
            : ResponsiveHelper.isMobilePhone()
                ? 3
                : ResponsiveHelper.isTab(context)
                    ? 4
                    : 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(
                Provider.of<ThemeProvider>(context).darkTheme ? 0.05 : 1),
            boxShadow: Provider.of<ThemeProvider>(context).darkTheme
                ? null
                : [
                    BoxShadow(
                        color: Colors.grey[200], spreadRadius: 1, blurRadius: 5)
                  ],
          ),
          child: Shimmer(
            duration: Duration(seconds: 2),
            enabled:
                Provider.of<CategoryProvider>(context).categoryList == null,
            child: Column(children: [
              Expanded(
                flex: 6,
                child: Container(
                  margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      vertical: Dimensions.PADDING_SIZE_LARGE),
                  child:
                      Container(color: Colors.grey[300], width: 50, height: 10),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
