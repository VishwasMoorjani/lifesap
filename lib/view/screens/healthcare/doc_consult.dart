import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/styles.dart';

import '../../../utill/color_resources.dart';
import '../../../utill/images.dart';

class DoctorConsult extends StatefulWidget {
  @override
  State<DoctorConsult> createState() => _DoctorConsultState();
}

class _DoctorConsultState extends State<DoctorConsult> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(8, 25, 8, 0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
                Text(
                  "Doctor's Consultation",
                  style: poppinsSemiBold.copyWith(fontSize: 20),
                )
              ],
            ),
            Material(
              elevation: 3,
              child: Divider(
                thickness: 1,
                color: Colors.transparent,
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.5,
                padding: EdgeInsets.all(15),
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {},
                        child: Stack(children: [
                          Container(
                            // padding: EdgeInsets.all(10),
                            height: 150,
                            //width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: ColorResources.getPrimaryColor(context),
                              ),
                            ),
                          ),
                          Image(
                              image: AssetImage(Images.about_us),
                              fit: BoxFit.contain),
                          Positioned(
                              bottom: 14,
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      ColorResources.getPrimaryColor(context),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        ColorResources.getPrimaryColor(context),
                                  ),
                                ),
                                // color: ColorResources.getPrimaryColor(context),
                                height: 40,
                                width: 163,
                              )),
                          Positioned(
                            bottom: 25,
                            // left: 8,
                            child: Container(
                              width: 163,
                              child: Text(
                                "Dr. Sky",
                                textAlign: TextAlign.center,
                                style: poppinsRegular.copyWith(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          )
                        ]),
                      );
                    })),
          ],
        ));
  }
}
