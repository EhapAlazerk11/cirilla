import 'package:cirilla/screens/post/blocks/core_quote.dart';
import 'package:flutter/material.dart';

import 'core_paragraph.dart';
import 'core_image.dart';
import 'core_gallery.dart';
import 'core_embed.dart';
import 'core_video.dart';
import 'core_columns.dart';
import 'rehub_box.dart';
import 'rehub_offerbox.dart';
import 'rehub_reviewbox.dart';
import 'rehub_comparison_table.dart';
import 'rehub_post_offer_listing.dart';
import 'rehub_title_box.dart';
import 'rehub_heading.dart';
import 'rehub_accordion.dart';
import 'rehub_conspros.dart';
import 'rehub_post_offerbox.dart';
import 'rehub_review_heading.dart';
import 'rehub_itinerary.dart';
import 'rehub_slider.dart';
import 'rehub_color_heading.dart';
import 'rehub_promo_box.dart';
import 'rehub_pretty_list.dart';
import 'rehub_versus_table.dart';
import 'rehub_how_to.dart';
import 'rehub_wc_box.dart';
import 'rehub_woocommerce_list.dart';
import 'rehub_offer_listing.dart';
import 'rehub_offer_listing_full.dart';
import 'core_heading.dart';
import 'core_quote.dart';
import 'core_list.dart';
import 'core_audio.dart';
import 'core_cover.dart';
import 'core_social_icon.dart';
import 'core_media_text.dart';

class PostBlock extends StatelessWidget {
  static const String paragraph = 'core/paragraph';
  static const String gallery = 'core/gallery';
  static const String image = 'core/image';
  static const String embed = 'core/embed';
  static const String video = 'core/video';
  static const String columns = 'core/columns';
  static const String box = 'rehub/box';
  static const String offerbox = 'rehub/offerbox';
  static const String reviewbox = 'rehub/reviewbox';
  static const String comparisonTable = 'rehub/comparison-table';
  static const String postOfferListing = 'rehub/post-offer-listing';
  static const String titleBox = 'rehub/titlebox';
  static const String doubleHeading = 'rehub/heading';
  static const String accordion = 'rehub/accordion';
  static const String conspros = 'rehub/conspros';
  static const String postOfferbox = 'rehub/post-offerbox';
  static const String reviewHeading = 'rehub/review-heading';
  static const String itinerary = 'rehub/itinerary';
  static const String slider = 'rehub/slider';
  static const String colorHeading = 'rehub/color-heading';
  static const String promoBox = 'rehub/promo-box';
  static const String prettyList = 'rehub/pretty-list';
  static const String versusTable = 'rehub/versus-table';
  static const String howto = 'rehub/howto';
  static const String wcBox = 'rehub/wc-box';
  static const String woocommerceList = 'rehub/woocommerce-list';
  static const String offerListing = 'rehub/offer-listing';
  static const String offerListingFull = 'rehub/offerlistingfull';
  static const String heading = 'core/heading';
  static const String quote = 'core/quote';
  static const String list = 'core/list';
  static const String audio = 'core/audio';
  static const String cover = 'core/cover';
  static const String social = 'core/social-links';
  static const String mediaText = 'core/media-text';

  final Map<String, dynamic>? block;

  const PostBlock({Key? key, this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (block!['blockName']) {
      case paragraph:
        return Paragraph(block: block);
      case image:
        return BlockImage(block: block);
      case gallery:
        return BlockGallery(block: block);
      case embed:
        return Embed(block: block);
      case video:
        return Video(block: block);
      case columns:
        return Columns(block: block);
      case offerbox:
        return RehubOfferbox(block: block);
      case reviewbox:
        return RehubReviewbox(block: block);
      case heading:
        return Heading(block: block);
      case quote:
        return Quote(block: block);
      case list:
        return ListBlock(block: block);
      case cover:
        return Cover(block: block);
      case social:
        return Social(block: block);
      case comparisonTable:
        return RehubComparisonTable(block: block);
      case postOfferListing:
        return PostOfferListing(block: block);
      case box:
        return Box(block: block);
      case titleBox:
        return RehubTitleBox(block: block);
      case doubleHeading:
        return RehubDoubleHeading(block: block);
      case accordion:
        return RehubAccordion(block: block);
      case conspros:
        return ConsPros(block: block);
      case postOfferbox:
        return RehubPostOfferbox(block: block);
      case reviewHeading:
        return RehubReviewHeading(block: block);
      case itinerary:
        return Itinerary(block: block);
      case slider:
        return SliderBlock(block: block);
      case audio:
        return Audio(block: block);
      case mediaText:
        return MediaText(block: block);
      case colorHeading:
        return RehubColorHeading(block: block);
      case promoBox:
        return RehubPromoBox(block: block);
      case prettyList:
        return PrettyList(block: block);
      case versusTable:
        return RehubVersusTable(block: block);
      case howto:
        return RehubHowTo(block: block);
      case wcBox:
        return RehubWcBox(block: block);
      case woocommerceList:
        return WoocommerceList(block: block);
      case offerListing:
        return OfferListing(block: block);
      case offerListingFull:
        return OfferListingFull(block: block);
      default:
        return Paragraph(block: block);
    }
  }
}
