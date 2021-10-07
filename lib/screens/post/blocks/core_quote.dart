import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as dom;

class Quote extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;
  const Quote({Key? key, required this.block});
  @override
  Widget build(BuildContext context) {
    dom.Document document = htmlParser.parse(block!['innerHTML']);

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};

    String? className = get(attrs, ['className'], 'is-style-default');

    List<dom.Element> p = document.getElementsByTagName('p');

    List<Widget> _p = [];
    for (int i = 0; i < p.length; i++) {
      String title = p[i].text;
      _p.add(Column(
        children: [Text(title)],
      ));
    }
    bool? sub = document.getElementsByTagName('cite').isEmpty;

    return Container(
      decoration: BoxDecoration(
          border: Border(
        left: BorderSide(
          color: (className == 'is-style-default') ? Theme.of(context).dividerColor : Colors.transparent,
          width: 2.0,
        ),
      )),
      padding: className == 'is-style-default' ? EdgeInsets.symmetric(horizontal: 10) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (document.getElementsByTagName('p')[0].text != '') ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _p,
            ),
            if (className == 'is-style-default') SizedBox(height: sub == true ? 0 : 16),
          ],
          if (sub != true) Text("${document.getElementsByTagName('cite')[0].text}")
        ],
      ),
    );
  }
}
