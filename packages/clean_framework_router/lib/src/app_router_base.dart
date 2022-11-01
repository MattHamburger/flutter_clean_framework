import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

typedef RouterParams = Map<String, String>;
typedef RouterConfiguration = GoRouter;

abstract class AppRouterBase<R extends Enum> {
  RouterConfiguration configureRouter();

  /// Navigates to the given [route] without respecting previous routes.
  /// i.e. navigation stack is not maintained and previous routes might be cleared based on the composition of new [route].
  void go(
    R route, {
    RouterParams params = const {},
    RouterParams queryParams = const {},
    Object? extra,
  });

  /// Navigates to the given [route] by pushing it at the top of the previous route.
  /// i.e navigation stack is maintained and previous routes are preserved.
  void push(
    R route, {
    RouterParams params = const {},
    RouterParams queryParams = const {},
    Object? extra,
  });

  /// Replaces the top-most page of the page stack with the given [route].
  void replace(
    R route, {
    RouterParams params = const {},
    RouterParams queryParams = const {},
    Object? extra,
  });

  /// Navigates to the given [location] by replacing the current route.
  void goLocation(
    String location, {
    Object? extra,
  });

  /// Navigates to the given [location] by pushing it at the top of the previous route.
  void pushLocation(
    String location, {
    Object? extra,
  });

  /// Replaces the top-most page of the page stack with the given URL [location]
  /// w/ optional query parameters, e.g. `/family/f2/person/p1?color=blue`.
  void replaceLocation(
    String location, {
    Object? extra,
  });

  /// Navigates the page back to the previous route if available.
  void pop();

  /// Constructs the full location of the given [route] with [params] and [queryParams].
  String locationOf(
    R route, {
    RouterParams params = const {},
    RouterParams queryParams = const {},
  });

  /// Register a closure to be called when the navigation stack changes.
  ///
  /// Adding a listener will provide a function which can be called off to remove the added listener.
  ///
  /// ```dart
  /// final removeListener = router.addListener(
  ///   (){
  ///     // do something
  ///   },
  /// );
  ///
  /// removeListener(); // removes the listener added above
  /// ```
  VoidCallback addListener(VoidCallback listener);

  void dispose();

  /// The current location.
  String get location;
}
