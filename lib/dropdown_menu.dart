library flutter_dropdown_menu;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

abstract class _DropdownMenuControllerListener {
  Future<Null> onShow(int index);
  Future<Null> onHide();
}

enum DropdownMenuShowHideSwitchStyle {
  /// the showing menu will direct hide without animation
  directHideAnimationShow,

  /// the showing menu will hide with animation,and the same time another menu shows with animation
  animationHideAnimationShow,

  /// the showing menu will hide with animation,until the animation complete, another menu shows with animation
  animationShowUntilAnimationHideComplete,
}

class DropdownMenuController {
  _DropdownMenuControllerListener _listener;

  void _setListener(_DropdownMenuControllerListener listener) {
    _listener = listener;
  }

  Future<Null> show(int index) {
    return _listener.onShow(index);
  }

  Future<Null> hide() {
    return _listener.onHide();
  }
}

class DropdownMenu extends StatefulWidget {
  final Widget child;

  final DropdownMenuController controller;

  /// menus whant to show
  /// the elements of the menus must be [SizedBox] or [DropdownMenuBuilder]
  final List<dynamic> menus;

  final Duration hideDuration;
  final Duration showDuration;
  final Curve showCurve;
  final Curve hideCurve;

  /// The style when one menu hide and another menu show ,
  /// see [DropdownMenuShowHideSwitchStyle]
  final DropdownMenuShowHideSwitchStyle switchStyle;

  DropdownMenu(
      {@required this.child,
      @required this.controller,
      @required this.menus,
      Duration hideDuration,
      Duration showDuration,
      Curve hideCurve,
      this.switchStyle: DropdownMenuShowHideSwitchStyle
          .animationShowUntilAnimationHideComplete,
      Curve showCurve})
      : hideDuration = hideDuration ?? new Duration(milliseconds: 150),
        showDuration = showDuration ?? new Duration(milliseconds: 300),
        showCurve = showCurve ?? Curves.fastOutSlowIn,
        hideCurve = hideCurve ?? Curves.fastOutSlowIn {
    assert(controller != null);
    assert(menus != null);
    assert(child != null);

    for (int i = 0, c = menus.length; i < c; ++i) {
      if (menus[i] is SizedBox) {
        assert((menus[i] as SizedBox).height != null);
        continue;
      }
      if (menus[i] is DropdownMenuBuilder) {
        continue;
      }

      throw new Exception(
          "The elements of the menus must be [SizedBox],or [DropdownMenuBuilder]");
    }
  }

  @override
  State<StatefulWidget> createState() {
    return new _DropdownMenuState();
  }
}

class DropdownMenuBuilder {
  final WidgetBuilder builder;
  final double height;

  DropdownMenuBuilder({@required this.builder, @required this.height})
      : assert(builder != null),
        assert(height != null && height > 0);
}

class _DropdownAnimation {
  Animation<Rect> rect;
  AnimationController animationController;
  RectTween position;

  _DropdownAnimation(TickerProvider provider) {
    animationController = new AnimationController(vsync: provider);
  }

  set height(double value) {
    position = new RectTween(
      begin: new Rect.fromLTRB(0.0, -value, 0.0, 0.0),
      end: new Rect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    );

    rect = position.animate(animationController);
  }

  set value(double value) {
    animationController.value = value;
  }

  void dispose() {
    animationController.dispose();
  }

  TickerFuture animateTo(double value, {Duration duration, Curve curve}) {
    return animationController.animateTo(value,
        duration: duration, curve: curve);
  }
}

