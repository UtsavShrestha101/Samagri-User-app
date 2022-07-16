/*
*  (This is third party plugin).
* */

/*
 * For Flutter
 * - Add dependencies to pubspec.yaml for Image Picker as well Image Cropper
 * - run command "flutter pub get"
 * make sure after run this command you need to re run application.
 * don't use hot reload whenever you adding some dependency.
*/

/* For Android
 * Reference : https://pub.dev/packages/image_cropper
 * See this reference there is some android config required
 */

/* For iOS
 * Reference : https://pub.dev/packages/image_cropper
 * There is no config required
 */

/*
* Make sure all steps you follow as references
* */



import 'dart:io';
import 'package:UIKitIntegration/integrations/request/api_util.dart';
import 'package:UIKitIntegration/utils/Generator.dart';
import 'package:UIKitIntegration/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';

class ImageCropperWidget extends StatefulWidget {

  final String refUrl;

  const ImageCropperWidget({Key key, this.refUrl}) : super(key: key);

  @override
  _ImageCropperWidgetState createState() => _ImageCropperWidgetState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _ImageCropperWidgetState extends State<ImageCropperWidget> {
  ThemeData themeData;
  CustomAppTheme customAppTheme;
  AppState state;
  File imageFile;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget child) {
        int themeType = value.themeMode();
        themeData = AppTheme.getThemeFromThemeMode(themeType);
        customAppTheme = AppTheme.getCustomAppTheme(themeType);
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: Scaffold(
              appBar: AppBar(
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    MdiIcons.chevronLeft,
                    color: themeData.colorScheme.onBackground,
                    size: MySize.size24,
                  ),
                ),
                centerTitle: true,
                title: Text(
                  "Image Cropper",
                  style: AppTheme.getTextStyle(themeData.textTheme.headline6,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 600),
                ),
                actions: widget.refUrl != null
                    ? [
                  InkWell(
                    onTap: () {
                      Generator.launchUrl(widget.refUrl);
                    },
                    child: Container(
                      margin: Spacing.right(16),
                      child: Icon(
                        MdiIcons.web,
                        color: themeData.colorScheme.onBackground,
                        size: MySize.size24,
                      ),
                    ),
                  )
                ]
                    : [],
              ),
              body: Center(
                  child: InkWell(
                    onTap: (){
                      if (state == AppState.free)
                        _pickImage();
                    },
                    child: Container(
                      child: imageFile != null
                          ? Image.file(imageFile)
                          : Container(
                        height: MySize.getScaledSizeWidth(250),
                        width: MySize.safeWidth - 50,
                        decoration: BoxDecoration(
                            color: customAppTheme.bgLayer3,
                            border: Border.all(
                                color: customAppTheme.bgLayer4, width: 1)
                        ),
                        child: Center(child: Text("Select image to crop",
                          style: AppTheme.getTextStyle(themeData.textTheme
                              .bodyText1, color: themeData.colorScheme
                              .onBackground, fontWeight: 500),)),
                      ),
                    ),
                  ),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.deepOrange,
                onPressed: () {
                  if (state == AppState.free)
                    _pickImage();
                  else if (state == AppState.picked)
                    _cropImage();
                  else if (state == AppState.cropped) _clearImage();
                },
                child: _buildButtonIcon(),
              ),
            ));
      },
    );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.add);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

  Future<Null> _pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile = await imagePicker.getImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }
}
