import 'package:flutter/cupertino.dart';

class CupertinoSliverHeader extends StatelessWidget {
  final double expandedHeight;
  final Widget background;
  final Color backgroundColor;

  const CupertinoSliverHeader({
    super.key,
    required this.expandedHeight,
    required this.background,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _CupertinoSliverHeaderDelegate(
        expandedHeight: expandedHeight,
        background: background,
        backgroundColor: backgroundColor,
      ),
    );
  }
}

class _CupertinoSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Widget background;
  final Color backgroundColor;

  _CupertinoSliverHeaderDelegate({
    required this.expandedHeight,
    required this.background,
    required this.backgroundColor,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxExtent;
    final double opacity = 1 - progress;

    return Container(
      color: backgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: opacity,
            child: background,
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant _CupertinoSliverHeaderDelegate oldDelegate) {
    return expandedHeight != oldDelegate.expandedHeight ||
        background != oldDelegate.background ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
