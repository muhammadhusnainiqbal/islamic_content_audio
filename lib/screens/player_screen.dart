import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:islamic_content_audio/config/app_config.dart';

class PlayerScreen extends StatefulWidget {
  final AppConfig appConfig;

  const PlayerScreen({required this.appConfig, super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  final AudioPlayer player = AudioPlayer();

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: widget.appConfig.admobBannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('BannerAd failed to load: ${error.message}');
        },
      ),
    );

    _bannerAd.load();

    /// total duration
    player.onDurationChanged.listen((d) {
      setState(() => duration = d);
    });

    /// current position
    player.onPositionChanged.listen((p) {
      setState(() => position = p);
    });

    /// when completed
    player.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    player.dispose();
    super.dispose();
  }

  Future<void> playAudio() async {
    await player.play(
      AssetSource('assets/islamic_content/islamic_content.mp3'),
    );
    setState(() => isPlaying = true);
  }

  Future<void> pauseAudio() async {
    await player.pause();
    setState(() => isPlaying = false);
  }

  Future<void> seekAudio(Duration value) async {
    await player.seek(value);
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = twoDigits(d.inMinutes);
    final seconds = twoDigits(d.inSeconds % 60);

    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Container(
              height: 75,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E7F5C), Color(0xFF134E3A)],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.appConfig.nameArabic,
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.appConfig.nameEnglish,
                    style: const TextStyle(fontSize: 15, color: Colors.white70),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),

            /// CENTER AREA
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// SLIDER
                    Slider(
                      min: 0,
                      max: duration.inSeconds == 0
                          ? 1
                          : duration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble().clamp(
                        0,
                        duration.inSeconds.toDouble(),
                      ),
                      onChanged: (value) {
                        seekAudio(Duration(seconds: value.toInt()));
                      },
                    ),

                    /// TIME
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatTime(position)),
                          Text(formatTime(duration)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// PLAY BUTTON
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: const Color(0xFF1E7F5C),
                      child: IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () {
                          isPlaying ? pauseAudio() : playAudio();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Banner Ad
            if (_isBannerAdReady)
              Container(
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
          ],
        ),
      ),
    );
  }
}
