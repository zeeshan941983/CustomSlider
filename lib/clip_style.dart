import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipStyle extends StatefulWidget {
  const ClipStyle({super.key});

  @override
  State<ClipStyle> createState() => _ClipStyleState();
}

class _ClipStyleState extends State<ClipStyle> {
  List<String> images = [
    'Assets/im1.jpeg',
    'Assets/im2.jpeg',
    'Assets/im3.jpg'
  ];
  List<String> title = ['Zeeshan', 'Ahmad', 'KHan'];
  PageController? controller;
  var viewFraction = 0.8;
  double? pageOffset = 0;
  int page = 0;
  Size? size;
  Timer? timer;
  @override
  void initState() {
    controller =
        PageController(initialPage: page, viewportFraction: viewFraction)
          ..addListener(() {
            setState(() {
              pageOffset = controller!.page;
              page = pageOffset!.round();
            });
          });

    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      page = (page + 1) % images.length;
      controller!.animateToPage(
        page,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
            child: const Text(
              'WelcomBack',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  letterSpacing: 1.3,
                  height: 1.3,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
            child: const Text(
              'Custom Slider with WeZeE',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  letterSpacing: 1.3,
                  height: 1.3,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: PageView.builder(
                controller: controller,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  double scale = max(viewFraction,
                      1 - (pageOffset! - index).abs() + viewFraction);
                  double angleY = (pageOffset! - index).abs();
                  if (angleY > .5) {
                    angleY = 1 - angleY;
                  }
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, .001)
                      ..rotateY(angleY),
                    child: Material(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: size!.width * 0.04,
                            left: size!.width * 0.04,
                            top: 80 - scale * 30),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: Image.asset(
                                images[index],
                                fit: BoxFit.cover,
                                height: size!.height * 0.5,
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: angleY == 0 ? 1 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                title[index],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Positioned(
                            //     top: 0,
                            //     left: 0,
                            //     right: 0,
                            //     child: Container(
                            //       padding: const EdgeInsets.only(
                            //           top: 15, bottom: 30, left: 20, right: 20),
                            //     ))
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => _buildDot(index, page),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildDot(int index, page) {
  Color color = page == index ? Colors.black : Colors.grey;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 20,
      width: page == index ? 40 : 20,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
    ),
  );
}

AppBar _appBar() {
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    elevation: 0,
    backgroundColor: Colors.transparent,
    actions: [
      IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_rounded,
            color: Colors.black,
          )),
      IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.person,
            color: Colors.black,
          )),
    ],
  );
}

class DesignClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 500);

    path.lineTo(size.width, 0);

    //  path.quadraticBezierTo(x1, y1, x2, y2)
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class Design2Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    path.lineTo(size.width * 1.02, 300);
    path.quadraticBezierTo(0, size.width, 200, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
