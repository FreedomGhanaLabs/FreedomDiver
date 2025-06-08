import 'package:flutter/material.dart';
import 'package:freedomdriver/shared/app_config.dart';
import 'package:freedomdriver/shared/theme/app_colors.dart';
import 'package:freedomdriver/utilities/ui.dart';

enum ToastPosition { top, bottom, center }

enum ToastType { success, error, info, warning }

class CustomToast {
  factory CustomToast() => _instance;
  CustomToast._internal();
  static final CustomToast _instance = CustomToast._internal();

  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void show({
    required BuildContext context,
    required String message,
    required String title,
    ToastPosition position = ToastPosition.bottom,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 2),
    double width = 300,
    VoidCallback? onDismiss,
  }) {
    if (_isVisible) {
      dismiss();
    }

    _overlayEntry = OverlayEntry(
      builder:
          (BuildContext context) => _ToastWidget(
            title: title,
            message: message,
            position: position,
            type: type,
            width: width,
            onDismiss: onDismiss,
          ),
    );

    _isVisible = true;
    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(duration, dismiss);
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
    required this.message,
    required this.title,
    required this.position,
    required this.type,
    required this.width,
    this.onDismiss,
  });
  final String title;
  final String message;
  final ToastPosition position;
  final ToastType type;
  final double width;
  final VoidCallback? onDismiss;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with TickerProviderStateMixin {
  late AnimationController _toastController;
  late AnimationController _iconController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _iconScale;
  late Animation<double> _iconFade;

  @override
  void initState() {
    super.initState();
    _toastController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 350),
    );

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    Offset beginOffset;
    switch (widget.position) {
      case ToastPosition.top:
        beginOffset = const Offset(0, -1);
        break;
      case ToastPosition.center:
        beginOffset = const Offset(0, 0.2);
        break;
      case ToastPosition.bottom:
        beginOffset = const Offset(0, 1);
        break;
    }

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _toastController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _toastController, curve: Curves.easeIn));

    _iconScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );
    _iconFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _iconController, curve: Curves.easeIn));

    _toastController.forward();
    _iconController.forward();
  }

  @override
  void dispose() {
    _toastController.dispose();
    _iconController.dispose();
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
        return Icons.info_outline;
    }
  }

  Color _getColorForType() {
    switch (widget.type) {
      case ToastType.success:
        return greenColor;
      case ToastType.error:
        return redColor;
      case ToastType.warning:
        return gradient1;
      case ToastType.info:
        return Colors.blue;
    }
  }

  Alignment _getAlignmentForPosition() {
    switch (widget.position) {
      case ToastPosition.top:
        return Alignment.topCenter;
      case ToastPosition.center:
        return Alignment.center;
      case ToastPosition.bottom:
        return Alignment.bottomCenter;
    }
  }

  void _dismissToast() {
    _iconController.reverse();
    _toastController.reverse().then((value) {
      if (widget.onDismiss != null) {
        widget.onDismiss!();
      }
      CustomToast.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: _getAlignmentForPosition(),
        child: Padding(
          padding: const EdgeInsets.all(smallWhiteSpace),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Dismissible(
                key: const ValueKey('custom_toast'),
                onDismissed: (direction) => _dismissToast(),
                direction: DismissDirection.up,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(roundedMd),
                  color: Colors.white,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 120,
                      maxWidth: 350,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(roundedMd),
                      border: Border.all(
                        color: _getColorForType().withValues(alpha: 0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getColorForType().withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxHeight: 100),
                          width: 6,
                          height: 50,
                          margin: const EdgeInsets.all(extraSmallWhiteSpace),
                          decoration: BoxDecoration(
                            color: _getColorForType(),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(roundedFull),
                            ),
                          ),
                        ),
                        ScaleTransition(
                          scale: _iconScale,
                          child: FadeTransition(
                            opacity: _iconFade,
                            child: Icon(
                              _getIconForType(),
                              color: _getColorForType(),
                              size: 24,
                            ),
                          ),
                        ),
                        HSpace(extraSmallWhiteSpace),
                        Expanded(
                          child: Text(
                            widget.message,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: paragraphText),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: _dismissToast,
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
      ),
    );
  }
}

// Extension method for easier usage with BuildContext
extension ToastExtension on BuildContext {
  void showToast({
    required String message,
    required String title,
    ToastPosition position = ToastPosition.bottom,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 2),
    double width = 300,
    VoidCallback? onDismiss,
  }) {
    CustomToast.show(
      context: this,
      title: title,
      message: message,
      position: position,
      type: type,
      duration: duration,
      width: width,
      onDismiss: onDismiss,
    );
  }

  void dismissToast() {
    CustomToast.dismiss();
  }
}

// Usage example widget
class ToastExample extends StatelessWidget {
  const ToastExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Toast Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.showToast(
                  title: "Toast Title",
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
                  title: "Error Toast",
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
                  title: "Warning Toast",
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
                  title: "Info Toast",
                  message:
                      'This is an info toast with a longer message that may wrap to multiple lines.',
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
