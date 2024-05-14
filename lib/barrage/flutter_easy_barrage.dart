import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';

class EasyBarrage extends StatefulWidget {
  final double width;
  final double height;

  final int rowNum;

  /// 行轨道之间的行间距高度
  final double rowSpaceHeight;

  ///一行中，每个item的水平间距宽度
  final double itemSpaceWidth;
  final Duration duration;

  ///是否随机
  final bool randomItemSpace;
  final EasyBarrageController controller;

  ///弹幕从某个位置开始出现，默认是0
  final double originStart;

  /// 轨道下标：对应轨道弹幕延迟出现的时间
  final Map<int, Duration>? channelDelayMap;

  /// 默认从右到左
  final TransitionDirection direction;

  EasyBarrage({
    Key? key,
    required this.width,
    required this.height,
    required this.controller,
    this.itemSpaceWidth = 45,
    this.rowNum = 3,
    this.channelDelayMap,
    this.originStart = 0,
    this.direction = TransitionDirection.rtl,
    this.randomItemSpace = false,
    this.duration = const Duration(seconds: 5),
    this.rowSpaceHeight = 10,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EasyBarrageState();
  }
}

class EasyBarrageState extends State<EasyBarrage> {
  List<BarrageLineController> controllers = [];
  late EasyBarrageController _controller;
  final Random _random = Random();

  Timer? _timeline;

  @override
  void initState() {
    _controller = widget.controller;
    _timeline = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      for (var element in controllers) {
        element.tick();
      }
    });
    _controller.addListener(handleBarrages);
    var rows = widget.rowNum;
    for (int i = 0; i < rows; i++) {
      BarrageLineController barrageController = BarrageLineController();
      controllers.add(barrageController);
    }

