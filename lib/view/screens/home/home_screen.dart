import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/product_type.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
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
import 'package:flutter_grocery/view/base/custom_divider.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/base/title_widget.dart';
import 'package:flutter_grocery/view/screens/blogs/blogs.dart';
import 'package:flutter_grocery/view/screens/cart/cart_screen.dart';
import 'package:flutter_grocery/view/screens/home/widget/banners_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/category_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/daily_item_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/product_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/upload_prescription.dart';
import 'package:flutter_grocery/view/screens/hospitals/hospitals.dart';
import 'package:flutter_grocery/view/screens/lab%20tests/lab_test.dart';
import 'package:flutter_grocery/view/screens/search/search_result_screen.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../menu/widget/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<dynamic> _loadTrending() async {
    // var request = http.Request(
    //     'GET',
    //     Uri.parse(
    //         'https://us-central1-lifesap-backend.cloudfunctions.net/app/api/products/all-products'));

    // http.StreamedResponse response = await request.send();

    // if (response.statusCode == 200) {
    //   response.stream.bytesToString().then((value) {
    //     log(value.);
    //   });
    // } else {
    //   log(response.reasonPhrase);
    // }
    final response = await http.get(Uri.parse(
        'https://us-central1-lifesap-backend.cloudfunctions.net/app/api/products/all-products'));
    if (response.statusCode == 200) {
      final response1 = jsonDecode(response.body);
      log(response1['products'].length.toString());
      return response1['products'];
    } else {
      log('error');
      throw Exception('Error');
    }
  }

  var _isLoggedIn;
  @override
  void initState() {
    super.initState();

    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
  }

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
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Trending",
                                  style: poppinsBold.copyWith(fontSize: 14),
                                ),
                                InkWell(
                                  child: Text(
                                    getTranslated('view_all', context),
                                    style: poppinsMedium.copyWith(
                                        fontSize: 12,
                                        color: ColorResources.getPrimaryColor(
                                            context)),
                                  ),
                                  onTap: () {},
                                )
                              ]),
                          FutureBuilder(
                            future: _loadTrending(),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    child: ListView.builder(
                                        reverse: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 5,
                                        itemBuilder: (context, position) {
                                          return Column(children: [
                                            SizedBox(
                                              height: 80,
                                              width: 80,
                                              child: Image(
                                                image: AssetImage(
                                                    "assets/image/product2.png"),
                                              ),
                                            ),
                                            Text(
                                              snapshot.data[0]["name"],
                                            ),
                                            Text(
                                                "Rs. " +
                                                    snapshot.data[0]["price"],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    decoration: TextDecoration
                                                        .lineThrough)),
                                            Text("Rs. " +
                                                snapshot.data[0]["dprice"]),
                                          ]);
                                        }));
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                      'Something went wrong, Please try again'),
                                );
                              } else {
                                return CircularProgressIndicator(
                                  color:
                                      ColorResources.getPrimaryColor(context),
                                );
                              }
                            },
                          ),

                          Divider(
                              color: ColorResources.getDividerColor(context),
                              thickness: 10),
                          Consumer<CategoryProvider>(
                              builder: (context, category, child) {
                            return category.categoryList == null
                                ? CategoryView()
                                : category.categoryList.length == 0
                                    ? SizedBox()
                                    : CategoryView();
                          }),

                          Divider(
                              color: ColorResources.getDividerColor(context),
                              thickness: 10),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Tests",
                                          style: poppinsBold.copyWith(
                                              fontSize: 14),
                                        ),
                                        InkWell(
                                          child: Text(
                                            getTranslated('view_all', context),
                                            style: poppinsMedium.copyWith(
                                                fontSize: 12,
                                                color: ColorResources
                                                    .getPrimaryColor(context)),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LabTest()));
                                          },
                                        )
                                      ])),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image(
                                      image: AssetImage("assets/image/7.png"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image(
                                      image: AssetImage("assets/image/8.png"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                        "assets/image/9.png",
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ]),
                          ),
                          Divider(
                              color: ColorResources.getDividerColor(context),
                              thickness: 10),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Health Tips",
                                            style: poppinsBold.copyWith(
                                                fontSize: 14),
                                          ),
                                          InkWell(
                                            child: Text(
                                              getTranslated(
                                                  'view_all', context),
                                              style: poppinsMedium.copyWith(
                                                  fontSize: 12,
                                                  color: ColorResources
                                                      .getPrimaryColor(
                                                          context)),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Blogs()));
                                            },
                                          )
                                        ])),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.10,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFF898A8E)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            maxRadius: 25,
                                            foregroundImage: AssetImage(
                                                "assets/image/topic3.jpg"),
                                          ),
                                          title: Text(
                                              "5 Unique ways to add walking in your daily routine"),
                                          // subtitle: Text(doc['Topic']),
                                          onTap: () {},
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                              color: ColorResources.getDividerColor(context),
                              thickness: 10),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/image/prescription.png"),
                                    fit: BoxFit.fitWidth)),
                            padding:
                                EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
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
                                  if (_isLoggedIn) {
                                    await UploadPhoto().pickImage(context);
                                  }
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
                              ),
                            ]),
                          ),

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
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => SearchHospitals())));
                        },
                        child: Text('HOSPITALS')),
                  )
                ]),
          ),
        )));
  }
}
