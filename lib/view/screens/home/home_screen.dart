import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/product_type.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/banner_provider.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/search_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/base/title_widget.dart';
import 'package:flutter_grocery/view/screens/cart/cart_screen.dart';
import 'package:flutter_grocery/view/screens/home/widget/banners_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/category_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/daily_item_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/product_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/upload_prescription.dart';
import 'package:flutter_grocery/view/screens/search/search_result_screen.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:provider/provider.dart';

import '../menu/widget/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _loadData(BuildContext context, bool reload) async {
    // await Provider.of<CategoryProvider>(context, listen: false).getCategoryList(context, reload);

    await Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
      context,
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .languageCode,
      reload,
    );
    await Provider.of<BannerProvider>(context, listen: false)
        .getBannerList(context, reload);
    await Provider.of<ProductProvider>(context, listen: false).getDailyItemList(
      context,
      reload,
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .languageCode,
    );

    // await Provider.of<ProductProvider>(context, listen: false).getPopularProductList(context, '1', true);
    Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
      context,
      '1',
      reload,
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .languageCode,
    );
  }

  List<String> text = [
    "Diabetic Care",
    "Health Condition",
    "Suppliments",
    "Medical Supplies",
    "Pet Care",
    "Surgical Supplies",
  ];

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    _loadData(context, false);

    return RefreshIndicator(
      onRefresh: () async {
        await _loadData(context, true);
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: Scrollbar(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
                // controller: _scrollController,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: Dimensions.PADDING_SIZE_DEFAULT,
                      ),
                      Text("Sample pickup from",
                          style: poppinsMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL)),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RouteHelper.address);
                          },
                          child: Text("address",
                              style: poppinsSemiBold.copyWith(
                                  color: ColorResources.getTextColor(context),
                                  fontSize: Dimensions.FONT_SIZE_SMALL)))
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  ),
                  Consumer<SearchProvider>(
                      builder: (context, searchProvider, child) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.PADDING_SIZE_DEFAULT),
                                      width: MediaQuery.of(context).size.width,
                                      child: CustomTextField(
                                        isElevation: true,
                                        fillColor: Colors.white,
                                        hintText: getTranslated(
                                            'search_item_here', context),
                                        isShowBorder: true,
                                        isShowSuffixIcon: true,
                                        suffixIconUrl: Icons.search,
                                        controller: _searchController,
                                        inputAction: TextInputAction.search,
                                        isIcon: true,
                                        onSubmit: (text) {
                                          if (_searchController.text.length >
                                              0) {
                                            List<int> _encoded = utf8
                                                .encode(_searchController.text);
                                            String _data =
                                                base64Encode(_encoded);
                                            searchProvider.saveSearchAddress(
                                                _searchController.text);
                                            searchProvider.searchProduct(
                                                _searchController.text,
                                                context);
                                            Navigator.pushNamed(
                                                context,
                                                RouteHelper.searchResult +
                                                    '?text=$_data',
                                                arguments: SearchResultScreen(
                                                    searchString:
                                                        _searchController
                                                            .text));
                                            //Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchResultScreen(searchString: _searchController.text)));
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ])),
                  Material(
                    elevation: 3,
                    child: Divider(
                      thickness: 1,
                      color: Colors.transparent,
                    ),
                  ),
                  Consumer<CategoryProvider>(
                      builder: (context, category, child) {
                    return category.categoryList == null
                        ? CategoryView()
                        : category.categoryList.length == 0
                            ? SizedBox()
                            : CategoryView();
                  }),
                  /*    Container(
                        height: MediaQuery.of(context).size.height * 0.32,
                        padding: EdgeInsets.all(10.0),
                        child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 0.0),
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(children: [
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: 85,
                                    child: Image(
                                        image: AssetImage(
                                          images[index],
                                        ),
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                Positioned(
                                  top: 65,
                                  left: 8,
                                  child: Container(
                                    width: 100,
                                    child: Text(
                                      text[index],
                                      textAlign: TextAlign.center,
                                      style: poppinsSemiBold.copyWith(
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                              ]);
                            })),*/
                  Divider(
                      color: ColorResources.getDividerColor(context),
                      thickness: 10),
                  Consumer<BannerProvider>(builder: (context, banner, child) {
                    return banner.bannerList == null
                        ? BannersView()
                        : banner.bannerList.length == 0
                            ? SizedBox()
                            : BannersView();
                  }),
                  Divider(
                      color: ColorResources.getDividerColor(context),
                      thickness: 10),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/image/prescription.png"),
                            fit: BoxFit.fitWidth)),
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    child: Column(children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Upload Prescription",
                          style: poppinsBold.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Upload prescription and tell us what you need. We do the rest!",
                        style: poppinsMedium.copyWith(
                            color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          await UploadPhoto().pickImage(context);
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Upload Now",
                                textAlign: TextAlign.left,
                                style: poppinsMedium.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 15,
                                color: Colors.white,
                              )
                            ]),
                      )
                    ]),
                  ),

                  Divider(
                      color: ColorResources.getDividerColor(context),
                      thickness: 10),

                  /*     Consumer<ProductProvider>(
                          builder: (context, product, child) {
                        return product.dailyItemList == null
                            ? DailyItemView()
                            : product.dailyItemList.length == 0
                                ? SizedBox()
                                : DailyItemView();
                      }),*/

                  // Popular Item
                  /*  Padding(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: TitleWidget(
                            title: getTranslated('popular_item', context)),
                      ),
                      ProductView(
                          productType: ProductType.POPULAR_PRODUCT,
                          scrollController: _scrollController),*/
                ]),
          ),
        ),
      ),
    );
  }
}