    _controller.speedNotify.addListener(() {
      controllers.forEach((element) {
        element.updateSpeed(_controller.speedNotify.value);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    releaseTimeLine();
    controllers.clear();
    super.dispose();
  }

  void handleBarrages() {
    double totalSpaceWidth = (widget.rowNum - 1) * widget.itemSpaceWidth;
    _controller.totalMapBarrageItems.forEach((key, value) {
      BarrageLineController ctrl = controllers[key];
      dispatch(ctrl, value, key, _controller.slideWidth + totalSpaceWidth);
    });

    if (_controller.totalBarrageItems.isNotEmpty) {
      for (int i = 0; i < controllers.length; i++) {
        List<BarrageItem> templist = [];
        templist.addAll(_controller.totalBarrageItems);
        dispatch(controllers[i], templist, i, _controller.slideWidth + totalSpaceWidth);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [...barrageLines()],
      ),
    );
  }

  List<Widget> barrageLines() {
    List<Widget> list = [];
    int rows = widget.rowNum;
    double height = ((widget.height - (rows - 1) * (widget.rowSpaceHeight)) / rows);
    for (int i = 0; i < rows; i++) {
      list.add(BarrageLine(
        direction: widget.direction,
        controller: controllers[i],
        fixedWidth: widget.width,
        itemSpaceWidth: widget.itemSpaceWidth,
        originStart: widget.originStart,
        height: height,
        duration: widget.duration,
      ));
      if (i != rows - 1) {
        list.add(SizedBox(
          height: widget.rowSpaceHeight,
        ));
      }
    }
    return list;
  }

  void _randTrigger(BarrageLineController ctrl, List<BarrageItem> value, double slideWidth) {
    if (_random.nextBool()) {
      Future.delayed(Duration(milliseconds: _random.nextInt(800)), () {
        ctrl.trigger(value, slideWidth);
      });
    } else {
      ctrl.trigger(value, slideWidth);
    }
  }

  void dispatch(BarrageLineController ctrl, List<BarrageItem> value, int channelIndex, double slideWidth) {
    if (widget.channelDelayMap != null) {
      Duration? duration = widget.channelDelayMap![channelIndex];
      if (duration != null) {
        Future.delayed(duration, () {
          ctrl.trigger(value, slideWidth);
        });
      } else {
        _randTrigger(ctrl, value, slideWidth);
      }
    } else {
      _randTrigger(ctrl, value, slideWidth);
    }
  }

  void releaseTimeLine() {
    _timeline?.cancel();
    _timeline = null;
  }
}

class EasyBarrageController extends ValueNotifier<BarrageItemValue> {
  List<BarrageItem> totalBarrageItems = [];
  HashMap<int, List<BarrageItem>> totalMapBarrageItems = HashMap<int, List<BarrageItem>>();
  ValueNotifier<Duration> speedNotify=ValueNotifier<Duration>(Duration.zero);
  double slideWidth = 0;

  EasyBarrageController() : super(BarrageItemValue());

  void sendBarrage(List<BarrageItem> items) {
    clearCache();
    totalBarrageItems.addAll(items);

    double maxW = 0;
    double totalW = 0;
    for (var element in totalBarrageItems) {
      maxW = max(maxW, element.itemWidth);
      totalW += element.itemWidth;
    }
    slideWidth = totalW;
    value = BarrageItemValue(widgets: totalBarrageItems, slideWidth: slideWidth);
  }

  void sendChannelMapBarrage(HashMap<int, List<BarrageItem>>? channelMapItems) {
    if (channelMapItems != null) {
      clearCache();
      totalMapBarrageItems.addAll(channelMapItems);
      double totalWidth = 0;
      double originmaxW = 0;
      totalMapBarrageItems.forEach((key, value) {
        double totalW = 0;
        for (var element in value) {
          originmaxW = max(originmaxW, element.itemWidth);
          totalW += element.itemWidth;
        }
        totalWidth = max(totalWidth, totalW);
      });
      slideWidth = totalWidth;

      value = BarrageItemValue(mapItems: totalMapBarrageItems, slideWidth: slideWidth);
    }
  }

  void stop() {
    ///todo
  }

  void clearCache() {
    totalMapBarrageItems.clear();
    totalBarrageItems.clear();
  }

  void updateSpeed(Duration duration) {
    speedNotify.value=duration;
  }

}

typedef HandleComplete = void Function();

class BarrageLine extends StatefulWidget {
  const BarrageLine(
      {required this.controller,
      Key? key,
      // this.bgchild,
      this.duration = const Duration(seconds: 5),
      this.onHandleComplete,
      this.itemSpaceWidth = 45,
      this.randomItemSpace = false,
      this.originStart = 0,
      required this.fixedWidth,
      required this.height,
      this.direction = TransitionDirection.rtl})
      : super(key: key);

  final double height;

  final  bool randomItemSpace;
  final double itemSpaceWidth;

  /// 平移时间（秒）
  ///
  final Duration duration;

  final double originStart;

  ///弹幕展示的宽度
  final double fixedWidth;
  final  BarrageLineController controller;

  ///
  /// 平移方向
  final TransitionDirection direction;
  final HandleComplete? onHandleComplete;

  getComplete() {}

  @override
  State<StatefulWidget> createState() => _BarrageLineState();
}

class _BarrageLineState extends State<BarrageLine> with TickerProviderStateMixin {
  // double _width = 0;
  // double _height = 0;
  late BarrageLineController controller;
  final Random _random = Random();
  bool hasCalled = false;

  @override
  void initState() {
    controller = widget.controller;
    controller.addListener(handleBarrages);
    controller.tickNotifier.addListener(() {
      handleWaitingBarrages();
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.destroy();
    controller.removeListener(handleBarrages);
    super.dispose();
  }

  void handleBarrages() {}

  void handleWaitingBarrages() {
    double originStart = widget.originStart;

    if (controller.hasNoItem()) {
      if (!hasCalled) {
        widget.onHandleComplete?.call();
        controller._tickCont=1;
        hasCalled = true;
      }
      return;
    }
    hasCalled = false;
    if (!controller.hasExtraSpace(
        widget.randomItemSpace ? (_random.nextInt((widget.itemSpaceWidth + originStart).toInt())).toDouble() : (widget.itemSpaceWidth + originStart),
        widget.direction)) {
      return;
    }
    var element = controller.next();
    // double childWidth = controller.maxWidth;

    controller.lastBarrage(element.id, widget.fixedWidth);
    var duration=widget.duration;
    Duration? dynamicDuration=controller.dynamicDuration;
    if(dynamicDuration!=null){
      duration=dynamicDuration;
    }
    Animation<double> animation;
    AnimationController animationController = AnimationController(duration: duration, vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.barrageItems.removeWhere((element2) => element2.id == element.id);
        }
      });

    var begin = originStart;
    var end = widget.fixedWidth * 2; // 暂时设置为展示宽度的2倍,理论上应该是 fixedWidth+widget本身的长度。这样可以保证速度一致。
    // var end = widget.fixedWidth + childWidth + originStart; // 精准！但是有个问题，如果每次的弹幕宽度不一致，会导致速度不一样
    animation = Tween(begin: begin, end: end).animate(animationController..forward());

    var widgetBarrage = AnimatedBuilder(
      animation: animation,
      child: element.item,
      builder: (BuildContext context, Widget? child) {
        if (animation.isCompleted) {
          controller.updateLastItemPosition(BarrageItemPosition(animationValue: double.infinity, id: element.id));
          return const SizedBox();
        }
        double widgetWidth = 0.0;

        if (child != null) {
          RenderObject? renderBox = context.findRenderObject();
          if (renderBox != null) {
            var rb = renderBox as RenderBox;
            if (rb.hasSize == true) {
              widgetWidth = renderBox.size.width;
              if (widgetWidth > 0 && animation.value >= (widget.fixedWidth + widgetWidth - 2)) {
                controller.updateLastItemPosition(BarrageItemPosition(id: element.id, animationValue: double.infinity));
                return const SizedBox();
              }
            }
          }
        }

        var widthPos = widget.fixedWidth - animation.value;
        if (widget.direction == TransitionDirection.rtl) {
          widthPos = widget.fixedWidth - animation.value;
        } else if (widget.direction == TransitionDirection.ltr) {
          widthPos = animation.value - element.itemWidth;
        }
        controller.updateLastItemPosition(BarrageItemPosition(animationValue: animation.value, id: element.id, widgetWidth: widgetWidth));
        const heightPos = .0;
        return Transform.translate(
          offset: Offset(widthPos, heightPos),
          child: child,
        );
      },
    );
    controller.widgets.putIfAbsent(animationController, () => widgetBarrage);
    if(mounted){
      setState(() {});
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.height,
      // color: Colors.black12,
      child: LayoutBuilder(builder: (_, snapshot) {
        // _width = widget.fixedWidth ?? snapshot.maxWidth;
        // _height = widget.height ?? snapshot.maxHeight;
        return Stack(
            fit: StackFit.expand,
            // alignment: Alignment.centerLeft,
            children: <Widget>[
              // widget.child,
              Stack(fit: StackFit.loose, alignment: Alignment.centerLeft, children: <Widget>[...controller.widgets.values]),
            ]);
      }),
    );
  }
}

class BarrageLineController extends ValueNotifier<BarrageItemValue> {
  List<BarrageItem> barrageItems = [];
  double maxWidth = 0;

  Map<AnimationController, Widget> get widgets => _widgets;
  BarrageItemPosition? _itemPosition;

  final Map<AnimationController, Widget> _widgets = {};

  BarrageLineController() : super(BarrageItemValue());

  ValueNotifier<int> get tickNotifier => _tickNotifier;
  final ValueNotifier<int> _tickNotifier = ValueNotifier(0);
  Duration? dynamicDuration;
  int _tickCont = 1;

  void trigger(List<BarrageItem> items, double localMaxWidth) {
    barrageItems.addAll(items);
    maxWidth = localMaxWidth;

    value = BarrageItemValue(widgets: barrageItems);
  }

  void updateLastItemPosition(BarrageItemPosition itemPosition) {
    if (_itemPosition?.id == itemPosition.id) {
      _itemPosition?.animationValue = itemPosition.animationValue;
      _itemPosition?.widgetWidth = itemPosition.widgetWidth;
    }
  }

  bool hasExtraSpace(double itemSpaceWidth, TransitionDirection direction) {
    return _itemPosition == null || ((_itemPosition!.animationValue) > (_itemPosition!.widgetWidth + itemSpaceWidth));
  }

  void destroy() {
    dispose();
    _tickCont = 0;
    widgets.forEach((key, value) {
      key.dispose();
    });
    widgets.clear();
    barrageItems.clear();
    tickNotifier.dispose();
  }

  void lastBarrage(String itemId, double fixedWidth) {
    _itemPosition ??= BarrageItemPosition(id: itemId);
    _itemPosition!.id = itemId;
    _itemPosition!.fixedWidth = fixedWidth;
  }

  void tick() {
    widgets.removeWhere((controller, widget) {
      if (controller.isCompleted) {
        controller.dispose();
        return true;
      }
      return false;
    });

    tickNotifier.value = _tickCont++;
  }

  bool hasNoItem() {
    return barrageItems.isEmpty;
  }

  BarrageItem next() {
    return barrageItems.removeAt(0);
  }

  void updateSpeed(Duration value) {
    dynamicDuration=value;
  }

}

class BarrageItemPosition {
  double animationValue = 0, fixedWidth = 0, widgetWidth = 0;
  String id;

  BarrageItemPosition({this.animationValue = 0, this.fixedWidth = 0, this.widgetWidth = 0, required this.id});
}

class BarrageItemValue {
  List<BarrageItem>? widgets;
  HashMap<int, List<BarrageItem>>? mapItems;

  double slideWidth; //用来计算行程

  BarrageItemValue({this.widgets, this.mapItems, this.slideWidth = 0});
}

class BarrageItem {
  Widget item;
  double itemWidth;
  String id = "";
  final Random _random = Random();

  BarrageItem({required this.item, required this.itemWidth}) {
    id = "${DateTime.now().toIso8601String()}:${_random.nextInt(1000)}";
  }
}

enum TransitionDirection {
  ///
  /// 从左到右
  ///
  ltr,

  ///
  /// 从右到左
  ///
  rtl,

  ///
  /// 从上到下
  ///
  // ttb, todo

  ///
  /// 从下到上
  ///
  // btt todo
}
