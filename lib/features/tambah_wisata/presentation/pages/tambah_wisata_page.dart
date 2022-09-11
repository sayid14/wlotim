import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wlotim/core/core.dart';
import 'package:wlotim/features/pilih_lokasi_wisata/presentation/pages/pilih_lokasi_wisata_page.dart';

class TambahWisataPage extends StatefulWidget {
  TambahWisataPage({super.key, this.wisataId});
  String? wisataId;

  @override
  State<TambahWisataPage> createState() => _TambahWisataPageState();
}

class _TambahWisataPageState extends State<TambahWisataPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  bool isLoadingDelete = false;

  final namaCon = TextEditingController();

  final deskripsiCon = TextEditingController();

  final catCon = TextEditingController();

  File? picked;

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

  // Uint8List? imageByts;
  Future getData() async {
    if (widget.wisataId == null) {
      return;
    }
    try {
      final data = await FirebaseFirestore.instance
          .collection(FirestoreConst.wisata)
          .doc(widget.wisataId)
          .get();
      namaCon.text = data["nama"];
      deskripsiCon.text = data["deskripsi"];
      catCon.text = data["category"];
      position = LatLng(data["lat"], data["lng"]);
      markers
          .add(Marker(markerId: MarkerId(data["nama"]), position: position!));
      final res = await get(Uri.parse(data["image"]));

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      picked = await File("$tempPath/${data["id"]}")
          .writeAsBytes(res.bodyBytes.toList());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.wisataId != null) {
      getData();
    }
  }

  Set<Marker> markers = {};

  final Completer<GoogleMapController> mapsCompleter = Completer();

  GoogleMapController? mapsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StatefulBuilder(builder: (context, state) {
                        if (picked != null) {
                          return Stack(
                            children: [
                              Image.file(picked!),
                              Positioned(
                                  right: 0,
                                  top: 0,
                                  child: InkWell(
                                    onTap: () async {
                                      state.call(
                                        () {
                                          picked = null;
                                        },
                                      );
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      child: const Icon(
                                        Icons.close,
                                        size: 30,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ))
                            ],
                          );
                        }
                        return InkWell(
                          onTap: () async {
                            final image = await pickImage(context);
                            if (image == null) return;
                            state.call(
                              () {
                                picked = File(image.path);
                              },
                            );
                          },
                          child: Icon(
                            Icons.add_a_photo,
                            size: MediaQuery.of(context).size.width * .5,
                            color: Colors.grey,
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 40,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      MainTextField(
                        controller: catCon,
                        readOnly: true,
                        label: "Category",
                        hint: "Category",
                        suffix: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isDense: true,
                            value: null,
                            items: CategoryConst.categoryList
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (value) {
                              catCon.text = value ?? "";
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MainTextField(
                        controller: namaCon,
                        label: "Nama",
                        hint: "Nama",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MainTextField(
                        controller: deskripsiCon,
                        label: "Deskripsi",
                        hint: "Masukan Deskripsi",
                        maxLines: 4,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      StatefulBuilder(builder: (context, state) {
                        if (position != null) {
                          return InkWell(
                            onTap: () async {
                              final p = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PilihLokasiWisataPage(),
                                  ));
                              if (p == null) return;
                              position = p;
                              addWisataMarker(position!);
                              state.call(
                                () {},
                              );
                            },
                            child: IgnorePointer(
                              ignoring: true,
                              child: SizedBox(
                                height: 100,
                                child: GoogleMap(
                                  liteModeEnabled: true,
                                  markers: markers,
                                  initialCameraPosition: CameraPosition(
                                    target: position!,
                                    zoom: 14.4746,
                                  ),
                                  onMapCreated: (controller) async {
                                    if (mapsCompleter.isCompleted) {
                                      mapsCompleter.complete(controller);
                                      mapsController =
                                          await mapsCompleter.future;
                                    } else {
                                      mapsController = controller;
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                        return ListTile(
                          onTap: () async {
                            final p = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PilihLokasiWisataPage(),
                                ));
                            if (p == null) return;
                            position = p;
                            addWisataMarker(position!);
                            state.call(
                              () {},
                            );
                          },
                          leading: const Icon(Icons.map),
                          title: const Text("Pilih Lokasi Wisata"),
                        );
                      }),
                      const SizedBox(
                        height: 30,
                      ),
                      StatefulBuilder(builder: (context, state) {
                        if (isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (namaCon.text.isEmpty ||
                                    catCon.text.isEmpty ||
                                    deskripsiCon.text.isEmpty ||
                                    position == null ||
                                    picked == null) {
                                  return;
                                }
                                final image = await convertImageToBase64();
                                if (image == null) {
                                  return;
                                }
                                state.call(
                                  () {
                                    isLoading = true;
                                  },
                                );
                                try {
                                  String id = const Uuid().v4();
                                  if (widget.wisataId != null) {
                                    id = widget.wisataId!;
                                  }
                                  final task = await FirebaseStorage.instance
                                      .ref()
                                      .child(id)
                                      .putFile(picked!);
                                  final uploadImage = await Future.value(task);
                                  final url =
                                      await uploadImage.ref.getDownloadURL();

                                  await FirebaseFirestore.instance
                                      .collection(FirestoreConst.wisata)
                                      .doc(id)
                                      .set({
                                    "id": id,
                                    "nama": namaCon.text,
                                    "category": catCon.text,
                                    "deskripsi": deskripsiCon.text,
                                    "lat": position?.latitude,
                                    "lng": position?.longitude,
                                    "image": url
                                  });
                                  DefaultDialog(
                                    title: "Sukses",
                                    content: widget.wisataId != null
                                        ? "Berhasil mengubah wisata"
                                        : "Berhasil menambah wisata",
                                    autoCloseDuration:
                                        const Duration(seconds: 3),
                                  )
                                      .showSuccess(context)
                                      .then((value) => Navigator.pop(context));
                                } catch (e) {
                                  DefaultDialog(
                                    title: "error",
                                    content: e.toString(),
                                  ).showError(context);
                                }
                                state.call(
                                  () {
                                    isLoading = false;
                                  },
                                );
                              },
                              child: const Text(
                                "Simpan",
                                style: TextStyle(fontWeight: FontWeight.w400),
                              )),
                        );
                      }),
                      if (widget.wisataId != null)
                        StatefulBuilder(builder: (context, state) {
                          if (isLoadingDelete) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                                onPressed: () async {
                                  state.call(
                                    () {
                                      isLoadingDelete = true;
                                    },
                                  );
                                  try {
                                    String id = const Uuid().v4();
                                    if (widget.wisataId != null) {
                                      id = widget.wisataId!;
                                    }
                                    final task = await FirebaseStorage.instance
                                        .ref()
                                        .child(id)
                                        .delete();
                                    await FirebaseFirestore.instance
                                        .collection(FirestoreConst.wisata)
                                        .doc(id)
                                        .delete();
                                    DefaultDialog(
                                      title: "Sukses",
                                      content: "Berhasil menghapus wisata",
                                      autoCloseDuration:
                                          const Duration(seconds: 3),
                                    ).showSuccess(context).then(
                                        (value) => Navigator.pop(context));
                                  } catch (e) {
                                    DefaultDialog(
                                      title: "error",
                                      content: e.toString(),
                                    ).showError(context);
                                  }
                                  state.call(
                                    () {
                                      isLoadingDelete = false;
                                    },
                                  );
                                },
                                child: const Text(
                                  "Hapus",
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                )),
                          );
                        }),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          }),
    ));
  }
}
