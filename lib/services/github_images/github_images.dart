import 'package:flutter/material.dart';

class GithubImages extends StatefulWidget {
  ///Example
  /// GithubImages(imageUrl: "https://github.com/chasseuragace/foodAppResources/blob/master/images/cat.png",image: (url)=>Image.network(url),),
  //
  final String imageUrl;
  final Function(String) image;

  const GithubImages({Key key, this.imageUrl, this.image}) : super(key: key);

  @override
  _GithubImagesState createState() => _GithubImagesState();
}

class _GithubImagesState extends State<GithubImages> {
  @override
  Widget build(BuildContext context) {
    return widget.image("${widget.imageUrl}?raw=true");
  }
}
