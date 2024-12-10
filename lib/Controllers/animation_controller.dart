import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimateController extends GetxController {
  // Hero animation method to show the second page with the full-screen image
  void showSecondPage(String tag, String image, BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false, // Keep the background slightly visible
      pageBuilder: (BuildContext context, _, __) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.8), // Darker background
          body: Stack(
            children: [
              // Blurred background effect
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(color: Colors.black.withOpacity(0.5)), // Add a slight tint to the background
              ),
              // Centered image
              Center(
                child: Hero(
                  tag: tag,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.contain, // Make sure the image scales properly
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
              ),
              // Close button positioned at the top-right corner
              Positioned(
                top: 40, // Adjust the position as needed
                right: 20,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}
