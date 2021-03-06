import 'package:rive/rive.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/animation.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/component.dart';

class ArtboardImporter extends ImportStackObject {
  final RuntimeArtboard artboard;
  ArtboardImporter(this.artboard);

  void addComponent(Core<CoreContext> object) => artboard.addObject(object);

  void addAnimation(Animation animation) {
    artboard.addObject(animation);
    animation.artboard = artboard;
  }

  void addStateMachine(StateMachine animation) => addAnimation(animation);

  @override
  bool resolve() {
    for (final object in artboard.objects.skip(1)) {
      if (object is Component && object.parentId == null) {
        object.parent = artboard;
      }
      object?.onAddedDirty();
    }
    assert(!artboard.children.contains(artboard),
        'artboard should never contain itself as a child');
    for (final object in artboard.objects.toList(growable: false)) {
      if (object == null) {
        continue;
      }
      object.onAdded();
    }
    artboard.clean();
    return true;
  }
}
