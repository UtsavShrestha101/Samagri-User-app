import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/screens/dashboard_screen/shopping_payment_screen.dart';


class ShoppingDeliveryAddressScreen extends StatefulWidget {
  @override
  _ShoppingDeliveryAddressScreenState createState() =>
      _ShoppingDeliveryAddressScreenState();
}

class _ShoppingDeliveryAddressScreenState
    extends State<ShoppingDeliveryAddressScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(MdiIcons.chevronLeft),
          ),
          title: FxText.sh1("Delivery Address", fontWeight: 600),
          centerTitle: true,
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              FxContainer.bordered(
                paddingAll: 0,
                marginAll: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      style:
                          FxTextStyle.sh2(fontWeight: 500, letterSpacing: 0.2),
                      decoration: InputDecoration(
                        hintStyle: FxTextStyle.sh2(
                          fontWeight: 500,
                          letterSpacing: 0,
                        ),
                        hintText: "Address 1",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none),
                        prefixIcon: Icon(MdiIcons.mapMarkerOutline, size: 24),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    Divider(
                      height: 0,
                    ),
                    TextFormField(
                      style:
                          FxTextStyle.sh2(fontWeight: 500, letterSpacing: 0.2),
                      decoration: InputDecoration(
                        hintStyle: FxTextStyle.sh2(
                          fontWeight: 500,
                          letterSpacing: 0,
                        ),
                        hintText: "Address 2",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none),
                        prefixIcon: Icon(
                          MdiIcons.mapMarkerPlusOutline,
                          size: 24,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    Divider(
                      height: 0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            style: FxTextStyle.sh2(
                                fontWeight: 500, letterSpacing: 0.2),
                            decoration: InputDecoration(
                              hintStyle: FxTextStyle.sh2(
                                fontWeight: 500,
                                letterSpacing: 0,
                              ),
                              hintText: "City",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              prefixIcon: Icon(
                                MdiIcons.homeCityOutline,
                                size: 24,
                              ),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: TextFormField(
                              style: FxTextStyle.sh2(
                                  fontWeight: 500, letterSpacing: 0.2),
                              decoration: InputDecoration(
                                hintStyle: FxTextStyle.sh2(
                                  fontWeight: 500,
                                  letterSpacing: 0,
                                ),
                                hintText: "PIN",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    borderSide: BorderSide.none),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    borderSide: BorderSide.none),
                                prefixIcon: Icon(
                                  MdiIcons.numeric,
                                  size: 24,
                                ),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              FxContainer.bordered(
                paddingAll: 0,
                marginAll: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      style:
                          FxTextStyle.sh2(fontWeight: 500, letterSpacing: 0.2),
                      decoration: InputDecoration(
                        hintStyle: FxTextStyle.sh2(
                          fontWeight: 500,
                          letterSpacing: 0,
                        ),
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none),
                        prefixIcon: Icon(MdiIcons.emailOutline, size: 24),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Divider(
                      height: 0,
                    ),
                    TextFormField(
                      style:
                          FxTextStyle.sh2(fontWeight: 500, letterSpacing: 0.2),
                      decoration: InputDecoration(
                        hintStyle: FxTextStyle.sh2(
                          fontWeight: 500,
                          letterSpacing: 0,
                        ),
                        hintText: "Contact",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none),
                        prefixIcon: Icon(
                          MdiIcons.phoneOutline,
                          size: 24,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    Divider(
                      height: 0,
                    ),
                    TextFormField(
                      style:
                          FxTextStyle.sh2(fontWeight: 500, letterSpacing: 0.2),
                      decoration: InputDecoration(
                        hintStyle: FxTextStyle.sh2(
                          fontWeight: 500,
                          letterSpacing: 0,
                        ),
                        hintText: "Delivery note",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            borderSide: BorderSide.none),
                        prefixIcon: Icon(
                          MdiIcons.informationOutline,
                          size: 24,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ],
                ),
              ),
              Center(
                child: FxButton(
                    padding: FxSpacing.x(40),
                    elevation: 0,
                    borderRadiusAll: 4,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShoppingPaymentScreen()));
                    },
                    child:
                        FxText.b2("NEXT", fontWeight: 600, letterSpacing: 0.5)),
              )
            ],
          ),
        ));
  }
}
