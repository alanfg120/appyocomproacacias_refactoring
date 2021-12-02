import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageCapture {

  ImageCapture();

  static Future<File?> getImagen(ImageSource source) async {
    try {
      final piker = ImagePicker();
      final xfile = await piker.pickImage(
          source: source, imageQuality: 80, maxHeight: 500, maxWidth: 500);
      return File(xfile!.path);
    } catch (error) {
      return null;
    }
  }
}
class ImageCaptureAvatar extends ImageCapture {
  final height = 500;
  final width = 500;
}

class ImageCapturePublicacion extends ImageCapture {
  final height = 900;
  final width = 900;
}
