import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController animationController2;
  late final Animation<AlignmentGeometry> alignAnimation;
  late final Animation<double> rotateAnimation;
  late final Animation<double> rotateAnimation2;
  bool isFront = true;
  double opacity = 0;
  @override
  void initState() {
    super.initState();
    animatedControllerMethod();
    alignAnimationMethod();
    rotateAnimationMethod();
  }

  animatedControllerMethod() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    animationController2 =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
  }

  alignAnimationMethod() {
    alignAnimation = Tween<AlignmentGeometry>(
            begin: Alignment.topLeft, end: Alignment.bottomRight)
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.bounceIn));
  }

  rotateAnimationMethod() {
    rotateAnimation = Tween<double>(begin: 0, end: 0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
    rotateAnimation2 =
        Tween<double>(begin: 0, end: 0).animate(animationController2)
          ..addListener(() {
            setState(() {});
          });
  }

  void flipCard() {
    if (isFront == true) {
      animationController2.forward();
    } else {
      animationController2.reverse();
    }
    isFront = !isFront;
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        opacity = 1;
                      });
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        gradient: LinearGradient(stops: [
                          0,
                          animationController.value,
                          1
                        ], colors: const [
                          Colors.blue,
                          Colors.purple,
                          Colors.pink
                        ]),
                      ),
                    ),
                  );
                },
              ),
            ),
            AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(seconds: 2),
                child: const Text(
                  'Hello',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w500),
                )),
            SizedBox(
                height: 200,
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: const Duration(seconds: 2),
                  child: AlignTransition(
                      alignment: alignAnimation,
                      child: RotationTransition(
                        turns: rotateAnimation,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Colors.blue,
                          ),
                        ),
                      )),
                )),
            InkWell(
                onTap: () => flipCard(),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(
                          animationController2.value * math.pi),
                      child: isFront
                          ? Container(
                            color: Colors.blue,
                            child: Image.network(
                                'https://cdn.iconscout.com/icon/premium/png-512-thumb/avatar-136-116502.png?f=webp&w=512',
                                fit: BoxFit.contain,
                              ),
                          )
                          : Container(
                            color: Colors.amber,
                            child: Transform(
                              
                                transform: Matrix4.rotationY(3.14),
                                alignment: Alignment.center,
                                child: Image.network(
                                  'https://cdn.iconscout.com/icon/premium/png-512-thumb/avatar-94-116460.png?f=webp&w=512',
                                  fit: BoxFit.contain,
                                ),
                              ),
                          )),
                ))
          ],
        ),
      ),
    );
  }
}
