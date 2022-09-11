import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wlotim/core/core.dart';
import 'package:wlotim/features/tambah_wisata/presentation/pages/tambah_wisata_page.dart';

class WisataAdminPage extends StatelessWidget {
  WisataAdminPage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  final namaCon = TextEditingController();
  final deskripsiCon = TextEditingController();
  final catCon = TextEditingController();
  XFile? picked;
  LatLng? position;
  Future<XFile?> pickImage(BuildContext context) async {
    final source = await pickImageSource(context);
    if (source == null) return null;
    final picker = ImagePicker();
    XFile? picked;
    if (source == 0) {
      picked = await picker.pickImage(source: ImageSource.camera);
    } else {
      picked = await picker.pickImage(source: ImageSource.gallery);
    }
    return picked;
  }

  Future<int?> pickImageSource(BuildContext context) async {
    return showModalBottomSheet<int?>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => UnconstrainedBox(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Pilih Sumber Gambar"),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      onTap: () => Navigator.pop(context, 0),
                      leading: const Icon(Icons.camera_alt),
                      title: const Text("Camera"),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () => Navigator.pop(context, 1),
                      leading: const Icon(Icons.perm_media),
                      title: const Text("Galery"),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Future addWisataMarker(LatLng position) async {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("Wisata"),
        position: position,
        infoWindow: const InfoWindow(
          title: "Wisata",
        ),
      ),
    );
    if (mapsController != null) {
      await mapsController!.animateCamera(CameraUpdate.newLatLng(position));
    }
  }

  Future<String?> convertImageToBase64() async {
    final byte = await picked?.readAsBytes();
    if (byte == null) {
      return null;
    }
    return base64Encode(byte.toList());
  }

  Set<Marker> markers = {};
  final Completer<GoogleMapController> mapsCompleter = Completer();
  GoogleMapController? mapsController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection(FirestoreConst.wisata)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data?.docs.isEmpty ?? true) {
                return const Center(
                  child: Text("Tidak Ada Wisata"),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data?.docs.length ?? 0,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TambahWisataPage(
                              wisataId: snapshot.data?.docs[index]["id"],
                            ),
                          )),
                      leading: SizedBox(
                          width: 80,
                          child: ImageNetWork(
                              snapshot.data?.docs[index]["image"])),
                      title: Text(snapshot.data?.docs[index]["nama"]),
                      subtitle: Text(snapshot.data?.docs[index]["nama"]),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
      bottomNavigationBar: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TambahWisataPage(),
                      ));
                },
                child: const Text("Tambah Wisata")),
          );
        },
      ),
    );
  }
}
