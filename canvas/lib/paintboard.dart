import 'package:flutter/material.dart';

import 'touch_points.dart';

class PaintBoard extends CustomPainter with PaintFeatures {
  List<TouchPoint?> _points = [];
  List<TouchPoint?> _undoPoints = [];
  Color _brushColor = Colors.black;
  double _strokeWidth = 5.0;
  final double _maxStrokeWidth = 50.0;

  // PaintBoard({List<TouchPoint?> points = const []}) {
  //   _points = points;
  // }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < _points.length - 1; i++) {
      TouchPoint? startPoint = _points[i];
      TouchPoint? endPoint = _points[i + 1];
      if (startPoint != null && endPoint != null) {
        paint.color = startPoint.color;
        paint.strokeWidth = startPoint.strokeWidth;
        canvas.drawLine(startPoint.point, endPoint.point, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PaintBoard oldDelegate) =>
      oldDelegate._points != _points;

  @override
  void clear() {
    _points = [];
    _undoPoints = [];
  }

  @override
  void updatePoints(List<TouchPoint?> points) {
    _points = points;
  }

  @override
  void addPoint(TouchPoint? point) {
    _points.add(point);
  }

  @override
  void initPoints(List<TouchPoint?> initPoints) {
    updatePoints(initPoints);
  }

  @override
  void setBrushColor(Color color) {
    _brushColor = color;
  }

  @override
  Color getBrushColor() {
    return _brushColor;
  }

  @override
  void setStrokeWidth(double strokeWidth) {
    _strokeWidth = strokeWidth;
  }

  @override
  double getStrokeWidth() {
    return _strokeWidth;
  }

  @override
  double getMaxStrokeWidth() {
    return _maxStrokeWidth;
  }

  @override
  bool hasPoints() {
    return _points.isNotEmpty;
  }

  @override
  void undo() {
    if (!hasPoints()) return;
    _points.removeLast(); // removes the last null touchpoint
    for (int i = _points.length - 1; i >= 0; i--) {
      if (_points[i] == null) {
        break;
      } else {
        _undoPoints.add(_points[i]);
        _points.removeAt(i);
      }
    }
    _undoPoints.add(null);
  }

  @override
  void redo() {
    if (!hasUndoPoints()) return;
    _undoPoints.removeLast();
    for (int i = _undoPoints.length - 1; i >= 0; i--) {
      if (_undoPoints[i] == null) {
        break;
      } else {
        // tempPoints.add(_undoPoints[i]);
        _points.add(_undoPoints[i]);
        _undoPoints.removeAt(i);
      }
    }
    _points.add(null);
  }

  @override
  List<TouchPoint?> getPoints() {
    return _points;
  }

  @override
  bool hasAnyPoints() {
    return hasPoints() || hasUndoPoints();
  }

  @override
  bool hasUndoPoints() {
    return _undoPoints.isNotEmpty;
  }
}

mixin PaintFeatures {
  void clear();
  void initPoints(List<TouchPoint?> initPoints);
  void updatePoints(List<TouchPoint?> points);
  void addPoint(TouchPoint? point);
  void setBrushColor(Color color);
  void setStrokeWidth(double strokeWidth);
  void undo();
  void redo();
  bool hasPoints();
  bool hasUndoPoints();
  bool hasAnyPoints();
  Color getBrushColor();
  List<TouchPoint?> getPoints();
  double getStrokeWidth();
  double getMaxStrokeWidth();
}
