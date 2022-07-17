import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/db/db_helper.dart';
import 'package:myapp/screens/splash_screen/splash_screen.dart';
import 'package:myapp/services/notification_service/notification_service.dart';
import 'app binding/my_bindings.dart';

Future<void> main() async {
  NotificationService().initialize();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox<int>(DatabaseHelper.outerlayerDB);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (child, Widget) {
        return GetMaterialApp(
          // useInheritedMediaQuery: true,
          // locale: DevicePreview.locale(context),
          title: "Samagri",
          initialBinding: MyBinding(),
          // useInheritedMediaQuery: true,
          builder: (context, widget) {
            // ScreenUtil.setContext(context);
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!);
          },
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
          // theme: ThemeData.dark(),
          theme: ThemeData(
            scaffoldBackgroundColor: Color(0xffe1ebfa),
            // Provider.of<CurrentTheme>(context).darkTheme == false
            //     ? Color.fromARGB(255, 255, 255, 255)
            //     : null,
            // brightness: Provider.of<CurrentTheme>(context).darkTheme
            //     ? Brightness.dark
            //     : Brightness.light,
            // primarySwatch: Colors.amber,
          ),
        );
      },
      // child: LoginScreen(),
    );
  }
}
