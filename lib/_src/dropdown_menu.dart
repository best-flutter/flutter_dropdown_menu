import 'dart:async';
import 'dart:ui' as ui show Image, ImageFilter;
import 'package:dropdown_menu/_src/drapdown_common.dart';
import 'package:flutter/material.dart';

enum DropdownMenuShowHideSwitchStyle {
  /// the showing menu will direct hide without animation
  directHideAnimationShow,

  /// the showing menu will direct hide without animation, and another menu shows without animation
  directHideDirectShow,

  /// the showing menu will hide with animation,and the same time another menu shows with animation
  animationHideAnimationShow,

  /// the showing menu will hide with animation,until the animation complete, another menu shows with animation
  animationShowUntilAnimationHideComplete,
}

class DropdownMenu extends DropdownWidget {
  /// menus whant to show
  final List<DropdownMenuBuilder> menus;

  final Duration hideDuration;
  final Duration showDuration;
  final Curve showCurve;
  final Curve hideCurve;

  /// if set , background is rendered with ImageFilter.blur
  final double blur;

  final VoidCallback onHide;

  /// The style when one menu hide and another menu show ,
  /// see [DropdownMenuShowHideSwitchStyle]
  final DropdownMenuShowHideSwitchStyle switchStyle;

  final double maxMenuHeight;

  DropdownMenu(
      {@required this.menus,
      DropdownMenuController controller,
      Duration hideDuration,
      Duration showDuration,
      this.onHide,
      this.blur,
      Key key,
      this.maxMenuHeight,
      Curve hideCurve,
      this.switchStyle: DropdownMenuShowHideSwitchStyle
          .animationShowUntilAnimationHideComplete,
      Curve showCurve})
      : hideDuration = hideDuration ?? new Duration(milliseconds: 150),
        showDuration = showDuration ?? new Duration(milliseconds: 300),
        showCurve = showCurve ?? Curves.fastOutSlowIn,
        hideCurve = hideCurve ?? Curves.fastOutSlowIn,
        super(key: key, controller: controller) {
    assert(menus != null);
  }

  @override
  DropdownState<DropdownMenu> createState() {
    return new _DropdownMenuState();
  }
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

class SizeClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return new Rect.fromLTWH(0.0, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}

class _DropdownMenuState extends DropdownState<DropdownMenu>
    with TickerProviderStateMixin {
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
    }

    _updateHeights();

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

    super.dispose();
  }

  void _updateHeights() {
    for (int i = 0, c = widget.menus.length; i < c; ++i) {
      _dropdownAnimations[i].height =
          _ensureHeight(_getHeight(widget.menus[i]));
    }
  }

  @override
  void didUpdateWidget(DropdownMenu oldWidget) {
    //update state
    _updateHeights();
    super.didUpdateWidget(oldWidget);
  }

  Widget createMenu(BuildContext context, DropdownMenuBuilder menu, int i) {
    DropdownMenuBuilder builder = menu;

    return new ClipRect(
      clipper: new SizeClipper(),
      child: new SizedBox(
          height: _ensureHeight(builder.height),
          child: _showing.contains(i) ? builder.builder(context) : null),
    );
  }

  Widget _buildBackground(BuildContext context) {
    Widget container = new Container(
      color: Colors.black26,
    );

    container = new BackdropFilter(
        filter: new ui.ImageFilter.blur(
          sigmaY: widget.blur,
          sigmaX: widget.blur,
        ),
        child: container);

    return container;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    print("build ${new DateTime.now()}");

    if (_show) {
      list.add(
        new FadeTransition(
          opacity: _fadeAnimation,
          child: new GestureDetector(
              onTap: onHide, child: _buildBackground(context)),
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

  TickerFuture onHide({bool dispatch: true}) {
    if (_activeIndex != null) {
      int index = _activeIndex;
      _activeIndex = null;
      TickerFuture future = _hide(index);
      if (dispatch) {
        if (controller != null) {
          controller.hide();
        }

        //if (widget.onHide != null) widget.onHide();
      }

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

  Future<void> onShow(int index) {
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
            _dropdownAnimations[_activeIndex].value = 0.0;
            _dropdownAnimations[index].value = 1.0;
            _activeIndex = index;

            setState(() {
              _show = true;
            });

            return new Future.value(null);
          }

          break;
        case DropdownMenuShowHideSwitchStyle.animationHideAnimationShow:
          {
            _hide(_activeIndex);
          }
          break;
        case DropdownMenuShowHideSwitchStyle.directHideDirectShow:
          {
            _dropdownAnimations[_activeIndex].value = 0.0;
          }
          break;
        case DropdownMenuShowHideSwitchStyle
            .animationShowUntilAnimationHideComplete:
          {
            return _hide(_activeIndex).whenComplete(() {
              return _handleShow(index, true);
            });
          }
          break;
      }
    }

    return _handleShow(index, true);
  }

  TickerFuture _handleShow(int index, bool animation) {
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
    DropdownMenuBuilder builder = menu as DropdownMenuBuilder;

    return builder.height;
  }

  double _ensureHeight(double height) {
    final double maxMenuHeight = widget.maxMenuHeight;
    assert(height != null || maxMenuHeight != null,
        "DropdownMenu.maxMenuHeight and DropdownMenuBuilder.height must not both null");
    if (maxMenuHeight != null) {
      if (height == null) return maxMenuHeight;
      return height > maxMenuHeight ? maxMenuHeight : height;
    }
    return height;
  }

  @override
  void onEvent(DropdownEvent event) {
    switch (event) {
      case DropdownEvent.SELECT:
      case DropdownEvent.HIDE:
        {
          onHide(dispatch: false);
        }
        break;
      case DropdownEvent.ACTIVE:
        {
          onShow(controller.menuIndex);
        }
        break;
    }
  }
}
