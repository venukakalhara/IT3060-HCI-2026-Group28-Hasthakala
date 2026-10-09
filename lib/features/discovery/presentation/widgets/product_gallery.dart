import '../../../../core/localization/tr.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProductGallery extends StatefulWidget {
  const ProductGallery({super.key, required this.images});
  final List<String> images;
  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  final _pages = PageController();
  int _index = 0;
  Widget _image(String url, {BoxFit fit = BoxFit.cover}) => Image.network(url,
      fit: fit,
      errorBuilder: (_, __, ___) =>
          const Center(child: Icon(Icons.broken_image_outlined, size: 48)));
  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _zoom() {
    showDialog<void>(
        context: context,
        builder: (context) => Dialog.fullscreen(
              child: Scaffold(
                appBar: AppBar(
                    title: Text(context.tr('discovery_photo', {
                      'index': '${_index + 1}',
                      'count': '${widget.images.length}'
                    })),
                    leading: IconButton(
                        tooltip: context.tr('discovery_close_photo'),
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context))),
                body: Center(
                    child: InteractiveViewer(
                        minScale: 1,
                        maxScale: 5,
                        child: _image(widget.images[_index],
                            fit: BoxFit.contain))),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty)
      return ColoredBox(
          color: AppColors.surface,
          child: Center(child: Text(context.tr('discovery_no_photos'))));
    return Column(children: [
      Expanded(
          child: Stack(children: [
        PageView.builder(
            controller: _pages,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _index = index),
            itemBuilder: (_, index) => GestureDetector(
                onTap: _zoom, child: _image(widget.images[index]))),
        Positioned(
            bottom: 4,
            right: 8,
            child: FilledButton.icon(
                onPressed: _zoom,
                icon: const Icon(Icons.zoom_in),
                label: Text('${_index + 1} / ${widget.images.length}'))),
      ])),
      SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(4),
            itemCount: widget.images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, index) => Semantics(
                button: true,
                selected: _index == index,
                child: InkWell(
                    onTap: () => _pages.animateToPage(index,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut),
                    child: Tooltip(
                        message: context.tr(
                            'discovery_view_photo', {'index': '${index + 1}'}),
                        child: Container(
                            width: 48,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: _index == index
                                        ? AppColors.primary
                                        : AppColors.border,
                                    width: 2)),
                            child: _image(widget.images[index]))))),
          )),
    ]);
  }
}
