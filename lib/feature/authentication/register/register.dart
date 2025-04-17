import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedom_driver/shared/app_config.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:freedom_driver/utilities/ui.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldFactory extends StatefulWidget {
  const TextFieldFactory({
    required this.controller,
    super.key,
    this.suffixIcon,
    this.onChanged,
    this.hintText,
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
    this.initialBorderColor,
    this.fieldActiveBorderColor,
    this.inputFormatters,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.fillColor,
    this.borderRadius,
    this.enabledBorderRadius,
    this.focusedBorderRadius,
    this.label,
    this.obscure,
    this.prefixSvgUrl,
    this.prefixIcon,
  });
  factory TextFieldFactory.name({
    required TextEditingController controller,
    TextStyle? hintTextStyle,
    TextStyle? fontStyle,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixText,
    String? prefixSvgUrl,
    IconData? prefixIcon,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    Color? initialBorderColor,
    Color? fieldActiveBorderColor,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
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
        initialBorderColor: initialBorderColor,
        fieldActiveBorderColor: fieldActiveBorderColor,
        inputFormatters: inputFormatters,
        validator: validator,
        hintText: hintText,
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
        initialBorderColor: initialBorderColor,
        fieldActiveBorderColor: fieldActiveBorderColor,
        inputFormatters: inputFormatters,
        validator: validator,
        fillColor: fillColor,
        enabledBorderColor: enabledColorBorder,
        borderRadius: borderRadius,
        enabledBorderRadius: enabledBorderRadius,
        hintText: hintText,
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
        initialBorderColor: initialBorderColor,
        fieldActiveBorderColor: fieldActiveBorderColor,
        inputFormatters: inputFormatters,
        validator: validator,
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
    String? hintText,
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
        initialBorderColor: initialBorderColor,
        fieldActiveBorderColor: fieldActiveBorderColor,
        inputFormatters: inputFormatters,
        validator: validator,
        hintText: hintText,
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
    String? hintText,
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
        initialBorderColor: initialBorderColor,
        fieldActiveBorderColor: fieldActiveBorderColor,
        inputFormatters: inputFormatters,
        validator: validator,
        hintText: hintText,
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
    Color? initialBorderColor,
    Color? fieldActiveBorderColor,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
    Color? fillColor,
    Color? enabledBorderColor,
    BorderRadius? borderRadius,
    BorderRadius? enabledBorderRadius,
    int? maxLines,
    BorderRadius? focusedBorderRadius,
    Widget? suffixIcon,
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
        initialBorderColor: initialBorderColor,
        fieldActiveBorderColor: fieldActiveBorderColor,
        inputFormatters: inputFormatters,
        validator: validator,
        hintText: hintText,
        fillColor: fillColor,
        enabledBorderColor: enabledBorderColor,
        borderRadius: borderRadius,
        enabledBorderRadius: enabledBorderRadius,
        maxLines: maxLines,
        focusedBorderRadius: focusedBorderRadius,
        suffixIcon: suffixIcon,
      );

//  a different factory
  final TextEditingController controller;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final String? label;
  final String? prefixSvgUrl;
  final IconData? prefixIcon;
  final String? hintText;
  final bool? obscure;
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
  final Color? initialBorderColor;
  final Color? fieldActiveBorderColor;
  final List<TextInputFormatter>? inputFormatters;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final BorderRadius? enabledBorderRadius;
  final BorderRadius? focusedBorderRadius;

  @override
  State<TextFieldFactory> createState() => _TextFieldFactoryState();
}

class _TextFieldFactoryState extends State<TextFieldFactory> {
  bool canSee = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: paragraphText,
            ),
          ),
        const VSpace(extraSmallWhiteSpace),
        TextFormField(
          inputFormatters: const [],
          controller: widget.controller,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          textAlign: widget.textAlign ?? TextAlign.start,
          textAlignVertical: widget.textAlignVertical,
          validator: widget.validator,
          autovalidateMode: widget.autovalidateMode,
          maxLines: widget.maxLines ?? 1,
          cursorColor: Colors.black,
          obscureText: widget.obscure != null ? canSee : false,
          obscuringCharacter: '*',
          onChanged: widget.onChanged,
          style: widget.fontStyle ??
              GoogleFonts.poppins(
                fontSize: 12.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
          decoration: InputDecoration(
            fillColor: widget.fillColor ?? fillColor,
            filled: true,
            labelText: widget.hintText,
            suffixIcon: widget.suffixIcon,
            labelStyle: widget.hintTextStyle ??
                GoogleFonts.poppins(
                  fontSize: paragraphText,
                  color: const Color(0xffE0E0E0),
                ),
            prefixIcon: widget.prefixSvgUrl != null
                ? SizedBox(
                    child: SvgPicture.asset(
                      widget.prefixSvgUrl!,
                      fit: BoxFit.scaleDown,
                    ),
                  )
                : widget.prefixIcon != null
                    ? Icon(widget.prefixIcon, size: 18)
                    : widget.prefixText,
            suffix: widget.obscure != null
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        canSee = !canSee;
                      });
                    },
                    child: Icon(
                      canSee
                          ? Icons.remove_red_eye_rounded
                          : Icons.remove_red_eye_outlined,
                    ),
                  )
                : null,
            errorText: widget.errorText,
            errorStyle: const TextStyle(
              height: 0,
            ),
            contentPadding:
                widget.contentPadding ?? const EdgeInsets.all(smallWhiteSpace),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.initialBorderColor ?? Colors.grey.shade100,
              ),
              borderRadius: widget.borderRadius ??
                  const BorderRadius.all(Radius.circular(5)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.fieldActiveBorderColor ?? Colors.orange,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(roundedMd)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: widget.enabledBorderRadius ??
                  const BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(
                color: widget.enabledBorderColor ?? Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.focusedBorderColor ?? thickFillColor,
              ),
              borderRadius: widget.focusedBorderRadius ??
                  const BorderRadius.all(
                    Radius.circular(roundedMd),
                  ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}
