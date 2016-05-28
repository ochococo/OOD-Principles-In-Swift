/*:
# 🍴 The Interface Segregation Principle

Make fine grained interfaces that are client specific.
 */

// I have a landing site.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// I can land on LandingSiteHaving objects.
protocol Landing {
    func landOn(on: LandingSiteHaving) -> String
}

// I have payload.
protocol PayloadHaving {
    var payload: String { get }
}

// I can fetch payload from vehicle (ex. via Canadarm).
final class InternationalSpaceStation {
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// I'm a barge - I have landing site (well, you get the idea).
final class OfCourseIStillLoveYouBarge : LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// I have payload and can land on things having landing site.
// I'm a very limited Space Vehicle, I know.
final class SpaceXCRS8 : Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    func landOn(on: LandingSiteHaving) -> String {
        return "Landed on \(on.landingSite) at April 8, 2016 20:52 UTC"
    }
}

// Actors
let crs8 = SpaceXCRS8()
let barge = OfCourseIStillLoveYouBarge()
let spaceStation = InternationalSpaceStation()

// NOTE: Space station has no idea about landing capabilities of SpaceXCRS8.
spaceStation.fetchPayload(crs8)

// NOTE: CRS8 knows only about the landing site information.
crs8.landOn(barge)
