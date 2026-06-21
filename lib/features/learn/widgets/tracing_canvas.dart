import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TracingCanvas extends StatefulWidget {
  final VoidCallback? onStrokeChanged;

  const TracingCanvas({super.key, this.onStrokeChanged});

  @override
  State<TracingCanvas> createState() => TracingCanvasState();
}

class TracingCanvasState extends State<TracingCanvas> {
  final List<List<Offset>> _strokes = [];

  bool get hasStrokes => _strokes.isNotEmpty;

  void clear() {
    setState(() => _strokes.clear());
    widget.onStrokeChanged?.call();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() => _strokes.add([details.localPosition]));
    widget.onStrokeChanged?.call();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() => _strokes.last.add(details.localPosition));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      child: CustomPaint(
        painter: _TracingPainter(strokes: _strokes),
        size: Size.infinite,
      ),
    );
  }
}

class _TracingPainter extends CustomPainter {
  final List<List<Offset>> strokes;

  _TracingPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryDark
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      for (var i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TracingPainter oldDelegate) => true;
}
