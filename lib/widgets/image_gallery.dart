import 'package:flutter/material.dart';

Widget _buildImageGallery(dynamic widget) {
  return SizedBox(
    height: 300,
    child: PageView.builder(
      itemCount: widget.product.images.length,
      itemBuilder: (context, index) {
        return Image.network(
          widget.product.images[0],
          fit: BoxFit.cover,
        );
      },
    ),
  );
}