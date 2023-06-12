import 'package:app/AppColors.dart';
import 'package:app/views/detail_groupTask/blocs/detail_group_task_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterGroupTask extends StatefulWidget {
  const FilterGroupTask({Key? key}) : super(key: key);

  @override
  State<FilterGroupTask> createState() => _FilterGroupTaskState();
}

class _FilterGroupTaskState extends State<FilterGroupTask> {
  int isSelect = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              blurRadius: 4, color: Colors.black.withOpacity(0.25), offset: const Offset(0, -4))
        ]),
        child: Column(
          children: [
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     const Text(
            //       "Không gian: ",
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //     ),
            //     Expanded(
            //       child: Wrap(
            //         children: [
            //           ItemStatus(title: "Đang đợi", isSelect: false, onPress: () {}),
            //           ItemStatus(title: "Đang làm", isSelect: false, onPress: () {}),
            //           ItemStatus(title: "Đã Xong", isSelect: false, onPress: () {}),
            //           ItemStatus(title: "Trễ", isSelect: false, onPress: () {}),
            //           ItemStatus(title: "Tất cả", isSelect: false, onPress: () {}),
            //         ],
            //       ),
            //     )
            //   ],
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Trạng thái: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Wrap(
                    children: [
                      ItemStatus(
                          title: "Tất cả",
                          isSelect: isSelect == 0,
                          onPress: () {
                            if (isSelect != 0) {
                              context.read<DetailGroupTaskBloc>().add(OnGetDataGroup());
                              setState(() {
                                isSelect = 0;
                              });
                            }
                          }),
                      ItemStatus(
                          title: "Đang đợi",
                          isSelect: isSelect == 1,
                          onPress: () {
                            if (isSelect != 1) {
                              context.read<DetailGroupTaskBloc>().add(OnGetDataGroup(status: "pending"));
                              setState(() {
                                isSelect = 1;
                              });
                            }
                          }),
                      ItemStatus(
                          title: "Đang làm",
                          isSelect: isSelect == 2,
                          onPress: () {
                            if (isSelect != 2) {
                              context.read<DetailGroupTaskBloc>().add(OnGetDataGroup(status: "process"));
                              setState(() {
                                isSelect = 2;
                              });
                            }
                          }),
                      ItemStatus(
                          title: "Đã Xong",
                          isSelect: isSelect == 3,
                          onPress: () {
                            if (isSelect != 3) {
                              context.read<DetailGroupTaskBloc>().add(OnGetDataGroup(status: "done"));
                              setState(() {
                                isSelect = 3;
                              });
                            }
                          }),
                      ItemStatus(
                          title: "Trễ",
                          isSelect: isSelect == 4,
                          onPress: () {
                            context.read<DetailGroupTaskBloc>().add(OnGetDataGroup(status: "late"));
                            if (isSelect != 4) {
                              setState(() {
                                isSelect = 4;
                              });
                            }
                          }),
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }
}

class ItemStatus extends StatelessWidget {
  final String title;
  final bool isSelect;
  final Function() onPress;
  const ItemStatus({Key? key, required this.title, required this.isSelect, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onPress();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 0, left: 4, right: 4, bottom: 8),
        width: 80,
        height: 30,
        decoration: BoxDecoration(
            color: !isSelect? AppColors.pinkSecond: AppColors.pink, borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Center(
            child: Text(
          title,
          style: const TextStyle(color: Colors.black),
        )),
      ),
    );
  }
}
