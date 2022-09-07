import 'package:flutter/material.dart';

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(
                  10,
                  (index) => const WisataTiles(
                        data: {
                          "title": "Gunung Rinjani",
                          "category": "Gunung",
                          "image": "assets/rinjani.jpg"
                        },
                      )),
            ),
          ),
        ),
      ),
    );
  }
}
