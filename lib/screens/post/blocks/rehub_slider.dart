import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class SliderBlock extends StatelessWidget with Utility {
  final Map<String, dynamic>? block;

  const SliderBlock({Key? key, this.block}) : super(key: key);

  List<String> convertData(List data) {
    List<String> result = [];
    for (int i = 0; i < data.length; i++) {
      dynamic item = data.elementAt(i);
      String image = item is Map ? get(item, ['image', 'url'], '') : '';
      if (image.isNotEmpty) {
        result.add(image);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Map? attrs = get(block, ['attrs'], {}) is Map ? get(block, ['attrs'], {}) : {};
    List slides = get(attrs, ['slides'], []);
    List<String> data = convertData(slides);

    if (data.isEmpty) {
      return Container();
    }

    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = (width * 185) / 337;
        double heightItem = height + 56;
        return SizedBox(
          width: width,
          height: heightItem,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                alignment: Alignment.topCenter,
                child: CirillaCacheImage(
                  data.elementAt(index),
                  width: width,
                  height: height,
                ),
              );
            },
            itemCount: data.length,
            itemWidth: width,
            itemHeight: heightItem,
            pagination: SwiperCustomPagination(builder: (_, SwiperPluginConfig? config) {
              int activeVisit = config?.activeIndex ?? 0;
              return Align(
                alignment: AlignmentDirectional.bottomStart,
                child: SizedBox(
                  height: 48,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      Color colorFilter = activeVisit == index ? Colors.black.withOpacity(0.5) : Colors.transparent;
                      return ColorFiltered(
                        colorFilter: ColorFilter.mode(colorFilter, BlendMode.srcOver),
                        child: CirillaCacheImage(
                          data.elementAt(index),
                          width: 72,
                          height: 48,
                        ),
                      );
                    },
                    separatorBuilder: (_, index) {
                      return SizedBox(width: 8);
                    },
                    itemCount: data.length,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
