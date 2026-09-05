import 'package:cached_network_image/cached_network_image.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

class HomePromoBanner extends StatelessWidget {
  final String discount;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final DateTime? expiresAt;

  const HomePromoBanner({
    super.key,
    required this.discount,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.expiresAt,
  });

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final daysLeft = expiresAt == null
        ? null
        : expiresAt!.difference(DateTime.now()).inDays + 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: brand.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 32,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          // بالعربي "خصم" بييجي قبل الرقم، وبالإنجليزي
                          // "off" بييجي بعده — بنبني الترتيب يدويًا
                          // حسب اللغة بدل ما نعتمد على انعكاس تلقائي.
                          // خط "خصم" أصغر بكتير من الرقم عشان يفضل جنب
                          // النسبة في نفس السطر من غير ما يكبّر الكارت.
                          children: isArabic
                              ? [
                                  TextSpan(
                                    text: '${strings.offLabel} ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: brand.textSecondary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "$discount%",
                                    style: TextStyle(
                                      color: brand.accent,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]
                              : [
                                  TextSpan(
                                    text: "$discount%",
                                    style: TextStyle(
                                      color: brand.accent,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${strings.offLabel}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 109,
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          title,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      if (daysLeft != null && daysLeft > 0) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            daysLeft == 1
                                ? strings.endsTomorrow
                                : strings.endsInDays(daysLeft),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      imageUrl != null
                          ? CachedNetworkImage(
                              height: 83,
                              width: 198,
                              imageUrl: imageUrl!,
                              fit: BoxFit.contain,
                              errorWidget: (context, url, error) => Icon(
                                Icons.weekend_outlined,
                                size: 60,
                                color: brand.textSecondary,
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.weekend_outlined,
                                size: 60,
                                color: brand.textSecondary,
                              ),
                            ),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: brand.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
