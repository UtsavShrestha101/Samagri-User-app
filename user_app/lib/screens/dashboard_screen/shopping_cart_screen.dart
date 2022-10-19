import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'shopping_delivery_address_screen.dart';
import 'shopping_order_status_screen.dart';

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _currentIndex = 0;
  // late ThemeData theme;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    _tabController!.animation!.addListener(() {
      final aniValue = _tabController!.animation!.value;
      if (aniValue - _currentIndex > 0.5) {
        setState(() {
          _currentIndex = _currentIndex + 1;
        });
      } else if (aniValue - _currentIndex < -0.5) {
        setState(() {
          _currentIndex = _currentIndex - 1;
        });
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(MdiIcons.chevronLeft),
          ),
          title: FxText.sh1("Cart", fontWeight: 600),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                  child: FxText.sh1("Active",
                      color: _currentIndex == 0 ? Colors.green : Colors.red,
                      fontWeight: 600)),
              Tab(
                  child: FxText.sh1("Past Order",
                      color: _currentIndex == 1 ? Colors.green : Colors.red,
                      fontWeight: 600)),
            ],
            labelColor: Colors.green,
            indicatorColor: Colors.red,
            unselectedLabelColor: Colors.pink,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            _CartScreen(),
            ShoppingOrderStatusScreen(),
          ],
        ));
  }
}

class _CartScreen extends StatefulWidget {
  @override
  __CartScreenState createState() => __CartScreenState();
}

class __CartScreenState extends State<_CartScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: _CartItemWidget(
                    name: "Cup Cake",
                    image: 'assets/images/product-1.jpg',
                    price: 159,
                    count: 2),
              ),
              Container(
                margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: _CartItemWidget(
                    name: "Woo Sandal",
                    image: 'assets/images/product-8.jpg',
                    price: 299,
                    count: 1),
              ),
              Container(
                margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: _CartItemWidget(
                    name: "High-Low ",
                    image: 'assets/images/product-7.jpg',
                    price: 459,
                    count: 3),
              ),
              CardBillWidget(),
              Container(
                margin: EdgeInsets.only(top: 16),
                child: Center(
                  child: FxButton(
                      elevation: 0,
                      borderRadiusAll: 4,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShoppingDeliveryAddressScreen()));
                      },
                      child: FxText.b2("CHECKOUT",
                          fontWeight: 600,
                          color: Colors.green,
                          letterSpacing: 0.5)),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}

class CardBillWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: FxSpacing.all(20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FxText.sh1(
                "Subtotal",
                fontWeight: 600,
              ),
              FxText.sh1(
                "\$  299.99",
                fontWeight: 600,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FxText.sh1(
                  "Shipping cost",
                  fontWeight: 600,
                ),
                FxText.sh1(
                  "\$  49.59",
                  fontWeight: 600,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FxText.sh1(
                  "Taxes",
                  fontWeight: 600,
                ),
                FxText.sh1(
                  "\$  29.99",
                  fontWeight: 600,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FxText.sh1("Total", fontWeight: 700),
                FxText.sh1("\$  399.89", fontWeight: 800),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemWidget extends StatefulWidget {
  final String name, image;
  final int price, count;

  const _CartItemWidget(
      {Key? key,
      required this.name,
      required this.image,
      required this.price,
      required this.count})
      : super(key: key);

  @override
  __CartItemWidgetState createState() => __CartItemWidgetState();
}

class __CartItemWidgetState extends State<_CartItemWidget> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _count = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    return FxContainer(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Image.asset(
              widget.image,
              height: 90.0,
              fit: BoxFit.fill,
            ),
          ),
          FxSpacing.width(20),
          Expanded(
            child: Container(
              height: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FxText.b1(widget.name, fontWeight: 600, letterSpacing: 0),
                  FxText.sh2("\$ " + widget.price.toString(),
                      fontWeight: 700, letterSpacing: 0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              if (_count > 1) {
                                setState(() {
                                  _count--;
                                  print("tapped");
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: 10, left: 10, top: 8, bottom: 8),
                              child: Icon(
                                MdiIcons.minus,
                                size: 20,
                              ),
                            ),
                          ),
                          Container(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                    child: child, scale: animation);
                              },
                              child: FxText.sh2(
                                '$_count',
                                fontWeight: 700,
                                key: ValueKey<int?>(_count),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _count++;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: 10, left: 10, top: 8, bottom: 8),
                              child: Icon(
                                MdiIcons.plus,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
