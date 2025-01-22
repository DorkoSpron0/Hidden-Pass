import 'package:flutter/material.dart';

class ListPasswords extends StatelessWidget {

  final String titleCard;
  final String descriptionCard;
  final Image image;
  final Size size;

  const ListPasswords({
    super.key,
    required this.size,
    required this.titleCard,
    required this.descriptionCard,
    required this.image
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * .25,
      child: ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0XFF395B64).withOpacity(.2),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 50,
                  right: 50,
                  top: 10,
                  bottom: 50,
                  child: image
                ),
                Positioned(
                    bottom: 15,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titleCard,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 16),
                        ),
                        Text(
                          descriptionCard,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
