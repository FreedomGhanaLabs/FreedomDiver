import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldFactory extends StatefulWidget {
  const TextFieldFactory({
    super.key,
    required this.controller,
    this.suffixIcon,
    this.onChanged,
    this.hinText,
    this.validator,
    this.autovalidateMode,
    this.errorText,
    this.maxLines,
    this.textAlign,
    this.textAlignVertical,
    this.contentPadding,
    this.hintTextStyle,
    this.fontStyle,
    this.prefixText,
    this.focusNode,
    this.keyboardType,
    this.errorBorderColor,
    this.fieldActiveBorderColor,
    this.inputFormatters,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.hintText,
    this.fillColor,
    this.borderRadius,
    this.enabledBorderRadius,
    this.focusedBorderRadius,
    this.obscureText,
  });
  factory TextFieldFactory.name({
    required TextEditingController controller,
    TextStyle? hintTextStyle,
    TextStyle? fontStyle,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixText,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    Color? initialBorderColor,
    Color? fieldActiveBorderColor,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    String? hinText,
    Color? fillColor,
    Widget? suffixIcon,
    void Function(String)? onChanged,
    Color? enabledColorBorder,
    Color? focusedBorderColor,
  }) =>
      TextFieldFactory(
        controller: controller,
        hintTextStyle: hintTextStyle,
        fontStyle: fontStyle,
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        contentPadding: contentPadding,
        prefixText: prefixText,
        focusNode: focusNode,
        keyboardType: keyboardType,
        errorBorderColor: initialBorderColor,
        fieldActiveBorderColor: fieldActiveBorderColor,
        inputFormatters: inputFormatters,
        validator: validator,
        hinText: hinText,
        fillColor: fillColor,
        suffixIcon: suffixIcon,
        onChanged: onChanged,
        enabledBorderColor: enabledColorBorder,
        focusedBorderColor: focusedBorderColor,
      );
  factory TextFieldFactory.phone({
    required TextEditingController controller,
    TextStyle? hintTextStyle,
    TextStyle? fontStyle,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixText,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    Color? initialBorderColor,
    Color? fieldActiveBorderColor,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    Color? fillColor,
    Color? enabledColorBorder,
    BorderRadius? borderRadius,
    BorderRadius? enabledBorderRadius,
    String? hintText,
    Widget? suffixIcon,
    Color? focusedBorderColor,
  }) =>
      TextFieldFactory(
        controller: controller,
        hintTextStyle: hintTextStyle,
        fontStyle: fontStyle,
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        contentPadding: contentPadding,
        prefixText: prefixText,
        focusNode: focusNode,
        keyboardType: keyboardType,
        errorBorderColor: initialBorderColor,
        fieldActiveBorderColor: fieldActiveBorderColor,
        inputFormatters: inputFormatters,
        validator: validator,
        fillColor: fillColor,
        enabledBorderColor: enabledColorBorder,
        borderRadius: borderRadius,
        enabledBorderRadius: enabledBorderRadius,
        hinText: hintText,
        suffixIcon: suffixIcon,
        focusedBorderColor: focusedBorderColor,
      );
  factory TextFieldFactory.password({
    required TextEditingController controller,
    TextStyle? hintTextStyle,
    TextStyle? fontStyle,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixText,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    Color? initialBorderColor,
    Color? fieldActiveBorderColor,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
    Widget? suffixIcon,
    bool? obscureText,
  }) =>
      TextFieldFactory(
        controller: controller,
        hintTextStyle: hintTextStyle,
        fontStyle: fontStyle,
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        contentPadding: contentPadding,
        prefixText: prefixText,
        focusNode: focusNode,
        keyboardType: keyboardType,
        errorBorderColor: initialBorderColor,
        fieldActiveBorderColor: fieldActiveBorderColor,
        inputFormatters: inputFormatters,
        validator: validator,
        hinText: hintText,
        suffixIcon: suffixIcon,
        obscureText: obscureText,
      );
  factory TextFieldFactory.email({
    required TextEditingController controller,
    TextStyle? hintTextStyle,
    TextStyle? fontStyle,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixText,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    Color? initialBorderColor,
    Color? fieldActiveBorderColor,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    String? hinText,
    Color? fillColor,
    Color? enabledColorBorder,
    Color? focusedBorderColor,
  }) =>
      TextFieldFactory(
        controller: controller,
        hintTextStyle: hintTextStyle,
        fontStyle: fontStyle,
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        contentPadding: contentPadding,
        prefixText: prefixText,
        focusNode: focusNode,
        keyboardType: keyboardType,
        errorBorderColor: initialBorderColor,
        fieldActiveBorderColor: fieldActiveBorderColor,
        inputFormatters: inputFormatters,
        validator: validator,
        hinText: hinText,
        fillColor: fillColor,
        enabledBorderColor: enabledColorBorder,
        focusedBorderColor: focusedBorderColor,
      );
  factory TextFieldFactory.location({
    required TextEditingController controller,
    TextStyle? hintTextStyle,
    TextStyle? fontStyle,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixText,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    Color? initialBorderColor,
    Color? fieldActiveBorderColor,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    String? hinText,
    Color? fillColor,
    Color? enabledBorderColor,
    BorderRadius? borderRadius,
    BorderRadius? enabledBorderRadius,
  }) =>
      TextFieldFactory(
        controller: controller,
        hintTextStyle: hintTextStyle,
        fontStyle: fontStyle,
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        contentPadding: contentPadding,
        prefixText: prefixText,
        focusNode: focusNode,
        keyboardType: keyboardType,
        errorBorderColor: initialBorderColor,
        fieldActiveBorderColor: fieldActiveBorderColor,
        inputFormatters: inputFormatters,
        validator: validator,
        hinText: hinText,
        fillColor: fillColor,
        enabledBorderColor: enabledBorderColor,
        borderRadius: borderRadius,
        enabledBorderRadius: enabledBorderRadius,
      );
  factory TextFieldFactory.itemField({
    required TextEditingController controller,
    TextStyle? hintTextStyle,
    TextStyle? fontStyle,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixText,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    Color? errorBorderColor,
    Color? fieldActiveBorderColor,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    String? hinText,
    Color? fillColor,
    Color? enabledBorderColor,
    BorderRadius? borderRadius,
    BorderRadius? enabledBorderRadius,
    int? maxLines,
    BorderRadius? focusedBorderRadius,
    Widget? suffixIcon,
    Color? focusedBorderColor,
  }) =>
      TextFieldFactory(
        controller: controller,
        hintTextStyle: hintTextStyle,
        fontStyle: fontStyle,
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        contentPadding: contentPadding,
        prefixText: prefixText,
        focusNode: focusNode,
        keyboardType: keyboardType,
        errorBorderColor: errorBorderColor,
        fieldActiveBorderColor: fieldActiveBorderColor,
        inputFormatters: inputFormatters,
        validator: validator,
        hinText: hinText,
        fillColor: fillColor,
        enabledBorderColor: enabledBorderColor,
        borderRadius: borderRadius,
        enabledBorderRadius: enabledBorderRadius,
        maxLines: maxLines,
        focusedBorderRadius: focusedBorderRadius,
        suffixIcon: suffixIcon,
        focusedBorderColor: focusedBorderColor,
      );
  final TextEditingController controller;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final String? hinText;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final String? errorText;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintTextStyle;
  final TextStyle? fontStyle;
  final Widget? prefixText;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Color? errorBorderColor;
  final Color? fieldActiveBorderColor;
  final List<TextInputFormatter>? inputFormatters;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final String? hintText;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final BorderRadius? enabledBorderRadius;
  final BorderRadius? focusedBorderRadius;
  final bool? obscureText;

  @override
  State<TextFieldFactory> createState() => _TextFieldFactoryState();
}

