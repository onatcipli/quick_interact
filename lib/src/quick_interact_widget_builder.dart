part of quick_interact;

/// [QuickInteractWidgetBuilder] is a widget builder for QuickInteractContainerBuilder.
/// It uses animations to create a slide and scale transition for the quick interaction widgets.
///
/// Attributes:
/// - `child`: The widget to be animated.
/// - `offsetAnimation`: The animation that controls the position of the widget.
/// - `scaleAnimation`: The animation that controls the scale of the widget.
/// - `config`: Configuration model for QuickInteractWidgetBuilder.
class QuickInteractWidgetBuilder extends StatelessWidget {
  /// Creates a [QuickInteractWidgetBuilder].
  ///
  /// The [child], [offsetAnimation], [scaleAnimation], and [config] arguments must not be null.
  const QuickInteractWidgetBuilder({
    Key? key,
    required this.child,
    required this.offsetAnimation,
    required this.scaleAnimation,
    required this.config,
  }) : super(key: key);

  /// The widget to be animated.
  final Widget child;

  /// The animation that controls the position of the widget.
  final Animation<Offset> offsetAnimation;

  /// The animation that controls the scale of the widget.
  final Animation<double> scaleAnimation;

  /// Configuration model for QuickInteractWidgetBuilder.
  final QuickInteractConfig config;

  /// Builds the widget tree.
  ///
  /// Returns a [Padding] widget that contains a [SlideTransition] widget,
  /// which in turn contains a [ScaleTransition] widget. The [ScaleTransition]
  /// widget contains a [SizedBox] that has the [child] widget.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(config.widgetPadding),
      child: SlideTransition(
        position: offsetAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: SizedBox(
            height: config.widgetSize,
            width: config.widgetSize,
            child: child,
          ),
        ),
      ),
    );
  }
}
