import 'package:flutter/cupertino.dart';

import '../../../core/widget/ShimmerWidget.dart';

Widget buildGridShimmer(bool isDark) {
  return GridView.builder(
    itemCount: 6,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.68,
    ),
    itemBuilder: (_, __) => CardShimmer(isDark: isDark),
  );
}