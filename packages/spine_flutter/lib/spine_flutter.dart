// spine_flutter.dart
// STUB / DUMMY package for CI builds only -- NOT the real Spine runtime.
//
// Every class, constructor, static factory and member used by the onion
// codebase is declared here with the same signature, so `flutter build apk`
// compiles on GitHub Actions. Nothing is rendered or animated by this stub.
// Character art and animation only appear with the real spine_flutter runtime.

library spine_flutter;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show AssetBundle, rootBundle;

Future<void> initSpineFlutter({bool enableMemoryDebugging = false}) async {}

enum Physics { none, reset, update, pose }

enum MixBlend { setup, first, replace, add }

enum EventType { start, interrupt, end, complete, dispose, event }

class Bounds {
  const Bounds(this.x, this.y, this.width, this.height);
  final double x;
  final double y;
  final double width;
  final double height;
}

abstract class BoundsProvider {
  const BoundsProvider();
  Bounds computeBounds(SkeletonDrawable drawable);
}

class Attachment {
  const Attachment();
}

class RegionAttachment extends Attachment {
  const RegionAttachment();
  List<double> computeWorldVertices(Slot slot) => const <double>[];
}

class VertexAttachment extends Attachment {
  const VertexAttachment();
  List<double> computeWorldVertices(Slot slot) => const <double>[];
}

class BoundingBoxAttachment extends VertexAttachment {
  const BoundingBoxAttachment();
}

class Slot {
  const Slot();
  Attachment? getAttachment() => null;
}

class BoneData {
  const BoneData();
  String getName() => '';
}

class Bone {
  const Bone();
  BoneData getData() => const BoneData();
  Bone? getParent() => null;
  double getX() => 0;
  void setX(double value) {}
  double getY() => 0;
  void setY(double value) {}
  double getWorldX() => 0;
  double getWorldY() => 0;
  double getRotation() => 0;
  void setRotation(double value) {}
  void setScaleY(double value) {}
}

class Skeleton {
  Skeleton();
  Bone? findBone(String name) => null;
  Slot? findSlot(String name) => null;
  List<Slot> getSlots() => const <Slot>[];
  void updateWorldTransform(Physics physics) {}
  Bounds getBounds() => const Bounds(0, 0, 0, 0);
}

class Animation {
  const Animation();
  String getName() => '';
  double getDuration() => 0;
}

class AnimationStateData {
  AnimationStateData();
  void setDefaultMix(double value) {}
  void setMixDuration(String from, String to, double duration) {}
}

class SkeletonData {
  SkeletonData();

  static Future<SkeletonData> fromAsset(
    Atlas atlas,
    String skeletonFile, {
    AssetBundle? bundle,
  }) async =>
      SkeletonData();

  Animation? findAnimation(String name) => null;
  List<Animation> getAnimations() => const <Animation>[];
  void dispose() {}
}

class Atlas {
  Atlas();

  static Future<Atlas> fromAsset(
    String atlasFile, {
    AssetBundle? bundle,
  }) async =>
      Atlas();

  void dispose() {}
}

class TrackEntry {
  TrackEntry();
  Animation getAnimation() => const Animation();
  bool getLoop() => true;
  double getTrackTime() => 0;
  void setTrackTime(double value) {}
  TrackEntry setDelay(double value) => this;
  TrackEntry setMixDuration(double value) => this;
  TrackEntry setAlpha(double value) => this;
  TrackEntry setTimeScale(double value) => this;
  TrackEntry setMixBlend(MixBlend value) => this;
}

class AnimationState {
  AnimationState();
  final AnimationStateData _data = AnimationStateData();
  AnimationStateData getData() => _data;
  TrackEntry? getCurrent(int trackIndex) => null;
  TrackEntry setAnimationByName(int trackIndex, String name, bool loop) =>
      TrackEntry();
  TrackEntry addAnimationByName(
    int trackIndex,
    String name,
    bool loop,
    double delay,
  ) =>
      TrackEntry();
  TrackEntry setEmptyAnimation(int trackIndex, double mixDuration) =>
      TrackEntry();
  TrackEntry addEmptyAnimation(
    int trackIndex,
    double mixDuration,
    double delay,
  ) =>
      TrackEntry();
  void clearTrack(int trackIndex) {}
}

class SkeletonDrawable {
  SkeletonDrawable(Atlas atlas, SkeletonData data, bool premultipliedAlpha)
    : skeleton = Skeleton();

  final Skeleton skeleton;
  void dispose() {}
}

class SpineWidgetController {
  SpineWidgetController({
    double targetFramesPerSecond = 60,
    this.onInitialized,
    this.onBeforeUpdateWorldTransforms,
    this.onAfterUpdateWorldTransforms,
    this.onAfterApplyAnimation,
    this.onBeforePaint,
    this.onAfterPaint,
    this.maxDeltaTime = 0.05,
    this.paintOverflow = EdgeInsets.zero,
  }) : _targetFramesPerSecond = targetFramesPerSecond;

  final void Function(SpineWidgetController controller)? onInitialized;
  final void Function(SpineWidgetController controller)?
  onBeforeUpdateWorldTransforms;
  final void Function(SpineWidgetController controller)?
  onAfterUpdateWorldTransforms;
  final void Function(SpineWidgetController controller)? onAfterApplyAnimation;
  final void Function(SpineWidgetController controller, Canvas canvas)?
  onBeforePaint;
  final void Function(SpineWidgetController controller, Canvas canvas)?
  onAfterPaint;
  final double maxDeltaTime;
  final EdgeInsets paintOverflow;

  double _targetFramesPerSecond;
  double get targetFramesPerSecond => _targetFramesPerSecond;
  set targetFramesPerSecond(double value) => _targetFramesPerSecond = value;

  double get updateDelta =>
      _targetFramesPerSecond > 0 ? 1 / _targetFramesPerSecond : 0;

  final Skeleton skeleton = Skeleton();
  final SkeletonData skeletonData = SkeletonData();
  final AnimationState animationState = AnimationState();

  bool get isPlaying => false;
  void pause() {}
  void resume() {}
  Offset toSkeletonCoordinates(Offset screenPosition) => screenPosition;
  void dispose() {}
}

class SpineWidget extends StatelessWidget {
  const SpineWidget._({
    super.key,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  final BoxFit fit;
  final Alignment alignment;

  static SpineWidget fromAsset(
    String atlasFile,
    String skeletonFile,
    SpineWidgetController controller, {
    Key? key,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    AssetBundle? bundle,
    BoundsProvider? boundsProvider,
  }) =>
      SpineWidget._(key: key, fit: fit, alignment: alignment);

  static SpineWidget fromDrawable(
    SkeletonDrawable drawable,
    SpineWidgetController controller, {
    Key? key,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    BoundsProvider? boundsProvider,
  }) =>
      SpineWidget._(key: key, fit: fit, alignment: alignment);

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
