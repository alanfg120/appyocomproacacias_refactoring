import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class YouTubeVideoView {
  final String urlImagen, url, fecha;

  YouTubeVideoView(
      {required this.urlImagen, required this.url, required this.fecha});

  String formatFecha() => DateFormat("dd MMMM 'del' yyyy  h:mm a")
      .format(DateTime.parse(this.fecha));

  void goToVideo() async {
    if (await canLaunch(this.url)) {
      await launch(this.url);
    } else {
      print('Could not launch ${this.url}');
      throw 'Could not launch ${this.url}';
    }
  }
}
