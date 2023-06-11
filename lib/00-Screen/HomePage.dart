import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_project/00-Screen/Menu.dart';
import 'package:hive_project/00-Screen/BottomSheetScreen.dart';
import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:hive_project/01-Data/User.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box box;
  late int CheckNoTasks = 0;
  late int CheckNo = 0;

  late int TotalNoTask = 0;
  int currentIndex = 0;
  final dataMap = <String, double>{
    "Flutter": 5,
  };
  @override
  void initState() {
    box = Hive.box<Map<dynamic, dynamic>>("HiveDB");
    // print(box.values);
    var list =box.values.toList();
    list.forEach((element) {
      if (element["checkbox"] == true ){
        CheckNo++;
      }else {
        if (CheckNo == 0 || CheckNo < 0) {
          CheckNo = 0;
        } else
          CheckNo--;
      } ;});
    CheckNoTasks = CheckNo;
    // TODO: implement initState
    super.initState();
  }

  void changeTitleText() {
    setState(() {
      TotalNoTask = box.values.length;

    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();
    changeTitleText();
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: BottomNavigationBar(
            unselectedItemColor: Colors.grey,
            currentIndex: currentIndex,
            onTap: (int index) {
              setState(() {
                currentIndex = index;
                if (index == 1) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Menu();
                    },
                  )).then((value) {
                    setState(() {
                      currentIndex = 0;
                    });
                  });
                }
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu")
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return BottomSheetScreen(ctx: context);
            },
          ).then((value) => changeTitleText());
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Icon(
              Icons.circle,
              size: 15,
              color: Theme.of(context).primaryColor,
            ),
            Text(
              " To do",
            )
          ],
        ),
        actions: [
          Row(
            children: [
              Text("$CheckNoTasks of $TotalNoTask Tasks",
                  style: TextStyle(color: Colors.black)),
              Container(
                  height: 50,
                  child: new AnimatedCircularChart(
                    key: _chartKey,
                    holeRadius: 10,
                    size: Size(50, 50),
                    initialChartData: <CircularStackEntry>[
                      new CircularStackEntry(
                        <CircularSegmentEntry>[
                          new CircularSegmentEntry(
                            (CheckNoTasks ==0 && TotalNoTask ==0 )? 0 :CheckNoTasks / TotalNoTask * 100,
                            Colors.deepPurple,
                            rankKey: 'completed',
                          ),
                          new CircularSegmentEntry(
                            (CheckNoTasks ==0 && TotalNoTask ==0 )? 0 :(CheckNoTasks / TotalNoTask * 100) - 100,
                            Colors.grey.withOpacity(0.2),
                            rankKey: 'remaining',
                          ),
                        ],
                        rankKey: 'progress',
                      ),
                    ],
                    chartType: CircularChartType.Radial,
                    edgeStyle: SegmentEdgeStyle.round,
                    percentageValues: true,
                  )),
            ],
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, value, child) {
          box.get(value);
          return ListView.separated(
            itemCount: value.values.length,
            itemBuilder: (context, index) {
              Map<dynamic, dynamic> mapdata = value.getAt(index);
              return Container(
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shadowColor: MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))))),
                  onPressed: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return BottomSheetScreen(
                            ctx: context,
                            idindex: index,
                            title: value.getAt(index)["title"],
                            description: value.getAt(index)["description"]);
                      },
                    );
                  },
                  child: Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        box.deleteAt(index);
                      });
                    },
                    resizeDuration: Duration(seconds: 3),
                    background: Container(
                      alignment: Alignment.lerp(
                          Alignment.topRight, Alignment.bottomCenter, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                          Text(
                            "Task deleted!",
                            style: TextStyle(color: Colors.black),
                          ),
                          Spacer(),
                          Container(
                            alignment: Alignment.centerRight,
                            child: FloatingActionButton(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                clipBehavior: Clip.none,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(width: 2),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "Undo",
                                  style: TextStyle(fontSize: 10),
                                ),
                                onPressed: () {
                                  setState(() {
                                    // box.add(value.getAt(index));
                                  });
                                }),
                          )
                        ],
                      ),
                    ),
                    child: ListTile(
                      title: Text("${mapdata["title"]}"),
                      subtitle: Text("${mapdata["description"]}"),
                      leading: Checkbox(
                        shape: CircleBorder(),
                        value: value.getAt(index)["checkbox"] ?? false,
                        onChanged: (bool? newcheck) {
                          setState(() {
                            if (value.getAt(index)["checkbox"] == false) {
                              CheckNoTasks++;
                            } else {
                              if (CheckNoTasks == 0 || CheckNoTasks < 0) {
                                CheckNoTasks = 0;
                              } else
                                CheckNoTasks--;
                            }
                            ;
                            value.getAt(index)["checkbox"] = newcheck;
                            value.putAt(index, {
                              "title": mapdata["title"],
                              "description": mapdata["description"],
                              "checkbox": newcheck
                            });
                          });
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                height: 0,
              );
            },
          );
        },
      ),
    );
  }
}
