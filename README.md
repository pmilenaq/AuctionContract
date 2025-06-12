# AuctionContract

## Trabajo Final - Módulo 2

### Subasta: Smart Contract

Este contrato inteligente es parte de mi trabajo final del Módulo 2, donde se ha desarrollado un sistema de subasta en la blockchain de Ethereum. El contrato permite a los usuarios participar en una subasta, realizar ofertas y retirar sus fondos de manera segura. Ha sido optimizado para mejorar la seguridad, la claridad y la funcionalidad.

## Funciones

- **placeBid()**: Permite a los usuarios realizar una oferta en la subasta. La oferta debe ser al menos un 5% mayor que la oferta más alta actual. Si se realiza una oferta en los últimos 10 minutos, se extiende el tiempo de la subasta.

- **endAuction()**: Finaliza la subasta y distribuye los fondos. Solo puede ser llamada por el propietario del contrato. Deduce un 2% de comisión del monto más alto antes de transferirlo al propietario y reembolsa a los postores no ganadores.

- **withdraw()**: Permite a los postores no ganadores retirar sus fondos después de que la subasta ha terminado. El ganador de la subasta no puede retirar fondos.

- **getBids()**: Devuelve la lista de participantes y sus respectivas ofertas.

- **getWinner()**: Devuelve la dirección del ganador y la oferta más alta.

## Variables

- **owner**: Dirección del propietario del contrato.
- **auctionEndTime**: Tiempo de finalización de la subasta.
- **auctionEnded**: Estado que indica si la subasta ha terminado.
- **highestBid**: Monto de la oferta más alta.
- **highestBidder**: Dirección del mejor postor.
- **bids**: Mapa que almacena las ofertas de cada dirección.
- **bidders**: Lista de todos los participantes en la subasta.

## Eventos

- **NewBid(address indexed bidder, uint256 amount)**: Emitido cuando se realiza una nueva oferta.
- **AuctionEnded(address winner, uint256 amount)**: Emitido cuando la subasta ha terminado.
- **Withdraw(address indexed bidder, uint256 amount)**: Emitido cuando un postor retira sus fondos.

## Mejoras y Optimizaciones

- **Comentarios y Documentación**: Se han añadido comentarios y etiquetas de documentación para mejorar comprensión del código.
- **Deducción de Comisión**: Se ha implementado la deducción de un 2% de comisión para el ganador al final de la subasta.
- **Funciones Nuevas**: Se han añadido las funciones `getBids` y `getWinner`, permitiendo a los usuarios obtener información sobre las ofertas y el ganador de la subasta.
- **Seguridad **: Se ha implementado un guardia de reentrancia para prevenir ataques.
- **Optimización de Código**: Se han almacenado variables locales fuera de los bucles.

## Requisitos

Este contrato está escrito en Solidity y debe ser desplegado en la red Ethereum.

## Instalación

Para compilar y desplegar este contrato, necesitarás Remix o Truffle.

## Contribuciones

Las contribuciones son bienvenidas. Si deseas contribuir, por favor abre un "issue" o un "pull request". ¡Muchas gracias!
