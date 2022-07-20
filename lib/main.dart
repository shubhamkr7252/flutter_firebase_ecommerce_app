import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_ecommerce_app/provider/notification_provider.dart';
import 'package:flutter_firebase_ecommerce_app/screens/authentication/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/brands_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/cart_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/categories_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/home_cms_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/products_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/search_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_address_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/order_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/user_provider.dart';
import 'package:flutter_firebase_ecommerce_app/provider/wishlist_provider.dart';
import 'package:flutter_firebase_ecommerce_app/theme/dark_theme.dart';
import 'package:flutter_firebase_ecommerce_app/theme/light_theme.dart';
import 'firebase_options.dart';
import 'provider/upload_user_profile_image_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env.local");
  await Hive.initFlutter();

  await OneSignal.shared.setAppId(dotenv.env["ONESIGNAL_APP_ID"]!);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => BrandsProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => HomeCMSProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => UploadUserProfileImageProvider()),
        ChangeNotifierProvider(create: (_) => UserAddressesProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: OKToast(
          child: MaterialApp(
            theme: LightTheme.data(context),
            darkTheme: DarkTheme.data(context),
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          ),
        ),
      ),
    );
  }
}
