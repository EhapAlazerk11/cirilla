import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gutenberg_blocks/gutenberg_blocks.dart';

double boxIcon = 40;

class Itinerary extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const Itinerary({Key? key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};

    List items = get(attrs, ['items'], []);

    if (items.isEmpty) {
      return Container();
    }
    List data = [...items];
    dynamic endItem = data.removeAt(data.length - 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.isNotEmpty)
          Stack(
            children: [
              PositionedDirectional(
                start: 0,
                top: boxIcon,
                bottom: 0,
                child: LayoutBuilder(
                  builder: (_, BoxConstraints constraints) {
                    double height = constraints.maxHeight;
                    Path customPathDashed = Path()
                      ..moveTo(0, 0)
                      ..lineTo(0, height);
                    return Container(
                      width: boxIcon,
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 1,
                        child: DottedBorder(
                          customPath: (size) => customPathDashed,
                          color: theme.dividerColor,
                          dashPattern: [3, 4],
                          strokeWidth: 1,
                          child: Container(),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: List.generate(data.length, (index) {
                  dynamic item = data.elementAt(index);
                  return Padding(
                    padding: EdgeInsets.only(bottom: 38),
                    child: buildItem(item: item, theme: theme),
                  );
                }),
              )
            ],
          ),
        buildItem(item: endItem, theme: theme),
      ],
    );
  }

  Widget buildItem({dynamic item, required ThemeData theme}) {
    Map data = item is Map ? item : {};
    String content = get(data, ['content'], '');
    Color colorBox = ConvertData.fromHex(get(data, ['color'], '#409cd1'))!;

    return ItineraryItem(
      icon: Icon(FontAwesomeIcons.solidCircle, size: 16, color: Colors.white),
      colorBoxIcon: colorBox,
      title: Text(content, style: theme.textTheme.bodyText2),
      sizeBoxIcon: boxIcon,
    );
  }
}
