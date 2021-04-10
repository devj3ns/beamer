import 'package:beamer/beamer.dart';
import 'package:beamer/src/beam_state.dart';
import 'package:flutter/widgets.dart';

/// Configuration for a navigatable application region.
///
/// Extend this class to define your locations to which you can then `beamTo`.
abstract class BeamLocation<T extends BeamState> extends ChangeNotifier {
  BeamLocation([T? state]) {
    _state = createState(state ?? BeamState());
  }

  late T _state;

  /// A state of this location.
  ///
  /// Upon beaming, it will be populated by all necessary attributes.
  /// See [BeamState].
  T get state => _state;
  set state(T state) {
    _state = state..configure();
    notifyListeners();
  }

  /// How to create state from generic [BeamState], often produced by [Beamer]
  /// for the use in [BeamerRouterDelegate.locationBuilder].
  ///
  /// Override this if you have your custom state class extending [BeamState].
  T createState(BeamState state) => state.copyForLocation(this) as T;

  /// Update a state via callback receiving the current state.
  /// If no callback is given, just notifies [BeamerRouterDelegate] to rebuild.
  ///
  /// Useful with [BeamState.copyWith].
  void update([T Function(T)? copy]) {
    if (copy != null) {
      state = copy(_state);
    } else {
      notifyListeners();
    }
  }

  /// Represents the "form" of URI paths supported by this [BeamLocation].
  ///
  /// Dynamic path segments are denoted with ':key' and consequently
  /// `{'key': <value>}` will be put to [state.pathParameters].
  ///
  /// For example: `['/books/:id']`.
  List<String> get pathBlueprints;

  /// Creates and returns the list of pages to be built by the [Navigator]
  /// when this [BeamLocation] is beamed to or internally inferred.
  ///
  /// `context` can be useful while building the pages.
  /// It will also contain anything injected via [builder].
  ///
  /// `state` is the state of this [BeamLocation], containing by default
  /// all the URI configuration parameters. See [BeamState].
  List<BeamPage> pagesBuilder(BuildContext context, T state);

  /// Will be executed before [pagesBuilder].
  void executeBefore(BuildContext context) => null;

  /// Will be executed after [pagesBuilder].
  void executeAfter(BuildContext context, List<BeamPage> pages) => null;

  /// Gives the ability to wrap the `navigator`.
  ///
  /// Mostly useful for providing something to the entire location,
  /// i.e. to all of the pages.
  ///
  /// For example:
  ///
  /// ```dart
  /// @override
  /// Widget builder(BuildContext context, Widget navigator) {
  ///   return MyProvider<MyObject>(
  ///     create: (context) => MyObject(),
  ///     child: navigator,
  ///   );
  /// }
  /// ```
  Widget builder(BuildContext context, Widget navigator) => navigator;

  /// Guards that will be executing [check] when this gets beamed to.
  ///
  /// Checks will be executed in order; chain of responsibility pattern.
  /// When some guard returns `false`, location will not be accepted
  /// and stack of pages will be updated as is configured in [BeamGuard].
  ///
  /// Override this in your subclasses, if needed.
  List<BeamGuard> get guards => const <BeamGuard>[];

  /// A transition delegate to be used by [Navigator].
  ///
  /// This will be used only by this location, unlike
  /// [BeamerRouterDelegate.transitionDelegate]
  /// that will be used for all locations.
  ///
  /// This ransition delegate will override the one in [BeamerRouterDelegate].
  TransitionDelegate? get transitionDelegate => null;
}

/// Default location to choose if requested URI doesn't parse to any location.
class NotFound extends BeamLocation {
  NotFound({String path = '/'}) : super(BeamState.fromUri(Uri.parse(path)));

  @override
  List<BeamPage> pagesBuilder(BuildContext context, BeamState state) => [];

  @override
  List<String> get pathBlueprints => [''];
}
