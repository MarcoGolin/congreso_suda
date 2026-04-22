import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/core/searcher/custom_search.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/talleres/models/taller.dart';
import 'package:congreso_evento/modules/talleres/pages/tallet_asignar_responsable/taller_asignar_responsable_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

const _brandPrimary = Color(0xFF387f4d);
const _brandLight = Color(0xFF73c165);

class TallerAsignarResponsablePage extends StatefulWidget {
  const TallerAsignarResponsablePage({super.key});

  @override
  State<TallerAsignarResponsablePage> createState() =>
      _TallerAsignarResponsablePageState();
}

class _TallerAsignarResponsablePageState
    extends State<TallerAsignarResponsablePage>
    with DefaultStateNotifier {
  final _ctrl = Modular.get<TallerAsignarResponsableCtrl>();

  late ReactionDisposer _rctDspr;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Post-frame para asegurar Modular.args está listo también en web/deep-link
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    _rctDspr = reaction((_) => _ctrl.stateClass, (s) {
      switch (s.status) {
        case StatusEnumGlobal.errorAndAction:
          hideLoader();
          Modular.to.pop(); // cierra el diálogo
          showAlertWarning(s.message);
          break;
        case StatusEnumGlobal.loading:
          showLoader();
          break;
        case StatusEnumGlobal.loaded:
          hideLoader();
          break;
        case StatusEnumGlobal.success:
          // hideLoader();
          showAlert(s.message, DefaultStateNotifier.TYPE_SUCCESS);
          break;
        case StatusEnumGlobal.errorDialog:
          hideLoader();
          showAlertWarning(s.message);
        default:
      }
    });
  }

  @override
  void dispose() {
    _rctDspr();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignar Responsable al Taller'),
        backgroundColor: _brandLight,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            spacing: 10,
            children: [
              Observer(
                builder: (_) => CustomSearch<Taller?>(
                  label: 'Eliga el Taller',
                  search: (value) =>
                      _ctrl.consultaTallerByDescripcion(descripcion: value),
                  selected: _ctrl.taller,
                  onChanged: (data) => _ctrl.setTaller = data,
                  showClear: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Debe seleccionar un taller';
                    }
                    return null;
                  },
                ),
              ),
              Observer(
                builder: (_) => CustomSearch<Usuario?>(
                  label: 'Asignar Responsable',
                  search: (value) =>
                      _ctrl.consultaCongresistaPorNombre(buscador: value),
                  selected: _ctrl.congresista,
                  onChanged: (data) => _ctrl.setCongresista = data,
                  showClear: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Debe seleccionar un congresista';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
