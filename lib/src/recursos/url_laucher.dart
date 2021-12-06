import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

void gotoMap(String latitud, String longitud) async {
  final url =
      "https://www.google.com/maps/search/?api=1&query=$latitud,$longitud";
  final String encodedURl = Uri.encodeFull(url);
  _canLauchUrl(encodedURl);
}

void gotoCall(String telefono) async {
  final url = 'tel:+57$telefono';
  _canLauchUrl(url);
}

void gotoMail(String email) async {
  final Uri _emailLaunchUri = Uri(scheme: 'mailto', path: '$email');
  final url = _emailLaunchUri.toString();
  _canLauchUrl(url);
}

void gotoWeb(String url) async => await _canLauchUrl(url);

void goToWhatsapp(
  String telefono,
) async {
  var url;
  if (Platform.isIOS) {
    url = "whatsapp://wa.me/+57$telefono/?text=${Uri.parse('')}";
  } else {
    url = "whatsapp://send?phone=+57$telefono&text=${Uri.parse('')}";
  }
  _canLauchUrl(url);
}

Future goSendToWhatsapp(
    String telefono,
    String texto
  ) async {
    String url() {
      if (Platform.isIOS) {
         return "whatsapp://wa.me/+57$telefono/?text=${Uri.encodeFull('$texto')}";
      } else {
        return "whatsapp://send?phone=+57$telefono&text=$texto";
      }
    }
    if (await canLaunch(url())) {
      await launch(url(),forceSafariVC: false);
    } else {
      throw 'Could not launch ${url()}';
    }
  }

_canLauchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
