import 'package:flutter/material.dart';

class PdfFiltroRender extends StatelessWidget {
  final List<Widget> filtros;
  const PdfFiltroRender({super.key, required this.filtros});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: filtros, // Lista dinámica de widgets
          ),
        ),
      ),
    );
  }
}
