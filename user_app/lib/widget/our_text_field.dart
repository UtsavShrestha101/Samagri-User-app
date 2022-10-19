import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/color.dart';

class CustomTextField extends StatefulWidget {
  final Widget? suffexWidget;
  final TextEditingController controller;
  final FocusNode? start;
  final FocusNode? end;
  final Function()? ontap;
  final bool? readonly;
  final Function(String) validator;
  final Function(String)? onchange;
  final IconData? icon;
  final TextInputType type;
  final String title;
  final int? height;
  final int? width;
  final int? length;
  final int number;
  final int letterlength;
  final String? initialValue;
  final bool? autofocus;

  const CustomTextField({
    Key? key,
    this.width,
    this.autofocus,
    this.suffexWidget,
    this.height,
    required this.letterlength,
    required this.controller,
    required this.validator,
    this.icon,
    this.onchange,
    required this.title,
    required this.type,
    this.length,
    this.start,
    this.end,
    required this.number,
    this.initialValue,
    this.ontap,
    this.readonly,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setSp(widget.width ?? 22.5),
      ),
      height: ScreenUtil().setSp(widget.height ?? 40),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.letterlength),
        ],
        scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        cursorColor: Colors.white,
        controller: widget.controller,
        initialValue: widget.initialValue,
        focusNode: widget.start,
        onEditingComplete: () {
          if (widget.number == 0) {
            FocusScope.of(context).requestFocus(
              widget.end,
            );
          } else {
            FocusScope.of(context).unfocus();
          }
        },
        onChanged: (String value) {
          widget.onchange!(value) ;
        },
        validator: (String? value) => widget.validator(value!),
        style: TextStyle(
          fontSize: ScreenUtil().setSp(15),
          color: logoColor,
        ),
        autofocus: widget.autofocus ?? false,
        keyboardType: widget.type,
        maxLines: widget.length,
        onTap: widget.ontap ?? () {},
        readOnly: widget.readonly ?? false,
        decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,

            // focusedBorder: InputBorder.none,
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setSp(10),
              horizontal: ScreenUtil().setSp(2),
            ),
            isDense: true,
            hintText: widget.title,
            hintStyle: TextStyle(
              color: logoColor,
              fontSize: ScreenUtil().setSp(
                17.5,
              ),
            ),
            prefixIcon: Icon(
              widget.icon,
              size: ScreenUtil().setSp(20),
              color: logoColor,
            ),
            errorStyle: TextStyle(
              fontSize: ScreenUtil().setSp(
                13.5,
              ),
            ),
            suffixIcon: widget.suffexWidget ?? null),
        // maxLength: 10,
      ),
    );
  }
}
