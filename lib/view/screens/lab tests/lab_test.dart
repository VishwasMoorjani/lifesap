import 'package:flutter/material.dart';
import 'package:flutter_grocery/view/base/no_data_screen.dart';

import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';

class LabTest extends StatefulWidget {
  @override
  State<LabTest> createState() => _LabTestState();
}

class _LabTestState extends State<LabTest> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Coming Soon !"),
    );
    /*Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 20.0),
              itemBuilder: (BuildContext context, int index) {
                return Stack(children: [
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        height: 150,
                        width: 70,
                        child: Image(
                            image: AssetImage(
                              Images.vitd,
                            ),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  /*  Positioned(
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
                                  ),*/
                ]);*
              })),
    );*/
  }
}
