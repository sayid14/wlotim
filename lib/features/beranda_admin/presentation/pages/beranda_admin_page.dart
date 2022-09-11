import 'package:flutter/material.dart';
import 'package:wlotim/features/maps_wisata/presentation/pages/maps_wisata_page.dart';
import 'package:wlotim/features/profil/presentation/pages/profil_page.dart';
import 'package:wlotim/features/wisata_admin/presentation/pages/wisata_admin_page.dart';

import '../widgets/menutiles.dart';

class BerandaAdminPage extends StatefulWidget {
  const BerandaAdminPage({Key? key}) : super(key: key);

  @override
  State<BerandaAdminPage> createState() => _BerandaAdminPageState();
}

class _BerandaAdminPageState extends State<BerandaAdminPage> {
  List<Map<String, dynamic>> data = [
    {
      "title": "Wisata",
      "image": "assets/ic_destination.png",
      "page": WisataAdminPage(),
    },
    {
      "title": "Maps",
      "image": "assets/map.png",
      "page": const MapsWisataPage(),
    },
    {
      "title": "Berita",
      "image": "assets/news-report.png",
      "page": null,
    },
    {
      "title": "Profil",
      "image": "assets/user.png",
      "page": const ProfilPage(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset("assets/rinjani.jpg"),
              Positioned(
                left: 0,
                right: 0,
                bottom: -50,
                child: Center(
                  child: SizedBox(
                      // height: 100,
                      width: MediaQuery.of(context).size.width * .95,
                      child: Card(
                        clipBehavior: Clip.none,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      const SizedBox(
                                        width: 150,
                                        height: 30,
                                      ),
                                      Positioned(
                                        top: -100,
                                        child: SizedBox(
                                          width: 150,
                                          height: 150,
                                          child: Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                  "assets/logo.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Expanded(
                                    child: Text(
                                      "Admin",
                                      // maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.schedule,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text("Rabu, 7 September 2022")
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              "Dashboard",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Wrap(
                  runSpacing: 8,
                  spacing: 8,
                  children: List.generate(
                      data.length,
                      (index) => MenuTiles(
                            data: data[index],
                          )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
