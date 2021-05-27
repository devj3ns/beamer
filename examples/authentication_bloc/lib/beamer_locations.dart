import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import 'presentation/account_page.dart';
import 'presentation/dashboard_page.dart';
import 'presentation/login_page.dart';

class BeamerLocations extends BeamLocation {
  BeamerLocations(BeamState state) : super(state);

  @override
  List<String> get pathBlueprints => [
        '/login',
        '/account',
        '/dashboard',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      if (state.uri.pathSegments.contains('login'))
        BeamPage(
          key: ValueKey('login'),
          title: 'Login',
          child: LoginPage(),
        ),
      if (state.uri.pathSegments.contains('dashboard'))
        BeamPage(
          key: ValueKey('dashboard'),
          title: 'Dashboard',
          child: DashboardPage(),
        ),
      if (state.uri.pathSegments.contains('account'))
        BeamPage(
          key: ValueKey('account'),
          title: 'Account',
          child: AccountPage(),
        ),
    ];
  }
}
