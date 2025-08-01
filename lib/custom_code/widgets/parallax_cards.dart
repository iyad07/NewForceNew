// Automatic FlutterFlow imports
// Imports other custom widgets
// Imports custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ParallaxCards extends StatefulWidget {
  const ParallaxCards({
    super.key,
    this.width,
    this.height,
    this.foregroundImages,
    this.backgroundImages,
    this.texts,
    this.onCardTap,
  });

  final double? width;
  final double? height;
  final List<String>? foregroundImages;
  final List<String>? backgroundImages;
  final List<String>? texts;
  final Function(int)? onCardTap;

  @override
  _ParallaxCardsState createState() => _ParallaxCardsState();
}

class _ParallaxCardsState extends State<ParallaxCards> {
  double? accelerometerXAxis;
  StreamSubscription<dynamic>? accelerometerListener;
  late final List<String> foregroundImages;
  late final List<String> backgroundImages;
  late final List<String> texts;

  @override
  void initState() {
    super.initState();
    foregroundImages = widget.foregroundImages ??
        [
          'https://raw.githubusercontent.com/sbis04/flutter-parallax-cards/main/images/rio.png'
        ];
    backgroundImages = widget.backgroundImages ??
        [
          'https://raw.githubusercontent.com/sbis04/flutter-parallax-cards/main/images/rio-bg.jpg'
        ];
    texts = widget.texts ?? ['Brazil'];
    accelerometerListener = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        setState(() {
          accelerometerXAxis = event.x;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    accelerometerListener?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: widget.height,
        viewportFraction: 0.80,
        enableInfiniteScroll: false,
      ),
      items: foregroundImages.asMap().entries.map((entry) {
        int index = entry.key;
        String foregroundImage = entry.value;

        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                if (widget.onCardTap != null) {
                  widget.onCardTap!(index);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                    // Background Image
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 100),
                      right: accelerometerXAxis != null
                          ? (-350 + accelerometerXAxis! * 30)
                          : -350,
                      child: backgroundImages[index].startsWith('http')
                        ? Image.network(
                            backgroundImages[index],
                            fit: BoxFit.fitHeight,
                          )
                        : Image.asset(
                            backgroundImages[index],
                            fit: BoxFit.fitHeight,
                          ),
                    ),
                    // Foreground Image
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 100),
                      width: 320,
                      bottom: -60,
                      right: accelerometerXAxis != null
                          ? (-13 + accelerometerXAxis! * 1.5)
                          : -13,
                      child: foregroundImage.startsWith('http')
                        ? Image.network(
                            foregroundImage,
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            foregroundImage,
                            fit: BoxFit.fill,
                          ),
                    ),
                    // Text (Country name)
                    Column(
                      children: [
                        const SizedBox(height: 60),
                        const Text(
                          'FEATURED',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          texts[index],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
