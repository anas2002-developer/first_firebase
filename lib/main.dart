import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_flutter/fdb_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? file;
  var fileName = "No file selected1";

  UploadTask? task;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) {
      return;
    } else {
      var filePath = result.files.single.path;

      setState(() {
        file = File(filePath!);
        fileName = (file != null) ? basename(file!.path) : "No file selected2";
      });
    }
  }

  Widget UploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final uploadPercent = (progress * 100).toStringAsFixed(2);
        return Text("$uploadPercent %");
      } else {
        return Container();
      }
    },
  );

  Future uploadFile() async {
    if (file == null) {
      return;
    } else {
      fileName = basename(file!.path);
      var destination = 'files2/$fileName';
      task = FdbStorage.uploadFile(destination, file!);
      setState(() {});

      if (task == null){
        return;
      }
      else{
        final snapshot = await task!.whenComplete(() => {});
        final url = await snapshot.ref.getDownloadURL();
        print(url);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  selectFile();
                },
                child: Text("Select files")),
            Text(fileName),
            ElevatedButton(
                onPressed: () {
                  uploadFile();
                },
                child: Text("Upload files")),

            task!=null ? UploadStatus(task!) : Container(),
          ],
        ),
      ),
    );
  }
}
