/*:
# 🍴 The Interface Segregation Principle (Principio de segregación de interfaces)

Crea interfaces de grano fino adaptadas al cliente específico.

Ningún cliente debería verse obligado a depender de métodos que no utiliza.
Cuando una interfaz crece demasiado, sus clientes quedan acoplados a métodos
que nunca invocan — y los cambios en esos métodos no relacionados pueden forzar
a los clientes a recompilar o redesplegar. Dividir las interfaces grandes en
protocolos más pequeños y especializados mantiene las dependencias estrechas
y cohesivas.

Ejemplo:
 */

// Tengo un sitio de aterrizaje.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// Puedo aterrizar en objetos LandingSiteHaving.
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// Tengo carga útil.
protocol PayloadHaving {
    var payload: String { get }
}

// Puedo recoger la carga útil de un vehículo (por ejemplo, mediante Canadarm).

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ La estación espacial no sabe nada sobre las capacidades de aterrizaje de SpaceXCRS8.
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// Soy una barcaza — tengo un sitio de aterrizaje (bueno, ya entienden la idea).
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// Tengo carga útil y puedo aterrizar en objetos con sitio de aterrizaje.
// Soy un vehículo espacial muy limitado, lo sé.
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 solo conoce la información del sitio de aterrizaje.
    func land(on: LandingSiteHaving) -> String {
        return "Landed on \(on.landingSite) at April 8, 2016 20:52 UTC"
    }
}

let crs8 = SpaceXCRS8()
let barge = OfCourseIStillLoveYouBarge()
let spaceStation = InternationalSpaceStation()

spaceStation.fetchPayload(vehicle: crs8)
crs8.land(on: barge)
