import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'paintboard.dart';
import 'touch_points.dart';

class LandScape extends StatefulWidget {
  const LandScape({Key? key}) : super(key: key);

  @override
  _LandScapeState createState() => _LandScapeState();
}

class _LandScapeState extends State<LandScape> {
 bool isColorPaletteOpened = false;
  double menuItemSpace = 8.0;
  late PaintBoard board;

  void toggleColorPallete() {
    isColorPaletteOpened = !isColorPaletteOpened;
  }

  @override
  void initState() {
    super.initState();
    board = GetIt.I.get(instanceName: 'board');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (_, constraints) {
          return Stack(children: [
            GestureDetector(
              onPanUpdate: (DragUpdateDetails dragDetails) {
                setState(() {
                  if (isColorPaletteOpened) toggleColorPallete();
                  TouchPoint point = TouchPoint(dragDetails.localPosition,
                      board.getBrushColor(),board.getStrokeWidth());
                  board.addPoint(point);
                });
              },
              onPanEnd: (_) => board.addPoint(null),
              child: Container(
                  color: Colors.white,
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: CustomPaint(
                    painter: board,
                  )),
            ),
            board.hasAnyPoints()
                ? Positioned(
                    top: 16,
                    right: 16,
                    child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 120),
                        tween: Tween(begin: 0.0, end: 1.0),
                        curve: Curves.easeIn,
                        builder: (context, double val, _) {
                          return Opacity(
                            opacity: val,
                            child: FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  board.clear();
                                  board.setBrushColor(Colors.black);
                                });
                              },
                              child: const Icon(Icons.close),
                            ),
                          );
                        }),
                  )
                : Positioned(
                    top: 16,
                    right: 16,
                    child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 120),
                        tween: Tween(begin: 1.0, end: 0.0),
                        curve: Curves.easeIn,
                        builder: (context, double val, _) {
                          if (val <= 0.0) return Container();
                          return Opacity(
                            opacity: val,
                            child: FloatingActionButton(
                              onPressed: () {},
                              child: const Icon(Icons.close),
                            ),
                          );
                        }),
                  ),
            isColorPaletteOpened
                ? Positioned(
                    top: constraints.maxHeight * 0.05,
                    left: 16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // board.getStrokeWidth() < 10
                        //      Text(
                        //         '0${board.getStrokeWidth().round()}',
                        //         //style: Theme.of(context).textTheme.caption,
                        //       )
                        //     : Text(
                        //         '${board.getStrokeWidth().round()}',
                        //         //style: Theme.of(context).textTheme.caption,
                        //       ),
                        SizedBox(
                          height: constraints.maxHeight * 0.82,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Slider.adaptive(
                                min: 1.0,
                                max: board.getMaxStrokeWidth(),
                                value: board.getStrokeWidth(),
                                onChanged: (newStrokeWidth) {
                                  setState(() {
                                    board.setStrokeWidth(newStrokeWidth);
                                  });
                                }),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16.0, left: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    board.hasPoints()
                        ? TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 120),
                            tween: Tween(begin: 0.0, end: 1.0),
                            curve: Curves.easeIn,
                            builder: (context, double val, _) {
                              // if (val <= 0.0) return Container();
                              return Opacity(
                                opacity: val,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    setState(() {
                                      board.undo();
                                    });
                                  },
                                  child: const Icon(Icons.keyboard_arrow_left),
                                ),
                              );
                            })
                        : TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 120),
                            tween: Tween(begin: 1.0, end: 0.0),
                            curve: Curves.easeIn,
                            builder: (context, double val, _) {
                            //  if (val <= 0.0) return Container();
                              return Opacity(
                                opacity: val,
                                child: FloatingActionButton(
                                  onPressed: () {},
                                  child: const Icon(Icons.keyboard_arrow_left),
                                ),
                              );
                            }),
                    const SizedBox(width: 12.0),
                    board.hasUndoPoints()
                        ? TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 120),
                            tween: Tween(begin: 0.0, end: 1.0),
                            curve: Curves.easeIn,
                            builder: (context, double val, _) {
                              //if (val <= 0.0) return Container();
                              return Opacity(
                                  opacity: val,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      setState(() {
                                        board.redo();
                                      });
                                    },
                                    child:
                                        const Icon(Icons.keyboard_arrow_right),
                                  ));
                            })
                        : TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 120),
                            tween: Tween(begin: 1.0, end: 0.0),
                            curve: Curves.easeIn,
                            builder: (context, double val, _) {
                              //   if (val <= 0.0) return Container();
                              return Opacity(
                                opacity: val,
                                child: FloatingActionButton(
                                  onPressed: () {},
                                  child: const Icon(Icons.keyboard_arrow_right),
                                ),
                              );
                            })
                  ],
                ),
              ),
            ),
          ]);
        },
      ),
      floatingActionButton: isColorPaletteOpened
          ? Row(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.4),
              Expanded(
                child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        toggleColorPallete();
                        board.setBrushColor(Colors.red);
                      });
                    },
                    child: const Icon(Icons.brush, color: Colors.red)),
              ),
              SizedBox(width: menuItemSpace),
              Expanded(
                child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        toggleColorPallete();
                        board.setBrushColor(Colors.purple);
                      });
                    },
                    child: const Icon(Icons.brush, color: Colors.purple)),
              ),
              SizedBox(width: menuItemSpace),
              Expanded(
                child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        toggleColorPallete();
                        board.setBrushColor(Colors.blue);
                      });
                    },
                    child: const Icon(Icons.brush, color: Colors.blue)),
              ),
              SizedBox(width: menuItemSpace),
              Expanded(
                child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        toggleColorPallete();
                        board.setBrushColor(Colors.yellow);
                      });
                    },
                    child: const Icon(Icons.brush, color: Colors.yellow)),
              ),
              SizedBox(width: menuItemSpace),
              Expanded(
                child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        toggleColorPallete();

                        board.setBrushColor(Colors.green);
                      });
                    },
                    child: const Icon(Icons.brush, color: Colors.green)),
              ),
              SizedBox(width: menuItemSpace),
              Expanded(
                child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        toggleColorPallete();
                        board.setBrushColor(Colors.black);
                      });
                    },
                    child: const Icon(Icons.brush, color: Colors.black)),
              ),
              SizedBox(width: menuItemSpace),
              if (board.hasAnyPoints())
                Expanded(
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        toggleColorPallete();
                        board.setBrushColor(Colors.white);
                      });
                    },
                    child: Container(),
                  ),
                ),
              SizedBox(width: menuItemSpace),
              Expanded(
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      toggleColorPallete();
                    });
                  },
                  child: const Icon(Icons.close),
                ),
              ),
            ])
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  toggleColorPallete();
                });
              },
              child: const Icon(Icons.brush_outlined),
            ),
    );
  }
}
