import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:music_player/album_record_play_animation.dart';
import 'dart:ui' as prefix0;

class MusicApp extends StatefulWidget {
  const MusicApp({super.key});

  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late SequenceAnimation _sequenceAnimation;
  bool _animated = false;
  bool _favoriteState = false;
  bool _minimized = false;
  bool _playPauseButton = false;
  late double _screenWidth, _screenHeight, _bottomNavigationBarHeight;

  // Uyulama release modunda başlarken (apk build edildikten sonra)
  // çok hızlı başladığı için size değerleri 0.0 oluyor. Bunu önlemek için
  // size 0.0 olmayana kadar çalıştırıyoruz.
  _recursiveZeroCheck(size) {
    if (size > 0) {
      return size;
    } else {
      _recursiveZeroCheck(size);
    }
  }

  @override
  void initState() {
    super.initState();

    _screenWidth =
        _recursiveZeroCheck(MediaQueryData.fromView(prefix0.window).size.width);
    _screenHeight = _recursiveZeroCheck(
        MediaQueryData.fromView(prefix0.window).size.height);

    // Bottom Navigation Bar Height
    _bottomNavigationBarHeight = 40;

    // -- Animation Positions and Size --
    // Round Container
    double roundContainerWidthSize = _screenWidth * 0.93;
    double roundContainerHeightSize = _screenHeight * 0.11;

    Offset roundContainerPosition =
        Offset(0, ((_screenHeight * 0.40) - (_bottomNavigationBarHeight / 2)));
    BorderRadius roundContainerBorderRadius = BorderRadius.circular(100);

    // Song Name
    Offset songNameEndPosition =
        Offset(-(_screenWidth * 0.02), _screenHeight * 0.78);
    Offset songNameStartPosition = Offset(0, _screenHeight * 0.50);
    double songNameStartFontSize = 23;
    double songNameEndFontSize = 18;

    _controller = AnimationController(vsync: this);
    _sequenceAnimation = SequenceAnimationBuilder()
        // RoundContainerWidth
        .addAnimatable(
            animatable: Tween<double>(
              begin: _screenWidth,
              end: roundContainerWidthSize,
            ),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 300),
            tag: 'RoundContainerWidth')
        // RoundContainerHeight
        .addAnimatable(
            animatable: Tween<double>(
              begin: _screenHeight,
              end: roundContainerHeightSize,
            ),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 300),
            tag: 'RoundContainerHeight')
        // RoundContainerPosition
        .addAnimatable(
            animatable: Tween<Offset>(
              begin: const Offset(0, 0),
              end: roundContainerPosition,
            ),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 300),
            tag: 'RoundContainerPosition')
        // RoundContainerBorderRadius
        .addAnimatable(
            animatable: BorderRadiusTween(
              begin: BorderRadius.circular(0),
              end: roundContainerBorderRadius,
            ),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 300),
            tag: 'RoundContainerBorderRadius')
        // Album Cover Position
        .addAnimatable(
            animatable: Tween<double>(
              begin: -100,
              end: 400,
            ),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 300),
            tag: 'AlbumCoverPosition')
        // Second Area Opacity
        .addAnimatable(
            animatable: Tween<double>(
              begin: 1,
              end: 0,
            ),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 100),
            tag: 'SecondAreaOpacity')
        // Song Name Position
        .addAnimatable(
            animatable: Tween<Offset>(
              begin: songNameStartPosition,
              end: songNameEndPosition,
            ),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 300),
            tag: 'SongNamePosition')
        // Song Name Font Size
        .addAnimatable(
            animatable: Tween<double>(
              begin: songNameStartFontSize,
              end: songNameEndFontSize,
            ),
            from: const Duration(milliseconds: 0),
            to: const Duration(milliseconds: 300),
            tag: 'SongNameFontSize')
        // Minimize Play/Pause Button Opacity
        .addAnimatable(
            animatable: Tween<double>(
              begin: 0,
              end: 1,
            ),
            from: const Duration(milliseconds: 300),
            to: const Duration(milliseconds: 400),
            tag: 'MinimizeButtonOpacity')
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Appbar
    AppBar appbar = AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        iconSize: 30,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Color(0xff342844),
        ),
        onPressed: () {
          setState(() {
            _minimized = !_minimized;
            if (_minimized) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          });
        },
      ),
      // Appbar Three Point Icon
      actions: <Widget>[
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.more_vert,
            color: Color(0xff342844),
          ),
          onPressed: () {},
        ),
      ],
      centerTitle: true,
      elevation: 0.0,
      title: const Text(
        'Album - Virgül',
        style: TextStyle(
          color: Color(0xff342844),
        ),
      ),
    );

    double appbarHeightSize = appbar.preferredSize.height;

    return Scaffold(
      appBar: appbar,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return Container(
              color: const Color(0xffF56F65),
              child: Stack(
                children: <Widget>[
                  // Rounded Container
                  AlignPositioned(
                    dx: _sequenceAnimation['RoundContainerPosition'].value.dx,
                    dy: _sequenceAnimation['RoundContainerPosition'].value.dy,
                    child: Container(
                      width: _sequenceAnimation['RoundContainerWidth'].value,
                      height: _sequenceAnimation['RoundContainerHeight'].value,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            _sequenceAnimation['RoundContainerBorderRadius']
                                .value,
                      ),
                    ),
                  ),
                  // Album-Vinlyn Area
                  Positioned(
                    // dx: _sequenceAnimation['AlbumCoverPosition'].value.dx,
                    // dy: _sequenceAnimation['AlbumCoverPosition'].value.dy,
                    left: ((_sequenceAnimation['AlbumCoverPosition'].value +
                            100) *
                        -0.27),
                    bottom: (280.toDouble() -
                        _sequenceAnimation['AlbumCoverPosition'].value),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: (_screenHeight * 0.50 - appbarHeightSize),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AlbumRecordPlayAnimation(
                                animated: _animated,
                                minimized: _minimized,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Second Area - ( Button and Name Area)
                  AlignPositioned(
                    dx: _sequenceAnimation['SongNamePosition'].value.dx,
                    dy: _sequenceAnimation['SongNamePosition']
                        .value
                        .dy, //screenHeight * 0.50 - appbarHeightSize,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: (_screenHeight * 0.40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              // Song Name Area
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // Song Name
                                    Text(
                                      'İhtimaller Perisi',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _sequenceAnimation[
                                                'SongNameFontSize']
                                            .value,
                                        color: const Color(0xff342844),
                                      ),
                                    ),
                                    const SizedBox(height: 7.0),
                                    // Singer Name
                                    const Text(
                                      'Gökhan Türkmen',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Button Area
                              Opacity(
                                opacity: _sequenceAnimation['SecondAreaOpacity']
                                    .value,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const SizedBox(width: 15),
                                    IconButton(
                                      iconSize: 25,
                                      color: const Color(0xff342844),
                                      icon: const Icon(Icons.shuffle),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      iconSize: 25,
                                      color: const Color(0xff342844),
                                      icon: const Icon(Icons.folder_open),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      iconSize: 25,
                                      color: const Color(0xff342844),
                                      icon: const Icon(Icons.file_download),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      iconSize: 25,
                                      color: const Color(0xff342844),
                                      icon: const Icon(Icons.repeat),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      iconSize: 25,
                                      color: _favoriteState
                                          ? const Color(0xffF56F65)
                                          : const Color(0xff342844),
                                      icon: Icon(_favoriteState
                                          ? Icons.favorite
                                          : Icons.favorite_border),
                                      onPressed: () {
                                        setState(() {
                                          _favoriteState = !_favoriteState;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 15),
                                  ],
                                ),
                              ),
                              // Slider Area
                              Opacity(
                                opacity: _sequenceAnimation['SecondAreaOpacity']
                                    .value,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const SizedBox(width: 15),
                                    const Text(
                                      '01:30',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SliderTheme(
                                      data: Theme.of(context)
                                          .sliderTheme
                                          .copyWith(
                                            trackHeight: 2,
                                            activeTrackColor:
                                                const Color(0xffF56F65),
                                            inactiveTrackColor:
                                                const Color(0xffDCDBDC),
                                            thumbColor: const Color(0xffF56F65),
                                            thumbShape:
                                                const RoundSliderThumbShape(
                                                    enabledThumbRadius: 5,
                                                    disabledThumbRadius: 8),
                                            overlayShape:
                                                const RoundSliderThumbShape(
                                                    enabledThumbRadius: 7,
                                                    disabledThumbRadius: 8),
                                          ),
                                      child: SizedBox(
                                        width: _screenWidth * 0.75 - 30,
                                        child: Slider(
                                          value: 0.5,
                                          onChanged: (newSliderValue) {},
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      '04:05',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                  ],
                                ),
                              ),
                              // Play Button Area
                              Opacity(
                                opacity: _sequenceAnimation['SecondAreaOpacity']
                                    .value,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    // Back Button
                                    IconButton(
                                      icon: const Icon(Icons.fast_rewind),
                                      color: const Color(0xff342844),
                                      iconSize: 45,
                                      onPressed: () {},
                                    ),
                                    // Play Button
                                    SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: FloatingActionButton(
                                        backgroundColor:
                                            const Color(0xff342844),
                                        child: Icon(
                                          _animated
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          size: 45,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _animated = !_animated;
                                          });
                                        },
                                      ),
                                    ),
                                    // Next Button
                                    IconButton(
                                      icon: const Icon(Icons.fast_forward),
                                      color: const Color(0xff342844),
                                      iconSize: 45,
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Minimize Play/Pause Button
                  AlignPositioned(
                    dx: _screenWidth * 0.35,
                    dy: _screenHeight * 0.375,
                    child: Opacity(
                      opacity:
                          _sequenceAnimation['MinimizeButtonOpacity'].value,
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: FloatingActionButton(
                          backgroundColor: const Color(0xffffffff),
                          child: Icon(
                            _playPauseButton ? Icons.pause : Icons.play_arrow,
                            size: 25,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _playPauseButton = !_playPauseButton;
                              _animated = _minimized ? false : !_animated;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
