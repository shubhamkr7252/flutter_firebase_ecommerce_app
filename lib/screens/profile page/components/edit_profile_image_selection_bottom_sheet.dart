import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/upload_user_profile_image_provider.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_firebase_ecommerce_app/widgets/custom_bottom_sheet_drag_handle.dart';

import '../../../widgets/custom_bottom_sheet_option_tile.dart';

class EditProfileImageSelectionBottomSheet extends StatelessWidget {
  const EditProfileImageSelectionBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius:
                BorderRadius.circular(SizeConfig.screenHeight! * .01)),
        child: Consumer<UploadUserProfileImageProvider>(
          builder: (context, uploaduserprofileimageprovider, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomBottomSheetDragHandleWithTitle(
                title: "Choose Image Source",
              ),
              SizedBox(height: SizeConfig.screenWidth! * .035),

              ///first inkwell with camera as source
              InkWell(
                onTap: () async {
                  Navigator.of(context).pop();
                  await uploaduserprofileimageprovider
                      .pickImage(ImageSource.camera)
                      .then((image) {
                    if (image != null) {
                      uploaduserprofileimageprovider.setImageFile(image);
                    }
                  });
                },
                child: CustomBottomSheetOptionTile(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  icon: FlutterRemix.camera_2_fill,
                  title: "Pick from Camera",
                ),
              ),

              SizedBox(width: SizeConfig.screenWidth! * .05),

              ///second inkwell with gallery as source
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  uploaduserprofileimageprovider
                      .pickImage(ImageSource.gallery)
                      .then((image) {
                    if (image != null) {
                      uploaduserprofileimageprovider.setImageFile(image);
                    }
                  });
                },
                child: CustomBottomSheetOptionTile(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  icon: FlutterRemix.gallery_fill,
                  title: "Pick from Gallery",
                ),
              ),
              SizedBox(height: SizeConfig.screenWidth! * .035),
            ],
          ),
        ),
      ),
    );
  }
}
