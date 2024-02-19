import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/line_model.dart';
import 'my_paint.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<LineData> draw = [];
  Color selectedColor = Colors.white;
  double selectedWidth = 3;
  int selectedColorIndex = 0;

  List<({Color color, int index})> colors = [
    (color: Colors.white, index: 0),
    (color: Colors.red, index: 1),
    (color: Colors.blue, index: 2),
    (color: Colors.green, index: 3),
    (color: Colors.yellow, index: 4),
    (color: Colors.tealAccent, index: 5)
  ];

  void onPanStart(DragStartDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);

    draw.add(
      LineData(
        points: [point],
        color: selectedColor,
        strokeWidth: selectedWidth,
      ),
    );
    setState(() {});
  }

  void onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    draw[draw.length - 1].points.add(point);
    setState(() {});
  }

  void onPanEnd(DragEndDetails details) {
    setState(() {});
  }

  void clear() {
    setState(() {
      draw = [];
    });
  }

  void back() {
    setState(() {
      draw = draw.take(draw.length - 1).toList();
    });
  }

  void changeColor(({Color color, int index}) e) {
    selectedColor = e.color;
    selectedColorIndex = e.index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onPanStart: onPanStart,
                onPanUpdate: onPanUpdate,
                onPanEnd: onPanEnd,
                child: CustomPaint(
                  painter: MyPainter(
                    lines: [...draw],
                  ),
                ),
              ),
            ),
            Positioned(
              top: size.height - 90,
              left: size.width - 100,
              child: IconButton(
                onPressed:
                    draw.isEmpty || draw.first.points.isEmpty ? null : back,
                icon: Icon(
                  CupertinoIcons.restart,
                  color: draw.isEmpty || draw.first.points.isEmpty
                      ? Colors.grey.shade700
                      : Colors.white,
                ),
              ),
            ),
            Positioned(
              top: size.height - 90,
              left: size.width - 50,
              child: IconButton(
                onPressed: draw.isEmpty ? null : clear,
                icon: Icon(
                  Icons.delete,
                  color: draw.isEmpty ? Colors.grey.shade700 : Colors.white,
                ),
              ),
            ),
            Positioned(
              left: size.width - 50,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: colors
                    .map<Widget>(
                      (e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => changeColor(e),
                          child: CircleAvatar(
                            backgroundColor: selectedColorIndex == e.index
                                ? e.color.withOpacity(0.5)
                                : const Color(0x00000000),
                            radius: 16,
                            child: Center(
                              child: CircleAvatar(
                                radius: 13,
                                backgroundColor: e.color,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
