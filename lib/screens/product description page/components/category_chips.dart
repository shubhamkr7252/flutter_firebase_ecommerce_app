import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/categories_provider.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';

class CategoriesChips extends StatelessWidget {
  final List<String> data;
  const CategoriesChips({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.screenHeight! * .015,
          right: SizeConfig.screenHeight! * .015,
          top: SizeConfig.screenHeight! * .015),
      width: SizeConfig.screenWidth!,
      height: SizeConfig.screenWidth! * .07,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: index == data.length - 1
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(right: 8),
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(SizeConfig.screenHeight! * .01),
                    color: Theme.of(context).cardTheme.color,
                  ),
                  child: Center(
                      child: Text(
                    getCategoryNameFromId(context, id: data[index]),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: SizeConfig.screenWidth! * .035),
                  ))),
            );
          }),
    );
  }

  String getCategoryNameFromId(BuildContext context, {required String id}) {
    CategoriesProvider _provider = Provider.of(context, listen: false);
    for (var element in _provider.allCategoryModelData!.categories!) {
      if (element.categoryId == id) {
        return element.categoryName;
      }
    }
    return "";
  }
}
