part of quick_interact;

/// [QuickInteractConfig] is a configuration model for QuickInteractBuilder and QuickInteract classes.
/// Attributes:
/// - [widgetSize]: Size of the quick interaction widgets container.
/// - [widgetPadding]: Padding between quick interaction widgets.
/// - [transitionAnimationEndOffset]: Offset animations end value.
/// - [scaleAnimationEndScale]: Scale animations end value.
/// - [containerColor]: Color of the quick interaction container.
/// - [containerHeight]: Height of the quick interaction container.
/// - [containerAnimationDuration]: Duration of the container animation.
/// - [cursorAnimationDuration]: Duration of the cursor animation.
/// - [containerAnimationCurve]: Curve of the container animation.
/// - [widgetAnimationCurve]: Curve of the widget animation.
class QuickInteractConfig {
  /// Size of the quick interaction widgets container.
  final double widgetSize;

  /// Padding between quick interaction widgets.
  final double widgetPadding;

  /// Offset animations end value.
  final Offset transitionAnimationEndOffset;

  /// Scale animations end value.
  final double scaleAnimationEndScale;

  /// Duration of the cursor animation.
  final Duration cursorAnimationDuration;

  /// Color of the quick interaction container.
  final Color? containerColor;

  /// Height of the quick interaction container.
  final double containerHeight;

  /// Border radius of the quick interaction container.
  final BorderRadius containerBorderRadius;

  /// Duration of the container animation.
  final Duration containerAnimationDuration;

  /// Curve of the container animation.
  final Curve containerAnimationCurve;

  /// Curve of the widget animation.
  final Curve widgetAnimationCurve;

  /// Elevation of the quick interaction container.
  final double elevation;

  /// Creates a new instance of [QuickInteractConfig].
  /// The default elevation is set to 5.
  const QuickInteractConfig({
    this.widgetSize = 35,
    this.widgetPadding = 4,
    this.cursorAnimationDuration = const Duration(milliseconds: 300),
    this.containerColor,
    this.containerHeight = 40,
    this.containerBorderRadius = const BorderRadius.all(
      Radius.circular(30),
    ),
    this.containerAnimationDuration = const Duration(milliseconds: 300),
    this.containerAnimationCurve = Curves.linearToEaseOut,
    this.widgetAnimationCurve = Curves.linearToEaseOut,
    this.transitionAnimationEndOffset = const Offset(0, -1),
    this.scaleAnimationEndScale = 1.5,
    this.elevation = 5,
  }) : assert(widgetSize <= containerHeight,
            'Widget size cannot be less than container height');

  /// Creates a new instance of [QuickInteractConfig] with only transition offset -2.
  /// The default elevation is set to 5.
  const QuickInteractConfig.onlyTransition({
    this.widgetSize = 50,
    this.widgetPadding = 2,
    this.cursorAnimationDuration = const Duration(milliseconds: 300),
    this.containerColor,
    this.containerHeight = 50,
    this.containerBorderRadius = const BorderRadius.all(
      Radius.circular(30),
    ),
    this.containerAnimationDuration = const Duration(milliseconds: 300),
    this.containerAnimationCurve = Curves.linearToEaseOut,
    this.widgetAnimationCurve = Curves.linearToEaseOut,
    this.transitionAnimationEndOffset = const Offset(0, -1),
    this.scaleAnimationEndScale = 1,
    this.elevation = 5,
  }) : assert(widgetSize <= containerHeight,
            'Widget size cannot be less than container height');

  /// Creates a new instance of [QuickInteractConfig] with only scale 2.
  /// The default elevation is set to 5.
  const QuickInteractConfig.onlyScale({
    this.widgetSize = 35,
    this.widgetPadding = 5,
    this.cursorAnimationDuration = const Duration(milliseconds: 300),
    this.containerColor,
    this.containerHeight = 40,
    this.containerBorderRadius = const BorderRadius.all(
      Radius.circular(30),
    ),
    this.containerAnimationDuration = const Duration(milliseconds: 300),
    this.containerAnimationCurve = Curves.linearToEaseOut,
    this.widgetAnimationCurve = Curves.linearToEaseOut,
    this.transitionAnimationEndOffset = const Offset(0, 0),
    this.scaleAnimationEndScale = 2,
    this.elevation = 5,
  }) : assert(widgetSize <= containerHeight,
            'Widget size cannot be less than container height');
}
