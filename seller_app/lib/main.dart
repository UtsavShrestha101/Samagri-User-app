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

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Home(),
//     );
//   }
// }

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   late GoogleMapController mapController; //contrller for Google map
//   final Set<Marker> markers = new Set(); //markers for google map
//   static const LatLng showLocation =
//       const LatLng(27.7089427, 85.3086209); //location to show in map

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Multiple Markers in Google Map"),
//         backgroundColor: Colors.deepOrangeAccent,
//       ),
//       body: GoogleMap(
//         //Map widget from google_maps_flutter package
//         zoomGesturesEnabled: true, //enable Zoom in, out on map
//         initialCameraPosition: CameraPosition(
//           //innital position in map
//           target: showLocation, //initial position
//           zoom: 15.0, //initial zoom level
//         ),
//         markers: getmarkers(), //markers to show on map
//         mapType: MapType.normal, //map type
//         onMapCreated: (controller) {
//           //method called when map is created
//           setState(() {
//             mapController = controller;
//           });
//         },
//       ),
//     );
//   }

//   Set<Marker> getmarkers() {
//     //markers to place on map
//     setState(() {
//       markers.add(Marker(
//         //add first marker
//         markerId: MarkerId(showLocation.toString()),
//         position: showLocation, //position of marker
//         infoWindow: InfoWindow(
//           //popup info
//           title: 'Marker Title First ',
//           snippet: 'My Custom Subtitle',
//         ),
//         icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//       ));

//       markers.add(Marker(
//         //add second marker
//         markerId: MarkerId(showLocation.toString()),
//         position: LatLng(27.7099116, 85.3132343), //position of marker
//         infoWindow: InfoWindow(
//           //popup info
//           title: 'Marker Title Second ',
//           snippet: 'My Custom Subtitle',
//         ),
//         icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//       ));

//       markers.add(Marker(
//         //add third marker
//         markerId: MarkerId(showLocation.toString()),
//         position: LatLng(27.7137735, 85.315626), //position of marker
//         infoWindow: InfoWindow(
//           //popup info
//           title: 'Marker Title Third ',
//           snippet: 'My Custom Subtitle',
//         ),
//         icon: BitmapDescriptor.defaultMarker, //Icon for Marker
//       ));

//       //add more markers here
//     });

//     return markers;
//   }
// }
