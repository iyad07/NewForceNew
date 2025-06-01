import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class ShareImageWidget extends StatelessWidget {
  final File image;

  const ShareImageWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Share.shareXFiles([XFile(image.path)], text: 'Check out this image!');
      },
      child: const Text('Share'),
    );
  }
}
