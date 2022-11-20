class Documento {
  const Documento(
      {required this.iddocumento,
      required this.titulo,
      required this.descripcion,
      required this.anio,
      required this.mes,
      required this.autor_es,
      required this.empresa,
      required this.edicion,
      required this.anio_doc,
      required this.fecharegistro,
      required this.idusuario_registra,
      required this.intent,
      required this.extension,
      required this.url_doc,
      required this.idcategoria,
      required this.url_portada});

  final String iddocumento,
      titulo,
      descripcion,
      anio,
      mes,
      autor_es,
      empresa,
      edicion,
      anio_doc,
      fecharegistro,
      idusuario_registra,
      intent,
      extension,
      url_doc,
      idcategoria,
      url_portada;
}

const _documentoAsset = 'assets/images';
final document_background = 'assets/images/background_gcp.png';

const documentos = [
  Documento(
      iddocumento: '1',
      titulo: 'Siempre Juntos',
      descripcion: 'Revista Institucional',
      anio: '2021',
      mes: 'Abril',
      autor_es: 'Agrícola Cerro Prieto',
      empresa: 'ACP',
      edicion: '01',
      anio_doc: '03',
      fecharegistro: '10/04/2021 15:00',
      idusuario_registra: '47870132',
      intent: 'application/pdf',
      extension: '.pdf',
      url_doc: 'url_archivo',
      idcategoria: '1',
      url_portada: '$_documentoAsset/revista_001.jpg'),
  Documento(
      iddocumento: '2',
      titulo: 'Siempre Juntos',
      descripcion: 'Revista Institucional',
      anio: '2020',
      mes: 'Abril',
      autor_es: 'Agrícola Cerro Prieto',
      empresa: 'ACP',
      edicion: '01',
      anio_doc: '04',
      fecharegistro: '30/04/2021 15:00',
      idusuario_registra: '47870132',
      intent: 'application/pdf',
      extension: '.pdf',
      url_doc: 'url_archivo',
      idcategoria: '1',
      url_portada: '$_documentoAsset/revista_002.jpg'),
  Documento(
      iddocumento: '3',
      titulo: 'Siempre Juntos',
      descripcion: 'Revista Institucional',
      anio: '2019',
      mes: 'Abril',
      autor_es: 'Agrícola Cerro Prieto',
      empresa: 'ACP',
      edicion: '01',
      anio_doc: '05',
      fecharegistro: '20/04/2021 15:00',
      idusuario_registra: '47870132',
      intent: 'application/pdf',
      extension: '.pdf',
      url_doc: 'url_archivo',
      idcategoria: '1',
      url_portada: '$_documentoAsset/revista_003.PNG')
];
