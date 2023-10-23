import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DriveImageList(),

      // home: VideoList(),
    );
  }
}




class DriveImageList extends StatefulWidget {
  @override
  _DriveImageListState createState() => _DriveImageListState();
}

class _DriveImageListState extends State<DriveImageList> {
  final _credentials = ServiceAccountCredentials.fromJson({
    "private_key": "AIzaSyCiHAuZJyIZoMmdDIldB1UlLn8OBsOE2E0",
    "client_email": "sujithnaidu03@gmail.com",
  });

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    final client = await clientViaServiceAccount(_credentials, DriveApi.driveScope as List<String>);
    final drive = DriveApi(client);
    try {
      final files = await drive.files.list();
      final imageUrls = files.files
          ?.where((file) => file.mimeType!.startsWith('image/'))
          .map((file) => file.webViewLink)
          .toList();

      // Use the imageUrls to display or work with the images in your app.
      print(imageUrls);
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Drive Images'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


// class VideoList extends StatefulWidget {
//   @override
//   _VideoListState createState() => _VideoListState();
// }
//
// class _VideoListState extends State<VideoList> {
//   String apiKey = 'AIzaSyCiHAuZJyIZoMmdDIldB1UlLn8OBsOE2E0';
//   String channelId = 'UCcFrrU5HatzM6JNuQAjw-Ew';
//   List<dynamic> videos = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchLatestVideos().then((videoList) {
//       setState(() {
//         videos = videoList;
//       });
//     });
//   }
//
//   Future<List<dynamic>> fetchLatestVideos() async {
//     final response = await http.get(
//       Uri.parse(
//           'https://www.googleapis.com/youtube/v3/search?'
//               'key=$apiKey&channelId=$channelId&part=snippet,id&order=date&maxResults=10'
//       ),
//     );
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       List<dynamic> videoList = data['items'];
//       return videoList;
//     } else {
//       throw Exception('Failed to load videos');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Testing'),
//       ),
//       body: ListView.builder(
//         itemCount: videos.length,
//         itemBuilder: (context, index) {
//           final video = videos[index];
//           final videoId = video['id']['videoId'];
//           final videoTitle = video['snippet']['title'];
//           // final videoDescription = video['snippet']['description'];
//           final videoPublishTime = video['snippet']['publishTime'];
//           final videoThumbnail = video['snippet']['thumbnails']['medium']['url'];
//           final formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(videoPublishTime));
//           print(formattedDate);
//           return ListTile(
//             leading: Image.network(videoThumbnail),
//             title: Text(videoTitle),
//             subtitle: Text(formattedDate),
//             onTap: () {
//               String videoUrl = 'https://www.youtube.com/watch?v=$videoId';
//             },
//           );
//         },
//       ),
//     );
//   }
// }
