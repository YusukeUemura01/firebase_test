import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FunctionUtils{
  static Future<dynamic> getImageGallery() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
    /*if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }*/
  }
  static Future<String> upLoadImage(String uid, File image)async{
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child(uid).putFile(image!);//uidが画像のファイル名
    String downloadUrl = await storageInstance.ref(uid).getDownloadURL(); //アップロードしたURLを取得
    print("image path $downloadUrl");
    return downloadUrl;
  }
}