import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/models/address/country.dart';
import 'package:cirilla/models/cart/cart.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/cart/cart_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

import 'cart_change_address.dart';

class CartShipping extends StatefulWidget {
  final CartData? cartData;
  final CartStore? cartStore;
  final Function(BuildContext context, int packageId, String rateId)? selectShipping;
  CartShipping({Key? key, this.cartData, this.selectShipping, this.cartStore});
  @override
  _CartShippingState createState() => _CartShippingState();
}

class _CartShippingState extends State<CartShipping> with LoadingMixin, SnackMixin {
  bool select = false;
  int? indexSelect;
  CountryStore? _countryStore;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RequestHelper requestHelper = Provider.of<RequestHelper>(context);
    _countryStore = CountryStore(requestHelper)..getCountry();
  }

  Future<void> _selectShipping(BuildContext context, int? packageId, String? rateId) async {
    // TranslateType translate = AppLocalizations.of(context).translate;
    try {
      await widget.cartStore!.selectShipping(packageId: packageId, rateId: rateId);
      // showSuccess(context, translate('cart_ship_success'));
    } catch (e) {
      showError(context, e);
    }
  }

  void showModal(BuildContext context, int index) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return CartChangeAddress(index: index);
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    TextTheme textTheme = theme.textTheme;

    int lengthShip = widget.cartData?.shippingRate?.length ?? 0;
    if (lengthShip == 0) {
      return Container();
    }
    return Observer(builder: (_) {
      return Column(
        children: List.generate(lengthShip, (index) {
          TranslateType translate = AppLocalizations.of(context)!.translate;

          ShippingRate shippingRate = widget.cartData!.shippingRate!.elementAt(index);

          List<String?> shippingAddress = [];

          String? city = get(shippingRate.destination, ['city'], '');
          String? countryId = get(shippingRate.destination, ['country'], '');
          String? postcode = get(shippingRate.destination, ['postcode'], '');
          String? state = get(shippingRate.destination, ['state'], '');

          List data = shippingRate.shipItem!;

          CountryData? countrySelect = _countryStore?.country.firstWhereOrNull((element) => element.code == countryId);

          String? country = countrySelect is CountryData ? countrySelect.name : '';

          if (city != '') shippingAddress.add(city);
          if (state != '') shippingAddress.add(state);
          if (postcode != '') shippingAddress.add(postcode);
          if (country != '') shippingAddress.add(country);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(shippingAddress.join(', '), style: textTheme.caption),
                  ),
                  GestureDetector(
                    onTap: () => showModal(context, index),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(FeatherIcons.mapPin, size: 14, color: theme.primaryColor),
                        SizedBox(width: 4),
                        Text(
                          translate('address_change')!,
                          style: textTheme.caption!.copyWith(color: theme.primaryColor),
                        )
                      ],
                    ),
                  )
                ],
              ),
              if (data.length != 0) ...[
                SizedBox(height: itemPadding),
                Container(
                  height: 70,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (BuildContext context, int index) => SizedBox(),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      ShipItem dataShipInfo = data.elementAt(index);

                      String name = dataShipInfo.name!;

                      bool selected = dataShipInfo.selected!;

                      bool isSelect = data.indexWhere((e) => e.selected == selected) >= 0;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ButtonSelect.icon(
                            color: theme.focusColor,
                            colorSelect: theme.primaryColor,
                            child: Text(name,
                                style: indexSelect == index
                                    ? textTheme.subtitle2!.copyWith(color: theme.primaryColor)
                                    : textTheme.subtitle2),
                            isSelect: indexSelect == index ? isSelect : selected,
                            onTap: () {
                              setState(() {
                                select = selected;
                                indexSelect = index;
                              });
                              _selectShipping(context, shippingRate.packageId, dataShipInfo.rateId);
                            },
                          ),
                          Padding(padding: EdgeInsetsDirectional.only(start: selected ? 1 : itemPaddingMedium))
                        ],
                      );
                    },
                  ),
                ),
              ]
            ],
          );
        }),
      );
    });
  }
}
