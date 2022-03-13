import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/address_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/location_provider.dart';
import 'package:flutter_grocery/provider/order_provider.dart';
import 'package:flutter_grocery/provider/profile_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/screens/address/select_location_screen.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddNewAddressScreen extends StatefulWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel address;
  AddNewAddressScreen({this.isEnableUpdate = false, this.address, this.fromCheckout = false});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  GoogleMapController _controller;
  CameraPosition _cameraPosition;
  bool _updateAddress = true;

  @override
  void initState() {
    super.initState();

    Provider.of<LocationProvider>(context, listen: false).initializeAllAddressType(context: context);
    Provider.of<LocationProvider>(context, listen: false).updateAddressStatusMessae(message: '');
    Provider.of<LocationProvider>(context, listen: false).updateErrorMessage(message: '');

    if (widget.isEnableUpdate && widget.address != null) {
      _updateAddress = false;
      Provider.of<LocationProvider>(context, listen: false)
          .updatePosition(CameraPosition(target: LatLng(double.parse(widget.address.latitude), double.parse(widget.address.longitude))), true, widget.address.address, context);
      _contactPersonNameController.text = '${widget.address.contactPersonName}';
      _contactPersonNumberController.text = '${widget.address.contactPersonNumber}';
      if (widget.address.addressType == 'Home') {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(0, false);
      } else if (widget.address.addressType == 'Workplace') {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(1, false);
      } else {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(2, false);
      }
    }else {
      _contactPersonNameController.text = '${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName ?? ''}'
          ' ${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.lName ?? ''}';
      _contactPersonNumberController.text = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.phone ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? MainAppBar(): CustomAppBar(title: widget.isEnableUpdate ? getTranslated('update_address', context) : getTranslated('add_new_address', context)),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          // if (locationProvider.address != null && _updateAddress) {
          //   _locationController.text = '${locationProvider.address.name ?? ''}'
          //       ' ${locationProvider.address.subAdministrativeArea ?? ''}'
          //       ' ${locationProvider.address.isoCountryCode ?? ''}';
          // }

          return Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Center(
                      child: SizedBox(
                        width: 1170,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                         // physics: BouncingScrollPhysics(),
                          children: [
                            Container(
                              height: ResponsiveHelper.isMobile(context)? 126: 300,
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                child: Stack(
                                  clipBehavior: Clip.none, children: [
                                  GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: CameraPosition(
                                      target: widget.isEnableUpdate
                                          ? LatLng(double.parse(widget.address.latitude) ?? 0.0, double.parse(widget.address.longitude) ?? 0.0)
                                          : LatLng(locationProvider.position.latitude ?? 0.0, locationProvider.position.longitude ?? 0.0),
                                      zoom: 17,
                                    ),
                                    onTap: (latLng) {
                                      Navigator.pushNamed(
                                        context, RouteHelper.selectLocation,
                                        arguments: SelectLocationScreen(googleMapController: _controller),
                                      );
                                    },
                                    zoomControlsEnabled: false,
                                    compassEnabled: false,
                                    indoorViewEnabled: true,
                                    mapToolbarEnabled: false,
                                    onCameraIdle: () {
                                      if(_updateAddress) {
                                        locationProvider.updatePosition(_cameraPosition, true, null, context);
                                      }else {
                                        _updateAddress = true;
                                      }
                                    },
                                    onCameraMove: ((_position) => _cameraPosition = _position),
                                    onMapCreated: (GoogleMapController controller) {
                                      _controller = controller;
                                      if (!widget.isEnableUpdate && _controller != null) {
                                        Provider.of<LocationProvider>(context, listen: false).getCurrentLocation(context, true, mapController: _controller);
                                      }
                                    },
                                  ),
                                  locationProvider.loading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme
                                      .of(context).primaryColor))) : SizedBox(),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.center,
                                      height: MediaQuery.of(context).size.height,
                                      child: Icon(
                                        Icons.location_on,
                                        size: 40,
                                        color: Theme.of(context).primaryColor,
                                      )),
                                  Positioned(
                                    bottom: 10,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        locationProvider.getCurrentLocation(context, true, mapController: _controller);
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                          color: ColorResources.getCardBgColor(context),
                                        ),
                                        child: Icon(
                                          Icons.my_location,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context, RouteHelper.selectLocation,
                                          arguments: SelectLocationScreen(googleMapController: _controller),
                                        );
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                          color: Colors.white,
                                        ),
                                        child: Icon(
                                          Icons.fullscreen,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Center(
                                  child: Text(
                                    getTranslated('add_the_location_correctly', context),
                                    style:
                                    Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_SMALL),
                                  )),
                            ),

                            // for label us
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24.0),
                              child: Text(
                                getTranslated('label_us', context),
                                style:
                                Theme.of(context).textTheme.headline3.copyWith(color: ColorResources.getHintColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                              ),
                            ),

                            Container(
                              height: 50,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: locationProvider.getAllAddressType.length,
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    locationProvider.updateAddressIndex(index, true);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT, horizontal: Dimensions.PADDING_SIZE_LARGE),
                                    margin: EdgeInsets.only(right: 17),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          Dimensions.PADDING_SIZE_SMALL,
                                        ),
                                        border: Border.all(
                                            color: locationProvider.selectAddressIndex == index
                                                ? Theme.of(context).primaryColor
                                                : ColorResources.getDarkColor(context)),
                                        color: locationProvider.selectAddressIndex == index
                                            ? Theme.of(context).primaryColor
                                            : ColorResources.getCardBgColor(context)),
                                    child: Text(
                                      getTranslated(locationProvider.getAllAddressType[index].toLowerCase(), context),
                                      style: poppinsRegular.copyWith(
                                          color: locationProvider.selectAddressIndex == index
                                              ? Theme.of(context).cardColor
                                              : ColorResources.getHintColor(context)),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24.0),
                              child: Text(
                                getTranslated('delivery_address', context),
                                style:
                                Theme.of(context).textTheme.headline3.copyWith(color: ColorResources.getHintColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                              ),
                            ),

                            // for Address Field
                            Text(
                              getTranslated('address_line_01', context),
                              style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: getTranslated('address_line_02', context),
                              isShowBorder: true,
                              inputType: TextInputType.streetAddress,
                              inputAction: TextInputAction.next,
                              focusNode: _addressNode,
                              nextFocus: _nameNode,
                              controller: locationProvider.locationController,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            // for Contact Person Name
                            Text(
                              getTranslated('contact_person_name', context),
                              style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: getTranslated('enter_contact_person_name', context),
                              isShowBorder: true,
                              inputType: TextInputType.name,
                              controller: _contactPersonNameController,
                              focusNode: _nameNode,
                              nextFocus: _numberNode,
                              inputAction: TextInputAction.next,
                              capitalization: TextCapitalization.words,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            // for Contact Person Number
                            Text(
                              getTranslated('contact_person_number', context),
                              style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: getTranslated('enter_contact_person_number', context),
                              isShowBorder: true,
                              inputType: TextInputType.phone,
                              inputAction: TextInputAction.done,
                              focusNode: _numberNode,
                              controller: _contactPersonNumberController,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              locationProvider.addressStatusMessage != null
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  locationProvider.addressStatusMessage.length > 0 ? CircleAvatar(backgroundColor: Colors.green, radius: 5) : SizedBox.shrink(),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      locationProvider.addressStatusMessage ?? "",
                      style:
                      Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.green, height: 1),
                    ),
                  )
                ],
              )
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  locationProvider.errorMessage.length > 0
                      ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                      : SizedBox.shrink(),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      locationProvider.errorMessage ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).primaryColor, height: 1),
                    ),
                  )
                ],
              ),

              Container(
                height: 50.0,
                width: 1170,
                margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: !locationProvider.isLoading ? CustomButton(
                  buttonText: widget.isEnableUpdate ? getTranslated('update_address', context) : getTranslated('save_location', context),
                  onPressed: locationProvider.loading ? null : () { AddressModel addressModel = AddressModel(
                    addressType: locationProvider.getAllAddressType[locationProvider.selectAddressIndex],
                    contactPersonName: _contactPersonNameController.text ?? '',
                    contactPersonNumber: _contactPersonNumberController.text ?? '',
                    address: locationProvider.locationController.text ?? '',
                    latitude: widget.isEnableUpdate ? locationProvider.position.latitude.toString() ?? widget.address.latitude
                        : locationProvider.position.latitude.toString() ?? '',
                    longitude: widget.isEnableUpdate ? locationProvider.position.longitude.toString() ?? widget.address.longitude
                        : locationProvider.position.longitude.toString() ?? '',
                  );
                  if (widget.isEnableUpdate) {
                    addressModel.id = widget.address.id;
                    addressModel.userId = widget.address.userId;
                    addressModel.method = 'put';
                    locationProvider.updateAddress(context, addressModel: addressModel, addressId: addressModel.id).then((value) {});
                  } else {
                    locationProvider.addAddress(addressModel, context).then((value) {
                      if (value.isSuccess) {
                        Navigator.pop(context);
                        if (widget.fromCheckout) {
                          Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
                          Provider.of<OrderProvider>(context, listen: false).setAddressIndex(-1);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.message), duration: Duration(milliseconds: 600), backgroundColor: Colors.green));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.message), duration: Duration(milliseconds: 600), backgroundColor: Colors.red));
                      }
                    });
                  }
                  },
                )
                    : Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    )),
              )
            ],
          );
        },
      ),
    );
  }
}
