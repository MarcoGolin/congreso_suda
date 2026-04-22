import 'package:flutter/material.dart';

class CustomSearchBuild extends StatelessWidget {
  final List<dynamic> list;
  final ScrollController scrollCTRL;
  final Widget Function(dynamic data, int index)? itemBuilder;
  final Function(dynamic) onTap;
  const CustomSearchBuild({
    super.key,
    required this.list,
    required this.scrollCTRL,
    this.itemBuilder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollCTRL,
      itemBuilder: (_, index) {
        var data = list[index];

        if (itemBuilder != null) {
          return itemBuilder!(data, index);
        }

        return ListTile(
          title: Text(data.title),
          subtitle: data.subTitle != null ? Text(data.subTitle!) : null,
          onTap: () {
            onTap(data);
          },
        );
      },
      itemCount: list.length,
    );
  }
}
