// import 'package:flutter/material.dart';
// import 'package:flutter_module/halo/represents/tour/features/detail/gallery_image/item_image.dart';
// class DataConvert {
//   List<double> ratios;
//   final List<double> heights;
//
//   DataConvert(this.ratios, this.heights);
// }
//
// DataConvert convertSize(List<double> list) {
//   DataConvert dt = DataConvert([], []);
//   if (list.isEmpty) {
//     return dt;
//   }
//   //Xu ly list ve so dep
//   List<double> newList = list.map((e) => e).toList();
//   newList = makeBeautiful(newList);
//
//   // Xu ly lai so
//   dt = handleShow(newList);
//   return dt;
// }
//
// DataConvert handleShow(List<double> list) {
//   List<int> numConfigs = [2, 1, 1, 1, 2, 1];
//   int index = 0;
//
//   DataConvert dt = DataConvert([], []);
//
//   final length = list.length;
//   final newList = list;
//   List<double> resultList = [];
//   List<List<double>> parentLists = [];
//
//   //Tach List
//   List<double> itemList = [];
//   for (int i = 0; i < length;) {
//     if (newList[i] == 0.75) {
//       if (itemList.isNotEmpty) {
//         parentLists.add([...itemList]);
//         itemList.clear();
//       }
//       itemList.add(newList[i]);
//       int j = i;
//       // add them nhieu nhat 3 phan tu.
//       while (++j < length && j - i < 4) {
//         itemList.add(newList[j]);
//       }
//       parentLists.add([...itemList]);
//       itemList.clear();
//       i = j;
//     } else {
//       itemList.add(newList[i++]);
//     }
//   }
//   if (itemList.isNotEmpty) {
//     parentLists.add([...itemList]);
//   }
//   itemList.clear();
//
//   // Xu ly lai
//   for (List<double> item in parentLists) {
//     //Xu li array 0.75
//     if (item.first == 0.75) {
//       if (item.length == 4) {
//         item[1] = item[2] = item[3] = 1;
//         dt.heights.add(3);
//       } else if (item.length == 3) {
//         item[0] = item[1] = item[2] = 1;
//         dt.heights.add(1);
//       } else if (item.length == 2) {
//         item[0] = item[1] = 1.5;
//         dt.heights.add(1.5);
//       } else {
//         item[0] = 3;
//         dt.heights.add(1.5);
//       }
//     }
//
//     // Xu li con lai
//     else {
//       for (int i = 0; i < item.length;) {
//         if (i == item.length - 1) {
//           item[i] = 3;
//           dt.heights.add(1.5);
//           break;
//         }
//         double li = item[i];
//         double sum = li;
//         if (sum == 3) {
//           i++;
//           continue;
//         }
//         double lj = item[i + 1];
//         if (i + 2 <= item.length - 1) {
//           double lk = item[i + 2];
//           if (li <= 1.5 && lj <= 1.5 && lk <= 1.5) {
//             item[i] = numConfigs[index++ % 6] == 2 ? 0.9 : 1;
//             item[i + 1] = 1;
//             item[i + 2] = 1;
//             dt.heights.add( item[i] == 1? 1: 2);
//             i += 3;
//             continue;
//           }
//         }
//         if (i + 1 == item.length - 1) {
//           if ((lj - li).abs() <= 0.5) {
//             item[i] = 1.5;
//             item[i + 1] = 1.5;
//             dt.heights.add(1.5);
//           } else {
//             item[i] = li > lj ? 2 : 1;
//             item[i + 1] = li > lj ? 1 : 2;
//             dt.heights.add(1);
//           }
//           break;
//         }
//         sum += lj;
//         if (sum >= 3) {
//           if ((lj - li).abs() <= 0.5) {
//             item[i] = 1.5;
//             item[i + 1] = 1.5;
//             dt.heights.add(1.5);
//           } else {
//             item[i] = li > lj ? 2 : 1;
//             item[i + 1] = li > lj ? 1 : 2;
//             dt.heights.add(1);
//           }
//           i += 2;
//           continue;
//         } else {
//           double lk = item[i + 2];
//           if (lk >= 2) {
//             item[i] = 1.5;
//             item[i + 1] = 1.5;
//             dt.heights.add(1.5);
//             if (i + 2 == item.length) {
//               break;
//             } else {
//               i += 2;
//               continue;
//             }
//           } else {
//             item[i] = numConfigs[index++ % 6] == 2 ? 0.9 : 1;
//             item[i + 1] = 1;
//             item[i + 2] = 1;
//             dt.heights.add( item[i] == 1? 1: 2);
//             if (i + 2 == item.length) {
//               break;
//             } else {
//               i += 3;
//               continue;
//             }
//           }
//         }
//       }
//     }
//
//     //gop mang
//     resultList = [...resultList, ...item];
//   }
//   dt.ratios = [...resultList];
//   resultList.clear();
//   return dt;
// }
//
// List<double> makeBeautiful(List<double> list) {
//   int length = list.length;
//   for (int i = 0; i < length; i++) {
//     if (list[i] < 0.7) {
//       list[i] = 0.75; /// ảnh cần sắp xếp dọc
//     } else if (list[i] < 1.6) {
//       list[i] = 1; /// ảnh cần hiển thị dạng hình vuông
//     } else if (list[i] < 2.6) {
//       list[i] = 2; /// ảnh cần hiển thị dạng chữ nhật 2:1
//     } else {
//       list[i] = 3; /// ảnh cần hiển thị dạng chữ nhật 3:1
//     }
//   }
//   return list;
// }
//
// int findEnd(List<double> list, double x, List<int> list2) {
//   if (list.isEmpty) {
//     return 0;
//   }
//   int min = 0;
//   int max = list.length - 1;
//   int length = list.length;
//   while (min <= max) {
//     int mid = ((min + max) / 2).floor();
//     if (x <= list[mid + 1 >= length ? length - 1 : mid + 1] && x >= list[mid]) {
//       return list2[mid + 1 >= length ? length - 1 : mid + 1] + 1;
//     } else if (x < list[mid]) {
//       max = mid - 1;
//     } else {
//       min = mid + 1;
//     }
//   }
//
//   return list2[length - 1] + 1;
// }
//
// int findStart(List<double> list, double x, List<int> list2) {
//   if (list.isEmpty) {
//     return 0;
//   }
//   int min = 0;
//   int max = list.length - 1;
//   int locate = -1;
//   while (min <= max) {
//     int mid = ((min + max) / 2).floor();
//     if (x > list[mid] && x < list[mid + 1]) {
//       locate = mid;
//       break;
//     } else if (x < list[mid]) {
//       max = mid - 1;
//     } else {
//       min = mid + 1;
//     }
//   }
//   if (locate == -1) {
//     return 0;
//   } else {
//     return list2[locate] + 1;
//   }
// }
//
//
//
//
//
// class DelegateShowList extends StatelessWidget {
//   const DelegateShowList(
//       {Key? key, required this.listImageShow, required this.ratios, required this.listGoc})
//       : super(key: key);
//   final List<String> listImageShow;
//   final List<double> ratios;
//   final List<String> listGoc;
//
//   //toDo: after handel size swap 2
//
//   @override
//   Widget build(BuildContext context) {
//     final sizeWidthDevice = MediaQuery.of(context).size.width;
//     return Wrap(children: [..._showListWidget(sizeWidthDevice, ratios)]);
//   }
//
//
//   List<Widget> _showListWidget(double sizeWidthDevice, List<double> test) {
//     List<Widget> resultList = [];
//     for (int index = 0; index < ratios.length;) {
//       double width = sizeWidthDevice / 3;
//       double height = sizeWidthDevice / 3;
//       if (test[index] == 0.75) {
//         resultList.add(
//           Row(
//             children: [
//               ItemImage(
//                 sizeWidth: sizeWidthDevice * 2 / 3,
//                 heightWidth: sizeWidthDevice,
//                 images: listGoc,
//                 index: index++
//               ),
//               Column(
//                 children: [
//                   ItemImage(
//                     sizeWidth: width,
//                     heightWidth: height,
//                     images: listGoc,
//                     index: index++
//                   ),
//                   ItemImage(
//                     sizeWidth: width,
//                     heightWidth: height,
//                     images: listGoc,
//                     index: index++
//                   ),
//                   ItemImage(
//                     sizeWidth: width,
//                     heightWidth: height,
//                     images: listGoc,
//                     index: index++
//                   ),
//                 ],
//               )
//             ],
//           ),
//         );
//       } else if (test[index] == 0.9) {
//         resultList.add(Row(
//           children: [
//             Column(
//               children: [
//                 ItemImage(
//                   sizeWidth: width,
//                   heightWidth: height,
//                   images: listGoc,
//                   index: index++,
//                 ),
//                 ItemImage(
//                   sizeWidth: width,
//                   heightWidth: height,
//                   images: listGoc,
//                   index: index++,
//                 ),
//               ],
//             ),
//             ItemImage(
//               sizeWidth: sizeWidthDevice * 2 / 3,
//               heightWidth: sizeWidthDevice * 2 / 3,
//               images: listGoc,
//               index: index++,
//             ),
//           ],
//         ));
//       } else {
//         resultList.add(
//           ItemImage(
//             sizeWidth: sizeWidthDevice / (3 / test[index]),
//             heightWidth: (test[index] == 1.5 || test[index] == 3)
//                 ? sizeWidthDevice / 2
//                 : sizeWidthDevice / 3,
//             images: listGoc,
//             index: index++,
//           ),
//         );
//       }
//     }
//     return resultList;
//   }
// }
//
// class ItemImage extends StatelessWidget {
//   final double sizeWidth;
//   final double heightWidth;
//   final List<String> images;
//   final int index;
//
//   const ItemImage({Key? key, required this.sizeWidth, required this.heightWidth, required this.images, required this.index}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
