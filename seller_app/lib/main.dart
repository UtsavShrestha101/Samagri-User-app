import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/db/db_helper.dart';
import 'package:myapp/models/add_list_model.dart';
import 'package:myapp/screens/splash_screen/splash_screen.dart';
import 'package:myapp/services/notification_service/notification_service.dart';
import 'app binding/my_bindings.dart';

Future<void> main() async {
  NotificationService().initialize();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(AddListModelAdapter());
  await Hive.openBox<int>(DatabaseHelper.outerlayerDB);
  await Hive.openBox<int>(DatabaseHelper.introHelperDB);
  await Hive.openBox<String>(DatabaseHelper.nearbylocationDB);
  await Hive.openBox<AddListModel>(DatabaseHelper.addtolistDB);
  await Hive.openBox<String>("product_history");
  // Intro intro = Intro(
  //   child: MyApp(),
  // );

  runApp(
    Intro(
      padding: const EdgeInsets.all(8),
      borderRadius: const BorderRadius.all(
        Radius.circular(4),
      ),
      maskColor: const Color.fromRGBO(0, 0, 0, .6),
      noAnimation: false,
      maskClosable: false,
      buttonTextBuilder: (order) => order == 4 ? 'Finish' : 'Next',
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (child, Widget) {
        return GetMaterialApp(
          title: "Samagri",
          initialBinding: MyBinding(),
          builder: (context, widget) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!);
          },
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Color(0xffe1ebfa),
          ),
        );
      },
    );
  }
}
