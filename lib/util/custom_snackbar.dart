import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

 showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
      duration:const Duration(seconds: 2),
      backgroundColor: const Color.fromARGB(255, 42, 156, 19),
    ),
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (files != null && files.files.isNotEmpty) {
      for (int i = 0; i < files.files.length; i++) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    
    debugPrint(e.toString());
  }
  return images;
}
