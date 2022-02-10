import 'package:flutter/gestures.dart';

typedef OnUpdate(DragUpdateDetails details);

class CustomDrag extends Drag {
  final List<PointerDownEvent>? events;

  final OnUpdate? onUpdate;

  CustomDrag({this.events, this.onUpdate});

  @override
  void update(DragUpdateDetails details) {
    super.update(details);
    final delta = details.delta;

    if (delta.dy.abs() == 0 && delta.dx > 0 && events!.length == 2) {
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
