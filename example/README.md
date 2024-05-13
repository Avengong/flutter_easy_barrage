# flutter_easy_barrage

A very easy barrage wall  to use!

一个非常简单易用的flutter弹幕组件！

## Getting Started

> EasyBarrage 需要明确弹幕展示的 width 和 height 来计算可用空间。


## 为什么要是它？
1. 可精准控制弹幕轨道间的间距
2. 可精准控制每个弹幕间的间距
3. 支持自定义轨道延迟出现时间
4. 支持弹幕起始位置的定制
5. 支持从左到右，从右到左，当然后续还可以继续支持上到下之类

#### EasyBarrage 参数

* **EasyBarrageController controller** - 弹幕控制器，用来发送批量、单个弹幕
* **double itemSpaceWidth** - 同一弹幕轨道中，每个item的水平间距宽度，默认45
* **bool randomItemSpace** - 根据给定的itemSpaceWidth，决定是否随机设置弹幕的间距。false表示使用固定的itemSpaceWidth，true表示随机
* **Duration duration** - 弹幕动画时间，默认为5s
* **int rowNum** - 弹幕轨道数，默认为3
* **double originStart** - 动画从举例屏幕的哪个位置开始，默认0，表示从屏幕的边缘开始
* **double width** - 弹幕宽度
* **double height** - 弹幕高度
* **TransitionDirection  direction** - 弹幕的方向，支持从左到右，从右到左
* **Map<int, Duration>? channelDelayMap;** - 轨道下标 ：对应轨道弹幕延迟出现的时间，用来强行指定每个轨道弹幕的延迟出现时机，不设置则默认为随机出现
* **double rowSpaceHeight** - 弹幕轨道间的间距。

[more examples - 详细用法请查看 examples](https://github.com/Avengong/flutter_easy_barrage/blob/master/lib/main.dart)

* show barrage easy!

```flutter
EasyBarrage(
  controller: controller,
  randomItemSpace: false,
  duration: const Duration(milliseconds: 5300),
  width: MediaQuery.of(context).size.width,
  height: 245,
  rowNum: 3,
  originStart: 0,
  itemSpaceWidth: 45,
  direction: TransitionDirection.ltr,
  channelDelayMap: channelDelayMap,
  rowSpaceHeight: 2.5,
),

```

* send barrage function

```flutter
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
         // 支持以map形式发送弹幕
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
        // 支持以 list 形式发送弹幕
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
        // 支持以 单个 形式发送弹幕
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
  ],
),
```


