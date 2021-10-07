import 'package:flutter/material.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product/product.dart';
import 'package:cirilla/utils/currency_format.dart';
import 'package:recase/recase.dart';
import 'package:cirilla/extension/strings.dart';

class ProductAddOns extends StatelessWidget with LoadingMixin {
  final Product? product;
  final Function onChange;
  final Map<String, dynamic> value;

  const ProductAddOns({
    Key? key,
    this.product,
    required this.onChange,
    required this.value,
  }) : super(key: key);

  String _getFieldName(Map<String, dynamic> item) {
    String str = item['name'];
    ReCase name = new ReCase(str.toLowerCase().normalize.removeSymbols);
    return 'addon-${product!.id}-${name.paramCase}-${item['position']}';
  }

  _onChange(dynamic option, Map<String, dynamic> item) {
    String fieldName = _getFieldName(item);
    Map<String, dynamic> selected = Map<String, dynamic>.of(value);
    selected.update(fieldName, (val) => option, ifAbsent: () => option);
    onChange(selected);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> metaData = product!.metaData!.firstWhere(
      (e) => e['key'] == '_product_addons',
      orElse: () => {'value': []},
    );
    return Container(
      child: metaData['value'].length > 0
          ? Column(
              children: List.generate(
                metaData['value'].length,
                (index) {
                  Map<String, dynamic> item = metaData['value'][index];
                  String fieldName = _getFieldName(item);
                  return _Field(
                    fieldName: fieldName,
                    item: item,
                    value: value,
                    onChange: _onChange,
                  );
                },
              ),
            )
          : null,
    );
  }
}

class _Field extends StatelessWidget {
  final String fieldName;
  final Map<String, dynamic> item;
  final Map<String, dynamic> value;
  final Function onChange;

  const _Field({
    Key? key,
    required this.fieldName,
    required this.item,
    required this.value,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String type = item['type'];
    dynamic selected = value[fieldName];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeading(type, selected),
        ...List.generate(
          item['options'].length,
          (i) {
            Map<String, dynamic> option = item['options'][i];
            if (type == 'multiple_choice') {
              return _Radio(
                option: option,
                onChange: (option) => onChange(option, item),
                value: selected ?? [],
              );
            }

            if (type == 'checkbox') {
              return _Checkbox(
                option: option,
                onChange: (value) => onChange(value, item),
                value: selected ?? [],
              );
            }

            if (type == 'custom_text' || type == 'custom_textarea') {
              return _TextFormField(
                option: option,
                onChange: (value) => onChange(value, item),
                value: selected ?? '',
                maxLines: type == 'custom_textarea' ? 8 : 1,
              );
            }

            return Container();
          },
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildHeading(String type, dynamic selected) {
    String str = '';
    if (type == 'checkbox' || type == 'multiple_choice') {
      str = selected != null ? selected.join(', ') : '';
    }

    if (type == 'custom_text') {
      str = selected ?? '';
    }
    return Row(
      children: [
        Text(item['name']),
        Text(': '),
        Text(str),
      ],
    );
  }
}

class _Checkbox extends StatelessWidget {
  final Map<String, dynamic> option;
  final Function onChange;
  final List<String> value;

  const _Checkbox({
    Key? key,
    required this.option,
    required this.onChange,
    required this.value,
  }) : super(key: key);

  int _getIndex(Map<String, dynamic> option) {
    return value.indexWhere((e) => e == option['label']);
  }

  _onChange(dynamic option) {
    int index = _getIndex(option);
    List<String> options = List<String>.of(value);
    String label = option['label'];
    index >= 0 ? options.removeAt(index) : options.add(label);
    onChange(options);
  }

  @override
  Widget build(BuildContext context) {
    String label = option['label'];
    return ListTile(
      horizontalTitleGap: 10,
      minLeadingWidth: 10,
      contentPadding: EdgeInsets.all(0),
      onTap: () => _onChange(option),
      leading: SizedBox(
        width: 20,
        height: 20,
        child: Checkbox(
          value: _getIndex(option) >= 0,
          onChanged: (value) => _onChange(option),
        ),
      ),
      title: Text(label),
      trailing: Text(formatCurrency(context, price: option['price'])),
    );
  }
}

class _Radio extends StatelessWidget {
  final Map<String, dynamic> option;
  final Function onChange;
  final List<String> value;

  const _Radio({
    Key? key,
    required this.option,
    required this.onChange,
    required this.value,
  }) : super(key: key);

  _onChange(dynamic option) {
    String label = option['label'];
    onChange([label]);
  }

  @override
  Widget build(BuildContext context) {
    String label = option['label'];
    return ListTile(
      horizontalTitleGap: 10,
      minLeadingWidth: 10,
      contentPadding: EdgeInsets.all(0),
      onTap: () => _onChange(option),
      leading: SizedBox(
        width: 20,
        height: 20,
        child: Radio(
          value: label,
          groupValue: value.length > 0 ? value.elementAt(0) : '',
          onChanged: (dynamic value) => _onChange(option),
        ),
      ),
      title: Text(label),
      trailing: Text(formatCurrency(context, price: option['price'])),
    );
  }
}

class _TextFormField extends StatelessWidget {
  final Map<String, dynamic> option;
  final Function onChange;
  final String value;
  final int maxLines;

  const _TextFormField({
    Key? key,
    required this.option,
    required this.onChange,
    required this.value,
    required this.maxLines,
  }) : super(key: key);

  _onChange(String str) {
    onChange(str);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: _onChange,
      maxLines: maxLines,
    );
  }
}
