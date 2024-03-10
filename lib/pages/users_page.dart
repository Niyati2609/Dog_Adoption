import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: ListView(
        children: [
          _buildUserItem("2021.niyati.gaonkar@ves.ac.in"),
          _buildUserItem("niyatig@gmail.com"),
        ],
      ),
    );
  }

  Widget _buildUserItem(String email) {
    return ListTile(
      title: Text("Useremail: $email"),
    );
  }
}
