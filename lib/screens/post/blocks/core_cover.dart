import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:flutter/material.dart';
import 'core_paragraph.dart';

Map<String, dynamic> alignments = {
  'top right': Alignment.topRight,
  'center right': Alignment.centerRight,
  'bottom right': Alignment.bottomRight,
  'top left': Alignment.topLeft,
  'center left': Alignment.centerLeft,
  'bottom left': Alignment.bottomLeft,
  'top center': Alignment.topCenter,
  'bottom center': Alignment.bottomCenter,
};

class Cover extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;
  const Cover({required this.block});
  @override
  Widget build(BuildContext context) {
    Map attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    String image = get(attrs, ['url'], '');
    List blocks = block!['innerBlocks'];
    String? contentPosition = attrs['contentPosition'];
    return Container(
      width: double.infinity,
      height: 430,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: CirillaCacheImage(
              image,
              width: double.infinity,
              height: 430,
            ),
          ),
          Align(
            alignment: alignments['$contentPosition'] ?? Alignment.center,
            child: Wrap(
              direction: Axis.vertical,
              children: List.generate(blocks.length, (index) {
                Map attrs = get(blocks.elementAt(index), ['attrs'], {}) is Map
                    ? get(blocks.elementAt(index), ['attrs'], {})
                    : {};
                String align = get(attrs, ['align'], '');
                return Paragraph(block: blocks.elementAt(index), alignCover: align, padCover: true);
              }),
            ),
          ),
        ],
      ),
    );
  }
}
