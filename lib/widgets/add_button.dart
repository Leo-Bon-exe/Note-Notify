import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../show_add_sheet/add_button_sheet.dart';

const int maxFailedLoadAttemps = 7;

class AddButton extends ConsumerStatefulWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  ConsumerState<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends ConsumerState<AddButton> {
  InterstitialAd? _interAd;
  int _attempt = 0;

  void createAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-2172461515627723/2077430707',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interAd = ad;
            _attempt = 0;
          },
          onAdFailedToLoad: (error) {
            _attempt++;
            _interAd = null;
            if (_attempt >= maxFailedLoadAttemps) {
              createAd();
            }
          },
        ));
  }

  void showInterAd() {
    if (_interAd != null) {
      _interAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          createAd();
        },
      );
      _interAd!.show();
    }
  }

  @override
  void initState() {
    super.initState();
    MobileAds.instance.initialize();
    createAd();
  }

  @override
  void dispose() {
    super.dispose();
    _interAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: const Alignment(0.85, 0.9),
        child: InkWell(
          child: Material(
            color: Colors.indigoAccent,
            borderRadius: BorderRadius.circular(40.0),
            elevation: 7,
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Colors.blue[700]),
              child: const Icon(Icons.add, size: 40),
            ),
          ),
          onTap: () => {
            showAddTaskBottomSheet(context, ref, showInterAd),
          },
        ));
  }
}
