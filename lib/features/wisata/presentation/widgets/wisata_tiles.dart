import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wlotim/core/core.dart';
import 'package:wlotim/features/wisata/presentation/widgets/category_card.dart';

import '../../../detail_wisata/presentation/pages/detail_wisata_page.dart';

class WisataTiles extends StatelessWidget {
  const WisataTiles({Key? key, this.data}) : super(key: key);
  final Map<String, dynamic>? data;
  ImageProvider image() {
    try {
      final i = base64Decode(data?["image"]);
      return Image.memory(i).image;
    } catch (e) {
      return const AssetImage("assets/broken_image.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailWisataPage(data: data),
          )),
      child: SizedBox(
          width: (MediaQuery.of(context).size.width * .5) - 16,
          height: MediaQuery.of(context).size.width * .5,
          child: LayoutBuilder(builder: (context, size) {
            return Card(
              clipBehavior: Clip.antiAlias,
              elevation: 3,
              child: Stack(
                children: [
                  SizedBox(
                      height: size.maxHeight,
                      child: ImageNetWork(
                        data?["image"] ?? "",
                        fit: BoxFit.cover,
                      )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: CategoryCard(
                            width: size.maxWidth * .5,
                            category: data?["category"],
                          )),
                      Container(
                        width: size.maxWidth,
                        color: Colors.black.withOpacity(0.6),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              data?["nama"] ?? "-",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          })),
    );
  }
}
