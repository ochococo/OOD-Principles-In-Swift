/*:
# 🍴 The Interface Segregation Principle (Schnittstellentrennungsprinzip)

Erstelle feingranulare Schnittstellen, die auf den jeweiligen Client zugeschnitten sind.

Kein Client sollte gezwungen sein, von Methoden abzuhängen, die er nicht
verwendet. Wenn eine Schnittstelle zu groß wird, werden ihre Clients an Methoden
gekoppelt, die sie nie aufrufen — und Änderungen an diesen nicht verwandten
Methoden können Clients zur Neukompilierung oder erneuten Bereitstellung zwingen.
Das Aufteilen umfangreicher Schnittstellen in kleinere, spezialisierte Protokolle
hält Abhängigkeiten schmal und kohäsiv.

Beispiel:
 */

// Ich habe einen Landeplatz.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// Ich kann auf LandingSiteHaving-Objekten landen.
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// Ich habe Nutzlast.
protocol PayloadHaving {
    var payload: String { get }
}

// Ich kann Nutzlast von einem Fahrzeug abholen (z. B. über Canadarm).

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ Die Raumstation hat keine Ahnung von den Landefähigkeiten der SpaceXCRS8.
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// Ich bin ein Lastkahn — ich habe einen Landeplatz (nun ja, Sie verstehen schon).
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// Ich habe Nutzlast und kann auf Objekten mit Landeplatz landen.
// Ich bin ein sehr eingeschränktes Raumfahrzeug, ich weiß.
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 kennt nur die Information über den Landeplatz.
    func land(on: LandingSiteHaving) -> String {
        return "Landed on \(on.landingSite) at April 8, 2016 20:52 UTC"
    }
}

let crs8 = SpaceXCRS8()
let barge = OfCourseIStillLoveYouBarge()
let spaceStation = InternationalSpaceStation()

spaceStation.fetchPayload(vehicle: crs8)
crs8.land(on: barge)
