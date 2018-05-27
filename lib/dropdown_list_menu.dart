import 'package:flutter/widgets.dart';

import 'package:dropdown_menu/drapdown_common.dart';

typedef Widget MenuItemBuilder<T>(BuildContext context, T data, bool selected);
typedef void MenuItemOnTap<T>(T data, int index);
typedef List<E> GetSubData<T, E>(T data);

const double kDropdownMenuItemHeight = 45.0;

class DropdownListMenu<T> extends DropdownWidget {
  final List<T> data;
  final int selectedIndex;
  final MenuItemBuilder itemBuilder;
  final double itemExtent;

  DropdownListMenu(
      {this.data,
      this.selectedIndex,
      this.itemBuilder,
      this.itemExtent: kDropdownMenuItemHeight});

  @override
  DropdownState<DropdownWidget> createState() {
    return new _MenuListState<T>();
  }
}

class _MenuListState<T> extends DropdownState<DropdownListMenu<T>> {
  int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Widget buildItem(BuildContext context, int index) {
    final List<T> list = widget.data;

    final T data = list[index];
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.itemBuilder(context, data, index == _selectedIndex),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });

        assert(controller != null);
        controller.select(data, index: index);
        // if (onTap != null) onTap(data, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemExtent: widget.itemExtent,
      itemBuilder: buildItem,
      itemCount: widget.data.length,
    );
  }

  @override
  void onEvent(DropdownEvent event) {
    switch (event) {
      case DropdownEvent.SELECT:
      case DropdownEvent.HIDE:
        {}
        break;
      case DropdownEvent.ACTIVE:
        {}
        break;
    }
  }
}

class DropdownTreeMenu<T, E> extends DropdownWidget {
  final List<T> data;
  final int selectedIndex;
  final MenuItemBuilder<T> itemBuilder;

  final int subSelectedIndex;
  final MenuItemBuilder<E> subItemBuilder;

  final GetSubData<T, E> getSubData;

  final double itemExtent;

  final Color background;

  final Color subBackground;

  final int flex;
  final int subFlex;

  DropdownTreeMenu({
    this.data,
    double itemExtent,
    this.selectedIndex,
    this.itemBuilder,
    this.subItemBuilder,
    this.getSubData,
    this.background: const Color(0xfffafafa),
    this.subBackground,
    this.flex: 1,
    this.subFlex: 2,
    this.subSelectedIndex,
  })  : assert(getSubData != null),
        itemExtent = itemExtent ?? kDropdownMenuItemHeight;

  @override
  DropdownState<DropdownWidget> createState() {
    return new _TreeMenuList();
  }
}

class _TreeMenuList<T, E> extends DropdownState<DropdownTreeMenu> {
  int _subSelectedIndex;
  int _selectedIndex;

  //
  int _activeIndex;

  List<E> _subData;

  List<T> _data;

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    _subSelectedIndex = widget.subSelectedIndex;
    _activeIndex = _selectedIndex;

    _data = widget.data;

    if (_activeIndex != null) {
      _subData = widget.getSubData(_data[_activeIndex]);
    }

    super.initState();
  }

  @override
  void didUpdateWidget(DropdownTreeMenu oldWidget) {
    // _selectedIndex = widget.selectedIndex;
    // _subSelectedIndex = widget.subSelectedIndex;
    // _activeIndex = _selectedIndex;

    super.didUpdateWidget(oldWidget);
  }

  Widget buildSubItem(BuildContext context, int index) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.subItemBuilder(context, _subData[index],
          _activeIndex == _selectedIndex && index == _subSelectedIndex),
      onTap: () {
        assert(controller != null);
        controller.select(_subData[index],
            index: _activeIndex, subIndex: index);
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
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.itemBuilder(context, data, index == _activeIndex),
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
    return new Row(
      children: <Widget>[
        new Expanded(
            flex: widget.flex,
            child: new Container(
              child: new ListView.builder(
                itemBuilder: buildItem,
                itemExtent: widget.itemExtent,
                itemCount: this._data == null ? 0 : this._data.length,
              ),
              color: widget.background,
            )),
        new Expanded(
            flex: widget.subFlex,
            child: new ListView.builder(
              itemBuilder: buildSubItem,
              itemExtent: widget.itemExtent,
              itemCount: this._subData == null ? 0 : this._subData.length,
            ))
      ],
    );
  }

  @override
  void onEvent(DropdownEvent event) {
    // TODO: implement onEvent
  }
}
