import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette_generator/palette_generator.dart';

class Spotlight extends StatefulWidget {
  const Spotlight({
    super.key,
    required this.cacheKey,
    required this.heroTag,
    required this.builder,
    this.placeholderBuilder,
    this.width,
    this.height,
  });

  final String cacheKey;
  final String heroTag;
  final WidgetBuilder builder;
  final WidgetBuilder? placeholderBuilder;
  final double? width;
  final double? height;

  @override
  State<Spotlight> createState() => _SpotlightState();
}

class _SpotlightState extends State<Spotlight> {
  PaletteGenerator? _palette;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: _loadFileFromCache(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                height: size.height,
                width: size.width,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(48),
                    ),
                    gradient: SweepGradient(
                      center: FractionalOffset(0.9, 0.5),
                      colors: [
                        _getColor((p) => p.dominantColor),
                        _getColor((p) => p.vibrantColor),
                        _getColor((p) => p.mutedColor),
                        _getColor((p) => p.lightMutedColor),
                        _getColor((p) => p.dominantColor),
                      ],
                      stops: <double>[0.0, 0.2, 0.5, 0.7, 1.0],
                      transform: GradientRotation(pi * 1.5),
                    ),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: FractionalOffset(0.5, 0.3),
                        colors: [
                          for (var a = 0; a < 200; a++)
                            Theme.of(context)
                                .colorScheme
                                .background
                                .withAlpha(a),
                        ],
                        stops: [
                          for (var stop = 0.0; stop < 1.0; stop += 1 / 200) stop
                        ],
                        radius: pi / 4,
                      ),
                    ),
                    child: const SizedBox(),
                  ),
                ),
              ),
              Positioned.fill(
                top: size.width / 1.5,
                child: widget.builder(context),
              ),
              Positioned(
                top: 0,
                height: size.width * 1.2,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Hero(
                      tag: widget.heroTag,
                      child: SvgPicture.string(
                        snapshot.data!,
                        placeholderBuilder: widget.placeholderBuilder,
                        height: widget.height,
                        width: widget.width,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return SizedBox(height: widget.height, width: widget.width);
      },
    );
  }

  Future<String> _loadFileFromCache() async {
    final file = await DefaultCacheManager().getSingleFile(
      '',
      key: widget.cacheKey,
    );
    final rawSvg = await file.readAsString();

    if (rawSvg.isNotEmpty) {
      final drawable = await svg.fromSvgString(rawSvg, widget.cacheKey);
      final picture = drawable.toPicture();
      final image = await picture.toImage(100, 100);
      _palette = await PaletteGenerator.fromImage(image);
    }

    return rawSvg;
  }

  Color _getColor(PaletteColor? Function(PaletteGenerator) generator) {
    const fallbackColor = Colors.white;

    if (_palette == null) return fallbackColor;
    return generator(_palette!)?.color ?? fallbackColor;
  }
}