import 'package:authentication_bloc/beamer_locations.dart';
import 'package:authentication_bloc/bloc/authentication_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  runApp(
    MyApp(
      authenticationRepository: AuthenticationRepository(),
      userRepository: UserRepository(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
    required this.authenticationRepository,
    required this.userRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  final routerDelegate = BeamerDelegate(
    guards: [
      // Guard /dashboard and /account by beaming to /login if the user is unauthenticated:
      BeamGuard(
        pathBlueprints: ['/dashboard*', '/account*'],
        check: (context, state) =>
            context.select((AuthenticationBloc auth) => auth.isAuthenticated()),
        beamTo: (context, failedUri) {
          // Update the queryParameters of the url with the failed uri
          return BeamerLocations(
            BeamState(
              pathBlueprintSegments: ['login'],
              queryParameters: {'next': failedUri.toString()},
            ),
          );
        },
        beamToNamed: '/login',
      ),
      // Guard /login by beaming to /dashboard or the failed uri if the user is authenticated:
      BeamGuard(
        pathBlueprints: ['/login*'],
        check: (context, state) => context
            .select((AuthenticationBloc auth) => !auth.isAuthenticated()),
        beamTo: (context, _) {
          final next = context.currentBeamLocation.state.queryParameters['next']
              ?.replaceAll('/', '');

          return BeamerLocations(
            BeamState(
              pathBlueprintSegments: [next ?? 'dashboard'],
            ),
          );
        },
      ),
    ],
    initialPath: '/login',
    locationBuilder: (state) => BeamerLocations(state),
  );

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider<AuthenticationBloc>(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        ),
        child: BeamerProvider(
          routerDelegate: routerDelegate,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerDelegate: routerDelegate,
            routeInformationParser: BeamerParser(),
          ),
        ),
      ),
    );
  }
}
