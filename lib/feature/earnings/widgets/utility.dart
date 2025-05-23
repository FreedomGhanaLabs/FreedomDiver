import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedom_driver/shared/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class SectionFactory extends StatelessWidget {
  const SectionFactory({
    super.key,
    this.onItemTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 22),
    this.backgroundColor = const Color(0xFFFBFAFA),
    this.titleStyle,
    this.sectionTextStyle,
    this.paddingSection,
  });
  final VoidCallback? onItemTap;
  final EdgeInsets? padding;
  final Color backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? sectionTextStyle;
  final EdgeInsetsGeometry? paddingSection;

  String get sectionTitle;
  List<SectionItem> get sectionItems;

  Widget _buildSectionItem(SectionItem item) {
    return InkWell(
      onTap: item.onTap ?? onItemTap,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            padding: paddingSection,
            margin: const EdgeInsets.only(left: 16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: SvgPicture.asset(item.iconPath ?? ''),
          ),
          const SizedBox(width: 16),
          Text(
            item.title,
            style: sectionTextStyle ??
                GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const Spacer(),
          if (item.subtitle != null)
            Text(
              item.subtitle!,
              style: GoogleFonts.poppins(
                fontSize: 8.27,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w200,
              ),
            ),
          const SizedBox(width: 22),
          if (item.showArrow)
            Padding(
              padding: const EdgeInsets.only(right: 22),
              child: SvgPicture.asset(
                'assets/images/arrow_right_icon.svg',
                colorFilter:
                const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sectionTitle,
              textAlign: TextAlign.center,
              style: titleStyle ??
                  GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 10.94,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 6.5),
            Container(
              decoration: ShapeDecoration(
                color: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < sectionItems.length; i++) ...[
                    if (i == 0) const SizedBox(height: 20),
                    _buildSectionItem(sectionItems[i]),
                    if (i < sectionItems.length - 1) ...[
                      const SizedBox(height: 19),
                      Container(
                        height: 1,
                        color: greyColor,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 19),
                    ] else
                      const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model class for section items
class SectionItem {
  final String title;
  final String? iconPath;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool showArrow;

  const SectionItem({
    required this.title,
    this.iconPath,
    this.subtitle,
    this.onTap,
    this.showArrow = true,
  });
}

// Personal Data Section Implementation
class PersonalDataSection extends SectionFactory {
  const PersonalDataSection(
      {super.key,
        super.onItemTap,
        super.padding,
        super.backgroundColor,
        super.titleStyle,
        super.sectionTextStyle,
        super.paddingSection,
        this.onProfileTap,
        this.onWalletTap});
  final VoidCallback? onProfileTap;

  final VoidCallback? onWalletTap;

  @override
  String get sectionTitle => 'Personal';

  @override
  List<SectionItem> get sectionItems => [
    SectionItem(
      title: 'Profile Details',
      iconPath: 'assets/app_icons/hamburg_icon.svg',
      onTap: () => onProfileTap!(),
    ),
    SectionItem(
      title: 'Manage Your Documents',
      iconPath: 'assets/app_icons/gradient_document.svg',
      onTap: () => onWalletTap!(),
    ),
  ];
}

// More Section Implementation
class MoreSection extends SectionFactory {
  const MoreSection({
    super.key,
    super.onItemTap,
    super.padding,
    super.backgroundColor,
    super.titleStyle,
    super.sectionTextStyle,
    super.paddingSection,
    this.onTapAddress,
    this.onTapLogout,
    this.onTapSecurity,
  });
  final VoidCallback? onTapAddress;
  final VoidCallback? onTapSecurity;
  final VoidCallback? onTapLogout;
  @override
  String get sectionTitle => 'More';

  @override
  List<SectionItem> get sectionItems => [
    SectionItem(
        title: 'Vehicle Information',
        iconPath: 'assets/app_icons/gradient_bike.svg',
        onTap: onTapAddress),
    SectionItem(
        title: 'Security and Privacy',
        iconPath: 'assets/app_icons/availability_icon.svg',
        onTap: onTapSecurity),
    SectionItem(
        title: 'Logout',
        iconPath: 'assets/app_icons/logout.svg',
        onTap: onTapLogout),
  ];
}

class ManagePayment extends SectionFactory {
  ManagePayment(
      {super.key,
        super.backgroundColor,
        super.padding,
        super.titleStyle,
        super.onItemTap,
        super.paddingSection,
        super.sectionTextStyle,
        this.onMasterCardTap,
        this.onVisaCardTap});
  final VoidCallback? onMasterCardTap;
  final VoidCallback? onVisaCardTap;
  @override
  List<SectionItem> get sectionItems => [
    SectionItem(
      title: '*** **** 1234',
      iconPath: 'assets/app_icons/mastercard.svg',
      onTap: onMasterCardTap,

    ),
    SectionItem(
      title: '*** **** 1234',
      iconPath: 'assets/app_icons/visa_electron.svg',
      onTap: () => onVisaCardTap,
    )
  ];

  @override
  String get sectionTitle => '';
}
