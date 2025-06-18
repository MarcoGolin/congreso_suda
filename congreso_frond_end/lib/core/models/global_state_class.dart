class GlobalStateClass {
  String? key;
  StatusEnumGlobal status = StatusEnumGlobal.loaded;
  String message = '';

  GlobalStateClass({required this.status, this.message = ''});

  GlobalStateClass copyWith({
    String? key,
    StatusEnumGlobal? status,
    String? message,
  }) {
    return GlobalStateClass(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

enum StatusEnumGlobal {
  loaded,
  loading,
  loadingList,
  loadingOnly,
  loadingCaixa,
  success,
  successEmpty,
  successOther,
  successAndAction,
  successAndBack,
  successAndNavigateHome,
  successAndNavigateAtivarNovaConta,
  error,
  errorAndAction,
  errorAndNavigateLogin,
  errorDialog,
  warning,
  onlyWarning,
  impresoraNoSeleccionada,
  listaVacia,
  clear,
  printerAPIError,
  loadingQR,
  loadedQR,
  caixaFechado,
}
