import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/utilities/responsive.dart';
import 'package:freedomdriver/utilities/ui.dart';

class UploadedDocumentImage extends StatelessWidget {
  const UploadedDocumentImage({super.key, this.documentUrl, required this.heading});

  final String? documentUrl;
  final String heading;

  @override
  Widget build(BuildContext context) {
    if (documentUrl != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading, style: normalTextStyle),
          const VSpace(extraSmallWhiteSpace),
          ClipRRect(
            borderRadius: BorderRadius.circular(roundedMd),
            child: CachedNetworkImage(
              imageUrl: documentUrl ?? '',
              width:
                  Responsive.isMobile(context)
                      ? mobileWidth
                      : Responsive.width(context),
            ),
          ),
          const VSpace(whiteSpace),
        ],
      );
    }
    return const SizedBox();
  }
}
