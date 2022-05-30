class Station {
  dynamic zespol,
      slupek,
      nazwa_zespolu,
      id_ulicy,
      szer_geo,
      dlug_geo,
      kierunek,
      obowiazuje_od;

  @override
  String toString() {
    return 'Station{zespol: $zespol, slupek: $slupek, nazwa_zespolu: $nazwa_zespolu, id_ulicy: $id_ulicy, szer_geo: $szer_geo, dlug_geo: $dlug_geo, kierunek: $kierunek, obowiazuje_od: $obowiazuje_od}';
  }
}
