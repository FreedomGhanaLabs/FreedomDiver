import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({
    required this.items,
    required this.initialValue,
    required this.onChanged,
    super.key,
  });
  final List<String> items;
  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
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
      items: widget.items.map((item) {
        return PopupMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: GoogleFonts.poppins(
              fontSize: 10.89,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }).toList(),
    );

    if (result != null && result != selectedValue) {
      setState(() {
        selectedValue = result;
      });
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDropdownMenu(context),
      child: Container(
        height: 50,
        width: 139,
        decoration: ShapeDecoration(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Colors.black.withValues(alpha: 0.03),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedValue,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15.99,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
