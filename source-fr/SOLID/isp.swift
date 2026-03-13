/*:
# 🍴 The Interface Segregation Principle (Principe de segregation des interfaces)

Creez des interfaces a granularite fine adaptees a chaque client.

Aucun client ne devrait etre force de dependre de methodes qu'il n'utilise pas.
Quand une interface devient trop volumineuse, ses clients se retrouvent couples
a des methodes qu'ils n'appellent jamais — et les modifications de ces methodes
non liees peuvent forcer les clients a recompiler ou a se redeployer. Diviser
les interfaces trop larges en protocoles plus petits et specialises maintient
les dependances etroites et coherentes.

Exemple :
 */

// J'ai un site d'atterrissage.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// Je peux atterrir sur des objets LandingSiteHaving.
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// J'ai une charge utile.
protocol PayloadHaving {
    var payload: String { get }
}

// Je peux recuperer la charge utile d'un vehicule (par ex. via le Canadarm).

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ La station spatiale ignore tout des capacites d'atterrissage de SpaceXCRS8.
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// Je suis une barge — j'ai un site d'atterrissage (enfin, vous voyez l'idee).
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// J'ai une charge utile et je peux atterrir sur des objets ayant un site d'atterrissage.
// Je suis un vehicule spatial tres limite, je le sais.
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 ne connait que les informations relatives au site d'atterrissage.
    func land(on: LandingSiteHaving) -> String {
        return "Landed on \(on.landingSite) at April 8, 2016 20:52 UTC"
    }
}

let crs8 = SpaceXCRS8()
let barge = OfCourseIStillLoveYouBarge()
let spaceStation = InternationalSpaceStation()

spaceStation.fetchPayload(vehicle: crs8)
crs8.land(on: barge)
