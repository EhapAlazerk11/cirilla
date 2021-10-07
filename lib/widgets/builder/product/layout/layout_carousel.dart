import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/loading_mixin.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/widgets/cirilla_divider.dart';
import 'package:flutter/material.dart';

class LayoutCarousel extends StatefulWidget {
  final List<Product>? products;
  final BuildItemProductType buildItem;
  final double? pad;
  final Color? dividerColor;
  final double? dividerHeight;
  final EdgeInsetsDirectional padding;
  final double width;
  final double height;
  final bool loading;
  final bool canLoadMore;
  final bool? enableLoadMore;
  final Function? onLoadMore;

  const LayoutCarousel({
    Key? key,
    this.products,
    required this.buildItem,
    this.pad = 0,
    this.dividerColor,
    this.dividerHeight = 1,
    this.padding = EdgeInsetsDirectional.zero,
    required this.width,
    required this.height,
    this.loading = false,
    this.canLoadMore = false,
    this.enableLoadMore = false,
    this.onLoadMore,
  }) : super(key: key);

  @override
  _LayoutCarouselState createState() => _LayoutCarouselState();
}

class _LayoutCarouselState extends State<LayoutCarousel> with LoadingMixin {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!widget.enableLoadMore! || !_controller.hasClients || widget.loading || !widget.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      widget.onLoadMore!();
    }
  }

  @override
  Widget build(BuildContext context) {
    int count = widget.enableLoadMore! && widget.loading ? widget.products!.length + 1 : widget.products!.length;
    return ListView.separated(
      controller: _controller,
      padding: widget.padding,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Column(
          children: [
            if (index == widget.products!.length)
              buildLoading(context, isLoading: widget.canLoadMore)
            else
              widget.buildItem(context, product: widget.products![index], width: widget.width, height: widget.height)
          ],
        );
      },
      separatorBuilder: (context, index) => CirillaDivider(
        color: widget.dividerColor,
        height: widget.pad,
        thickness: widget.dividerHeight,
        axis: Axis.vertical,
      ),
      itemCount: count,
    );
  }
}
