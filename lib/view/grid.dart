import 'package:flutter/material.dart';
// import staggered grid v 0.7.0
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MyGridView extends StatefulWidget {
  const MyGridView({super.key});

  @override
  State<MyGridView> createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  List<String> isi = [
    "hallo",
    "hallo Bandung",
    "ibu kota",
    "periangan",
    "hallo",
    "hallo Bandung",
    "kota kenang kenangan",
    "sudah lama beta",
    "tidak berjumpa",
    "dengan kau",
    "sekarang",
    "sudah menjadi",
    "lautan api",
    "mari bung",
    "rebut kembali"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: List.generate(isi.length, (index) => ExpandableStaggeredTile(message: isi[index])),
            // children: const [
            //   ExpandableStaggeredTile(message: "hallo"),
            //   ExpandableStaggeredTile(message: "hallo Bandung"),
            //   ExpandableStaggeredTile(message: "ibu kota"),
            //   ExpandableStaggeredTile(message: "periangan"),
            //   ExpandableStaggeredTile(message: "hallo"),
            //   ExpandableStaggeredTile(message: "hallo Bandung"),
            //   ExpandableStaggeredTile(message: "kota kenang kenangan"),
            //   ExpandableStaggeredTile(message: "sudah lama beta"),
            //   ExpandableStaggeredTile(message: "tidak berjumpa"),
            //   ExpandableStaggeredTile(message: "dengan kau"),
            //   ExpandableStaggeredTile(message: "sekarang"),
            //   ExpandableStaggeredTile(message: "sudah menjadi"),
            //   ExpandableStaggeredTile(message: "lautan api"),
            //   ExpandableStaggeredTile(message: "mari bung"),
            //   ExpandableStaggeredTile(message: "rebut kembali"),
            // ],
          ),
        ),
      ),
    );
  }
}

class ExpandableStaggeredTile extends StatefulWidget {
  final String message;
  const ExpandableStaggeredTile({super.key, required this.message});

  @override
  State<ExpandableStaggeredTile> createState() =>
      _ExpandableStaggeredTileState();
}

class _ExpandableStaggeredTileState extends State<ExpandableStaggeredTile> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return StaggeredGridTile.count(
      crossAxisCellCount: isExpanded ? 2 : 1,
      mainAxisCellCount: isExpanded ? 2 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                widget.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// animatedVersion
// class _ExpandableStaggeredTileState extends State<ExpandableStaggeredTile> {
//   bool isExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300), // Animation duration
//       curve: Curves.easeInOut, // Animation curve
//       width: isExpanded ? 200.0 : 100.0, // Adjust the width based on isExpanded
//       height:
//           isExpanded ? 100.0 : 50.0, // Adjust the height based on isExpanded
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             setState(() {
//               isExpanded = !isExpanded;
//             });
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.blue[300],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Center(
//               child: Text(
//                 widget.message,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
