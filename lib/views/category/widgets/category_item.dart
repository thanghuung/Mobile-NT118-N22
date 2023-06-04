import 'package:app/AppColors.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final int countWork;
  const CategoryItem({Key? key, required this.title, required this.countWork}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      width: (MediaQuery.of(context).size.width - 24) / 2,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.bookmark_border,
                color: AppColors.pink,
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "$countWork công việc",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
