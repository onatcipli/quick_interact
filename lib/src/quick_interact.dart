part of quick_interact;

/// [QuickInteractions] is a widget that provides quick interaction functionality.
/// It uses long press gesture to trigger a set of quick interaction widgets.
///
/// Attributes:
/// - `quickInteractionWidgets`: The list of widgets for quick interactions.
/// - `config`: The configuration model for QuickInteractBuilder and QuickInteract classes.
/// - `onQuickInteractCompleted`: The callback function when a quick interaction is completed.
/// - `child`: The child widget.
/// - `onTap`: The callback function when the widget is tapped.
/// - `toolTip`: The tooltip widget.
/// - `disable`: A flag to disable the quick interactions.
/// - `animate`: A flag to enable animation for the quick interactions.
/// - `showToolTipDelay`: The delay before showing the tooltip.
class QuickInteractions extends StatefulWidget {
  const QuickInteractions({
    Key? key,
    required this.quickInteractionWidgets,
    required this.onQuickInteractCompleted,
    required this.child,
    this.onTap,
    this.toolTip,
    this.disable = false,
    this.animate = true,
    this.showToolTipDelay = const Duration(
      seconds: 2,
    ),
    this.config = const QuickInteractConfig(),
  }) : super(key: key);

  /// The delay before showing the tooltip.
  final Duration showToolTipDelay;

  /// The tooltip widget.
  final Widget? toolTip;

  /// The list of widgets for quick interactions.
  final List<Widget> quickInteractionWidgets;

  /// The callback function when the widget is tapped.
  final VoidCallback? onTap;

  /// The callback function when a quick interaction is completed.
  final Function(int) onQuickInteractCompleted;

  /// The child widget.
  final Widget child;

  /// A flag to disable the quick interactions.
  final bool disable;

  /// A flag to enable animation for the quick interactions.
  final bool animate;

  /// The configuration model for QuickInteractBuilder and QuickInteract classes.
  final QuickInteractConfig config;

  @override
  State<QuickInteractions> createState() => _QuickInteractionsState();
}

/// [_QuickInteractionsState] is the state class for [QuickInteractions].
/// It handles the gestures and animations for the quick interactions.
class _QuickInteractionsState extends State<QuickInteractions> {
  final GlobalKey _globalKey = GlobalKey();
  RenderBox? _renderObject;
  Offset? _globalPosition;
  OverlayEntry? entry;
  GlobalKey<QuickInteractContainerBuilderState>? controller;

