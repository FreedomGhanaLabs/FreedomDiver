import 'package:flutter/material.dart';

enum ToastPosition {
  top,
  bottom,
  center,
}

enum ToastType {
  success,
  error,
  info,
  warning,
}

class CustomToast {
  factory CustomToast() => _instance;
  CustomToast._internal();
  static final CustomToast _instance = CustomToast._internal();

  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void show({
    required BuildContext context,
    required String message,
    ToastPosition position = ToastPosition.bottom,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 2),
    double width = 300,
    VoidCallback? onDismiss,
  }) {
    // Dismiss any existing toast first
    if (_isVisible) {
      dismiss();
    }

    // Create overlay entry
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => _ToastWidget(
        message: message,
        position: position,
        type: type,
        width: width,
        onDismiss: onDismiss,
      ),
    );

    // Show the toast
    _isVisible = true;
    Overlay.of(context).insert(_overlayEntry!);

    // Auto dismiss after duration
    Future.delayed(duration, () {
      dismiss();
    });
  }

  static void dismiss() {
    if (_isVisible && _overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isVisible = false;
    }
  }
}

class _ToastWidget extends StatefulWidget {

  const _ToastWidget({
    Key? key,
    required this.message,
    required this.position,
    required this.type,
    required this.width,
    this.onDismiss,
  }) : super(key: key);
  final String message;
  final ToastPosition position;
  final ToastType type;
  final double width;
  final VoidCallback? onDismiss;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Different slide animations based on position
    Offset beginOffset;
    switch (widget.position) {
      case ToastPosition.top:
        beginOffset = const Offset(0.0, -1.0);
        break;
      case ToastPosition.center:
        beginOffset = const Offset(0.0, 0.2);
        break;
      case ToastPosition.bottom:
      default:
        beginOffset = const Offset(0.0, 1.0);
        break;
    }

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  IconData _getIconForType() {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle_outline;
      case ToastType.error:
        return Icons.error_outline;
      case ToastType.warning:
        return Icons.warning_amber_outlined;
      case ToastType.info:
      default:
        return Icons.info_outline;
    }
  }

  Color _getColorForType() {
    switch (widget.type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.error:
        return Colors.red;
      case ToastType.warning:
        return Colors.orange;
      case ToastType.info:
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: _getAlignmentForPosition(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Material(
                elevation: 6.0,
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
                child: Container(
                  width: widget.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: _getColorForType().withOpacity(0.3),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _getColorForType().withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 64,
                        decoration: BoxDecoration(
                          color: _getColorForType(),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            bottomLeft: Radius.circular(12.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          _getIconForType(),
                          color: _getColorForType(),
                          size: 28,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            widget.message,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          _dismissToast();
                        },
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Alignment _getAlignmentForPosition() {
    switch (widget.position) {
      case ToastPosition.top:
        return Alignment.topCenter;
      case ToastPosition.center:
        return Alignment.center;
      case ToastPosition.bottom:
      default:
        return Alignment.bottomCenter;
    }
  }

  void _dismissToast() {
    _animationController.reverse().then((value) {
      if (widget.onDismiss != null) {
        widget.onDismiss!();
      }
      CustomToast.dismiss();
    });
  }
}

// Extension method for easier usage with BuildContext
extension ToastExtension on BuildContext {
  void showToast({
    required String message,
    ToastPosition position = ToastPosition.bottom,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 2),
    double width = 300,
    VoidCallback? onDismiss,
  }) {
    CustomToast.show(
      context: this,
      message: message,
      position: position,
      type: type,
      duration: duration,
      width: width,
      onDismiss: onDismiss,
    );
  }
}

// Usage example widget
class ToastExample extends StatelessWidget {
  const ToastExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Toast Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.showToast(
                  message: 'This is a success toast!',
                  type: ToastType.success,
                );
              },
              child: const Text('Show Success Toast'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.showToast(
                  message: 'This is an error toast!',
                  type: ToastType.error,
                );
              },
              child: const Text('Show Error Toast'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.showToast(
                  message: 'This is a warning toast!',
                  type: ToastType.warning,
                  position: ToastPosition.top,
                );
              },
              child: const Text('Show Warning Toast (Top)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.showToast(
                  message: 'This is an info toast with a longer message that may wrap to multiple lines.',
                  type: ToastType.info,
                  position: ToastPosition.center,
                  duration: const Duration(seconds: 4),
                );
              },
              child: const Text('Show Info Toast (Center)'),
            ),
          ],
        ),
      ),
    );
  }
}