import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wlotim/core/core.dart';

class DetailWisataPage extends StatelessWidget {
  const DetailWisataPage({Key? key, required this.data}) : super(key: key);
  final Map<String, dynamic>? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Detail Wisata"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: GoogleMap(
                  liteModeEnabled: true,
                  markers: {
                    Marker(
                      markerId: MarkerId(data?["nama"]),
                      position: LatLng(data?["lat"] ?? 0, data?["lng"] ?? 0),
                    )
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(data?["lat"] ?? 0, data?["lng"] ?? 0),
                    zoom: 14.4746,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) =>
                      InteractiveViewer(child: ImageNetWork(data?["image"])),
                ),
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ImageNetWork(data?["image"])),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            child: Icon(
                              Icons.pin_drop,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Text(data?["nama"] ?? "-"))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            child: Icon(
                              Icons.format_align_center_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Text(data?["deskripsi"] ?? "-"))
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
