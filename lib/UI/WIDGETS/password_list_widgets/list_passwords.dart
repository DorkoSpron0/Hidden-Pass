import 'package:flutter/material.dart';

class ListPasswords extends StatelessWidget {
  const ListPasswords({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * .3,
      child: ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0XFF5D5D5D),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 50,
                  right: 50,
                  top: 50,
                  bottom: 50,
                  child: Image.asset('assets/images/LogoSimple.png'),
                ),
                Positioned(
                    bottom: 15,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "AAAAAAAAAAAA",
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 16),
                        ),
                        Text(
                          "BBBBBBBBBBBB",
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
