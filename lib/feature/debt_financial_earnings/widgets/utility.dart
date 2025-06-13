import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/shared/widgets/app_icon.dart';
import 'package:freedomdriver/utilities/responsive.dart';

abstract class SectionFactory extends StatelessWidget {
  const SectionFactory({
    super.key,
    this.onItemTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 22),
    this.backgroundColor = const Color(0xFFFBFAFA),
    this.titleStyle,
    this.sectionTextStyle,
    this.paddingSection,
    this.sectionSubHeadingStyle,
  });
  final VoidCallback? onItemTap;
  final EdgeInsets? padding;
  final Color backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? sectionTextStyle;
  final TextStyle? sectionSubHeadingStyle;
  final EdgeInsetsGeometry? paddingSection;

  String get sectionTitle;
  List<SectionItem> get sectionItems;

  Widget _buildSectionItem(SectionItem item) {
    return InkWell(
      onTap: item.onTap ?? onItemTap,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            padding: paddingSection ?? const EdgeInsets.all(extraSmallWhiteSpace),
            margin: const EdgeInsets.only(left: smallWhiteSpace),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(roundedMd),
            ),
            child:
                item.iconPath!.endsWith('svg')
                    ? SvgPicture.asset(item.iconPath ?? '')
                    : Image.asset(item.iconPath ?? ''),
          ),
          const SizedBox(width: smallWhiteSpace),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style:
                    sectionTextStyle ??
                    const TextStyle(
                      fontSize: smallText,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              if (item.subheading != null)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: Text(
                    item.subheading ?? '',
                    softWrap: true,
                    style:
                        sectionSubHeadingStyle ??
                        TextStyle(
                          fontSize: smallText,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                  ),
                ),
            ],
          ),
          const Spacer(),
          if (item.subtitle != null)
            Text(
              item.subtitle!,
              style: const TextStyle(
                fontSize: 8.27,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w200,
              ),
            ),
          const SizedBox(width: 22),
          if (item.showArrow)
            Padding(
              padding: const EdgeInsets.only(right: 22),
              child: AppIcon(
                iconName: 'arrow_right_icon',
                colorFilter: ColorFilter.mode(
                  Colors.grey.shade700,
                  BlendMode.srcIn,
                ),
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
            if (sectionTitle.isNotEmpty)
              Text(
              sectionTitle,
              textAlign: TextAlign.center,
              style:
                  titleStyle ??
                  const TextStyle(
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
                        width: Responsive.width(context),
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
  const SectionItem({
    required this.title,
    this.iconPath,
    this.subtitle,
    this.subheading,
    this.sectionSubHeadingStyle,
    this.onTap,
    this.showArrow = true,
  });
  final String title;
  final String? iconPath;
  final String? subtitle;
  final String? subheading;
  final TextStyle? sectionSubHeadingStyle;
  final VoidCallback? onTap;
  final bool showArrow;
}

String getIconUrl(String iconName) => 'assets/app_icons/$iconName.svg';
String getPngImageUrl(String imageName) => 'assets/app_images/$imageName.png';

// Personal Data Section Implementation
class SecurityAndPrivacySection extends SectionFactory {
  const SecurityAndPrivacySection({
    super.key,
    super.onItemTap,
    super.padding,
    super.backgroundColor,
    super.titleStyle,
    super.sectionTextStyle,
    super.paddingSection,
    this.onTrustedDevicesTap,
    this.on2faTap,
    this.onChangePasswordTap,
    this.onManageLocationTap,
  });
  final VoidCallback? on2faTap;

  final VoidCallback? onManageLocationTap;
  final VoidCallback? onChangePasswordTap;
  final VoidCallback? onTrustedDevicesTap;

  @override
  String get sectionTitle => '';

  @override
  List<SectionItem> get sectionItems => [
    SectionItem(
      title: 'Two-Step Verification',
      iconPath: getIconUrl('2fa'),
      onTap: on2faTap,
    ),
    SectionItem(
      title: 'Change Password',
      iconPath: getIconUrl('solar_password'),
      onTap: onChangePasswordTap,
    ),
    SectionItem(
      title: 'Trusted Devices',
      iconPath: getIconUrl('solar_devices'),
      onTap: onTrustedDevicesTap,
    ),
    SectionItem(
      title: 'Manage Location Settings',
      iconPath: getIconUrl('location_duotone'),
      onTap: onManageLocationTap,
    ),
  ];
}

// Personal Data Section Implementation
class PersonalDataSection extends SectionFactory {
  const PersonalDataSection({
    super.key,
    super.onItemTap,
    super.padding,
    super.backgroundColor,
    super.titleStyle,
    super.sectionTextStyle,
    super.paddingSection,
    this.onDebtTap,
    this.onProfileTap,
    this.onDocumentTap,
    this.onWalletTap,
  });
  final VoidCallback? onProfileTap;

  final VoidCallback? onWalletTap;
  final VoidCallback? onDocumentTap;
  final VoidCallback? onDebtTap;

  @override
  String get sectionTitle => 'Personal';

  @override
  List<SectionItem> get sectionItems => [
    SectionItem(
      title: 'Profile Details',
      iconPath: getIconUrl('hamburg_icon'),
      onTap: onProfileTap,
    ),
    SectionItem(
      title: 'Manage Your Documents',
      iconPath: getIconUrl('address_book'),
      onTap: onDocumentTap,
    ),
    SectionItem(
      title: 'Debt Management',
      iconPath: getIconUrl('gradient_document'),
      onTap: onDebtTap,
    ),
    SectionItem(
      title: 'Wallet',
      iconPath: getIconUrl('solar_wallet'),
      onTap: onWalletTap,
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
    // SectionItem(
    //   title: 'Vehicle Information',
    //   iconPath: getIconUrl('gradient_bike'),
    //   onTap: onTapAddress,
    // ),
    SectionItem(
      title: 'Security and Privacy',
      iconPath: getIconUrl('light_security'),
      onTap: onTapSecurity,
    ),
    SectionItem(
      title: 'Logout',
      iconPath: getIconUrl('logout'),
      onTap: onTapLogout,
    ),
  ];
}

class ManagePayment extends SectionFactory {
  const ManagePayment({
    super.key,
    super.backgroundColor,
    super.padding,
    super.titleStyle,
    super.onItemTap,
    super.paddingSection,
    super.sectionTextStyle,
    this.onAddWalletTap,
    this.onAddMobileMoneyTap,
    this.walletSubheading,
    this.mobileMoneySubheading
  });
  final VoidCallback? onAddWalletTap;
  final VoidCallback? onAddMobileMoneyTap;
  final String? walletSubheading;
  final String? mobileMoneySubheading;


  @override
  List<SectionItem> get sectionItems => [
    SectionItem(
      title: 'Add Bank Account',
      subheading: walletSubheading, // '*** **** 1234',
      iconPath: 'assets/app_icons/mastercard.svg',
      onTap: onAddWalletTap,
    ),
    SectionItem(
      title: 'Add Mobile Money',
      subheading: mobileMoneySubheading, // '*** **** 1234',
      iconPath: 'assets/app_images/momo.png',
      onTap: onAddMobileMoneyTap,
    ),
  ];

  @override
  String get sectionTitle => '';
}

// Personal Data Section Implementation
class ManageDocuments extends SectionFactory {
  const ManageDocuments({
    super.key,
    super.onItemTap,
    super.padding,
    super.backgroundColor,
    super.titleStyle,
    super.sectionTextStyle,
    super.paddingSection,
    this.onAddressTap,
    this.onLicenseTap,
    this.onGhanaCardTap,
    this.onMotorcycleImageTap,
    this.addressStatus,
    this.ghanaCardStatus,
    this.licenseStatus,
    this.motorcycleStatus,
  });
  final VoidCallback? onAddressTap;
  final VoidCallback? onLicenseTap;
  final VoidCallback? onMotorcycleImageTap;
  final VoidCallback? onGhanaCardTap;
  final String? addressStatus;
  final String? licenseStatus;
  final String? motorcycleStatus;
  final String? ghanaCardStatus;

  @override
  String get sectionTitle => '';

  @override
  List<SectionItem> get sectionItems => [
    SectionItem(
      title: 'Verify Address',
      subheading: addressStatus,
      iconPath: getIconUrl('gradient_document'),
      onTap: onAddressTap,
    ),
    SectionItem(
      title: 'Driver License',
      subheading: licenseStatus,
      iconPath: getIconUrl('gradient_document'),
      onTap: onLicenseTap,
    ),
    SectionItem(
      title: 'Ghana Card',
      subheading: ghanaCardStatus,
      iconPath: getIconUrl('gradient_document'),
      onTap: onGhanaCardTap,
    ),
    SectionItem(
      title: 'Motorcycle Image',
      subheading: motorcycleStatus,
      iconPath: getIconUrl('gradient_bike'),
      onTap: onMotorcycleImageTap,
    ),
  ];
}
