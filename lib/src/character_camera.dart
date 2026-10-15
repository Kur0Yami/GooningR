import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

const characterCameraGestureKey = ValueKey('character-stage-gesture');
const characterCameraTransformKey = ValueKey('character-camera-transform');
const characterCameraOffsetKey = ValueKey('character-camera-offset');

/// Kamera karakter: zoom + geser (kini ke segala arah, bukan hanya atas-bawah).
/// Posisi disimpan sebagai pecahan ukuran area, lalu dilaporkan lewat
/// [onCameraChanged] agar bisa disimpan permanen (lihat AppController).
class CharacterCamera extends StatefulWidget {
  const CharacterCamera({
    super.key,
    required this.child,
    required this.onTap,
    this.onGazeChanged,
    this.onGazeEnd,
    this.onCameraChanged,
    this.minScale = 0.8,
    this.maxScale = 2.2,
    this.initialScale = 1.25,
    this.initialHorizontalOffsetFraction = 0.0,
    this.initialVerticalOffsetFraction = 0.2,
    this.keepSceneProportions = false,
  });

  final Widget child;
  final ValueChanged<Offset> onTap;
  final ValueChanged<Offset>? onGazeChanged;
  final VoidCallback? onGazeEnd;

  /// (zoom, geser-x sebagai pecahan lebar, geser-y sebagai pecahan tinggi).
  final void Function(double scale, double offsetX, double offsetY)?
  onCameraChanged;
  final double minScale;
  final double maxScale;
  final double initialScale;
  final double initialHorizontalOffsetFraction;
  final double initialVerticalOffsetFraction;
  final bool keepSceneProportions;

  @override
  State<CharacterCamera> createState() => _CharacterCameraState();
}

class _CharacterCameraState extends State<CharacterCamera>
    with WidgetsBindingObserver {
  static const double _minOffsetX = -1.0;
  static const double _maxOffsetX = 1.0;

  late double _scale;
  late double _offsetX;
  late double _offsetY;
  double _scaleAtGestureStart = 1;
  Size? _referenceSceneSize;
  bool _pinchDetected = false;
  bool _suppressTap = false;
  Timer? _tapSuppressionTimer;
  final Set<int> _pointers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _syncFromWidget();
  }

  void _syncFromWidget() {
    _scale = widget.initialScale.clamp(widget.minScale, widget.maxScale);
    _offsetX = widget.initialHorizontalOffsetFraction
        .clamp(_minOffsetX, _maxOffsetX)
        .toDouble();
    _offsetY = widget.initialVerticalOffsetFraction;
  }

  @override
  void didUpdateWidget(covariant CharacterCamera oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialScale != widget.initialScale ||
        oldWidget.initialHorizontalOffsetFraction !=
            widget.initialHorizontalOffsetFraction ||
        oldWidget.initialVerticalOffsetFraction !=
            widget.initialVerticalOffsetFraction) {
      _syncFromWidget();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tapSuppressionTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _pointers.clear();
      _pinchDetected = false;
      widget.onGazeEnd?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 0 && constraints.maxHeight > 0) {
          _referenceSceneSize ??= constraints.biggest;
        }
        final referenceSize = _referenceSceneSize ?? constraints.biggest;
        final translation = Offset(
          _offsetX * constraints.maxWidth,
          _offsetY * constraints.maxHeight,
        );
        return Semantics(
          button: true,
          label: '莱莎，点击触发互动',
          child: Listener(
            onPointerDown: (event) {
              _pointers.add(event.pointer);
              if (_pointers.length == 1) {
                widget.onGazeChanged?.call(
                  _unscalePosition(
                    event.localPosition,
                    constraints.biggest,
                    translation,
                  ),
                );
              } else {
                widget.onGazeEnd?.call();
              }
            },
            onPointerMove: (event) {
              if (_pointers.length == 1 && !_pinchDetected && !_suppressTap) {
                widget.onGazeChanged?.call(
                  _unscalePosition(
                    event.localPosition,
                    constraints.biggest,
                    translation,
                  ),
                );
              }
            },
            onPointerUp: (event) {
              _pointers.remove(event.pointer);
              widget.onGazeEnd?.call();
            },
            onPointerCancel: (event) {
              _pointers.remove(event.pointer);
              widget.onGazeEnd?.call();
            },
            child: GestureDetector(
              key: characterCameraGestureKey,
              behavior: HitTestBehavior.opaque,
              onTapUp: (details) {
                if (_pinchDetected || _suppressTap) return;
                widget.onTap(
                  _unscalePosition(
                    details.localPosition,
                    constraints.biggest,
                    translation,
                  ),
                );
              },
              onScaleStart: (details) {
                _scaleAtGestureStart = _scale;
                _pinchDetected = details.pointerCount > 1;
              },
              onScaleUpdate: (details) {
                if (details.pointerCount < 2) return;
                _pinchDetected = true;
                _suppressTap = true;
                final nextScale = (_scaleAtGestureStart * details.scale)
                    .clamp(widget.minScale, widget.maxScale)
                    .toDouble();
                final width = math.max(constraints.maxWidth, 1.0);
                final height = math.max(constraints.maxHeight, 1.0);
                final nextOffsetX =
                    (_offsetX + details.focalPointDelta.dx / width)
                        .clamp(_minOffsetX, _maxOffsetX)
                        .toDouble();
                final maxDown = 0.55, maxUp = 0.35;
                final nextOffsetY =
                    (_offsetY + details.focalPointDelta.dy / height)
                        .clamp(-maxUp, maxDown)
                        .toDouble();
                if ((nextScale - _scale).abs() < 0.001 &&
                    (nextOffsetX - _offsetX).abs() < 0.0005 &&
                    (nextOffsetY - _offsetY).abs() < 0.0005) {
                  return;
                }
                setState(() {
                  _scale = nextScale;
                  _offsetX = nextOffsetX;
                  _offsetY = nextOffsetY;
                });
              },
              onScaleEnd: (_) {
                if (_pinchDetected) {
                  _tapSuppressionTimer?.cancel();
                  _tapSuppressionTimer = Timer(
                    const Duration(milliseconds: 280),
                    () => _suppressTap = false,
                  );
                  widget.onCameraChanged?.call(_scale, _offsetX, _offsetY);
                }
                _pinchDetected = false;
              },
              child: Transform.translate(
                key: characterCameraOffsetKey,
                offset: translation,
                child: Transform.scale(
                  key: characterCameraTransformKey,
                  scale: _scale,
                  alignment: Alignment.bottomCenter,
                  child: widget.keepSceneProportions
                      ? SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            alignment: Alignment.bottomCenter,
                            child: SizedBox.fromSize(
                              size: referenceSize,
                              child: widget.child,
                            ),
                          ),
                        )
                      : widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Offset _unscalePosition(
    Offset position,
    Size stageSize,
    Offset translation,
  ) {
    final translated = position - translation;
    final origin = Offset(stageSize.width / 2, stageSize.height);
    final cameraPosition = origin + (translated - origin) / _scale;
    final reference = _referenceSceneSize;
    if (!widget.keepSceneProportions || reference == null) {
      return cameraPosition;
    }
    final fitScale = math.min(
      stageSize.width / reference.width,
      stageSize.height / reference.height,
    );
    if (fitScale <= 0) return cameraPosition;
    final sceneOrigin = Offset(
      (stageSize.width - reference.width * fitScale) / 2,
      stageSize.height - reference.height * fitScale,
    );
    return (cameraPosition - sceneOrigin) / fitScale;
  }
}
