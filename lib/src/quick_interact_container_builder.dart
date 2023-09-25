part of quick_interact;

/// [QuickInteractContainerBuilder] is a widget that builds a container for quick interactions.
/// Attributes:
/// - [quickInteractWidgets]: List of widgets for quick interactions.
/// - [globalPosition]: Global position of the container.
/// - [removeOverlay]: Callback for removing overlay.
/// - [config]: Configuration model for QuickInteractContainerBuilder.
class QuickInteractContainerBuilder extends StatefulWidget {
  const QuickInteractContainerBuilder({
    Key? key,
    required this.globalPosition,
    required this.removeOverlay,
    required this.quickInteractWidgets,
    required this.config,
  }) : super(key: key);

  /// List of widgets for quick interactions.
  final List<Widget> quickInteractWidgets;

  /// Global position of the container.
  final Offset globalPosition;

  /// Callback for removing overlay.
  final VoidCallback removeOverlay;

  /// Configuration model for QuickInteractContainerBuilder.
  final QuickInteractConfig config;

  @override
  State<QuickInteractContainerBuilder> createState() =>
      QuickInteractContainerBuilderState();
}

/// [QuickInteractContainerBuilderState] is the state class for QuickInteractContainerBuilder.
/// It handles the animations and interactions of the quick interact widgets.
class QuickInteractContainerBuilderState
    extends State<QuickInteractContainerBuilder> with TickerProviderStateMixin {
  /// Height of the container.
  double height = 0;

  /// List of offset animations for each quick interact widget.
  List<Animation<Offset>> offsetFactors = [];

  /// List of scale animations for each quick interact widget.
  List<Animation<double>> scaleFactors = [];

  /// List of animation controllers for offset animations.
  List<AnimationController> offsetAnimationControllers = [];

  /// List of animation controllers for scale animations.
  List<AnimationController> scaleAnimationControllers = [];

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    height = widget.config.containerHeight;
    initAnimations();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showAnimation();
    });
  }

  /// Initializes the animations for the quick interact widgets.
  void initAnimations() {
    initOffsetAnimation();
    initScaleAnimation();
  }

  /// Initializes the offset animations for the quick interact widgets.
  void initOffsetAnimation() {
    offsetFactors = List.generate(
      widget.quickInteractWidgets.length,
      (index) {
        AnimationController animationController = AnimationController(
          vsync: this,
          duration: widget.config.cursorAnimationDuration,
        );
        offsetAnimationControllers.add(animationController);
        return Tween<Offset>(
          begin: Offset.zero,
          end: widget.config.transitionAnimationEndOffset,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: widget.config.widgetAnimationCurve,
          ),
        );
      },
    );
  }

  /// Initializes the scale animations for the quick interact widgets.
  void initScaleAnimation() {
    scaleFactors = List.generate(
      widget.quickInteractWidgets.length,
      (index) {
        AnimationController animationController = AnimationController(
          vsync: this,
          duration: widget.config.cursorAnimationDuration,
        );
        scaleAnimationControllers.add(animationController);
        return Tween<double>(
          begin: 1,
          end: widget.config.scaleAnimationEndScale,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: widget.config.widgetAnimationCurve,
          ),
        );
      },
    );
  }

  /// Shows the QuickReactionContainer.
  showAnimation() {
    setState(() {
      height = widget.config.containerHeight;
    });
  }

  /// Hides the QuickReactionContainer.
  hideAnimation() async {
    setState(() {
      height = 0;
    });
    await Future.delayed(widget.config.containerAnimationDuration);
    widget.removeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: widget.config.containerAnimationDuration,
      curve: widget.config.containerAnimationCurve,
      left: widget.globalPosition.dx,
      top: widget.globalPosition.dy - height,
      child: AnimatedOpacity(
        curve: widget.config.containerAnimationCurve,
        duration: widget.config.containerAnimationDuration,
        opacity: height == 0 ? 0 : 1,
        child: Material(
          borderRadius: widget.config.containerBorderRadius,
          color: Colors.transparent,
          elevation: widget.config.elevation,
          child: AnimatedContainer(
            curve: widget.config.containerAnimationCurve,
            duration: widget.config.containerAnimationDuration,
            decoration: BoxDecoration(
              color: widget.config.containerColor ??
                  Theme.of(context).primaryColor,
              borderRadius: widget.config.containerBorderRadius,
            ),
            height: height,
            child: Row(
              children: [
                for (int i = 0; i < widget.quickInteractWidgets.length; i++)
                  QuickInteractWidgetBuilder(
                    offsetAnimation: offsetFactors.elementAt(i),
                    scaleAnimation: scaleFactors.elementAt(i),
                    config: widget.config,
                    child: widget.quickInteractWidgets[i],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Activates the interaction of the quick interact widget at the given index.
  void activateInteraction(int i) {
    offsetAnimationControllers[i].forward();
    scaleAnimationControllers[i].forward();
  }

  /// Deactivates the interaction of the quick interact widget at the given index.
  void deActivateInteraction(int i) {
    offsetAnimationControllers[i].reverse();
    scaleAnimationControllers[i].reverse();
  }
}
