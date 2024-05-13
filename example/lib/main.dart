import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_easy_barrage/barrage/easy_barrage.dart';
import 'package:flutter_easy_barrage/flutter_easy_barrage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterEasyBarragePlugin = FlutterEasyBarrage();

  EasyBarrageController controller = EasyBarrageController();

  Map<int, Duration> channelDelayMap = HashMap();

  @override
  void initState() {
    // channelDelayMap[0] = Duration.zero;
    // channelDelayMap[1] = const Duration(milliseconds: 600);
    // channelDelayMap[2] = const Duration(milliseconds: 300);
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _flutterEasyBarragePlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body:
            Column(children: [

              EasyBarrage(
                controller: controller,
                randomItemSpace: false,
                duration: const Duration(milliseconds: 5300),
                width: MediaQuery.of(context).size.width,
                height: 245,
                rowNum: 3,
                originStart: 0,
                itemSpaceWidth: 45,
                direction: TransitionDirection.rtl,
                channelDelayMap: channelDelayMap,
                rowSpaceHeight: 2.5,
              ),

              Row(
                children: [
                  ElevatedButton(
                    child: Text("sendMap"),
                    onPressed: () {
                      HashMap<int, List<BarrageItem>> mapItems = HashMap<int, List<BarrageItem>>();
                      List<BarrageItem> list0 = [];

                      for (int i = 0; i < 5; i++) {
                        double width = 80;
                        double height = 80;
                        if (i % 2 == 0) {
                        } else {
                          width = 40;
                          height = 40;
                        }
                        list0.add(BarrageItem(
                          item: Container(
                            alignment: Alignment.centerLeft,
                            height: width,
                            width: height,
                            color: Colors.green,
                            child: Text(
                              "a11111--${i}",
                              style: TextStyle(fontSize: 10, decoration: TextDecoration.none),
                            ),
                          ),
                          itemWidth: width,
                        ));
                        print("list0  i:$i ,va:${i % 2} width:$width, height:$height");
                      }

                      mapItems.putIfAbsent(0, () => list0);

                      List<BarrageItem> list1 = [];
                      for (int i = 0; i < 5; i++) {
                        double width = 80;
                        double height = 80;
                        if (i % 2 == 0) {
                          width = 40;
                          height = 40;
                        } else {}
                        list1.add(BarrageItem(
                          item: Container(
                            alignment: Alignment.centerLeft,
                            height: width,
                            width: height,
                            color: Colors.green,
                            child: Text(
                              "a11111--${i}",
                              style: TextStyle(fontSize: 10, decoration: TextDecoration.none),
                            ),
                          ),
                          itemWidth: width,
                        ));
                      }
                      mapItems.putIfAbsent(1, () => list1);

                      List<BarrageItem> list2 = [];
                      for (int i = 0; i < 5; i++) {
                        double width = 80;
                        double height = 80;
                        if (i % 2 == 0) {
                        } else {
                          width = 40;
                          height = 40;
                        }
                        list2.add(BarrageItem(
                          item: Container(
                            alignment: Alignment.center,
                            height: width,
                            width: height,
                            color: Colors.green,
                            child: Text(
                              "$width x $height === ${i}",
                              style: TextStyle(fontSize: 10, decoration: TextDecoration.none),
                            ),
                          ),
                          itemWidth: width,
                        ));
                      }
                      mapItems.putIfAbsent(2, () => list2);

                      controller.sendChannelMapBarrage(mapItems);
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    child: Text("sendlist"),
                    onPressed: () {
                      List<BarrageItem> list = [];

                      for (int i = 0; i < 5; i++) {
                        double width = 80;
                        double height = 80;
                        if (i % 2 == 0) {
                        } else {
                          width = 40;
                          height = 40;
                        }
                        list.add(BarrageItem(
                          item: Container(
                            alignment: Alignment.centerLeft,
                            height: width,
                            width: height,
                            color: Colors.green,
                            child: Text(
                              "b11111--${i}",
                              style: TextStyle(fontSize: 10, decoration: TextDecoration.none),
                            ),
                          ),
                          itemWidth: width,
                        ));
                        print("list0  i:$i ,va:${i % 2} width:$width, height:$height");
                      }

                      controller.sendBarrage([...list]);
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    child: Text("sendSingle"),
                    onPressed: () {
                      double width=80;
                      double height=80;

                      controller.sendBarrage([BarrageItem(
                        item: Container(
                          alignment: Alignment.centerLeft,
                          height: width,
                          width: height,
                          color: Colors.green,
                          child: Text(
                            "b--single",
                            style: TextStyle(fontSize: 10, decoration: TextDecoration.none),
                          ),
                        ),
                        itemWidth: width,
                      )]);

                    },
                  ),
                  // ElevatedButton(
                  //   child: Text("stop"),
                  //   onPressed: () {
                  //     controller.stop();
                  //   },
                  // ),
                ],
              ),

              Center(
                child: Text('Running on: $_platformVersion\n'),
              ),
            ],)


      ),
    );
  }
}
