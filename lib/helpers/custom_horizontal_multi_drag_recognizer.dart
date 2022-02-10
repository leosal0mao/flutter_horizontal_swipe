import 'package:flutter/gestures.dart';

class CustomHorizontalMultiDragGestureRecognizer extends MultiDragGestureRecognizer {
  final List<PointerDownEvent> events = [];

  CustomHorizontalMultiDragGestureRecognizer({Object? debugOwner}) : super(debugOwner: debugOwner);

  @override
  createNewPointerState(PointerDownEvent event) {
    events.add(event);
    return _CustomHorizontalPointerState(event.position, event.kind, onDisposeState: () {
      events.remove(event);
    });
  }

  @override
  String get debugDescription => 'custom horizontal multidrag';
}

typedef OnDisposeState();

class _CustomHorizontalPointerState extends MultiDragPointerState {
  final OnDisposeState? onDisposeState;

  _CustomHorizontalPointerState(Offset initialPosition, PointerDeviceKind kind, {DeviceGestureSettings? gestureSettings, this.onDisposeState})
      : super(initialPosition, kind, gestureSettings);

  @override
  void checkForResolutionAfterMove() {
    if (pendingDelta!.dx.abs() > kTouchSlop) {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  void accepted(GestureMultiDragStartCallback starter) {
    starter(initialPosition);
  }

  @override
  void dispose() {
    onDisposeState?.call();
    super.dispose();
  }
}
