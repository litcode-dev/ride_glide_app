import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/glide_tokens.dart';

class MapBackground extends StatelessWidget {
  final bool dark;
  final bool route;

  const MapBackground({super.key, this.dark = false, this.route = false});

  // Lagos, Nigeria – Lagos Island / Victoria Island area
  static const _center    = LatLng(6.4420, 3.4080);
  static const _pickup    = LatLng(6.4220, 3.3920);
  static const _carPos    = LatLng(6.4360, 3.4040);
  static const _dest      = LatLng(6.4600, 3.4260);
  static const _userPos   = LatLng(6.4420, 3.4080);

  static const _routePoints = [
    LatLng(6.4220, 3.3920),
    LatLng(6.4270, 3.3970),
    LatLng(6.4310, 3.4010),
    LatLng(6.4360, 3.4040),
    LatLng(6.4440, 3.4130),
    LatLng(6.4530, 3.4200),
    LatLng(6.4600, 3.4260),
  ];

  // Scattered nearby cars for the home screen
  static const _nearbyCars = [
    LatLng(6.4460, 3.4010),
    LatLng(6.4390, 3.4160),
    LatLng(6.4480, 3.3960),
    LatLng(6.4340, 3.4120),
  ];

  @override
  Widget build(BuildContext context) {
    final tileUrl = dark
        ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
        : 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';

    return FlutterMap(
      key: ValueKey('map-$dark'),
      options: MapOptions(
        initialCenter: route ? const LatLng(6.4400, 3.4090) : _center,
        initialZoom: route ? 13.8 : 14.2,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: tileUrl,
          userAgentPackageName: 'com.example.ride_app',
          maxNativeZoom: 19,
          tileProvider: NetworkTileProvider(),
        ),

        if (!route) ...[
          // Home screen: user location dot + nearby cars
          MarkerLayer(markers: [
            Marker(
              point: _userPos,
              width: 22,
              height: 22,
              child: _UserLocationMarker(),
            ),
            ..._nearbyCars.map((pos) => Marker(
                  point: pos,
                  width: 32,
                  height: 32,
                  child: _SmallCarMarker(),
                )),
          ]),
        ],

        if (route) ...[
          PolylineLayer(polylines: [
            // Halo
            Polyline(
              points: _routePoints,
              strokeWidth: 18,
              color: Colors.black.withValues(alpha: 0.09),
            ),
            // Main route line with white border highlight
            Polyline(
              points: _routePoints,
              strokeWidth: 7,
              color: kAccent,
              borderStrokeWidth: 2,
              borderColor: Colors.white.withValues(alpha: 0.4),
              strokeCap: StrokeCap.round,
              strokeJoin: StrokeJoin.round,
            ),
          ]),
          MarkerLayer(markers: [
            Marker(
              point: _pickup,
              width: 28,
              height: 28,
              child: _PickupMarker(),
            ),
            Marker(
              point: _carPos,
              width: 40,
              height: 40,
              child: _CarMarker(),
            ),
            Marker(
              point: _dest,
              width: 28,
              height: 28,
              child: _DestMarker(),
            ),
          ]),
        ],
      ],
    );
  }
}

class _UserLocationMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kAccent.withValues(alpha: 0.22),
        border: Border.all(color: kAccent, width: 2),
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: kAccent),
        ),
      ),
    );
  }
}

class _SmallCarMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4, offset: const Offset(0, 1)),
        ],
      ),
      child: const Icon(LucideIcons.carFront, size: 16, color: Color(0xFF1A1A1A)),
    );
  }
}

class _PickupMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kAccent,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(color: kAccent.withValues(alpha: 0.5), blurRadius: 8),
        ],
      ),
    );
  }
}

class _DestMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF111111),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 8),
        ],
      ),
    );
  }
}

class _CarMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.20), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: const Icon(LucideIcons.carFront, size: 20, color: Color(0xFF111111)),
    );
  }
}
