import 'package:flutter/material.dart';

import 'package:beamer/beamer.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You are successfully logged it.\nWelcome to your dashboard!'),
            SizedBox(height: 5),
            ElevatedButton(
              child: Text('Account Page'),
              onPressed: () => context.beamToNamed('/account'),
            ),
          ],
        ),
      ),
    );
  }
}
