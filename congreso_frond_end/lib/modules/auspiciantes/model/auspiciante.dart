// Base pública de Supabase para AUSpiciantes (termina SIN slash)
const _supabaseSponsorsBase =
    'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/auspiciantes';

class Auspiciante {
  final String fileName; // e.g. "OTICA CIENTIFICA.png"
  final String? displayName; // opcional, distinto del file

  const Auspiciante(this.fileName, {this.displayName});

  String get url => '$_supabaseSponsorsBase/${Uri.encodeComponent(fileName)}';

  String get name =>
      displayName ??
      fileName.replaceAll(
        RegExp(r'\.(png|jpg|jpeg)$', caseSensitive: false),
        '',
      );

  // ---------- PRIORIDAD ----------
  /// Lista de 12 principales en el orden exacto que pediste (texto libre).
  static const List<String> _priorityOrderUser = [
    'Unisud',
    'Churrascaria Parana',
    'Queen Anne',
    'Casa Maringa',
    'Casa Rojas',
    'LG',
    'SI importados',
    'Dalet',
    'Super 10',
    'Tikita',
    'Farmacia Mega Farma SDG',
    'Agua saltos',
  ];

  /// Mapeo flexible: cómo matchean esos nombres con tus archivos reales.
  /// (match por "contiene" case-insensitive sobre `name`)
  static const Map<String, String> _priorityMatchHints = {
    'Unisud': 'UNISUD',
    'Churrascaria Parana': 'CHURRASCARIA PARANA',
    'Queen Anne': 'QUEEN ANNE',
    'Casa Maringa': 'CASA MARINGA',
    'Casa Rojas': 'CASA ROJAS',
    'LG': 'LG IMPORTADOS',
    'SI importados': 'SI IMPORTADOS',
    'Dalet': 'DALET',
    'Super 10': 'SUPER 10 MEGASTORE',
    'Tikita': 'TIKITA',
    'Farmacia Mega Farma SDG': 'MEGA FARMA SDG',
    'Agua saltos': 'AGUA SALTOS',
  };

  static bool _containsIgnoreCase(String haystack, String needle) {
    return haystack.toLowerCase().contains(needle.toLowerCase());
  }

  /// ¿Este auspiciador es "principal"?
  static bool isPriority(Auspiciante a) {
    final n = a.name;
    return _priorityMatchHints.values.any(
      (hint) => _containsIgnoreCase(n, hint),
    );
  }

  /// Reordena una lista cualquiera: primero los 12 principales en el orden exacto,
  /// luego el resto barajado.
  static List<Auspiciante> prioritize(List<Auspiciante> input) {
    // indexar por hint -> Auspiciante que matchea
    final byHint = <String, Auspiciante?>{};
    for (final entry in _priorityMatchHints.entries) {
      final hint = entry.value;
      final found = input.firstWhere(
        (a) => _containsIgnoreCase(a.name, hint),
        orElse: () => const Auspiciante('__NOT_FOUND__'),
      );
      byHint[hint] = found.fileName == '__NOT_FOUND__' ? null : found;
    }

    // construir la cabeza en el orden exacto del usuario
    final head = <Auspiciante>[];
    final booked = <String>{};
    for (final userKey in _priorityOrderUser) {
      final hint = _priorityMatchHints[userKey];
      if (hint == null) continue;
      final a = byHint[hint];
      if (a != null && !booked.contains(a.fileName)) {
        head.add(a);
        booked.add(a.fileName);
      }
    }

    // resto aleatorio
    final tail = input.where((a) => !booked.contains(a.fileName)).toList()
      ..shuffle();

    return [...head, ...tail];
  }

