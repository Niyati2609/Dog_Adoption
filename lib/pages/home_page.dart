import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_adoption/components/my_post_button.dart';
import 'package:dog_adoption/components/my_textfield.dart';
import 'package:dog_adoption/database/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dog_adoption/components/my_drawer.dart';

import 'add_post_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreDatabase database = FirestoreDatabase();
  final TextEditingController searchValueController = TextEditingController();
  String selectedCategory = 'Breed'; // Default category is Breed
  bool isPressed = false;
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Page",
          style: TextStyle(
            color: Colors.white, // Change text color here
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPostPage(database: database)),
              );
            },
            icon: Row(
              children: [
                Text(
                  "Post",
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(width: 5), // Add some space between text and icon
                Icon(Icons.add),
              ],
            ),
          ),
        ],
      ),

      drawer: MyDrawer(),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 8),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                items: <String>['Breed', 'Age', 'Color'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Expanded(
                child: MyTextField(
                  hintText: 'Enter search value',
                  obscureText: false,
                  controller: searchValueController,
                ),
              ),
              SizedBox(width: 8),
              Container(
                width: 40, // Adjust width as needed
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {}); // Trigger rebuild to apply filter
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero), // Remove padding
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // Transparent background
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              ),

              SizedBox(width: 8),
            ],
          ),
     // Track whether the button is pressed or not


      StreamBuilder(
            stream: database.getPostStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final posts = snapshot.data!.docs;

              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No Dogs"),
                  ),
                );
              }

              // Filter posts based on selected category and search value
              final filteredPosts = posts.where((post) {
                final String postValue = post[selectedCategory].toString().toLowerCase();
                final String searchValue = searchValueController.text.toLowerCase();
                return postValue.contains(searchValue);
              }).toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: filteredPosts.length,
                  itemBuilder: (context, index) {
                    final post = filteredPosts[index];

                    String breed = post['Breed'];
                    String age = post['Age'];
                    String color = post['Color'];
                    bool hasMedicalCondition = post['HasMedicalCondition'];
                    String userEmail = post['UserEmail'];
                    Timestamp timestamp = post['TimeStamp'];
                    String image = post['image'];

                    return ListTile(
                      title: Text('Breed: $breed'),
                      leading: Container(
                        height: 80,
                        width: 80,
                        child: Image.network(image),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Age: $age'),
                          Text('Color: $color'),
                          Text('Has Medical Condition: ${hasMedicalCondition ? 'Yes' : 'No'}'),
                          Text('User Email: $userEmail'),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
