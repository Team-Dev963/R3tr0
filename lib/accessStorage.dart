import 'dart:io';
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class AccessStorage {
  static List<String> allowedExtensions = ['txt', 'png', 'jpg', 'jpeg', 'gif', 'svg'];

  // Will get the path where files are going to be stored
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  // Will get the path where files are going to be stored
  Future<File> getFile(String name, String ext) async {
    final path = await localPath;
    switch (ext) {
      case "txt":
        return File('$path/text/$name.$ext');
        break;
      case "png":
      case "svg":
      case "gif":
      case "jpeg":
      case "jpg":
        return File('$path/images/$name.$ext');
        break;
      default:
        return File('$path/others/$name.$ext');
    }
  }

  Future<dynamic> readFileData(String name, String ext) async {
    try {
      final file = await getFile(name, ext);
      switch (ext) {
        case "txt":
          String body = await file.readAsString();
          return body;
          break;
        case "png":
        case "svg":
        case "gif":
        case "jpeg":
        case "jpg":
          return Image.file(file);
          break;
        default:
        // todo for OTHERS|
      }
      return "tmp";
    } catch (e) {
      return e.toString();
    }
  }

  Future<File> getLocalFile() async {
    return await FilePicker.getFile(allowedExtensions: allowedExtensions);
  }

  Future<dynamic> writeFileData(String name, String ext, dynamic content) async {
    try {
      final file = await getFile(name, ext);
      switch (ext) {
        case "txt":
          await file.writeAsString("$content");
          break;
        case "png":
        case "svg":
        case "gif":
        case "jpeg":
          if (content is File) {
            await file.writeAsBytes(await content.readAsBytes());
          }
          break;
        default:
        // todo for OTHERS
      }
      return "tmp";
    } catch (e) {
      return e.toString();
    }
  }
}
