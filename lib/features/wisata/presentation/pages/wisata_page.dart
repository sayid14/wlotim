import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wlotim/core/core.dart';

import '../widgets/wisata_tiles.dart';

class WisataPage extends StatelessWidget {
  const WisataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Daftar Wisata Lombok Timur"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
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
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Wrap(
                      runSpacing: 8,
                      spacing: 8,
                      children: List.generate(
                          snapshot.data?.docs.length ?? 0,
                          (index) => WisataTiles(
                                data: snapshot.data?.docs[index].data(),
                              )),
                    ),
                  ),
                );
              }
              return const SizedBox();
            }),
      ),
    );
  }
}
