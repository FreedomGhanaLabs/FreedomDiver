import 'package:flutter/material.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';


class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    this.onChanged,
    this.items,
    this.initialValue,
    this.value,
    this.label,
    super.key,
    this.onTap,
  });
  final List<String>? items;
  final String? initialValue;
  final String? value;
  final String? label;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue ?? '';
  }

  Future<void> _showDropdownMenu(BuildContext context) async {
    final renderBox = context.findRenderObject()! as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        0,
      ),
      items: (widget.items ?? []).map((item) {
        return PopupMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              fontSize: smallText,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );

    if (result != null && result != selectedValue) {
      setState(() {
        selectedValue = result;
      });
      widget.onChanged?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: const TextStyle(
              color: Colors.black,
              fontSize: paragraphText,
              fontWeight: FontWeight.w600,
            ),
          ),
        const VSpace(extraSmallWhiteSpace + 2),
        GestureDetector(
          onTap: widget.onTap ?? () => _showDropdownMenu(context),
          child: Container(
            height: 50,
            width: Responsive.width(context),
            padding: const EdgeInsets.symmetric(horizontal: smallWhiteSpace),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: gradient1,
                ),
                borderRadius: BorderRadius.circular(roundedMd),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.value ?? selectedValue,
                  style: const TextStyle(
                    fontSize: paragraphText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        const VSpace(smallWhiteSpace),
      ],
    );
  }
}
