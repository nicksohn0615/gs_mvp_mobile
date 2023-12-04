import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
//
// void main() {
//   runApp(AnimationsDemo());
// }
//
// class AnimationsDemo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Animations Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//       ),
//       home: ContainerTransformDemo(),
//     );
//   }
// }

class ContainerTransformDemo extends StatefulWidget {
  const ContainerTransformDemo({Key? key}) : super(key: key);

  @override
  _ContainerTransformDemoState createState() {
    return _ContainerTransformDemoState();
  }
}

class _ContainerTransformDemoState extends State<ContainerTransformDemo> {
  ContainerTransitionType _transitionType = ContainerTransitionType.fadeThrough;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Container transform demo'),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: 2,
        children: <Widget>[
          ...List<Widget>.generate(10, (int index) {
            return OpenContainer<bool>(
              openShape: const RoundedRectangleBorder(),
              transitionDuration: Duration(milliseconds: 500),
              transitionType: _transitionType,
              openBuilder: (BuildContext _, VoidCallback openContainer) {
                return _DemoDetailsPage();
              },
              closedShape: const RoundedRectangleBorder(),
              closedElevation: 0.0,
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  // Define how the card's content should be clipped
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  // Define the child widget of the card
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Add padding around the row widget
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Add an image widget to display an image
                            Image.asset(
                              'assets/images/opencontainer.jpg',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            // Add some spacing between the image and the text
                            Container(width: 20),
                            // Add an expanded widget to take up the remaining horizontal space
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // Add some spacing between the top of the card and the title
                                  Container(height: 5),
                                  // Add a title widget
                                  Text(
                                    "Cards Title ${index + 1}",
                                    // style: MyTextSample.title(context)!.copyWith(
                                    //   color: MyColorsSample.grey_80,
                                    // ),
                                  ),
                                  // Add some spacing between the title and the subtitle
                                  Container(height: 5),
                                  // Add a subtitle widget
                                  Text(
                                    "Sub title",
                                    // style: MyTextSample.body1(context)!.copyWith(
                                    //   color: Colors.grey[500],
                                    // ),
                                  ),
                                  // Add some spacing between the subtitle and the text
                                  Container(height: 10),
                                  // Add a text widget to display some text
                                  Text(
                                    'test',
                                    maxLines: 2,
                                    // style: MyTextSample.subhead(context)!.copyWith(
                                    //   color: Colors.grey[700],
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );

                //   ListTile(
                //   onTap: openContainer,
                //   title: Text('Title item ${index + 1}'),
                //   subtitle: const Text('subtitle text'),
                // );
              },
            );
          }),
        ],
      ),
    );
  }
}

class _DemoDetailsPage extends StatelessWidget {
  const _DemoDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return
        // SizedBox(
        //   width: 100,
        //   height: 100,
        //   child: Text('test'),
        // );

        Scaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: Container(
                child: Text('test'),
              ),
            ));
  }
}

//
// class _DemoDetailsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Demo details page'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   'Title',
//                   // style: Theme.of(context).textTheme.headline5.copyWith(
//                   //       color: Colors.black54,
//                   //       fontSize: 30.0,
//                   //     ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   'Demo details page',
//                   // style: Theme.of(context).textTheme.bodyText2.copyWith(
//                   //       color: Colors.black54,
//                   //       height: 1.5,
//                   //       fontSize: 16.0,
//                   //     ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
