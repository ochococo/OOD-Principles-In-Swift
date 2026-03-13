/*:
# 🍴 The Interface Segregation Principle (Zasada segregacji interfejsów)

Twórz drobnoziarniste interfejsy dopasowane do konkretnego klienta.

Żaden klient nie powinien być zmuszony do zależności od metod, których nie
używa. Gdy interfejs rozrasta się nadmiernie, jego klienci zostają sprzężeni
z metodami, których nigdy nie wywołują — a zmiany w tych niezwiązanych metodach
mogą wymusić rekompilację lub ponowne wdrożenie klientów. Dzielenie rozbudowanych
interfejsów na mniejsze, wyspecjalizowane protokoły utrzymuje zależności wąskie
i spójne.

Przykład:
 */

// Mam miejsce do lądowania.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// Potrafię lądować na obiektach LandingSiteHaving.
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// Mam ładunek.
protocol PayloadHaving {
    var payload: String { get }
}

// Potrafię pobrać ładunek z pojazdu (np. za pomocą Canadarm).

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ Stacja kosmiczna nie ma pojęcia o zdolnościach lądowania SpaceXCRS8.
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// Jestem barką — mam miejsce do lądowania (no, rozumiecie o co chodzi).
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// Mam ładunek i potrafię lądować na obiektach z miejscem do lądowania.
// Jestem bardzo ograniczonym pojazdem kosmicznym, wiem o tym.
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 zna tylko informacje o miejscu lądowania.
    func land(on: LandingSiteHaving) -> String {
        return "Landed on \(on.landingSite) at April 8, 2016 20:52 UTC"
    }
}

let crs8 = SpaceXCRS8()
let barge = OfCourseIStillLoveYouBarge()
let spaceStation = InternationalSpaceStation()

spaceStation.fetchPayload(vehicle: crs8)
crs8.land(on: barge)
