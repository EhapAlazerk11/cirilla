import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_quantity.dart';
import 'package:flutter/material.dart';

class ProductQuantity extends StatelessWidget with ShapeMixin {
  final String? align;
  final int qty;
  final ValueChanged<int>? onChanged;

  const ProductQuantity({Key? key, this.align = 'left', this.qty = 1, this.onChanged}) : super(key: key);

  void buildModalEmpty(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      shape: borderRadiusTop(),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                translate('product_quantity_min', {'min': '1'})!,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                    onPressed: () => Navigator.pop(context), child: Text(translate('product_quantity_agree')!)),
              ),
            ],
          ),
        );
      },
    );
    future.then((void value) {
      onChanged!(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    AlignmentDirectional alignment = align == 'right'
        ? AlignmentDirectional.centerEnd
        : align == 'center'
            ? AlignmentDirectional.center
            : AlignmentDirectional.centerStart;
    return Container(
      alignment: alignment,
      child: CirillaQuantity(
        onChanged: onChanged,
        value: qty,
        color: Theme.of(context).colorScheme.surface,
        height: 48,
        width: 90,
        radius: 8,
        actionEmpty: () => buildModalEmpty(context),
        actionZero: () => buildModalEmpty(context),
      ),
    );
  }
}