class _DropdownMenuState extends State<DropdownMenu>
    with TickerProviderStateMixin
    implements _DropdownMenuControllerListener {
  List<_DropdownAnimation> _dropdownAnimations;

  bool _show;
  List<int> _showing;

  AnimationController _fadeController;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    _showing = [];
    _dropdownAnimations = [];
    for (int i = 0, c = widget.menus.length; i < c; ++i) {
      _dropdownAnimations.add(new _DropdownAnimation(this));
      _dropdownAnimations[i].height = _getHeight(widget.menus[i]);
    }
    _show = false;

    _fadeController = new AnimationController(vsync: this);
    _fadeAnimation = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);

    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0, c = _dropdownAnimations.length; i < c; ++i) {
      _dropdownAnimations[i].dispose();
    }

    if (widget.controller != null) {
      widget.controller._setListener(null);
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (widget.controller != null) {
      widget.controller._setListener(this);
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(DropdownMenu oldWidget) {
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller != null) {
        oldWidget.controller._setListener(null);
      }
      if (widget.controller != null) {
        widget.controller._setListener(this);
      }
    }
    //update state

    for (int i = 0, c = widget.menus.length; i < c; ++i) {
      _dropdownAnimations[i].height = _getHeight(widget.menus[i]);
    }

    super.didUpdateWidget(oldWidget);
  }

  Widget createMenu(BuildContext context, dynamic menu, int i) {
    if (menu is Widget) {
      return menu;
    }

    DropdownMenuBuilder builder = menu as DropdownMenuBuilder;

    return new SizedBox(
        height: builder.height,
        child: _showing.contains(i) ? builder.builder(context) : null);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      widget.child,
    ];

    if (_show) {
      assert(_activeIndex != null);
      list.add(
        new FadeTransition(
          opacity: _fadeAnimation,
          child: new GestureDetector(
              onTap: onHide,
              child: new Container(
                color: Colors.black26,
              )),
        ),
      );
    }

    for (int i = 0, c = widget.menus.length; i < c; ++i) {
      list.add(new RelativePositionedTransition(
          rect: _dropdownAnimations[i].rect,
          size: new Size(0.0, 0.0),
          child: new Align(
              alignment: Alignment.topCenter,
              child: new Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: createMenu(context, widget.menus[i], i),
              ))));
    }

    //WidgetsBinding;
    //context.findRenderObject();
    return new Stack(
      fit: StackFit.expand,
      children: list,
    );
  }

  @override
  TickerFuture onHide() {
    if (_activeIndex != null) {
      int index = _activeIndex;
      _activeIndex = null;
      TickerFuture future = _hide(index);
      _fadeController.animateTo(0.0,
          duration: widget.hideDuration, curve: widget.hideCurve);

      future.whenComplete(() {
        setState(() {
          _show = false;
        });
      });
      return future;
    }

    return new TickerFuture.complete();
  }

  TickerFuture _hide(int index) {
    TickerFuture future = _dropdownAnimations[index]
        .animateTo(0.0, duration: widget.hideDuration, curve: widget.hideCurve);
    return future;
  }

  int _activeIndex;

  @override
  Future<Null> onShow(int index) {
    //哪一个是要展示的

    assert(index >= 0 && index < _dropdownAnimations.length);
    if (!_showing.contains(index)) {
      _showing.add(index);
    }

    if (_activeIndex != null) {
      if (_activeIndex == index) {
        return onHide();
      }

      switch (widget.switchStyle) {
        case DropdownMenuShowHideSwitchStyle.directHideAnimationShow:
          {
            _dropdownAnimations[index].value = 0.0;
          }

          break;
        case DropdownMenuShowHideSwitchStyle.animationHideAnimationShow:
          {
            _hide(_activeIndex);
          }
          break;
        case DropdownMenuShowHideSwitchStyle
            .animationShowUntilAnimationHideComplete:
          {
            return _hide(_activeIndex).whenComplete(() {
              return _handleShow(index);
            });
          }
          break;
      }
    }

    return _handleShow(index);
  }

  TickerFuture _handleShow(int index) {
    _activeIndex = index;

    setState(() {
      _show = true;
    });

    _fadeController.animateTo(1.0,
        duration: widget.showDuration, curve: widget.showCurve);

    return _dropdownAnimations[index]
        .animateTo(1.0, duration: widget.showDuration, curve: widget.showCurve);
  }

  double _getHeight(dynamic menu) {
    if (menu is SizedBox) {
      SizedBox sizedBox = menu;
      assert(sizedBox.height != null);
      return sizedBox.height;
    }

    DropdownMenuBuilder builder = menu as DropdownMenuBuilder;
    return builder.height;
  }
}
