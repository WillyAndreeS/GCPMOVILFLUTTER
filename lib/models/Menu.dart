class Menu{
  int id;
  String nombre;
  String imagen;
  Menu(this.id, this.nombre, this.imagen);
}

final Menus = [
  Menu(1, '¿Quiénes somos?', 'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/img_quienes_somos.jpeg?alt=media&token=e628509c-502d-40f3-81bd-e10393857a54'),
  Menu(2, 'Cultura', 'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/img_mvv.jpeg?alt=media&token=7dfbe7d6-ca41-41a1-91ba-c03bdfecd926'),
  Menu(3, 'Certificaciones', 'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/certificaciones_planta_empaque.jpg?alt=media&token=e9a22b31-ab9e-4a09-b6ca-e58fb126d407'),
  Menu(4, 'Contáctanos', 'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/img_contactanos.jpeg?alt=media&token=fc2ff7cc-6e31-44f4-b828-35baddeb6333'),
  Menu(5, 'ACP en el mundo', 'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/img_acp_mundo.jpg?alt=media&token=78fadcea-c790-4cfa-8d46-567f5bb7b23e'),
  Menu(6, 'GPS ACP', 'https://firebasestorage.googleapis.com/v0/b/gcp-movil.appspot.com/o/img_acp_mundo_offline.jpg?alt=media&token=22da5327-8acc-4ade-b1f6-c5d51cab95e4'),
];