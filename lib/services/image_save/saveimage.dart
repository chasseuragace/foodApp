import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NetworkToLocalImage extends StatefulWidget {
  /// example
  /// NetworkToLocalImage("https://static.toiimg.com/thumb/56933159.cms?imgsize=686279&width=800&height=800",(d){
  //               return Image.memory(d);
  //             })
  String url;
  final Image Function(dynamic v) imageMemory;

  NetworkToLocalImage(this.url, {Key key, this.imageMemory}) : super(key: key);

  @override
  _LoadImages createState() => new _LoadImages(url);
}

class _LoadImages extends State<NetworkToLocalImage> {
  String url;
  String filename;
  var dataBytes;

  _LoadImages(this.url) {
    filename = Uri.parse(url).pathSegments.last;
    filename = filename.split("/").last;
    print("filename is $filename");
    downloadImage().then((bytes) {
      setState(() {
        dataBytes = bytes;
      });
    });
  }

  Future<dynamic> downloadImage() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    print(dir + "$filename");
    File file = new File('$dir/$filename');

    if (file.existsSync()) {
      print('file already exist');
      var image = await file.readAsBytes();
      return image;
    } else {
      print('file not found downloading from server');
      var request = await http.get(
        url,
      );
      var bytes = await request.bodyBytes; //close();
      await file.writeAsBytes(bytes);
      print(file.path);
      return bytes;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (dataBytes != null)
      return Center(
          child: widget.imageMemory == null
              ? Image.memory(dataBytes)
              : widget.imageMemory(dataBytes));
    else
      return new CircularProgressIndicator();
  }
}
