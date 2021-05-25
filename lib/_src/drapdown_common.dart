import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum DropdownEvent {
  // the menu will hide
  HIDE,

  // the menu will active
  ACTIVE,

  // user has click menu item
  SELECT
}

class DropdownMenuController extends ChangeNotifier {
  //user interaction event name
  DropdownEvent event;

  // whitch menu index
  int menuIndex;

  /// selected data
  dynamic data;

  /// item index in list [TreeMenuList] or [MenuList] or your custom menu
  int index;

  /// item index in sublist of [TreeMenuList]
  int subIndex;

  void hide() {
    event = DropdownEvent.HIDE;
    notifyListeners();
  }

  void show(int index) {
    event = DropdownEvent.ACTIVE;
    menuIndex = index;
    notifyListeners();
  }

  void select(dynamic data, {int index, int subIndex}) {
    event = DropdownEvent.SELECT;
    this.data = data;
    this.index = index;
    this.subIndex = subIndex;
    notifyListeners();
  }
}

typedef DropdownMenuOnSelected(
    {int menuIndex, int index, int subIndex, dynamic data});

class DefaultDropdownMenuController extends StatefulWidget {
  const DefaultDropdownMenuController({
    Key key,
    @required this.child,
    this.onSelected,
  }) : super(key: key);

  final Widget child;

  final DropdownMenuOnSelected onSelected;

  static DropdownMenuController of(BuildContext context) {
    final _DropdownMenuControllerScope scope =
        context.dependOnInheritedWidgetOfExactType(
            aspect: _DropdownMenuControllerScope);
    return scope?.controller;
  }

  @override
  _DefaultDropdownMenuControllerState createState() =>
      new _DefaultDropdownMenuControllerState();
}

class _DefaultDropdownMenuControllerState
    extends State<DefaultDropdownMenuController>
    with SingleTickerProviderStateMixin {
  DropdownMenuController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new DropdownMenuController();
    _controller.addListener(_onController);
  }

  void _onController() {
    switch (_controller.event) {
      case DropdownEvent.SELECT:
        {
          //通知widget
          if (widget.onSelected == null) return;
          widget.onSelected(
              data: _controller.data,
              menuIndex: _controller.menuIndex,
              index: _controller.index,
              subIndex: _controller.subIndex);
        }
        break;
      case DropdownEvent.ACTIVE:
        break;
      case DropdownEvent.HIDE:
        break;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onController);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new _DropdownMenuControllerScope(
      controller: _controller,
      enabled: TickerMode.of(context),
      child: widget.child,
    );
  }
}

class _DropdownMenuControllerScope extends InheritedWidget {
  const _DropdownMenuControllerScope(
      {Key key, this.controller, this.enabled, Widget child})
      : super(key: key, child: child);

  final DropdownMenuController controller;
  final bool enabled;

  @override
  bool updateShouldNotify(_DropdownMenuControllerScope old) {
    return enabled != old.enabled || controller != old.controller;
  }
}

abstract class DropdownWidget extends StatefulWidget {
  final DropdownMenuController controller;

  DropdownWidget({Key key, this.controller}) : super(key: key);

  @override
  DropdownState<DropdownWidget> createState();
}

abstract class DropdownState<T extends DropdownWidget> extends State<T> {
  DropdownMenuController controller;

  @override
  void dispose() {
    if (controller != null) {
      controller.removeListener(_onController);
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (controller == null) {
      if (widget.controller == null) {
        controller = DefaultDropdownMenuController.of(context);
      } else {
        controller = widget.controller;
      }

      if (controller != null) {
        controller.addListener(_onController);
      }
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    if (widget.controller != null) {
      if (controller != null) {
        controller.removeListener(_onController);
      }
      controller = widget.controller;
      controller.addListener(_onController);
    }

    super.didUpdateWidget(oldWidget);
  }

  void _onController() {
    onEvent(controller.event);
  }

  void onEvent(DropdownEvent event);
}

class DropdownMenuBuilder {
  final WidgetBuilder builder;
  final double height;

  //if height == null , use [DropdownMenu.maxMenuHeight]
  DropdownMenuBuilder({@required this.builder, this.height})
      : assert(builder != null);
}
