import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../shared/app_config.dart';
import '../../../utilities/responsive.dart';
import '../../../utilities/ui.dart';

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
          VSpace(extraSmallWhiteSpace),
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
          VSpace(whiteSpace),
        ],
      );
    }
    return SizedBox();
  }
}
