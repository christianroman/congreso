Propuesta para #app115
=========

Aplicacion para dispositivos moviles iPhone (iOS 6)

![Alt text](https://raw.github.com/chroman/congreso/master/app115.png "App115")

Caracteristicas
-

  - [Backend] y base de datos propios.
  - Listado de legisladores.
  - Detalle de legislador, comisiones, iniciativas, asistencias, votaciones, telefono, etc.
  - Listado de comisiones y miembros pertenecientes.
  - Listado de partidos y miembros pertenecientes.
  - Localizacion de diputados y senadores dependiendo tu ubicación.
  - La API con Sinatra esta diseñada para hacer web crawling a la pagina oficial de diputados y obtener comisiones, iniciativas, asistencias y votaciones. ([congreso-api])

Version
-

1.0

Datos tecnicos
-----------

La app en conjunto utiliza las siguientes tecnologias:

* iOS 6.
* Ruby on Rails 3 (Backend).
* PostgreSQL 9.1 (Base de datos).
* PostGIS (Busquedas point-in-multipolygon).
* Sinatra Framework (Web crawling) 

Licencia
-

MIT

[Backend]: https://github.com/chroman/congreso-backend
[congreso-api]: https://github.com/chroman/congreso-api
  