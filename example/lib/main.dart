import 'package:flutter/material.dart';
import 'package:quick_interact/quick_interact.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Interact Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Interact Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'long press icons to activate Quick Interact and hover and release.',
            ),
            const SizedBox(
              height: 100,
            ),
            Center(
              child: QuickInteractions(
                quickInteractionWidgets: const [
                  Icon(Icons.thumb_up),
                  Icon(Icons.thumb_down),
                  Icon(Icons.favorite),
                  Icon(Icons.bookmark),
                ],
                onQuickInteractCompleted: (index) {
                  print('Quick interaction selected: $index');
                },
                toolTip: const Text('Long press \nfor the quick interaction'),
                showToolTipDelay: const Duration(seconds: 1),
                config: const QuickInteractConfig(),
                child: const Icon(Icons.send),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      iconQuickReaction(
                        config: const QuickInteractConfig(),
                      ),
                      iconQuickReaction(
                        config: const QuickInteractConfig.onlyScale(),
                      ),
                      iconQuickReaction(
                        config: const QuickInteractConfig.onlyTransition(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      userAvatarQuickReaction(
                        config: const QuickInteractConfig(),
                      ),
                      userAvatarQuickReaction(
                        config: const QuickInteractConfig.onlyScale(),
                      ),
                      userAvatarQuickReaction(
                        config: const QuickInteractConfig.onlyTransition(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userAvatarQuickReaction({required QuickInteractConfig config}) {
    return Center(
      child: QuickInteractions(
        quickInteractionWidgets: const [
          CircleAvatar(
            radius: 15,
            backgroundImage:
                NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
          ),
          CircleAvatar(
            radius: 15,
            backgroundImage:
                NetworkImage('https://randomuser.me/api/portraits/women/2.jpg'),
          ),
          CircleAvatar(
            radius: 15,
            backgroundImage:
                NetworkImage('https://randomuser.me/api/portraits/men/3.jpg'),
          ),
          CircleAvatar(
            radius: 15,
            backgroundImage:
                NetworkImage('https://randomuser.me/api/portraits/women/4.jpg'),
          ),
        ],
        onQuickInteractCompleted: (index) {
          print('Quick interaction selected: $index');
        },
        animate: true,
        config: config,
        showToolTipDelay: const Duration(milliseconds: 300),
        child: const Icon(Icons.send),
      ),
    );
  }

  Widget iconQuickReaction({required QuickInteractConfig config}) {
    return QuickInteractions(
      quickInteractionWidgets: const [
        Icon(Icons.thumb_up),
        Icon(Icons.thumb_down),
        Icon(Icons.favorite),
        Icon(Icons.bookmark),
      ],
      onQuickInteractCompleted: (index) {
        print('Quick interaction selected: $index');
      },
      config: config,
      child: const Icon(Icons.send),
    );
  }
}
