/*:
# 🍴 The Interface Segregation Principle (Arayuz Ayrimi Ilkesi)

Istemciye ozel ince taneli arayuzler olusturun.

Hicbir istemci kullanmadigi metodlara bagimli olmaya zorlanmamalidir. Bir
arayuz cok buyudugunde, istemcileri hic cagirmadiklari metodlara baglanir —
ve bu ilgisiz metodlardaki degisiklikler istemcileri yeniden derlemeye veya
yeniden dagitima zorlayabilir. Siskin arayuzleri daha kucuk, role ozgu
protokollere bolmek bagimliliklari dar ve tutarli tutar.

Ornek:
 */

// Bir inis saham var.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// LandingSiteHaving nesnelerine inebilirim.
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// Yukum var.
protocol PayloadHaving {
    var payload: String { get }
}

// Aractan yuk alabilirim (ornegin Canadarm ile).

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ Uzay istasyonunun SpaceXCRS8'in inis yetenekleri hakkinda hicbir fikri yok.
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// Ben bir mavnayim — inis saham var (yani, anliyorsunuz).
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// Yukum var ve inis sahasi olan seylere inebilirim.
// Cok sinirli bir uzay araciyim, biliyorum.
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 yalnizca inis sahasi bilgisini bilir.
    func land(on: LandingSiteHaving) -> String {
        return "Landed on \(on.landingSite) at April 8, 2016 20:52 UTC"
    }
}

let crs8 = SpaceXCRS8()
let barge = OfCourseIStillLoveYouBarge()
let spaceStation = InternationalSpaceStation()

spaceStation.fetchPayload(vehicle: crs8)
crs8.land(on: barge)
