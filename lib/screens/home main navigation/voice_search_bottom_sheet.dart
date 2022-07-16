import 'dart:developer';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_ecommerce_app/extension/string_casing_extension.dart';
import 'package:flutter_firebase_ecommerce_app/screens/product%20listing/product_listing_screen.dart';
import 'package:flutter_firebase_ecommerce_app/service/navigator_service.dart';
import 'package:flutter_firebase_ecommerce_app/theme/size.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_speech/flutter_speech.dart';

const languages = [
  Language('Francais', 'fr_FR'),
  Language('English', 'en_US'),
  Language('Pусский', 'ru_RU'),
  Language('Italiano', 'it_IT'),
  Language('Español', 'es_ES'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class VoiceSearchBottomSheet extends StatefulWidget {
  const VoiceSearchBottomSheet({Key? key}) : super(key: key);

  @override
  _VoiceSearchBottomSheetState createState() => _VoiceSearchBottomSheetState();
}

class _VoiceSearchBottomSheetState extends State<VoiceSearchBottomSheet> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String transcription = 'Say "Search for (Product Name)"';

  //String _currentLocale = 'en_US';
  Language selectedLang = languages[1];

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    start();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    log('_MyAppState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);
    _speech.activate('fr_FR').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
      child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius:
                  BorderRadius.circular(SizeConfig.screenHeight! * .01)),
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.screenHeight! * .015,
              vertical: SizeConfig.screenHeight! * .055),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AvatarGlow(
                animate: _isListening,
                glowColor: Theme.of(context).colorScheme.primary,
                endRadius: 75.0,
                duration: const Duration(milliseconds: 2000),
                repeatPauseDuration: const Duration(milliseconds: 100),
                repeat: true,
                child: InkWell(
                  onTap: _speechRecognitionAvailable && !_isListening
                      ? () => start()
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withOpacity(0.25),
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.screenHeight! * .03),
                      child: Icon(
                        _isListening
                            ? FlutterRemix.mic_2_fill
                            : FlutterRemix.mic_2_line,
                        size: SizeConfig.screenWidth! * .075,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight! * .015),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(SizeConfig.screenHeight! * .015),
                  child: Text(transcription)),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     _buildButton(
              //       onPressed: _isListening ? () => cancel() : null,
              //       label: 'Cancel',
              //     ),
              //     _buildButton(
              //       onPressed: _isListening ? () => stop() : null,
              //       label: 'Stop',
              //     ),
              //   ],
              // ),
            ],
          )),
    );
  }

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages
      .map((l) => CheckedPopupMenuItem<Language>(
            value: l,
            checked: selectedLang == l,
            child: Text(l.name),
          ))
      .toList();

  void _selectLangHandler(Language lang) {
    setState(() => selectedLang = lang);
  }

  Widget _buildButton({required String label, VoidCallback? onPressed}) =>
      Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ));

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          log('_MyAppState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void cancel() =>
      _speech.cancel().then((_) => setState(() => _isListening = false));

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    log('_MyAppState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) {
    log('_MyAppState.onRecognitionResult... $text');
    setState(() => transcription = text.toCapitalized());

    if (text.isNotEmpty && _isListening == false) {
      List<String> data = text.split(" ");

      if (data[0] != "search" || (data.contains("for") && data[1] != "for")) {
        setState(() {
          transcription = 'Say "Search for (Product Name)"';
        });
        return;
      } else {
        data.removeAt(0);
        if (data.contains("for")) {
          data.removeAt(0);
        }

        String queryText = data
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", "")
            .replaceAll(",", "")
            .trim()
            .toLowerCase();

        Navigator.of(context).pop();
        NavigatorService.push(context,
            page: ProductListingScreen(
                id: queryText,
                name: 'Search: "${queryText.toTitleCase()}"',
                type: "Search"));
      }
    }
  }

  void onRecognitionComplete(String text) async {
    log('_MyAppState.onRecognitionComplete... $text');

    setState(() => _isListening = false);
  }

  void errorHandler() => activateSpeechRecognizer();
}
