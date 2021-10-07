import 'package:cirilla/screens/product/widgets/product_review_list.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:cirilla/widgets/cirilla_rating.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class ReviewList extends StatelessWidget {
  final int perPage;
  ReviewList({
    Key? key,
    this.perPage = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, int index) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CommentContainedItem(
                image: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CirillaCacheImage(
                    'https://jssors8.azureedge.net/demos/image-slider/img/faded-monaco-scenery-evening-dark-picjumbo-com-image.jpg',
                    width: 48,
                    height: 48,
                  ),
                ),
                name: Text('Thomas', style: theme.textTheme.subtitle2),
                date: Text('12/12/2020', style: theme.textTheme.caption),
                rating: CirillaRating(initialValue: 4),
                comment: Text(
                  'Lorem Ipsum is simply dummy text of the printing an typesetting industry',
                  style: theme.textTheme.caption,
                ),
                onClick: () {},
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
          ],
        );
      },
      itemCount: 10,
    );
  }
}

class BasicReview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReviewBasicWidget(
      rating: 5,
      countRating: 50,
      countStar5: 50,
    );
  }
}

class BottomWriteReview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      width: double.infinity,
      alignment: Alignment.center,
      child: SizedBox(
        height: 34,
        child: ElevatedButton(
          child: Text('Write Review'),
          onPressed: () {},
        ),
      ),
    );
  }
}
