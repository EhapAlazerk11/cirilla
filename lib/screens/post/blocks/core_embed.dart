import 'package:cirilla/mixins/mixins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Embed extends StatelessWidget {
  final Map<String, dynamic>? block;
  Embed({Key? key, this.block});
  @override
  Widget build(BuildContext context) {
    Uri uri = Uri.parse(get(block, ['attrs', 'url'], ''));

    String? id = uri.queryParameters['v'];
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Html(data: '<iframe width="$width" height="100%" src="https://www.youtube.com/embed/$id"></iframe>'),
    );
  }
}
