import 'package:dog_adoption/components/my_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void displayMessageToUser(String message, BuildContext context){
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
  );
}