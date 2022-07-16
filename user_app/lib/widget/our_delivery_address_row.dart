import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:myapp/models/delivery_address_model.dart';
import 'package:myapp/services/firestore_service/location_detail.dart';
import 'package:myapp/utils/color.dart';
import 'package:myapp/widget/our_sized_box.dart';

import '../controller/address_choose_controller.dart';
import 'our_delivery_address_tile.dart';

class OurDeliveryAddressColumn extends StatefulWidget {
  final DeliveryLocation deliveryLocation;
  final Function function;
  const OurDeliveryAddressColumn(
      {Key? key, required this.deliveryLocation, required this.function})
      : super(key: key);

  @override
  State<OurDeliveryAddressColumn> createState() =>
      _OurDeliveryAddressColumnState();
}

class _OurDeliveryAddressColumnState extends State<OurDeliveryAddressColumn> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () {
          Get.find<ChooseAddressController>()
              .change(widget.deliveryLocation.uid!);
        },
        onLongPress: () async {
          await Location().deleteLocation(widget.deliveryLocation.uid!);
        },
        child: Row(
          children: [
            Radio(
              activeColor: darklogoColor,
              value: widget.deliveryLocation.uid!,
              groupValue: Get.find<ChooseAddressController>().choose.value,
              onChanged: (String? value) {
                Get.find<ChooseAddressController>()
                    .change(widget.deliveryLocation.uid!);
              },
            ),
            // Text("data"),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(10),
                  vertical: ScreenUtil().setSp(
                    10,
                  ),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(10),
                  vertical: ScreenUtil().setSp(
                    10,
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      ScreenUtil().setSp(20),
                    )),
                // width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OurDeliveryAddressTile(
                      title: "Administrative Area: ",
                      value: widget.deliveryLocation.administrativeArea ?? "",
                    ),
                    OurSizedBox(),
                    OurDeliveryAddressTile(
                      title: "Sub-Administrative Area: ",
                      value: widget.deliveryLocation.administrativeArea2 ?? "",
                    ),
                    OurSizedBox(),
                    OurDeliveryAddressTile(
                      title: "Locality: ",
                      value: widget.deliveryLocation.locality ?? "",
                    ),
                    OurSizedBox(),
                    OurDeliveryAddressTile(
                      title: "Sub-Locality: ",
                      value: widget.deliveryLocation.sublocality ?? "",
                    ),
                    OurSizedBox(),
                    OurDeliveryAddressTile(
                      title: "Delivery address: ",
                      value: widget.deliveryLocation.fullAddress ?? "",
                    ),
                    OurSizedBox(),
                    Get.find<ChooseAddressController>().choose.value ==
                            widget.deliveryLocation.uid
                        ? InkWell(
                            onTap: () {
                              widget.function();
                              print("Button Pressed");
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setSp(10),
                                  vertical: ScreenUtil().setSp(6),
                                ),
                                decoration: BoxDecoration(
                                  color: logoColor,
                                  borderRadius: BorderRadius.circular(
                                    ScreenUtil().setSp(25),
                                  ),
                                ),
                                child: Text(
                                  "Proceed",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(15.5),
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