  /// 🔹 Lista completa original
  static List<Auspiciante> _allRaw() {
    final list = <Auspiciante>[
      // Columna 1
      Auspiciante('AMOROSA.png'),
      Auspiciante('ARENA BEACH MN.png'),
      Auspiciante('ART E PESCA.png'),
      Auspiciante('OTICA CIENTIFICA.png'),
      Auspiciante('PETISCARIA VIRADO NO ALHO.png'),
      Auspiciante('RAFAELA HOLSBACH.png'),
      Auspiciante('REAL BIKE.png'),
      Auspiciante('SABINA DERMAGLOW.png'),
      Auspiciante('TOP STATION.png'),
      Auspiciante('Zs Studio Nail Design.png'),
      Auspiciante('ALAN MARX.png'),
      Auspiciante('AMED.png'),
      Auspiciante('ANA BAEZ.png'),
      Auspiciante('ARENA BEACH 1.png'),
      Auspiciante('CANDIES CALCADOS.png'),
      Auspiciante('CASA SILVER CENTER.png'),
      Auspiciante('CLAUDIO GONZALEZ.png'),
      Auspiciante('EL FUTURO.png'),
      Auspiciante('ESTRELLA IMPORTADOS.png'),

      // Columna 2
      Auspiciante('EXPRESSO ATACAREJO.png'),
      Auspiciante('FARMASUL POPULAR.png'),
      Auspiciante('FERREXMAXX.png'),
      Auspiciante('FRK STORE.png'),
      Auspiciante('FV EMPRENDIMENTOS.png'),
      Auspiciante('GIORE SEMIJOAIS.png'),
      Auspiciante('LETICIA MANCUELLO.png'),
      Auspiciante('LIZ FERREIRA.png'),
      Auspiciante('LOJA DO PATO.png'),
      Auspiciante('MARCIA JARDIM.png'),
      Auspiciante('MYLAN.png'),
      Auspiciante('RC POINT.png'),
      Auspiciante('RC PRINT.png'),
      Auspiciante('RONALDO HERRMIENTAS.png'),
      Auspiciante('SALUS HBM.png'),
      Auspiciante('SILMARA.png'),
      Auspiciante('TIO VELHO.png'),
      Auspiciante('UNIK BEAUTY SPA.png'),
      Auspiciante('AGUA SALTOS.png'),

      // Columna 3
      Auspiciante('BELMONT.png'),
      Auspiciante('CASA MARINGA.png'),
      Auspiciante('CASA ROJAS.png'),
      Auspiciante('CASA SOL.png'),
      Auspiciante('CHURRASCARIA PARANA.png'),
      Auspiciante('COFRINHO CENTER.png'),
      Auspiciante('DALET.png'),
      Auspiciante('DEYSI BARRETO (2).png'),
      Auspiciante('DEYSI BARRETO.png'),
      Auspiciante('DIGITAL IMPORTADOS.png'),
      Auspiciante('FARMACIA VITAL FORMA.png'),
      Auspiciante('FENIX IMPORTADOS.png'),
      Auspiciante('IMPERIO STORE.png'),
      Auspiciante('KEITY SANABRIA.png'),
      Auspiciante('LACONIA IMPORT.png'),
      Auspiciante('LADY FASHION.png'),
      Auspiciante('LG IMPORTADOS.png'),
      Auspiciante('MEGA FARMA SDG.png'),
      Auspiciante('QUEEN ANNE.png'),

      // Columna 4
      Auspiciante('RODY SANABRIA.png'),
      Auspiciante('SI IMPORTADOS.png'),
      Auspiciante('SUPER 10 MEGASTORE.png'),
      Auspiciante('SUPERMERCADO EL PUNTO.png'),
      Auspiciante('TIKITA.png'),
      Auspiciante('TIO CELL.png'),
      Auspiciante('TOWERS IMPORTADOS.png'),
      Auspiciante('UNISUD.png'),
      Auspiciante('VIVIAN FLEITAS.png'),
    ];
    return list;
  }

  /// 🔹 Retorna la lista final con prioridad fija y resto aleatorio
  static List<Auspiciante> all() {
    final raw = _allRaw();
    return prioritize(raw);
  }
}
