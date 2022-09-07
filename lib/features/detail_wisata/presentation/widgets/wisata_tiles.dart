import 'package:flutter/material.dart';
import 'package:wlotim/features/wisata/presentation/widgets/category_card.dart';

class WisataTiles extends StatelessWidget {
  const WisataTiles({Key? key, this.data}) : super(key: key);
  final Map<String, dynamic>? data;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: (MediaQuery.of(context).size.width * .5) - 16,
        height: MediaQuery.of(context).size.width * .5,
        child: LayoutBuilder(builder: (context, size) {
          return Card(
            clipBehavior: Clip.antiAlias,
            elevation: 3,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.asset(
                        data?["image"],
                      ).image)),
              child: Column(
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
                          data?["title"] ?? "-",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }));
  }
}
