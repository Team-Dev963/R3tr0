import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';

class AccessStorage {

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
          // todo for IMAGES
          break;
        default:
          // todo for OTHERS
      }
      return "tmp";
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> writeFileData(String name, String ext, dynamic content) async {
    try {
      final file = await getFile(name, ext);
      switch (ext) {
        case "txt":
          return file.writeAsString("$content");
          break;
        case "png":
        case "svg":
        case "gif":
        case "jpeg":
          // todo for IMAGES
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
