import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/product_review/product_review.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/product/review_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/app_localization.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ProductReviewForm extends StatefulWidget {
  final Widget? product;
  final ProductReviewStore? store;
  final int? productId;

  ProductReviewForm({
    Key? key,
    this.product,
    this.store,
    required this.productId,
  }) : super(key: key);

  @override
  _ProductReviewFormState createState() => _ProductReviewFormState();
}

class _ProductReviewFormState extends State<ProductReviewForm> with SnackMixin, LoadingMixin, AppBarMixin {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  AuthStore? _authStore;

  final _formKey = GlobalKey<FormState>();

  final _txtReview = TextEditingController();
  TextEditingController? _txtName;
  TextEditingController? _txtEmail;

  FocusNode? _nameFocusNode;
  FocusNode? _emailFocusNode;

  int _rating = 5;

  bool _loading = false;

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);
    String name = _authStore?.user?.displayName ?? '';
    String email = _authStore?.user?.userEmail ?? '';

    _txtName = TextEditingController(text: name);
    _txtEmail = TextEditingController(text: email);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _txtReview.dispose();
    _txtName!.dispose();
    _txtEmail!.dispose();

    _nameFocusNode!.dispose();
    _emailFocusNode!.dispose();
    super.dispose();
  }

  Future<void> handleSubmit() async {
    setState(() {
      _loading = true;
    });
    try {
      ProductReview review = await widget.store!.writeReview(queryParameters: {
        "product_id": widget.productId,
        "review": _txtReview.text,
        "reviewer": _txtName!.text,
        "reviewer_email": _txtEmail!.text,
        "rating": _rating
      });

      if (review.status == ProductReviewStatus.approved) {
        widget.store!.refresh();
      } else {
        showSuccess(context, 'Your review is awaiting approval');
      }

      setState(() {
        _loading = false;
      });

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _loading = false;
      });
      showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      key: scaffoldMessengerKey,
      appBar: baseStyleAppBar(context, title: translate('product_reviews')!),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.product!,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  Text(translate('product_tab_star')!),
                  SizedBox(height: 16),
                  CirillaRating.select(
                    defaultRating: _rating,
                    onFinishRating: (int value) => setState(() {
                      _rating = value;
                    }),
                  ),
                  SizedBox(height: 48),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildReviewField(translate),
                        if (!_authStore!.isLogin) ...[
                          SizedBox(height: 16),
                          buildNameField(translate),
                          SizedBox(height: 16),
                          buildEmailField(translate),
                        ],
                        SizedBox(height: 24),
                        SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: ElevatedButton(
                            child: _loading
                                ? entryLoading(
                                    context,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  )
                                : Text(translate('product_submit_review')!),
                            onPressed: _loading
                                ? () {}
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      handleSubmit();
                                    }
                                  },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildReviewField(TranslateType translate) {
    return TextFormField(
      controller: _txtReview,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('validate_review_required');
        }
        return null;
      },
      maxLines: 5,
      decoration: InputDecoration(
        labelText: translate('input_review'),
        alignLabelWithHint: true,
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_nameFocusNode);
      },
    );
  }

  Widget buildNameField(TranslateType translate) {
    return TextFormField(
      controller: _txtName,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('validate_name_required');
        }
        return null;
      },
      decoration: InputDecoration(labelText: translate('input_name')),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_emailFocusNode);
      },
    );
  }

  Widget buildEmailField(TranslateType translate) {
    return TextFormField(
      controller: _txtEmail,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('validate_email_required');
        }
        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
          return translate('validate_email_value');
        }
        return null;
      },
      decoration: InputDecoration(labelText: translate('input_email')),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
    );
  }
}
