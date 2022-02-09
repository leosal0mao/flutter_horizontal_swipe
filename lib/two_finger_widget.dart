import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TwoFingerPointerWidget extends StatelessWidget {
  final Widget? child;
  final OnUpdate? onUpdate;

  const TwoFingerPointerWidget({Key? key, this.child, this.onUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        CustomHorizontalMultiDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<CustomHorizontalMultiDragGestureRecognizer>(
          () => CustomHorizontalMultiDragGestureRecognizer(),
          (CustomHorizontalMultiDragGestureRecognizer instance) {
            instance.onStart = (Offset position) {
              return CustomDrag(events: instance.events, onUpdate: onUpdate!);
            };
          },
        ),
      },
      child: child,
    );
  }
}

typedef OnUpdate(DragUpdateDetails details);

class CustomDrag extends Drag {
  final List<PointerDownEvent>? events;

  final OnUpdate? onUpdate;

  CustomDrag({this.events, this.onUpdate});

  @override
  void update(DragUpdateDetails details) {
    super.update(details);
    final delta = details.delta;
    if (delta.dy.abs() > 0 && events!.length == 2) {
      onUpdate?.call(DragUpdateDetails(
        sourceTimeStamp: details.sourceTimeStamp,
        delta: Offset(0, delta.dy),
        primaryDelta: details.primaryDelta,
        globalPosition: details.globalPosition,
        localPosition: details.localPosition,
      ));
    }
  }

  @override
  void end(DragEndDetails details) {
    super.end(details);
  }
}

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
