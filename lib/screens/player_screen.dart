import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:islamic_content_audio/config/app_config.dart';

class PlayerScreen extends StatefulWidget {
  final AppConfig appConfig;

  const PlayerScreen({required this.appConfig, super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with WidgetsBindingObserver {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  final AudioPlayer player = AudioPlayer();

  static const String _kLastAudioKey = 'player_last_audio';
  static const String _kLastPositionKey = 'player_last_position_ms';
  final String _assetPath = 'islamic_content/islamic_content.mp3';

  int _lastSavedAtMs = 0;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

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

      // Persist position periodically while playing (throttle to reduce writes)
      if (isPlaying) {
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - _lastSavedAtMs > 1500) {
          _lastSavedAtMs = now;
          _savePosition(p);
          _saveCurrentAudioAndPosition();
        }
      }
    });

    /// when completed
    player.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        position = Duration.zero;
      });
      // disable wakelock and reset saved position
      WakelockPlus.disable();
      _savePosition(Duration.zero);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _persistCurrentState();
    _bannerAd.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _persistCurrentState();
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> playAudio() async {
    try {
      await player.setSource(AssetSource(_assetPath));
    } catch (_) {}

    await player.play(AssetSource(_assetPath));
    setState(() => isPlaying = true);

    // enable wakelock while playing
    WakelockPlus.enable();

    // persist current audio & position
    _saveCurrentAudioAndPosition();
  }

  Future<void> pauseAudio() async {
    await player.pause();
    setState(() => isPlaying = false);
    WakelockPlus.disable();

    // save position immediately when pausing
    _persistCurrentState();
  }

  Future<void> seekAudio(Duration value) async {
    await player.seek(value);
    // update stored position after a manual seek
    _persistCurrentState();
  }

  Future<void> playFromStart() async {
    try {
      await player.setSource(AssetSource(_assetPath));
    } catch (_) {}

    await player.seek(Duration.zero);
    await player.play(AssetSource(_assetPath));
    setState(() => isPlaying = true);
    WakelockPlus.enable();
    _persistCurrentState();
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = twoDigits(d.inMinutes);
    final seconds = twoDigits(d.inSeconds % 60);

    return "$minutes:$seconds";
  }

  Future<void> _savePosition(Duration p) async {
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.setInt(_kLastPositionKey, p.inMilliseconds);
    } catch (_) {}
  }

  Future<void> _saveCurrentAudioAndPosition() async {
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.setString(_kLastAudioKey, _assetPath);
      await sp.setInt(_kLastPositionKey, position.inMilliseconds);
    } catch (_) {}
  }

  Future<void> _persistCurrentState() async {
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.setString(_kLastAudioKey, _assetPath);
      await sp.setInt(_kLastPositionKey, position.inMilliseconds);
    } catch (_) {}
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
                    /// RESET ICON ABOVE SLIDER
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0, bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: playFromStart,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF1E7F5C,
                                ).withOpacity(0.14),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.restart_alt,
                                color: Color(0xFF1E7F5C),
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// SLIDER
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF1E7F5C),
                        inactiveTrackColor: Colors.grey.shade300,

                        /// draggable circle color
                        thumbColor: const Color(0xFF1E7F5C),

                        /// ripple effect color
                        overlayColor: const Color(0xFF1E7F5C).withOpacity(0.2),

                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 10,
                        ),
                      ),
                      child: Slider(
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
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),

            // Banner Ad
            SizedBox(
              height: 50, // reserve banner height
              child: _isBannerAdReady ? AdWidget(ad: _bannerAd) : null,
            ),
          ],
        ),
      ),
    );
  }
}
