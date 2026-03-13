/*:
# 🍴 The Interface Segregation Principle (Princípio da Segregação de Interfaces)

Crie interfaces granulares e específicas para cada cliente.

Nenhum cliente deve ser forçado a depender de métodos que não utiliza. Quando uma
interface cresce demais, seus clientes ficam acoplados a métodos que nunca chamam
— e mudanças nesses métodos não relacionados podem forçar os clientes a
recompilar ou reimplantar. Dividir interfaces inchadas em protocolos menores e
específicos por função mantém as dependências estreitas e coesas.

Exemplo:
 */

// Eu tenho um local de pouso.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// Eu posso pousar em objetos LandingSiteHaving.
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// Eu tenho carga útil.
protocol PayloadHaving {
    var payload: String { get }
}

// Eu posso buscar carga útil de um veículo (ex.: via Canadarm).

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ A estação espacial não tem ideia sobre as capacidades de pouso do SpaceXCRS8.
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// Eu sou uma barcaça — tenho um local de pouso (bem, você entendeu).
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// Eu tenho carga útil e posso pousar em coisas que têm local de pouso.
// Sou um veículo espacial muito limitado, eu sei.
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ O CRS8 conhece apenas as informações do local de pouso.
    func land(on: LandingSiteHaving) -> String {
        return "Landed on \(on.landingSite) at April 8, 2016 20:52 UTC"
    }
}

let crs8 = SpaceXCRS8()
let barge = OfCourseIStillLoveYouBarge()
let spaceStation = InternationalSpaceStation()

spaceStation.fetchPayload(vehicle: crs8)
crs8.land(on: barge)
