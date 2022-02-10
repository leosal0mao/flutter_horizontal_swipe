import 'package:flutter/material.dart';

import '../helpers/custom_drag.dart';
import '../helpers/custom_horizontal_multi_drag_recognizer.dart';

class TwoFingerSwipeWidget extends StatelessWidget {
  final Widget? child;
  final OnUpdate? onUpdate;

  const TwoFingerSwipeWidget({Key? key, this.child, this.onUpdate}) : super(key: key);

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
