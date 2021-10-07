import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Social extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const Social({Key? key, this.block}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List? blocks = block!['innerBlocks'];

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};

    String? className = get(attrs, ['className'], 'is-style-default');

    String? align = get(attrs, ['align'], 'left');

    String? size = get(attrs, ['size'], 'has-small-icon-size');

    double iconSize = 14;

    switch (size) {
      case 'has-small-icon-size':
        iconSize = 11;
        break;
      case 'has-normal-icon-size':
        iconSize = 16;
        break;
      case 'has-large-icon-size':
        iconSize = 24;
        break;
      case 'has-huge-icon-size':
        iconSize = 32;
        break;
    }
    return Row(
      mainAxisAlignment: align == 'center'
          ? MainAxisAlignment.center
          : align == 'right'
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
      children: List.generate(blocks!.length, (index) {
        Map attrs =
            get(blocks.elementAt(index), ['attrs'], {}) is Map ? get(blocks.elementAt(index), ['attrs'], {}) : {};

        String? icon = attrs['service'];

        IconData iconSocial = FontAwesomeIcons.facebook;

        switch (icon) {
          case 'twitter':
            iconSocial = FontAwesomeIcons.twitter;
            break;
          case 'amazon':
            iconSocial = FontAwesomeIcons.google;
            break;
          case 'pinterest':
            iconSocial = FontAwesomeIcons.pinterest;
            break;
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            decoration: BoxDecoration(
              color: className == 'is-style-logos-only' ? Colors.transparent : Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.symmetric(horizontal: className == 'is-style-pill-shape' ? 20 : 10, vertical: 10),
            child: Icon(
              iconSocial,
              size: iconSize,
            ),
          ),
        );
      }),
    );
  }
}
