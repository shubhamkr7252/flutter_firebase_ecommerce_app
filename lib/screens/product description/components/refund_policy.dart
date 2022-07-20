import 'package:flutter/material.dart';

import '../../../theme/size.dart';

class ProductDescriptionRefundPolicy extends StatelessWidget {
  const ProductDescriptionRefundPolicy({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              "Refund Policy",
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
                      Expanded(
                          child: Text(index == 0
                              ? "10 Days Replacement Policy"
                              : "GST invoice available")),
                    ],
                  ),
              itemCount: 2),
        ],
      ),
    );
  }
}
