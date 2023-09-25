part of quick_interact;

/// [AnimateInteractWidget] is a widget that animates the interaction of a child widget.
/// It uses the [OverlayEntry] to display the child widget and animate it.
///
/// Attributes:
/// - [child]: The widget to animate.
/// - [current]: The current offset of the widget.
/// - [entry]: The overlay entry used to display the widget.
class AnimateInteractWidget extends StatefulWidget {
  const AnimateInteractWidget({
    Key? key,
    required this.child,
    required this.current,
    required this.entry,
  }) : super(key: key);

  final Widget child;
  final Offset current;
  final OverlayEntry entry;

  @override
  State<AnimateInteractWidget> createState() => _AnimateInteractWidgetState();
}

/// [_AnimateInteractWidgetState] is the state of [AnimateInteractWidget].
/// It handles the animation of the widget.
class _AnimateInteractWidgetState extends State<AnimateInteractWidget>
    with TickerProviderStateMixin {
  late Animation<double> dxAnimation;
  late Animation<double> opacityAnimation;
  late Animation<double> dyAnimation;
  late AnimationController dxAnimationController;
  late AnimationController dyAnimationController;

  final duration = const Duration(milliseconds: 3000);

  num swingAnimation = 25;

  @override
  void initState() {
    super.initState();
    dxAnimationController = AnimationController(
      vsync: this,
      duration: duration ~/ 4,
    );
    dyAnimationController = AnimationController(
      vsync: this,
      duration: duration,
    );
    dxAnimation = Tween<double>(
      begin: widget.current.dx,
      end: widget.current.dx + swingAnimation,
    ).animate(
      CurvedAnimation(
        parent: dxAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    dyAnimation = Tween<double>(
      begin: widget.current.dy,
      end: widget.current.dy - 800,
    ).animate(
      CurvedAnimation(
        parent: dyAnimationController,
        curve: Curves.linear,
      ),
    );
    opacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: dyAnimationController,
        curve: Curves.linear,
      ),
    );

    dyAnimationController.forward();
    dxAnimationController.repeat(
      reverse: true,
    );
    dxAnimationController.addListener(() {
      setState(() {});
    });
    dyAnimationController.addListener(() {
      setState(() {});
    });
    Future.delayed(duration).then((value) {
      widget.entry.remove();
      dxAnimationController.stop();
      dyAnimationController.stop();
    });
  }

  @override
  void dispose() {
    super.dispose();
    dxAnimationController.dispose();
    dyAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: dyAnimation.value,
      left: dxAnimation.value,
      child: Opacity(
        opacity: opacityAnimation.value,
        child: widget.child,
      ),
    );
  }
}
