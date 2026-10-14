// spine_flutter.dart
// STUB / DUMMY package -- BUKAN runtime Spine asli.
//
// Tujuan file ini cuma satu: bikin `flutter pub get` dan
// `flutter build apk --debug` sukses di CI (GitHub Actions) walau
// package spine_flutter asli (native runtime Spine 4.2, berlisensi)
// belum/tidak tersedia di repo ini.
//
// Semua kelas & method di bawah ini bentuknya (nama, parameter, tipe
// kembalian) dibuat SAMA PERSIS dengan API spine_flutter asli yang
// dipakai kode aplikasi (lib/main.dart, lib/src/chat_screen.dart,
// lib/src/enhanced_animation_system.dart, lib/src/scene_backdrop_bounds.dart)
// -- tapi isinya no-op / dummy. Artinya:
//   - Karakter Spine TIDAK akan tampil atau bergerak.
//   - Semua kalkulasi rig/animasi jalan tanpa error, tapi gak ada efek visual.
//   - Aman dipakai buat verifikasi build pipeline & suntik asset manual
//     ke APK jadi (lihat docs/RESOURCE_SETUP_AND_BUILD.md).
//
// JANGAN dipakai buat rilis ke pengguna akhir -- ganti dengan package
// spine_flutter asli begitu tersedia.

library spine_flutter;

import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show AssetBundle;

/// No-op pengganti initSpineFlutter() asli. Spine runtime asli butuh
/// native binding; stub ini cuma langsung selesai.
Future<void> initSpineFlutter({bool enableMemoryDebugging = false}) async {}

enum Physics { none, reset, update, pose }

enum MixBlend { setup, first, replace, add }

enum EventType { start, interrupt, end, complete, dispose, event }

class Vector2 {
  const Vector2(this.x, this.y);
  final double x;
  final double y;
}

class Bounds {
  const Bounds(this.x, this.y, this.width, this.height);
  final double x;
  final double y;
  final double width;
  final double height;
}

/// Dipakai lib/src/scene_backdrop_bounds.dart (SceneBackdropBounds extends ini).
abstract class BoundsProvider {
  const BoundsProvider();
  Bounds computeBounds(SkeletonDrawable drawable);
}

class BoneData {
  const BoneData();
  double getY() => 0;
}

class Bone {
  Bone(this._name);
  final String _name;

  double _x = 0;
  double _y = 0;
  double _rotation = 0;
  double _scaleX = 1;
  double _scaleY = 1;
  Bone? _parent;

  double getX() => _x;
  void setX(double value) => _x = value;
  double getY() => _y;
  void setY(double value) => _y = value;
  double getRotation() => _rotation;
  void setRotation(double value) => _rotation = value;
  double getScaleX() => _scaleX;
  void setScaleX(double value) => _scaleX = value;
  double getScaleY() => _scaleY;
  void setScaleY(double value) => _scaleY = value;

  double getWorldX() => _x;
  double getWorldY() => _y;

  Bone? getParent() => _parent;
  BoneData getData() => const BoneData();

  Vector2 worldToLocal(double x, double y) => Vector2(x, y);
}

class SlotData {
  const SlotData(this._name);
  final String _name;
  String getName() => _name;
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
  Slot(this._name);
  final String _name;
  SlotData getData() => SlotData(_name);
  Attachment? getAttachment() => null;
}

class Skeleton {
  final Map<String, Bone> _bones = <String, Bone>{};

  Bone? findBone(String name) =>
      _bones.putIfAbsent(name, () => Bone(name));

  Slot? findSlot(String name) => null;

  List<Slot> getSlots() => const <Slot>[];

  void updateWorldTransform(Physics physics) {}

  Bounds getBounds() => const Bounds(0, 0, 0, 0);
}

class SkeletonDrawable {
  final Skeleton skeleton = Skeleton();
}

class Animation {
  const Animation([this._name = '']);
  final String _name;
  double getDuration() => 0;
  String getName() => _name;
}

class SkeletonData {
  Animation? findAnimation(String name) => null;
  List<Animation> getAnimations() => const <Animation>[];
}

