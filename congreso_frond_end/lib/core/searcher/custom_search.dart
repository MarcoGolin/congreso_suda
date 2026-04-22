import 'package:congreso_evento/core/inputs/text_field_custom.dart';
import 'package:congreso_evento/core/searcher/custom_search_delegate.dart';
import 'package:congreso_evento/core/searcher/models/i_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomSearch<T> extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final FocusNode? focusNode;
  final dynamic selected;
  final Future<List<T>> Function(String) search;
  final Function(dynamic data) onChanged;
  final Function(String)? onFieldSubmited;
  final String? Function(String?)? validator;
  final Color? fontColor;
  final bool? showClear;
  final bool? enable;
  const CustomSearch({
    super.key,
    required this.search,
    required this.onChanged,
    required this.selected,
    this.label,
    this.validator,
    this.fontColor,
    this.controller,
    this.focusNode,
    this.onFieldSubmited,
    this.showClear = false,
    this.enable = true,
  });

  @override
  State<CustomSearch<T>> createState() => _CustomSearchState<T>();
}

class _CustomSearchState<T> extends State<CustomSearch<T>> {
  final _txtCTRL = TextEditingController();

  final _scrollCTRL = ScrollController();

  bool _isInitialized = false;

  @override
  void dispose() {
    _txtCTRL.dispose();
    _scrollCTRL.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize text field with selected value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateTextField();
        _isInitialized = true;
      }
    });
  }

  @override
  void didUpdateWidget(CustomSearch<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      _updateTextField();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only update on first call (initialization)
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updateTextField();
          _isInitialized = true;
        }
      });
    }
  }

  void _updateTextField() {
    final sel = widget.selected;
    if (sel == null) {
      _txtCTRL.text = '';
    } else if (sel is String) {
      _txtCTRL.text = sel.isEmpty ? '' : sel;
    } else if (sel is IListTile) {
      _txtCTRL.text = sel.title;
    } else {
      _txtCTRL.text = sel.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (isMobile) {
      return _buildMobile();
    }

    return _buildDeskop();
  }

  Widget _buildDeskop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: TypeAheadField(
            controller: widget.controller ?? _txtCTRL,
            suggestionsCallback: widget.search,
            focusNode: widget.focusNode,
            builder: (context, controller, focusNode) {
              return TextFieldCustom(
                // enabled: widget.enable,
                label: widget.label ?? '',
                enabled: widget.enable,
                controller: controller,
                focusNode: focusNode,
                validator: widget.validator,
                onFieldSubmitted: widget.onFieldSubmited,
              );
            },
            itemBuilder: (context, data) {
              return ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                title: Text(_returnTitle(data)),
                subtitle: _returnSubTitle(data).isNotEmpty
                    ? Text(_returnSubTitle(data))
                    : null,
              );
            },
            onSelected: widget.onChanged,
          ),
        ),
        widget.showClear == true && widget.enable == true
            ? IconButton(
                onPressed: _novo,
                color: widget.fontColor,
                icon: const Icon(Icons.clear),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  void _novo() {
    widget.controller?.clear();
    widget.onChanged(null);
  }

  String _returnTitle(dynamic data) {
    if (data is IListTile) {
      return data.title;
    }
    return data ?? '';
  }

  String _returnSubTitle(dynamic data) {
    if (data is IListTile) {
      return data.subTitle;
    }
    return data ?? '';
  }

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      query: widget.selected != null ? widget.selected.title : _txtCTRL.text,
      delegate: CustomSearchDelegate(
        scrollCTRL: _scrollCTRL,
        search: widget.search,
        onSelected: (data) {
          _txtCTRL.text =
              '${data.subTitle != null ? '${data.subTitle}, ' : ''}${data.title}';
          widget.onChanged(data);
        },
      ),
    );
  }

  Widget _buildMobile() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFieldCustom(
            label: widget.label ?? '',
            enabled: widget.enable,
            controller: widget.controller ?? _txtCTRL,
            validator: widget.validator,
            onFieldSubmitted: (v) => _showSearch(context),
            onTap: () => _showSearch(context),
          ),
        ),
        // Expanded(
        //   child: TextFormInput(
        //     labelText: widget.label,
        //     fontColor: widget.fontColor,
        //     minLines: 1,
        //     maxLines: 5,
        //     onTap: () => _showSearch(context),
        //     readOnly: true,
        //     controller: widget.controller ?? _txtCTRL,
        //     onFieldSubmitted: (v) => _showSearch(context),
        //     validator: widget.validator,
        //   ),
        // ),
        widget.showClear == true && widget.enable == true
            ? IconButton(
                onPressed: _novo,
                color: widget.fontColor,
                icon: const Icon(Icons.clear),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
