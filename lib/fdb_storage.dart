import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FdbStorage {
  static UploadTask? uploadFile(String destination, File file){

    try{
      var reference = FirebaseStorage.instance.ref(destination);
      return reference.putFile(file);

    } on FirebaseException catch(e){
      print("Error occured");
      print(e);
      return null;
    }

  }
}