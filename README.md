# AuctionContract

# Contrato de Subasta

Este contrato inteligente permite a los usuarios participar en una subasta, realizar ofertas y retirar sus fondos de manera segura.

## Funciones

- `placeBid()`: Permite a los usuarios realizar una oferta en la subasta. La oferta debe ser al menos un 5% mayor que la oferta más alta actual.
- `endAuction()`: Finaliza la subasta, solo puede ser llamada por el propietario del contrato.
- `withdraw()`: Permite al ganador de la subasta retirar sus fondos después de que la subasta ha terminado.
- `getBids()`: Devuelve la lista de participantes y sus respectivas ofertas.
- `getWinner()`: Devuelve la dirección del ganador y la oferta más alta.

## Variables

- `owner`: Dirección del propietario del contrato.
- `auctionEndTime`: Tiempo de finalización de la subasta.
- `auctionEnded`: Estado que indica si la subasta ha terminado.
- `highestBid`: Monto de la oferta más alta.
- `highestBidder`: Dirección del mejor postor.
- `bids`: Mapa que almacena las ofertas de cada dirección.
- `bidders`: Lista de todos los participantes en la subasta.

## Eventos

- `NewBid(address indexed bidder, uint256 amount)`: Emitido cuando se realiza una nueva oferta.
- `AuctionEnded(address winner, uint256 amount)`: Emitido cuando la subasta ha terminado.

## Requisitos

- Este contrato está escrito en Solidity y debe ser desplegado en la red Ethereum.

## Instalación

Para compilar y desplegar este contrato, necesitarás [Remix](https://remix.ethereum.org/) o [Truffle](https://www.trufflesuite.com/truffle).

## Contribuciones

Las contribuciones son bienvenidas. Si deseas contribuir, por favor abre un "issue" o un "pull request". Muchas gracias!
