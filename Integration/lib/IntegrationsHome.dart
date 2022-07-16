import 'package:UIKitIntegration/integrations/WebViewPage.dart';
import 'package:UIKitIntegration/integrations/auth/GoogleSignInWidget.dart';
import 'package:UIKitIntegration/integrations/firebase/FirebaseUserPage.dart';
import 'package:UIKitIntegration/integrations/image_cropper/ImageCropperWidget.dart';
import 'package:UIKitIntegration/integrations/payment/StripePaymentWidget.dart';
import 'package:UIKitIntegration/integrations/quick_actions/QuickActionsWidget.dart';
import 'package:UIKitIntegration/integrations/request/GETRequestPage.dart';
import 'package:UIKitIntegration/integrations/request/POSTRequestPage.dart';
import 'package:UIKitIntegration/integrations/url_launcher/UrlLauncherWidget.dart';
import 'package:UIKitIntegration/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

import 'AppTheme.dart';
import 'SingleGridItem.dart';
import 'integrations/admob/BannerAdmobWidget.dart';
import 'integrations/admob/InterstitialAdmobWidget.dart';
import 'integrations/admob/RewardAdmobWidget.dart';
import 'integrations/firebase/FirebaseLoginPage.dart';
import 'integrations/firebase/FirebaseRegisterPage.dart';
import 'integrations/shimmer/LoadingShimmerWidget.dart';
import 'integrations/shimmer/PostShimmer.dart';
import 'integrations/shimmer/ShoppingPageShimmer.dart';
import 'integrations/shimmer/SlideUnlockShimmerWidget.dart';

class IntegrationsHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
        color: themeData.colorScheme.background,
        child: ListView(
          padding: Spacing.fromLTRB(8,16,16,0),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            GridView.count(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                crossAxisCount: 2,
                padding: EdgeInsets.all(MySize.size4),
                mainAxisSpacing: MySize.size16,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: MySize.size16,
                children: <Widget>[
                  SingleGridItem(
                      title: "Admob",
                      icon: './assets/icons/albums-outline.png',
                      items: [
                        SinglePageItem(
                          icon: './assets/icons/albums-outline.png',
                          title: "Admob Interstitial",
                          navigation: InterstitialAdmobWidget(
                            refUrl: 'https://pub.dev/packages/admob_flutter',
                          ),
                        ),
                        SinglePageItem(
                          icon: './assets/icons/albums-outline.png',
                          title: "Admob Reward",
                          navigation: RewardAdmobWidget(
                            refUrl: 'https://pub.dev/packages/admob_flutter',
                          ),
                        ),
                        SinglePageItem(
                          icon: './assets/icons/albums-outline.png',
                          title: "Admob Banner",
                          navigation: BannerAdmobWidget(
                            refUrl: 'https://pub.dev/packages/admob_flutter',
                          ),
                        ),
                      ]),
                  SingleGridItem(
                    title: "Firebase",
                    icon: './assets/icons/albums-outline.png',
                    items: [
                      SinglePageItem(
                        icon: './assets/icons/albums-outline.png',
                        title: "Home",
                        navigation: FirebaseUserPage(),
                      ),  SinglePageItem(
                        icon: './assets/icons/albums-outline.png',
                        title: "Login",
                        navigation: FirebaseLoginPage(),
                      ),
                      SinglePageItem(
                        icon: './assets/icons/albums-outline.png',
                        title: "Register",
                        navigation: FirebaseRegisterPage(),
                      ),

                    ],
                  ),
                  SingleGridItem(
                    title: "Request",
                    icon: './assets/icons/albums-outline.png',
                    items: [
                      SinglePageItem(
                        icon: './assets/icons/albums-outline.png',
                        title: "GET",
                        navigation: GETRequestPage(),
                      ),
                      SinglePageItem(
                        icon: './assets/icons/albums-outline.png',
                        title: "POST",
                        navigation: POSTRequestPage(),
                      ),
                    ],
                  ),
                  SinglePageItem(
                    icon: './assets/icons/albums-outline.png',
                    title: "Web View",
                    navigation: WebViewPage(refUrl: 'https://pub.dev/packages/webview_flutter',),
                  ),
                  SinglePageItem(
                    icon: './assets/icons/albums-outline.png',
                    title: "Image Cropper",
                    navigation: ImageCropperWidget(refUrl: 'https://pub.dev/packages/image_cropper',),
                  ),
                  SinglePageItem(
                    icon: './assets/icons/albums-outline.png',
                    title: "Google SignIn",
                    navigation: GoogleSignInWidget(refUrl: 'https://pub.dev/packages/google_sign_in',),
                  ),
                   SinglePageItem(
                    icon: './assets/icons/albums-outline.png',
                    title: "Quick Actions",
                    navigation: QuickActionsWidget(refUrl: 'https://pub.dev/packages/quick_actions',),
                  ),
                   SinglePageItem(
                    icon: './assets/icons/albums-outline.png',
                    title: "Stripe Payment",
                    navigation: StripePaymentWidget(refUrl: 'https://pub.dev/packages/stripe_payment',),
                  ),
                  SingleGridItem(
                      title: "Shimmer",
                      icon: './assets/icons/albums-outline.png',
                      items: [
                        SinglePageItem(
                          icon: './assets/icons/albums-outline.png',
                          title: "Shimmer Loading",
                          navigation: LoadingShimmerWidget(
                            refUrl: 'https://pub.dev/packages/shimmer',
                          ),
                        ),
                        SinglePageItem(
                          icon: './assets/icons/albums-outline.png',
                          title: "Slide Unlock",
                          navigation: SlideUnlockShimmerWidget(
                            refUrl: 'https://pub.dev/packages/shimmer',
                          ),
                        ),
                        SinglePageItem(
                          icon: './assets/icons/albums-outline.png',
                          title: "Shopping Page ",
                          navigation: ShoppingPageShimmerWidget(
                            refUrl: 'https://pub.dev/packages/shimmer',
                          ),
                        ),
                        SinglePageItem(
                          icon: './assets/icons/albums-outline.png',
                          title: "Shimmer Post",
                          navigation: PostShimmerWidget(
                            refUrl: 'https://pub.dev/packages/shimmer',
                          ),
                        ),
                      ]),
                  SinglePageItem(
                    icon: './assets/icons/albums-outline.png',
                    title: "URL Launcher",
                    navigation: UrlLauncherWidget(refUrl: 'https://pub.dev/packages/url_launcher',),
                  ),


                ]),
            Container(
              margin:
                  EdgeInsets.only(top: MySize.size16, bottom: MySize.size16),
              child: Center(
                child: Text("More Integrations are coming soon...",
                    style: AppTheme.getTextStyle(
                      themeData.textTheme.bodyText2,
                      letterSpacing: 0.25,
                      fontWeight: 500,
                    )),
              ),
            )
          ],
        ));
  }
}
