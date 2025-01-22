import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:not_uygulamasi/widgets/ana_menu.dart';
import 'package:not_uygulamasi/widgets/sol_menu_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BannerAd _bannerAd;

  bool _isBannerAdLoaded = false;

  void createBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: dotenv.env['BANNER_AD']!,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              _isBannerAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest());
    _bannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    MobileAds.instance.initialize();
    createBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        persistentFooterButtons: [
          _isBannerAdLoaded
              ? Center(
                  child: Container(
                    color: Colors.red,
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  ),
                )
              : const SizedBox()
        ],
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 32, 32, 41),
        body: const SafeArea(
          child: Stack(
            children: [SolMenuBar(), AnaMenu()],
          ),
        ),
      ),
    );
  }
}
