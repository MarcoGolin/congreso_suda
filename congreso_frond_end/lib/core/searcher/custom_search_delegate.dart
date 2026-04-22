import 'dart:async';

import 'package:flutter/material.dart';

class CustomSearch extends StatefulWidget {
  final String? label;
  final String? foto;
  final dynamic selected;
  final TextEditingController? controller;
  final List<dynamic>? list;
  final Future<List<dynamic>> Function(String)? search;
  final Function(dynamic data) onChanged;
  final String? Function(String?)? validator;
  final bool? enable;
  final bool? showClear;
  const CustomSearch({
    super.key,
    this.search,
    required this.onChanged,
    this.selected,
    this.label,
    this.validator,
    this.enable = true,
    this.list,
    this.foto,
    this.controller,
    this.showClear = true,
  });

  @override
  State<CustomSearch> createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  final _txtCTRL = TextEditingController();

  final _scrollCTRL = ScrollController();

  @override
  void initState() {
    super.initState();
    _updateTextField();
  }

  @override
  void dispose() {
    _txtCTRL.dispose();
    _scrollCTRL.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomSearch oldWidget) {
    _updateTextField();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _updateTextField();
    super.didChangeDependencies();
  }

  _updateTextField() {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      if (mounted) {
        widget.selected != null
            ? _txtCTRL.text = "${widget.selected.title}"
            : _txtCTRL.text = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: widget.label,
              suffixIcon: const Icon(Icons.arrow_drop_down),
              enabled: widget.enable == true,
            ),
            style: TextStyle(color: widget.enable == true ? null : Colors.grey),
            minLines: 1,
            maxLines: 5,
            onTap: widget.enable == true ? () => _showSearch(context) : null,
            readOnly: true,
            controller: widget.controller ?? _txtCTRL,
            onFieldSubmitted:
                widget.enable == true ? (v) => _showSearch(context) : null,
            validator: widget.validator,
          ),
        ),
        widget.showClear == true
            ? IconButton(
                onPressed: widget.enable == true
                    ? () {
                        _txtCTRL.text = '';
                        if (widget.controller != null) {
                          widget.controller!.clear();
                        }
                        widget.onChanged(null);
                      }
                    : null,
                icon: const Icon(Icons.cancel),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  _showSearch(BuildContext context) {
    showSearch(
      context: context,
      query: widget.selected != null ? widget.selected.title : _txtCTRL.text,
      delegate: CustomSearchDelegate(
        scrollCTRL: _scrollCTRL,
        search: widget.search,
        list: widget.list,
        onSelected: (data) {
          _txtCTRL.text =
              '${data.subTitle != null ? '${data.subTitle}, ' : ''}${data.title}';
          widget.onChanged(data);
        },
      ),
    );
  }
}

class CustomSearchDelegate<T> extends SearchDelegate<dynamic> {
  final Widget Function(T data)? itemBuilder;
  final Function(dynamic data)? onSelected;
  final Future<List<T>> Function(String)? search;
  final List<T>? list;
  final ScrollController scrollCTRL;
  CustomSearchDelegate({
    this.itemBuilder,
    this.onSelected,
    required this.search,
    this.list,
    required this.scrollCTRL,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      )
    ];
  }

  @override
  String get searchFieldLabel => 'Consulte por Descrpción';

  // @override
  // InputDecorationTheme? get searchFieldDecorationTheme =>
  //     InputDecorationTheme(

  //     );

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _build(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: list == null
            ? FutureBuilder<List<dynamic>>(
                future: search!(query),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Consulta sin datos!'),
                      );
                    }

                    var l = snapshot.data;

                    return ListView.builder(
                      controller: scrollCTRL,
                      itemBuilder: (_, index) {
                        var data = l[index];

                        // return itemBuilder(data);

                        if (itemBuilder != null) {
                          return itemBuilder!(data);
                        }

                        return ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(data.title),
                          ),
                          subtitle: (data.subTitle != null &&
                                  data.subTitle!.isNotEmpty)
                              ? Text(data.subTitle!)
                              : null,
                          onTap: () {
                            onSelected!(data);
                            close(context, null);
                          },
                        );
                      },
                      itemCount: l!.length,
                    );

                    // return dataBuilder(snapshot.data);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            : ListView.builder(
                controller: scrollCTRL,
                itemBuilder: (_, index) {
                  final data = list![index] as dynamic;

                  if (data == null) {
                    return const SizedBox.shrink();
                  }

                  if (itemBuilder != null) {
                    return itemBuilder!(data);
                  }

                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(data.title),
                    ),
                    subtitle:
                        (data.subTitle != null && data.subTitle!.isNotEmpty)
                            ? Text(data.subTitle!)
                            : null,
                    onTap: () {
                      onSelected!(data);
                      close(context, null);
                    },
                  );
                },
                itemCount: list!.length,
              ),
      ),
    );
  }
}