  int? latestIndex;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.disable) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _renderObject =
          _globalKey.currentContext?.findRenderObject() as RenderBox;
      _globalPosition = _renderObject?.localToGlobal(
        Offset.zero,
      );
      if (widget.toolTip != null) {
        Future.delayed(widget.showToolTipDelay).then((value) {
          if (mounted) showTooltip();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.disable) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _globalKey,
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap ?? onTap,
      onLongPressStart: onLongPressStart,
      onLongPressCancel: onLongPressCancel,
      onLongPressEnd: onLongPressEnd,
      onLongPressMoveUpdate: onLongPressMoveUpdate,
      child: widget.child,
    );
  }

  /// Handles the long press start gesture.
  /// It shows the quick interaction widgets and activates the first one.
  void onLongPressStart(LongPressStartDetails details) {
    if (widget.disable) {
      return;
    }
    if (widget.quickInteractionWidgets.isNotEmpty) {
      show();
      controller?.currentState?.activateInteraction(0);
      Vibrate.feedback(FeedbackType.heavy);
    }
  }

  /// Handles the long press move update gesture.
  /// It animates the cursor based on the current position.
  void onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (widget.disable) {
      return;
    }
    animateCursor(details.localPosition);
  }

  /// Animates the cursor based on the current position.
  /// It activates and deactivates the quick interaction widgets based on the cursor position.
  void animateCursor(Offset offset) {
    if (checkIsValidPosition(offset)) {
      if (latestIndex != null) {
        controller?.currentState?.deActivateInteraction(latestIndex!);
        latestIndex = null;
      }
      return;
    }
    final index = getIndexFromCurrentOffset(offset);
    if (latestIndex == null) {
      latestIndex = index;
      Vibrate.feedback(FeedbackType.medium);
      controller?.currentState?.activateInteraction(index);
    } else {
      if (latestIndex != index) {
        controller?.currentState?.deActivateInteraction(latestIndex!);
        controller?.currentState?.activateInteraction(index);
        Vibrate.feedback(FeedbackType.medium);
        latestIndex = index;
      }
    }
  }

  /// Handles the long press cancel gesture.
  /// It hides the quick interaction widgets with animation.
  void onLongPressCancel() {
    if (widget.disable) {
      return;
    }
    hideAnimation();
  }

  /// Handles the long press end gesture.
  /// It hides the quick interaction widgets with animation and triggers the quick interaction completed callback.
  Future<void> onLongPressEnd(LongPressEndDetails details) async {
    if (widget.disable) {
      return;
    }
    hideAnimation();
    if (checkIsValidPosition(details.localPosition)) {
      Vibrate.feedback(FeedbackType.error);
      return;
    }
    final index = getIndexFromCurrentOffset(details.localPosition);
    if (widget.animate) {
      animateInteraction(index);
    }

    /// send request
    widget.onQuickInteractCompleted(index);
    Vibrate.feedback(FeedbackType.success);
  }

  /// Gets the index of the quick interaction widget from the current offset.
  int getIndexFromCurrentOffset(Offset offset) {
    final current = ((offset.dx /
            (widget.config.widgetSize + (widget.config.widgetPadding * 2)))
        .floor());
    return current > widget.quickInteractionWidgets.length - 1
        ? widget.quickInteractionWidgets.length - 1
        : current < 0
            ? 0
            : current;
  }

  /// Shows the quick interaction widgets.
  void show() {
    if (entry != null) {
      removeWithoutAnimation();
    }
    controller = GlobalKey<QuickInteractContainerBuilderState>();
    entry = OverlayEntry(
      opaque: false,
      builder: (BuildContext context) {
        return QuickInteractContainerBuilder(
          key: controller,
          globalPosition: _globalPosition!,
          quickInteractWidgets: widget.quickInteractionWidgets,
          config: widget.config,
          removeOverlay: () => removeWithoutAnimation(),
        );
      },
    );
    Overlay.of(context).insert(entry!);
  }

  /// Animates the interaction with the given index.
  animateInteraction(int index) {
    final child = widget.quickInteractionWidgets.elementAt(index);
    late OverlayEntry entry;
    entry = OverlayEntry(
      opaque: false,
      builder: (BuildContext context) {
        return AnimateInteractWidget(
          current: _globalPosition!,
          entry: entry,
          child: child,
        );
      },
    );
    Overlay.of(context).insert(entry);
  }

  /// Animates the interaction with the given widget.
  animateInteractionWidget(Widget child) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      opaque: false,
      builder: (BuildContext context) {
        return AnimateInteractWidget(
          current: _globalPosition!,
          entry: entry,
          child: child,
        );
      },
    );
    Overlay.of(context).insert(entry);
  }

  /// Hides the quick interaction widgets with animation.
  void hideAnimation() {
    if (controller != null) {
      controller!.currentState!.hideAnimation();
    }
  }

  /// Removes the quick interaction widgets without animation.
  void removeWithoutAnimation() {
    entry!.remove();
    entry = null;
    controller = null;
    latestIndex = null;
  }

  /// Handles the tap gesture.
  /// It shows the tooltip.
  void onTap() {
    if (widget.disable) {
      return;
    }
    showTooltip();
  }

  /// Checks if the given offset is a valid position for the quick interactions.
  bool checkIsValidPosition(Offset offset) {
    return offset.dy > 0 || offset.dy.abs() > 100;
  }

  /// Shows the tooltip with the given text.
  void showTooltip({String? text}) async {
    try {
      late OverlayEntry entry;
      entry = OverlayEntry(
        opaque: false,
        builder: (BuildContext context) {
          return Positioned(
            top: _globalPosition!.dy - 30,
            left: _globalPosition!.dx,
            child: Material(
              color: Colors.transparent,
              elevation: 0,
              child: widget.toolTip,
            ),
          );
        },
      );
      Overlay.of(context).insert(entry);
      await Future.delayed(const Duration(seconds: 3));
      entry.remove();
    } catch (e) {
      // print(e);
    }
  }
}
