import 'dart:collection';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/address/country.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'modal_country.dart';
import 'modal_state.dart';

class AddressFieldForm extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? addressFields;
  final List<CountryData> countries;
  final Function(String key, String value) changeValue;
  final List<String>? hideFields;
  final Widget? titleModal;
  final bool? borderFields;

  AddressFieldForm({
    Key? key,
    this.formKey,
    this.hideFields,
    this.titleModal,
    this.borderFields = false,
    required this.data,
    required this.countries,
    required this.changeValue,
    this.addressFields,
  }) : super(key: key);

  @override
  _AddressFieldForm createState() => _AddressFieldForm();
}

class _AddressFieldForm extends State<AddressFieldForm> with Utility {
  final _txtCountry = TextEditingController();
  final _txtState = TextEditingController();

  FocusNode? _countryFocusNode;
  FocusNode? _stateFocusNode;

  String? countryId = '';
  String? stateId = '';

  @override
  void initState() {
    super.initState();
    countryId = get(widget.data, ['country'], '');
    stateId = get(widget.data, ['state'], '');

    _countryFocusNode = FocusNode();
    _stateFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant AddressFieldForm oldWidget) {
    String? oldCountry = get(oldWidget.data, ['country'], '');
    String? oldState = get(oldWidget.data, ['state'], '');

    String? newCountry = get(widget.data, ['country'], '');
    String? newState = get(widget.data, ['state'], '');

    if (oldCountry != newCountry && newCountry != countryId) {
      setState(() {
        countryId = newCountry;
      });
    }
    if (oldState != newState && newState != stateId) {
      setState(() {
        stateId = newState;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _txtCountry.dispose();
    _txtState.dispose();
    _countryFocusNode!.dispose();
    _stateFocusNode!.dispose();
    super.dispose();
  }

  Map<String, dynamic> getFields(Map<String, dynamic> defaultData, Map<String, dynamic>? addData) {
    Map<String, dynamic> data = {...defaultData};
    if (addData != null && addData.isNotEmpty) {
      for (int i = 0; i < addData.keys.length; i++) {
        String keyAdd = addData.keys.elementAt(i);
        Map<String, dynamic>? defaultDataKey = defaultData[keyAdd];
        Map<String, dynamic>? newDataKey = addData[keyAdd];
        if (defaultDataKey != null) {
          data[keyAdd] = {
            ...defaultDataKey,
            ...newDataKey!,
          };
        }
      }
    }
    data.removeWhere(
        (key, value) => value['hidden'] == true || (widget.hideFields != null && widget.hideFields!.contains(key)));
    Map<String, dynamic> sorted = SplayTreeMap.from(data, (key1, key2) {
      int priorityKey1 = ConvertData.stringToInt(get(data, [key1, 'priority']));
      int priorityKey2 = ConvertData.stringToInt(get(data, [key2, 'priority']));
      return priorityKey1.compareTo(priorityKey2);
    });

    return sorted;
  }

  FormFieldValidator<String>? validatorInput(String key, bool requiredInput, TranslateType translate) {
    if (requiredInput) {
      return (String? value) {
        if (value == null || value.isEmpty) {
          return translate('validate_not_null');
        }
        return null;
      };
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    if (widget.addressFields == null || get(widget.addressFields, ['default'], null) == null) {
      return Container();
    }
    Map<String, dynamic> defaultFields = get(widget.addressFields, ['default'], null);

    Map<String, dynamic>? addFields = get(widget.addressFields, [countryId], null);
    Map<String, dynamic> fields = getFields(defaultFields, addFields);

    CountryData? countrySelect = widget.countries.firstWhereOrNull((element) => element.code == countryId);

    List<Map<String, dynamic>> states = countrySelect is CountryData ? countrySelect.states! : [];
    Map<String, dynamic>? stateSelect = states.firstWhereOrNull((element) => element['code'] == stateId);
    _txtCountry.text = countrySelect is CountryData ? countrySelect.name! : '';
    _txtState.text = stateSelect is Map<String, dynamic> ? stateSelect['name'] : '';

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.titleModal != null)
            Padding(
              padding: EdgeInsets.only(bottom: 48),
              child: Center(
                child: widget.titleModal,
              ),
            ),
          ...List.generate(fields.keys.length, (index) {
            String keyField = fields.keys.elementAt(index);
            Map? field = get(fields, [keyField], {});
            String? type = get(field, ['type'], '');
            String? label = get(field, ['label'], '');
            String? placeholder = get(field, ['placeholder'], null);
            List? validate = get(field, ['validate'], []);
            bool? requiredInput = get(field, ['required'], true);
            double pad = index < fields.keys.length - 1 ? itemPaddingMedium : 0;

            if (type == 'country') {
              return Padding(
                padding: EdgeInsets.only(bottom: pad),
                child: AddressFieldCountry(
                  controller: _txtCountry,
                  label: label,
                  placeholder: placeholder,
                  requiredInput: requiredInput,
                  borderFields: widget.borderFields,
                  onChanged: (String value) {
                    setState(() {
                      countryId = value;
                      stateId = '';
                    });
                    widget.changeValue(keyField, value);
                  },
                  validator: validatorInput(keyField, requiredInput!, translate),
                  countries: widget.countries,
                  countryId: countryId,
                  focusNode: _countryFocusNode,
                ),
              );
            }

            if (type == 'state') {
              return Padding(
                padding: EdgeInsets.only(bottom: pad),
                child: AddressFieldState(
                  controller: _txtState,
                  label: label,
                  placeholder: placeholder,
                  requiredInput: requiredInput,
                  borderFields: widget.borderFields,
                  onChanged: (String value) {
                    setState(() {
                      stateId = value;
                    });
                    widget.changeValue(keyField, value);
                  },
                  validator: validatorInput(keyField, requiredInput!, translate),
                  states: states,
                  stateId: stateId,
                  focusNode: _stateFocusNode,
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.only(bottom: pad),
              child: AddressFieldText(
                value: get(widget.data, [keyField], ''),
                label: label,
                placeholder: placeholder,
                requiredInput: requiredInput,
                validate: validate,
                borderFields: widget.borderFields,
                onChanged: (String value) => widget.changeValue(keyField, value),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class AddressFieldText extends StatefulWidget {
  final String? value;
  final String? label;
  final String? placeholder;
  final bool? requiredInput;
  final ValueChanged<String> onChanged;
  final bool? borderFields;
  final List? validate;

  AddressFieldText({
    Key? key,
    this.value,
    this.borderFields,
    required this.label,
    required this.onChanged,
    this.placeholder,
    this.requiredInput,
    this.validate,
  }) : super(key: key);

  @override
  _AddressFieldText createState() => _AddressFieldText();
}

class _AddressFieldText extends State<AddressFieldText> {
  final _txtInputText = TextEditingController();

  @override
  void didChangeDependencies() {
    _txtInputText.text = widget.value ?? '';
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant AddressFieldText oldWidget) {
    if (oldWidget.value != widget.value && widget.value != _txtInputText.text) {
      _txtInputText.text = widget.value!;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _txtInputText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    String? labelText = widget.requiredInput! ? '${widget.label} *' : widget.label;
    String hintText = widget.placeholder ?? '';

    return TextFormField(
      controller: _txtInputText,
      validator: widget.requiredInput!
          ? (String? value) {
              if (value == null || value.isEmpty) {
                return translate('validate_not_null');
              }
              if (widget.validate is List && widget.validate!.contains('email')) {
                return emailValidator(value: value, errorEmail: translate('validate_email_value'));
              }
              return null;
            }
          : null,
      decoration: widget.borderFields == true
          ? InputDecoration(
              labelText: labelText,
              hintText: hintText,
              contentPadding: EdgeInsetsDirectional.only(start: itemPaddingMedium),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            )
          : InputDecoration(
              labelText: labelText,
              hintText: hintText,
            ),
      onChanged: widget.onChanged,
    );
  }
}

class AddressFieldCountry extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? placeholder;
  final bool? requiredInput;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final List<CountryData> countries;
  final String? countryId;
  final FocusNode? focusNode;
  final bool? borderFields;

  AddressFieldCountry({
    Key? key,
    this.controller,
    required this.label,
    required this.onChanged,
    required this.countries,
    required this.countryId,
    this.placeholder,
    this.requiredInput,
    this.validator,
    this.focusNode,
    this.borderFields,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      onTap: () {
        if (!focusNode!.hasPrimaryFocus) {
          focusNode!.unfocus();
        }
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return buildViewModal(
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter stateSetter) {
                  return ModalCountries(
                    countries: countries,
                    countryId: countryId,
                    onChange: (String? countryValue, String? stateValue) {
                      onChanged(countryValue!);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
        );
      },
      decoration: borderFields == true
          ? InputDecoration(
              labelText: '$label${requiredInput! ? ' *' : ''}',
              hintText: placeholder ?? '',
              suffixIcon: Padding(
                padding: EdgeInsetsDirectional.only(end: itemPaddingMedium),
                child: Icon(FeatherIcons.chevronDown, size: 16),
              ),
              suffixIconConstraints: BoxConstraints(
                minWidth: 2,
                minHeight: 2,
              ),
              contentPadding: EdgeInsetsDirectional.only(start: itemPaddingMedium),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            )
          : InputDecoration(
              labelText: '$label${requiredInput! ? ' *' : ''}',
              hintText: placeholder ?? '',
              suffixIcon: Icon(FeatherIcons.chevronDown, size: 16),
              suffixIconConstraints: BoxConstraints(
                minWidth: 2,
                minHeight: 2,
              ),
            ),
    );
  }

  Widget buildViewModal({Widget? child}) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      double height = constraints.maxHeight;
      return Container(
        constraints: BoxConstraints(maxHeight: height - 100),
        padding: EdgeInsets.symmetric(horizontal: layoutPadding, vertical: itemPaddingLarge),
        child: SizedBox(
          width: double.infinity,
          child: child,
        ),
      );
    });
  }
}

class AddressFieldState extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? placeholder;
  final bool? requiredInput;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final List states;
  final String? stateId;
  final FocusNode? focusNode;
  final bool? borderFields;

  AddressFieldState({
    Key? key,
    this.controller,
    this.borderFields,
    required this.label,
    required this.onChanged,
    required this.states,
    required this.stateId,
    this.placeholder,
    this.requiredInput,
    this.validator,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (states.length > 0) {
      return TextFormField(
        controller: controller,
        validator: validator,
        focusNode: focusNode,
        onTap: () {
          if (!focusNode!.hasPrimaryFocus) {
            focusNode!.unfocus();
          }
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return buildViewModal(
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter stateSetter) {
                    return ModalState(
                      states: states,
                      stateId: stateId,
                      onChange: (String? stateValue) {
                        onChanged(stateValue!);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
          );
        },
        decoration: borderFields == true
            ? InputDecoration(
                labelText: '$label${requiredInput! ? ' *' : ''}',
                hintText: placeholder ?? '',
                suffixIcon: Padding(
                  padding: EdgeInsetsDirectional.only(end: itemPaddingMedium),
                  child: Icon(FeatherIcons.chevronDown, size: 16),
                ),
                suffixIconConstraints: BoxConstraints(
                  minWidth: 2,
                  minHeight: 2,
                ),
                contentPadding: EdgeInsetsDirectional.only(start: itemPaddingMedium, end: itemPaddingMedium),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              )
            : InputDecoration(
                labelText: '$label${requiredInput! ? ' *' : ''}',
                hintText: placeholder ?? '',
                suffixIcon: Icon(FeatherIcons.chevronDown, size: 16),
                suffixIconConstraints: BoxConstraints(
                  minWidth: 2,
                  minHeight: 2,
                ),
              ),
      );
    }
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: '$label${requiredInput! ? ' *' : ''}',
        hintText: placeholder ?? '',
      ),
    );
  }

  Widget buildViewModal({Widget? child}) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      double height = constraints.maxHeight;
      return Container(
        constraints: BoxConstraints(maxHeight: height - 100),
        padding: EdgeInsets.symmetric(horizontal: layoutPadding, vertical: itemPaddingLarge),
        child: SizedBox(
          width: double.infinity,
          child: child,
        ),
      );
    });
  }
}
