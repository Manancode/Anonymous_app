// // ignore_for_file: unused_import

// import 'package:flutter/material.dart';
// import 'screens/home_screen.dart';  // Import other files as needed

// void main() async {
//   // Initialization code
//   runApp(MyApp());
// }















// // ignore_for_file: unused_import, avoid_print

// import 'package:flutter/material.dart';
// // ignore: unused_import
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';



// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<User?> signInAnonymously() async {
//     try {
//       UserCredential userCredential = await _auth.signInAnonymously();
//       return userCredential.user;
//     } catch (e) {
//       print("Error during anonymous sign-in: $e");
//       return null;
//     }
//   }
// }


// class FirestoreService {
//   final CollectionReference postsCollection =
//       FirebaseFirestore.instance.collection('posts');

//   Future<void> addPost(String content, String userId) {
//     return postsCollection.add({
//       'content': content,
//       'userId': userId,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//   }

//   Stream<QuerySnapshot> getPostsStream() {
//     return postsCollection.orderBy('timestamp', descending: true).snapshots();
//   }
// }

















// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
       
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

  

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   // final int _counter = 0;


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
        
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
//         title: Text(widget.title),
//       ),
//       body: 
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }



// ignore_for_file: unused_import, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print("Error during anonymous sign-in: $e");
      return null;
    }
  }
}

class FirestoreService {
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  Future<void> addPost(String content, String userId) {
    return postsCollection.add({
      'content': content,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getPostsStream() {
    return postsCollection.orderBy('timestamp', descending: true).snapshots();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: _firestoreService.getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var posts = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(post['content']),
                // Add more UI components as needed
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Example of adding a post
          User? user = await _authService.signInAnonymously();
          if (user != null) {
            await _firestoreService.addPost(_postController.text, user.uid);
            _postController.clear();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
