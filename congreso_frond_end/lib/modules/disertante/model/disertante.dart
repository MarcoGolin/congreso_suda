class Disertante {
  final String nombre;
  final String especialidad;
  final List<String> flyersPathsOrUrls; // 1..n (usamos 2 en tu caso)

  Disertante({
    required this.nombre,
    required this.especialidad,
    required this.flyersPathsOrUrls,
  });

  //lista de disertantes de ejemplo
  static List<Disertante> disertantesEjemplo = [
    Disertante(
      nombre: 'Dr. Guillermo Legal Airaldi',
      especialidad: 'Pediatria',
      flyersPathsOrUrls: [
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dr.%20Guillermo%20Legal/Dr.%20Guillermo%20Legal%20Airaldi%201.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dr.%20Guillermo%20Legal/Dr.%20Guillermo%20Legal%20Airaldi%202.png',
      ],
    ),
    Disertante(
      nombre: 'Dr. Gustavo Ensina',
      especialidad: 'Psiquiatria',
      flyersPathsOrUrls: [
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dr.%20Gustavo%20Ensina/Dr.%20Gustavo%20Ensina%201.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dr.%20Gustavo%20Ensina/Dr.%20Gustavo%20Ensina%202.png',
      ],
    ),
    Disertante(
      nombre: 'Dr. Pablo Sosa',
      especialidad: 'Neurologia',
      flyersPathsOrUrls: [
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dr.%20Pablo%20Sosa/Dr.%20Pablo%20Sosa%201.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dr.%20Pablo%20Sosa/Dr.%20Pablo%20Sosa%202.png',
      ],
    ),
    Disertante(
      nombre: 'Dra. Clarissa Da Costa',
      especialidad: 'Emergentologia',
      flyersPathsOrUrls: [
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dra.%20Clarissa%20da%20Costa/Dra.%20Clarissa%20Da%20Costa%201.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dra.%20Clarissa%20da%20Costa/Dra.%20Clarissa%20Da%20Costa%202.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dra.%20Clarissa%20da%20Costa/Dra.%20Clarissa%20Da%20Costa%203.png',
      ],
    ),
    Disertante(
      nombre: 'Dra. Elva Legal',
      especialidad: 'Anestesiologia',
      flyersPathsOrUrls: [
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dra.%20Elva%20Legal/Dra.%20Elva%20Legal%201.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dra.%20Elva%20Legal/Dra.%20Elva%20Legal%202.png',
      ],
    ),
    Disertante(
      nombre: 'Dra. Jacqueline Gonzalez',
      especialidad: 'Reumatologia',
      flyersPathsOrUrls: [
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dra.%20Jacqueline%20Gonzalez/Dra.%20Jacqueline%20Gonzalez%201.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dra.%20Jacqueline%20Gonzalez/Dra.%20Jacqueline%20Gonzalez%202.png',
      ],
    ),
    Disertante(
      nombre: 'Dra. Leiner Sabore',
      especialidad: 'Ginecologia y Obstetricia',
      flyersPathsOrUrls: [
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dra.%20Leiner%20Sabore/Dra.%20Leiner%20Sabore%201.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dra.%20Leiner%20Sabore/Dra.%20Leiner%20Sabore%202.png',
      ],
    ),
    Disertante(
      nombre: 'Dra. SONIA BOGADO',
      especialidad: 'Pediatria Clinica',
      flyersPathsOrUrls: [
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dra.%20Sonia%20Bogado/Dra.%20SONIA%20BOGADO%201%20(2).png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dra.%20Sonia%20Bogado/Dra.%20SONIA%20BOGADO%202.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dra.%20Sonia%20Bogado/Dra.%20SONIA%20BOGADO%203.png',
      ],
    ),
    Disertante(
      nombre: 'Dr. Cesar Luis Sanchez',
      especialidad: 'Ortopedia y Traumatologia',
      flyersPathsOrUrls: [
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dr.%20Cesar%20Sanchez/Dr.%20Cesar%20Luis%20Sanchez%201.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dr.%20Cesar%20Sanchez/Dr.%20Cesar%20Luis%20Sanchez%202.png',
      ],
    ),
    Disertante(
      nombre: 'Dra. Kawany Goncalves',
      especialidad: 'Medica Revalidada',
      flyersPathsOrUrls: [
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dra.%20Kawany%20Goncalves/Dra.%20Kawany%20Goncalves%201.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dra.%20Kawany%20Goncalves/Dra.%20Kawany%20Goncalves%202.png',
      ],
    ),
    Disertante(
      nombre: 'Dr. Hernán Ortiz',
      especialidad: 'Medica Revalidada',
      flyersPathsOrUrls: [
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/DR%20HERNAN%20ORTIZ/Dr.%20Hernan%20Ortiz%201.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/DR%20HERNAN%20ORTIZ/Dr.%20Hernan%20Ortiz%202.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/DR%20HERNAN%20ORTIZ/Dr.%20Hernan%20Ortiz%203.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/DR%20HERNAN%20ORTIZ/Dr.%20Hernan%20Ortiz%204.png',
      ],
    ),
    Disertante(
      nombre: 'Dr. Ariel Amarilla',
      especialidad: 'Medica Revalidada',
      flyersPathsOrUrls: [
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/DR%20ARIEL%20AMARILLA/Dr.%20Ariel%20Amarilla%201.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/DR%20ARIEL%20AMARILLA/Dr.%20Ariel%20Amarilla%202.png',
      ],
    ),
    Disertante(
      nombre: 'Dr. Lino Marcelo Pederzani',
      especialidad: 'Medica Revalidada',
      flyersPathsOrUrls: [
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dr.%20Marcelo%20Pederzani/DR.%20Lino%20Marcelo%20Pederzani%201.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dr.%20Marcelo%20Pederzani/DR.%20Lino%20Marcelo%20Pederzani%202.png',
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/disertantes/Dr.%20Marcelo%20Pederzani/DR.%20Lino%20Marcelo%20Pederzani%203.png',
      ],
    ),
  ];
}
