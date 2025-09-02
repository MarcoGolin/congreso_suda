import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/congresista_ctrl.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/utils/carnet_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

const brandPrimary = Color(0xFF387f4d); // ya lo tenés
const brandLight = Color(0xFF73c165); // ya lo tenés
const kBorder = Color(0xFFE5E7EB);
const kMuted = Color(0xFF6B7280);
const kInk = Color(0xFF111827);

class CongresistaEndDrawer extends StatefulWidget {
  const CongresistaEndDrawer({super.key});

  @override
  State<CongresistaEndDrawer> createState() => _CongresistaEndDrawerState();
}

class _CongresistaEndDrawerState extends State<CongresistaEndDrawer> {
  final _ctrl = Modular.get<CongresistaCtrl>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(child: Text('Opciones')),
          ListTile(
            title: const Text('Opción 1'),
            onTap: () {
              // Acción para la opción 1
              _generarCarnetsLote(_ctrl.congresistas);
            },
          ),
          ListTile(
            title: const Text('Opción 2'),
            onTap: () {
              // Acción para la opción 2
            },
          ),
        ],
      ),
    );
  }

  void _generarCarnetsLote(List<Usuario> users) async {
    await printOrShareCarnetsGrid(users);
  }
}
