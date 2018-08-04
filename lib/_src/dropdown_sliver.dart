import 'package:flutter/material.dart';

class DropdownSliverChildBuilderDelegate
    extends SliverPersistentHeaderDelegate {
  WidgetBuilder builder;

  DropdownSliverChildBuilderDelegate({this.builder}) : assert(builder != null);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context);
  }

  // TODO: implement maxExtent
  @override
  double get maxExtent => 46.0;

  // TODO: implement minExtent
  @override
  double get minExtent => 46.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
