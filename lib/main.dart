import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iexplore/extensions/object_box.dart';
import 'package:iexplore/models/objectBoxModel/account_object_box_model.dart';
import 'package:iexplore/models/objectBoxModel/event_object_box_model.dart';
import 'package:iexplore/objectbox.g.dart';
import 'package:iexplore/splashScreen/splash_screen.dart';

/// Global variable
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
late ObjectBox objectbox;
Box<AccountObjectBoxModel> accountObjectBox =
    objectbox.store.box<AccountObjectBoxModel>();
Box<EventObjectBoxModel> eventObjectBox =
    objectbox.store.box<EventObjectBoxModel>();
AccountObjectBoxModel? currentAccount;

Uint8List secret =
    Uint8List.fromList([0, 46, 79, 193, 185, 65, 73, 239, 15, 5]);
SyncCredentials credentials = SyncCredentials.sharedSecretUint8List(secret);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      );

  objectbox = await ObjectBox.create();
  if (Sync.isAvailable()) {
    SyncClient syncClient = Sync.client(
        objectbox.store,
        'ws://127.0.0.1:9999', // wss for SSL, ws for unencrypted traffic
        credentials);

    final subscription = syncClient.loginEvents.listen((SyncLoginEvent event) {
      if (event == SyncLoginEvent.loggedIn) print('Logged in successfully');
    });
    syncClient.start(); // connect and start syncing

    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iExplore',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MasterSplashScreen(),
    );
  }

// @override
// void dispose(){
//   super.dispose();
//   objectbox.store.close();
// }
}
