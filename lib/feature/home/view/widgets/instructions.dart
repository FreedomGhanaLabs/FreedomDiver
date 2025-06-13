import 'package:flutter/material.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';

class InstructionList extends StatelessWidget {
  final List<String> instructions;

  const InstructionList({required this.instructions, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: instructions.length,
      separatorBuilder: (_, __) => Divider(height: 1),
      itemBuilder: (context, index) {
        final step = instructions[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: medWhiteSpace,
            backgroundColor: thickFillColor,
            child: Text(
              '${index + 1}',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          title: Text(step, style: paragraphTextStyle),
        );
      },
    );
  }
}
