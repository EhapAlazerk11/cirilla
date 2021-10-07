import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/widgets/cirilla_vendor_item.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:ui/ui.dart';

import 'view_grid.dart';
import 'view_list.dart';
import 'view_carousel.dart';

class LayoutMap extends StatefulWidget {
  final int? typeView;
  final Widget? header;
  final bool? loading;
  final List<Vendor>? vendors;
  final VendorStore? vendorStore;
  final ScrollController? controller;

  LayoutMap({
    Key? key,
    this.typeView,
    this.header,
    this.loading,
    this.vendorStore,
    this.vendors,
    this.controller,
  }) : super(key: key);

  @override
  _LayoutMapState createState() => _LayoutMapState();
}

class _LayoutMapState extends State<LayoutMap> with LoadingMixin {
  double top = 0.7;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // String template = Strings.vendorItemGradient;
    String view = widget.typeView == 1
        ? 'grid'
        : widget.typeView == 3
            ? 'list'
            : 'carousel';

    double paddingBottomCarousel = MediaQuery.of(context).padding.bottom;
    return Theme(
      data: theme.copyWith(canvasColor: Colors.transparent),
      child: Scaffold(
        bottomSheet: view == 'carousel'
            ? Container(
                key: Key('${widget.typeView}'),
                margin: EdgeInsets.only(bottom: paddingBottomCarousel),
                child: builderView(
                  context,
                  vendors: widget.vendors,
                  view: view,
                  type: widget.typeView,
                ),
              )
            : null,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(initlat, initlng),
                  zoom: initZoom,
                ),
                myLocationButtonEnabled: false,
                // markers: _markers.values.toSet(),
                // onMapCreated: enablePinMap
                //     ? (GoogleMapController controller) => _onMapCreated(
                //   controller,
                //   items: itemsCustomize,
                //   initMarker: LatLng(initLat, initLng),
                // )
                //     : null,
              ),
            ),
            Positioned(
              top: 44,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: initBoxShadow,
                ),
                child: widget.header,
              ),
            ),
            if (view != 'carousel')
              NotificationListener<DraggableScrollableNotification>(
                key: Key('${widget.typeView}'),
                onNotification: (notification) {
                  setState(() {
                    top = 1 - notification.extent;
                  });
                  return true;
                },
                child: DraggableScrollableActuator(
                  child: DraggableScrollableSheet(
                    expand: true,
                    initialChildSize: 0.3,
                    minChildSize: 0.3,
                    maxChildSize: 0.85,
                    builder: (
                      BuildContext context,
                      ScrollController scrollController,
                    ) {
                      return Container(
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: initBoxShadow,
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: SafeArea(
                          top: false,
                          child: CustomScrollView(
                            controller: scrollController,
                            physics: BouncingScrollPhysics(),
                            slivers: [
                              SliverPersistentHeader(
                                pinned: true,
                                floating: true,
                                delegate: StickyTabBarDelegate(
                                  child: Container(
                                    height: 24,
                                    color: theme.scaffoldBackgroundColor,
                                    child: Center(
                                      child: Container(
                                        height: 4,
                                        width: 51,
                                        decoration: BoxDecoration(
                                          color: theme.dividerColor,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    ),
                                  ),
                                  height: 32,
                                ),
                              ),
                              CupertinoSliverRefreshControl(
                                onRefresh: widget.vendorStore!.refresh,
                                builder: buildAppRefreshIndicator,
                              ),
                              SliverToBoxAdapter(
                                child: builderView(
                                  context,
                                  vendors: widget.vendors,
                                  view: view,
                                  type: widget.typeView,
                                ),
                              ),
                              if (widget.loading!)
                                SliverToBoxAdapter(
                                  child: buildLoading(context, isLoading: widget.vendorStore!.canLoadMore),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget builderView(BuildContext context, {List<Vendor>? vendors, String? view, int? type}) {
    ThemeData theme = Theme.of(context);

    String template = Strings.vendorItemGradient;
    double pad = 16;
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: 20, vertical: 24);
    Color colorItem = theme.colorScheme.surface;
    double widthBanner = 262;
    double heightBanner = 180;

    switch (widget.typeView) {
      case 1:
        template = Strings.vendorItemContained;
        padding = EdgeInsets.fromLTRB(20, 0, 20, 24);
        break;
      case 2:
        template = Strings.vendorItemEmerge;
        padding = EdgeInsets.symmetric(horizontal: 20, vertical: 24);
        colorItem = theme.scaffoldBackgroundColor;
        widthBanner = 270;
        heightBanner = 174;
        break;

      case 3:
        template = Strings.vendorItemHorizontal;
        pad = 8;
        padding = EdgeInsets.fromLTRB(20, 0, 20, 24);
        break;
    }

    switch (view) {
      case 'list':
        return ViewList(
          length: vendors!.length,
          padding: padding,
          pad: pad,
          buildItem: ({required int index, double? widthItem}) {
            return buildItem(
              vendor: vendors.elementAt(index),
              widthItem: widthItem,
              template: template,
              color: colorItem,
              widthBanner: widthBanner,
              heightBanner: heightBanner,
            );
          },
        );
      case 'grid':
        return ViewGrid(
          length: vendors!.length,
          padding: padding,
          pad: pad,
          buildItem: ({required int index, double? widthItem}) {
            return buildItem(
              vendor: vendors.elementAt(index),
              widthItem: widthItem,
              template: template,
              color: colorItem,
              widthBanner: widthBanner,
              heightBanner: heightBanner,
            );
          },
        );
      default:
        return ViewCarousel(
          length: vendors!.length,
          padding: padding,
          pad: pad,
          buildItem: ({required int index, double? widthItem}) {
            return buildItem(
              vendor: vendors.elementAt(index),
              widthItem: widthItem,
              template: template,
              color: colorItem,
              widthBanner: widthBanner,
              heightBanner: heightBanner,
            );
          },
        );
    }
  }

  Widget buildItem(
      {Vendor? vendor, double? widthItem, String? template, Color? color, double? widthBanner, double? heightBanner}) {
    return CirillaVendorItem(
      vendor: vendor,
      template: template,
      widthItem: widthItem,
      color: color,
      widthBanner: widthBanner,
      heightBanner: heightBanner,
      directionIcon: buildIconDirection(context),
      enableDistance: true,
    );
  }

  Widget buildIconDirection(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => print('map'),
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(FeatherIcons.navigation, color: theme.primaryColor, size: 14),
      ),
    );
  }
}
