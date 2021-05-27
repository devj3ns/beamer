import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/authentication_bloc.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        actions: [
          MaterialButton(
            child: Text(
              'Log out',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: context.read<AuthenticationBloc>().logout,
          )
        ],
      ),
      body: Center(
        child: Text(
          'You are logged in as a user with id:${context.read<AuthenticationBloc>().state.user.id}',
        ),
      ),
    );
  }
}
