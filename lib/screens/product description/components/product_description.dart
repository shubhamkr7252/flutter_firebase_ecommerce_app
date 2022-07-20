import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';

class ProductDescription extends StatelessWidget {
  final List<String> data;
  const ProductDescription({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.screenHeight! * .015),
      child: Container(
        padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(SizeConfig.screenHeight! * .01),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenHeight! * .015,
                  vertical: SizeConfig.screenHeight! * .01),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenHeight! * .01),
                  color: Theme.of(context).colorScheme.primary),
              child: Text(
                "Product Description",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: SizeConfig.screenWidth! * .035,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * .015),
            ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("\u2022 "),
                        Expanded(child: Text(data[index])),
                      ],
                    ),
                itemCount: data.length),
          ],
        ),
      ),
    );
  }
}
