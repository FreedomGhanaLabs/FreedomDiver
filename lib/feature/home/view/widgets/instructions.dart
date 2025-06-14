import 'package:flutter/material.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';

class InstructionList extends StatelessWidget {

  const InstructionList({required this.instructions, super.key});
  final List<String> instructions;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: instructions.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final step = instructions[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: medWhiteSpace,
            backgroundColor: thickFillColor,
            child: Text(
              '${index + 1}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          title: Text(step, style: paragraphTextStyle),
        );
      },
    );
  }
}