class AnimationStateData {
  void setDefaultMix(double value) {}
}

class TrackEntry {
  void setMixDuration(double value) {}
  void setAlpha(double value) {}
  void setTimeScale(double value) {}
  void setMixBlend(MixBlend value) {}
  void setTrackTime(double value) {}
  void setListener(
    void Function(EventType type, TrackEntry entry, Object? event) listener,
  ) {}
  Animation getAnimation() => const Animation();
  bool getLoop() => true;
}

class AnimationState {
  final AnimationStateData _data = AnimationStateData();

  AnimationStateData getData() => _data;
  TrackEntry? getCurrent(int trackIndex) => null;

  TrackEntry setAnimationByName(int trackIndex, String name, bool loop) =>
      TrackEntry();
  TrackEntry setEmptyAnimation(int trackIndex, double mixDuration) =>
      TrackEntry();
  TrackEntry addEmptyAnimation(
    int trackIndex,
    double mixDuration, [
    double delay = 0,
  ]) => TrackEntry();
  TrackEntry addAnimationByName(
    int trackIndex,
    String name,
    bool loop,
    double delay,
  ) => TrackEntry();

  void clearTrack(int trackIndex) {}
}

class SpineWidgetController {
  SpineWidgetController({
    this.onInitialized,
    this.onBeforeUpdateWorldTransforms,
    this.onAfterUpdateWorldTransforms,
    this.onBeforeApplyAnimation,
    this.onAfterApplyAnimation,
    double targetFramesPerSecond = 60,
    this.maxDeltaTime = 0.1,
    this.paintOverflow = EdgeInsets.zero,
  }) : _targetFramesPerSecond = targetFramesPerSecond {
    scheduleMicrotask(() {
      onInitialized?.call(this);
    });
  }

  final void Function(SpineWidgetController controller)? onInitialized;
  final void Function(SpineWidgetController controller)?
  onBeforeUpdateWorldTransforms;
  final void Function(SpineWidgetController controller)?
  onAfterUpdateWorldTransforms;
  final void Function(SpineWidgetController controller)?
  onBeforeApplyAnimation;
  final void Function(SpineWidgetController controller)? onAfterApplyAnimation;

  /// Batas atas delta waktu per frame (detik) yang dikirim ke physics/animasi
  /// asli Spine. Stub ini tidak menjalankan loop animasi apa pun, jadi nilai
  /// ini cuma disimpan supaya kode pemanggil tetap type-check.
  final double maxDeltaTime;

  /// Area tambahan di luar bounds skeleton yang masih boleh digambar (dipakai
  /// runtime asli buat clipping/repaint region). No-op di stub ini.
  final EdgeInsets paintOverflow;

  double _targetFramesPerSecond;
  double get targetFramesPerSecond => _targetFramesPerSecond;
  set targetFramesPerSecond(double value) => _targetFramesPerSecond = value;

  /// Delta waktu (detik) sejak update terakhir. Runtime asli menghitung ini
  /// dari ticker; stub ini cuma menurunkannya dari [targetFramesPerSecond]
  /// supaya kode yang membaginya (mis. buat physics wind) tidak div-by-zero.
  double get updateDelta =>
      _targetFramesPerSecond > 0 ? 1 / _targetFramesPerSecond : 0;

  final Skeleton skeleton = Skeleton();
  final SkeletonData skeletonData = SkeletonData();
  final AnimationState animationState = AnimationState();

  Offset toSkeletonCoordinates(Offset screenPosition) => screenPosition;

  void dispose() {}
}

class SpineWidget extends StatelessWidget {
  const SpineWidget.fromAsset(
    this.atlasFile,
    this.skeletonFile,
    this.controller, {
    super.key,
    this.bundle,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.boundsProvider,
  });

  final String atlasFile;
  final String skeletonFile;
  final SpineWidgetController controller;
  final AssetBundle? bundle;
  final BoxFit fit;
  final Alignment alignment;
  final BoundsProvider? boundsProvider;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
