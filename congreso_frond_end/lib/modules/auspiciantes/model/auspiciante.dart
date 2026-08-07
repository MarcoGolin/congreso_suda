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
        RegExp(r'\.(png|jpg|jpeg|webp)$', caseSensitive: false),
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
      Auspiciante('AMOROSA.webp'),
      Auspiciante('ARENA BEACH MN.webp'),
      Auspiciante('ART E PESCA.webp'),
      Auspiciante('OTICA CIENTIFICA.webp'),
      Auspiciante('PETISCARIA VIRADO NO ALHO.webp'),
      Auspiciante('RAFAELA HOLSBACH.webp'),
      Auspiciante('REAL BIKE.webp'),
      Auspiciante('SABINA DERMAGLOW.webp'),
      Auspiciante('TOP STATION.webp'),
      Auspiciante('Zs Studio Nail Design.webp'),
      Auspiciante('ALAN MARX.webp'),
      Auspiciante('AMED.webp'),
      Auspiciante('ANA BAEZ.webp'),
      Auspiciante('ARENA BEACH 1.webp'),
      Auspiciante('CANDIES CALCADOS.webp'),
      Auspiciante('CASA SILVER CENTER.webp'),
      Auspiciante('CLAUDIO GONZALEZ.webp'),
      Auspiciante('EL FUTURO.webp'),
      Auspiciante('ESTRELLA IMPORTADOS.webp'),

      // Columna 2
      Auspiciante('EXPRESSO ATACAREJO.webp'),
      Auspiciante('FARMASUL POPULAR.webp'),
      Auspiciante('FERREXMAXX.webp'),
      Auspiciante('FRK STORE.webp'),
      Auspiciante('FV EMPRENDIMIENTOS.webp'),
      Auspiciante('GIORE SEMIJOAIS.webp'),
      Auspiciante('LETICIA MANCUELLO.webp'),
      Auspiciante('LIZ FERREIRA.webp'),
      Auspiciante('LOJA DO PATO.webp'),
      Auspiciante('MARCIA JARDIM.webp'),
      Auspiciante('MYLAN.webp'),
      Auspiciante('RC POINT.webp'),
      Auspiciante('RC PRINT.webp'),
      Auspiciante('RONALDO HERRMIENTAS.webp'),
      Auspiciante('SALUS HBM.webp'),
      Auspiciante('SILMARA.webp'),
      Auspiciante('TIO VELHO.webp'),
      Auspiciante('UNIK BEAUTY SPA.webp'),
      Auspiciante('AGUA SALTOS.webp'),

      // Columna 3
      Auspiciante('BELMONT.webp'),
      Auspiciante('CASA MARINGA.webp'),
      Auspiciante('CASA ROJAS.webp'),
      Auspiciante('CASA SOL.webp'),
      Auspiciante('CHURRASCARIA PARANA.webp'),
      Auspiciante('COFRINHO CENTER.webp'),
      Auspiciante('DALET.webp'),
      Auspiciante('DEYSI BARRETO (2).webp'),
      Auspiciante('DEYSI BARRETO.webp'),
      Auspiciante('DIGITAL IMPORTADOS.webp'),
      Auspiciante('FARMACIA VITAL FORMA.webp'),
      Auspiciante('FENIX IMPORTADOS.webp'),
      Auspiciante('IMPERIO STORE.webp'),
      Auspiciante('KEITY SANABRIA.webp'),
      Auspiciante('LACONIA IMPORT.webp'),
      Auspiciante('LADY FASHION.webp'),
      Auspiciante('LG IMPORTADOS.webp'),
      Auspiciante('MEGA FARMA SDG.webp'),
      Auspiciante('QUEEN ANNE.webp'),

      // Columna 4
      Auspiciante('RODY SANABRIA.webp'),
      Auspiciante('SI IMPORTADOS.webp'),
      Auspiciante('SUPER 10 MEGASTORE.webp'),
      Auspiciante('SUPERMERCADO EL PUNTO.webp'),
      Auspiciante('TIKITA.webp'),
      Auspiciante('TIO CELL.webp'),
      Auspiciante('TOWERS IMPORTADOS.webp'),
      Auspiciante('UNISUD.webp'),
      Auspiciante('VIVIAN FLEITAS.webp'),
    ];
    return list;
  }

  /// 🔹 Retorna la lista final con prioridad fija y resto aleatorio
  static List<Auspiciante> all() {
    final raw = _allRaw();
    return prioritize(raw);
  }
}
