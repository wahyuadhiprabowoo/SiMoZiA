
///url api: https://admin-puskesmas.000webhostapp.com/api/
  //all data: /all
  // all puskesmas: /puskesmas
  // detail puskesmas: /puskesmas/{id}
  // all posyandu: /posyandu
  // detail posyandu: /posyandu/{id}
  // detail balita dari puskesmas/posyandu[crud]: /puskesmas/{id}/posyandu/{id}/balita 
  // filter balita: /puskesmas/posyandu[crud]: /puskesmas/{id}/posyandu/{id}/balita/filter-panjang/{klasifikasi_panjang_badan}
  // filter balita: /puskesmas/posyandu[crud]: /puskesmas/{id}/posyandu/{id}/balita/filter-berat/{klasifikasi_berat_badan}
  // filter balita: /puskesmas/posyandu[crud]: /puskesmas/{id}/posyandu/{id}/balita/filter-detak/{klasifikasi_detak_jantung}
  // filter balita: /puskesmas/posyandu[crud]: /puskesmas/{id}/posyandu/{id}/balita/filter-create-at
  // filter create->at http://localhost:8000/api/puskesmas/1/posyandu/4/balita/filter-create-at?start_date=2023-06-11&end_date=2023-06-30
  