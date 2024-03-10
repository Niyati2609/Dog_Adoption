
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dog_adoption/database/firestore.dart';
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  final FirestoreDatabase database;

  AddPostPage({required this.database});

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController breedController = TextEditingController();
  String ageDropdownValue = 'New Born';
  final TextEditingController colorController = TextEditingController();
  bool hasMedicalCondition = false;
  String imageUrl = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Post'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Breed:'),
            TextField(
              controller: breedController,
            ),
            SizedBox(height: 20),
            Text('Age:'),
            DropdownButton<String>(
              value: ageDropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  ageDropdownValue = newValue!;
                });
              },
              items: <String>['New Born', 'Middle Old', 'Old'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Color:'),
            TextField(
              controller: colorController,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Medical Conditions:'),
                Checkbox(
                  value: hasMedicalCondition,
                  onChanged: (bool? value) {
                    setState(() {
                      hasMedicalCondition = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            IconButton(onPressed: () async {
              ImagePicker imagePicker = ImagePicker();
              XFile? file =
              await imagePicker.pickImage(source: ImageSource.gallery);
              print('${file?.path}');

              if (file == null) return;
              //Import dart:core
              String uniqueFileName =
              DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';

              /*Step 2: Upload to Firebase storage*/
              //Install firebase_storage
              //Import the library

              //Get a reference to storage root
              Reference referenceRoot = FirebaseStorage.instance.ref();
              Reference referenceDirImages =
              referenceRoot.child('images');

              //Create a reference for the image to be stored
              Reference referenceImageToUpload =
              referenceDirImages.child(uniqueFileName);

              //Handle errors/success
              try {
                //Store the file
                await referenceImageToUpload.putFile(File(file!.path));
                //Success: get the download URL
                imageUrl = await referenceImageToUpload.getDownloadURL();
              } catch (error) {
                //Some error occurred
              }
            }, icon: Icon(Icons.camera_alt)),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (imageUrl.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Please upload an image')));

                  return;
                }
                String breed = breedController.text;
                String age = ageDropdownValue;
                String color = colorController.text; // Assuming you have access to this variable

                await widget.database.addPosts(breed, age, color, hasMedicalCondition,imageUrl);
                Navigator.pop(context); // Go back to the previous screen
              },

              child: Text(
                "Submit",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
