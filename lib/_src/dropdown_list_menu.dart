import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:dropdown_menu/_src/drapdown_common.dart';

typedef MenuItemBuilder<T> = Widget Function(
    BuildContext context, T? data, bool selected);
typedef MenuItemOnTap<T> = void Function(T data, int index);
typedef GetSubData<T, E> = List<E> Function(T data);

const double kDropdownMenuItemHeight = 45.0;

class DropdownListMenu<T> extends DropdownWidget {
  final List<T>? data;
  final int? selectedIndex;
  final MenuItemBuilder? itemBuilder;
  final double itemExtent;

  DropdownListMenu(
      {super.key,
      this.data,
      this.selectedIndex,
      this.itemBuilder,
      this.itemExtent = kDropdownMenuItemHeight});

  @override
  DropdownState<DropdownWidget> createState() {
    return MenuListState<T>();
  }
}

class MenuListState<T> extends DropdownState<DropdownListMenu<T>> {
  int? _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  Widget buildItem(BuildContext context, int index) {
    final List<T> list = widget.data!;

    final T data = list[index];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.itemBuilder!(context, data, index == _selectedIndex),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        assert(controller != null);
        controller!.select(data, index: index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: widget.itemExtent,
      itemBuilder: buildItem,
      itemCount: widget.data!.length,
    );
  }

  @override
  void onEvent(DropdownEvent? event) {
    switch (event) {
      case DropdownEvent.SELECT:
      case DropdownEvent.HIDE:
        {}
        break;
      case DropdownEvent.ACTIVE:
        {}
        break;
      default:
        break;
    }
  }
}

/// This widget is just like this:
/// ----------------|---------------------
/// MainItem1       |SubItem1
/// MainItem2       |SubItem2
/// MainItem3       |SubItem3
/// ----------------|---------------------
/// When you tap "MainItem1", the sub list of this widget will
/// 1. call `getSubData(widget.data[0])`, this will return a list of data for sub list
/// 2. Refresh the sub list of the widget by using the list above.
///
///
class DropdownTreeMenu<T, E> extends DropdownWidget {
  /// data from this widget
  final List<T> data;

  /// selected index of main list
  final int? selectedIndex;

  /// item builder for main list
  final MenuItemBuilder<T>? itemBuilder;

  //selected index of sub list
  final int? subSelectedIndex;

  /// A function to build right item of the tree
  final MenuItemBuilder<E>? subItemBuilder;

  /// A callback to get sub list from left list data, eg.
  /// When you set List<MyData> to left,
  /// a callback (MyData data)=>data.children; must be provided
  final GetSubData<T, E> getSubData;

  /// `itemExtent` of main list
  final double itemExtent;

  /// `itemExtent` of sub list
  final double? subItemExtent;

  /// background for main list
  final Color background;

  /// background for sub list
  final Color? subBackground;

  /// flex for main list
  final int flex;

  /// flex for sub list,
  /// if `subFlex`==2 and `flex`==1,then sub list will be 2 times larger than main list
  final int subFlex;

  DropdownTreeMenu({
    super.key,
    required this.data,
    double? itemExtent,
    this.selectedIndex,
    this.itemBuilder,
    this.subItemExtent,
    this.subItemBuilder,
    required this.getSubData,
    this.background = const Color(0xfffafafa),
    this.subBackground,
    this.flex = 1,
    this.subFlex = 2,
    this.subSelectedIndex,
  }) : itemExtent = itemExtent ?? kDropdownMenuItemHeight;

  @override
  DropdownState<DropdownWidget> createState() {
    return _TreeMenuList<T, E>();
  }
}

class _TreeMenuList<T, E> extends DropdownState<DropdownTreeMenu<T, E>> {
  int? _subSelectedIndex;
  int? _selectedIndex;

  //
  int? _activeIndex;

  List<E>? _subData;

  List<T>? _data;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    _subSelectedIndex = widget.subSelectedIndex;
    _activeIndex = _selectedIndex;

    _data = widget.data;

    if (_activeIndex != null) {
      _subData = widget.getSubData(_data![_activeIndex!]);
    }

    super.initState();
  }

  @override
  void didUpdateWidget(DropdownTreeMenu<T, E> oldWidget) {
    // _selectedIndex = widget.selectedIndex;
    // _subSelectedIndex = widget.subSelectedIndex;
    // _activeIndex = _selectedIndex;

    super.didUpdateWidget(oldWidget);
  }

  Widget buildSubItem(BuildContext context, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.subItemBuilder!(context, _subData![index],
          _activeIndex == _selectedIndex && index == _subSelectedIndex),
      onTap: () {
        assert(controller != null);
        controller!
            .select(_subData![index], index: _activeIndex, subIndex: index);
        setState(() {
          _selectedIndex = _activeIndex;
          _subSelectedIndex = index;
        });
      },
    );
  }

  Widget buildItem(BuildContext context, int index) {
    final List<T> list = widget.data;
    final T data = list[index];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.itemBuilder!(context, data, index == _activeIndex),
      onTap: () {
        //切换
        //拿到数据
        setState(() {
          _subData = widget.getSubData(data);
          _activeIndex = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
            flex: widget.flex,
            child: Container(
              color: widget.background,
              child: ListView.builder(
                itemExtent: widget.itemExtent,
                itemBuilder: buildItem,
                itemCount: this._data == null ? 0 : this._data!.length,
              ),
            )),
        Expanded(
            flex: widget.subFlex,
            child: Container(
              color: widget.subBackground,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    buildSubItem,
                    childCount:
                        this._subData == null ? 0 : this._subData!.length,
                  ))
                ],
              ),
            ))
      ],
    );
  }

  @override
  void onEvent(DropdownEvent? event) {
    // TODO: implement onEvent
  }
}
