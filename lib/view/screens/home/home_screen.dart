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
import 'package:flutter_grocery/view/screens/search/search_result_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
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
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteHelper.cart);
              },
              backgroundColor: ColorResources.getPrimaryColor(context),
              child: Stack(children: [
                Center(
                  child: Icon(Icons.shopping_cart),
                ),
                Positioned(
                  top: -3.5,
                  right: -0.24,
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: Text(
                        '${Provider.of<CartProvider>(context).cartList.length}',
                        style: TextStyle(
                            color: Theme.of(context).cardColor, fontSize: 10)),
                  ),
                ),
              ])),
          appBar: ResponsiveHelper.isDesktop(context) ? MainAppBar() : null,
          body: Scrollbar(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: SizedBox(
                width: 1170,
                child: Column(
                    // controller: _scrollController,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              child: Image(
                                image: AssetImage(Images.app_logo),
                              ),
                            ),
                            Text(
                              AppConstants.APP_NAME,
                              style: TextStyle(
                                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                fontWeight: FontWeight.bold,
                                color: ColorResources.getPrimaryColor(context),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: Dimensions.PADDING_SIZE_DEFAULT,
                          ),
                          Text(
                            "Sample pickup from",
                            style: TextStyle(
                                color: ColorResources.getTextColor(context)),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, RouteHelper.address);
                              },
                              child: Text(
                                "address",
                                style: TextStyle(
                                    color: ColorResources.getTextColor(context),
                                    fontWeight: FontWeight.bold),
                              ))
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
                                              horizontal: Dimensions
                                                  .PADDING_SIZE_DEFAULT),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: CustomTextField(
                                            isElevation: true,
                                            hintText: getTranslated(
                                                'search_item_here', context),
                                            isShowBorder: true,
                                            isShowSuffixIcon: true,
                                            suffixIconUrl: Icons.search,
                                            controller: _searchController,
                                            inputAction: TextInputAction.search,
                                            isIcon: true,
                                            onSubmit: (text) {
                                              if (_searchController
                                                      .text.length >
                                                  0) {
                                                List<int> _encoded =
                                                    utf8.encode(
                                                        _searchController.text);
                                                String _data =
                                                    base64Encode(_encoded);
                                                searchProvider
                                                    .saveSearchAddress(
                                                        _searchController.text);
                                                searchProvider.searchProduct(
                                                    _searchController.text,
                                                    context);
                                                Navigator.pushNamed(
                                                    context,
                                                    RouteHelper.searchResult +
                                                        '?text=$_data',
                                                    arguments:
                                                        SearchResultScreen(
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
                      // Category

                      Consumer<BannerProvider>(
                          builder: (context, banner, child) {
                        return banner.bannerList == null
                            ? BannersView()
                            : banner.bannerList.length == 0
                                ? SizedBox()
                                : BannersView();
                      }),

                      Consumer<CategoryProvider>(
                          builder: (context, category, child) {
                        return category.categoryList == null
                            ? CategoryView()
                            : category.categoryList.length == 0
                                ? SizedBox()
                                : CategoryView();
                      }),
                      Consumer<ProductProvider>(
                          builder: (context, product, child) {
                        return product.dailyItemList == null
                            ? DailyItemView()
                            : product.dailyItemList.length == 0
                                ? SizedBox()
                                : DailyItemView();
                      }),

                      // Popular Item
                      Padding(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: TitleWidget(
                            title: getTranslated('popular_item', context)),
                      ),
                      ProductView(
                          productType: ProductType.POPULAR_PRODUCT,
                          scrollController: _scrollController),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