class _TextFieldFactoryState extends State<TextFieldFactory> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [],
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      textAlign: widget.textAlign ?? TextAlign.start,
      textAlignVertical: widget.textAlignVertical,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      maxLines: widget.maxLines ?? 1,
      cursorColor: Colors.black,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText ?? false,
      style: widget.fontStyle ??
          GoogleFonts.poppins(
            fontSize: 12.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
      decoration: InputDecoration(
        fillColor: widget.fillColor ?? fillColor,
        filled: true,
        labelText: widget.hinText,
        suffixIcon: widget.suffixIcon,
        labelStyle: widget.hintTextStyle ??
            GoogleFonts.poppins(
              fontSize: 14.sp,
              color: const Color(0xffE0E0E0),
            ),
        prefixIcon: widget.prefixText,
        errorText: widget.errorText,
        errorStyle: const TextStyle(
          height: 0,
        ),
        contentPadding: widget.contentPadding ?? const EdgeInsets.all(12),
        errorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: widget.errorBorderColor ?? Colors.purple),
          borderRadius:
              widget.borderRadius ?? const BorderRadius.all(Radius.circular(5)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: widget.fieldActiveBorderColor ?? Colors.orange),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: widget.enabledBorderRadius ??
              const BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(
            color: widget.enabledBorderColor ?? Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: widget.focusedBorderColor ?? thickFillColor),
          borderRadius: widget.focusedBorderRadius ??
              const BorderRadius.all(
                Radius.circular(5),
              ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        alignLabelWithHint: true,
      ),
    );
  }
}
