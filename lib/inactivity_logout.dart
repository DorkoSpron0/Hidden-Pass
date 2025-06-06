import 'dart:async';
import 'package:flutter/material.dart';

class InactivityLogout extends StatefulWidget {
  final Widget child;
  final Duration timeoutDuration;
  final VoidCallback onTimeout;

  const InactivityLogout({
    required this.child,
    required this.onTimeout,
    this.timeoutDuration = const Duration(minutes: 15),
    super.key,
  });

  @override
  State<InactivityLogout> createState() => _InactivityLogoutState();
}

class _InactivityLogoutState extends State<InactivityLogout> with WidgetsBindingObserver {
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _resetTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(widget.timeoutDuration, widget.onTimeout);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resetTimer();
    }
  }

  void _handleUserInteraction([_]) {
    _resetTimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      onScaleStart: (_) => _handleUserInteraction(),
      child: widget.child,
    );
  }
}
