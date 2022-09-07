import 'package:flutter/material.dart';

class MenuTiles extends StatelessWidget {
  const MenuTiles({Key? key, this.data}) : super(key: key);
  final Map<String, dynamic>? data;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => data?["page"],
          )),
      child: SizedBox(
          width: (MediaQuery.of(context).size.width * .5) - 16,
          height: MediaQuery.of(context).size.width * .35,
          child: LayoutBuilder(builder: (context, size) {
            return Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      data?["image"],
                      width: size.maxHeight * .5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data?["title"] ?? "-",
                          style: const TextStyle(fontSize: 17),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.green,
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }
}
