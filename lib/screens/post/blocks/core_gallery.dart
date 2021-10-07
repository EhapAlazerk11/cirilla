import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as dom;

class BlockGallery extends StatelessWidget {
  final Map<String, dynamic>? block;

  const BlockGallery({Key? key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dom.Document document = htmlParser.parse(block!['innerHTML']);
    double screenWidth = MediaQuery.of(context).size.width;

    List<dom.Element> images = document.getElementsByTagName("figure");

    if (images.length == 0) return Container();

    List<Widget> _images = [];

    for (int i = 0; i < images.length; i++) {
      dom.Element image = images[i].getElementsByTagName("img")[0];

      double? width = ConvertData.stringToDouble(image.attributes['width'], screenWidth);
      double? height = ConvertData.stringToDouble(image.attributes['height'], screenWidth);

      _images.add(Column(
        children: [
          CirillaCacheImage(
            image.attributes['src'],
            width: width,
            height: height,
          ),
          SizedBox(height: 20)
        ],
      ));
    }

    return Column(
      children: _images,
    );
  }
}
