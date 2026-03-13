/*:
# 🍴 The Interface Segregation Principle (인터페이스 분리 원칙)

클라이언트별로 세분화된 인터페이스를 만들어야 한다.

클라이언트는 자신이 사용하지 않는 메서드에 의존하도록 강제되어서는 안 된다.
인터페이스가 지나치게 커지면 클라이언트는 호출하지 않는 메서드에까지 결합되며,
그 관련 없는 메서드가 변경되면 클라이언트도 재컴파일하거나 재배포해야 할 수 있다.
비대한 인터페이스를 작고 역할별로 특화된 프로토콜로 분리하면 의존성을 좁고
응집력 있게 유지할 수 있다.

예시:
 */

// 방문 사이트가 있다.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// LandingSiteHaving 객체에 착륙할 수 있다.
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// 페이로드가 있다.
protocol PayloadHaving {
    var payload: String { get }
}

// 차량에서 페이로드를 가져올 수 있다 (예. Canadaarm을 통해).
protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {

    // ⚠️ 우주 정거장은 SpaceXCRS8의 착륙 능력에 대해 전혀 모른다.
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// 바지선 - 착륙 지점이 있다 (well, you get the idea).
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// 페이로드가 있고 착륙 지점이 있는 곳에 착륙할 수 있다.
// 매우 제한된 우주 비행체라는 것을 안다.
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 은 착륙지 정보만 알고 있다.
    func land(on: LandingSiteHaving) -> String {
        return "Landed on \(on.landingSite) at April 8, 2016 20:52 UTC"
    }
}

let crs8 = SpaceXCRS8()
let barge = OfCourseIStillLoveYouBarge()
let spaceStation = InternationalSpaceStation()

spaceStation.fetchPayload(vehicle: crs8)
crs8.land(on: barge)
