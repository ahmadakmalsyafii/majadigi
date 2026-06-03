import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/entity/destination_entity.dart';

class RuteTabView extends StatelessWidget {
  final DestinationEntity destination;

  const RuteTabView({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final latLng = LatLng(destination.latitude, destination.longitude);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: latLng,
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.majadigi.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: latLng,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
