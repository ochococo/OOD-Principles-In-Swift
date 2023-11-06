
객체지향 설계 원칙 in Swift 5
=========================

A short cheat-sheet with Playground ([OOD-Principles-In-Swift-ko-KR.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift-ko-KR.playground.zip)).

👷 Project maintained by: [@nsmeme](http://twitter.com/nsmeme) (Oktawian Chojnacki)

🇰🇷 Translated by: [jwonyLee](https://github.com/jwonyLee) (JiWon Lee)

S.O.L.I.D.
==========

* [The Single Responsibility Principle (단일 책임 원칙)](#-the-single-responsibility-principle-단일-책임-원칙)
* [The Open Closed Principle (개방 폐쇄 원칙)](#-the-open-closed-principle-개방-폐쇄-원칙)
* [The Liskov Substitution Principle (리스코프 치환 원칙)](#-the-liskov-substitution-principle-리스코프-치환-원칙)
* [The Interface Segregation Principle (인터페이스 분리 원칙)](#-the-interface-segregation-principle-인터페이스-분리-원칙)
* [The Dependency Inversion Principle (의존관계 역전 원칙)](#-the-dependency-inversion-principle-의존관계-역전-원칙)




# 🔐 클래스에는 단 한 가지 변경 이유만 존재해야 한다. ([자세히](https://docs.google.com/open?id=0ByOwmqah_nuGNHEtcU5OekdDMkk))

예시:

```swift

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// 문. 캡슐화된 상태를 갖고 있으며 메서드를 사용해 변경할 수 있다.
struct PodBayDoor: Openable, Closeable {

    private enum State {
        case open
        case closed
    }

    private var state: State = .closed

    mutating func open() {
        state = .open
    }

    mutating func close() {
        state = .closed
    }
}

// 여는 일만 담당하며 안에 무엇이 들어있는 지, 어떻게 닫는 지 모른다.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// 닫는 일만 담당하며 안에 무엇이 들어있는 지, 어떻게 여는 지 모른다.
final class DoorCloser {
    private var door: Closeable

    init(door: Closeable) {
        self.door = door
    }

    func execute() {
        door.close()
    }
}

let door = PodBayDoor()

// ⚠️ `DoorOpeneer`만이 문을 여는 책임이 있다.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ 문을 닫은 후 다른 작업을 해야 하는 경우,
// 알람을 켜는 것처럼 `DoorOpener` 클래스를 변경할 필요가 없다.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()

```

# ✋ The Open Closed Principle (개방 폐쇄 원칙)

클래스의 동작을 수정하지 않고, 확장할 수 있어야 한다. ([자세히](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgN2M5MTkwM2EtNWFkZC00ZTI3LWFjZTUtNTFhZGZiYmUzODc1&hl=en))

예시:
 
```swift

protocol Shooting {
    func shoot() -> String
}

// 레이저 빔. 쏠 수 있다.
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// 무기가 있고 모든 걸 한 번에 발사할 수 있다고 믿는다. 빵야! 빵야! 빵야!
final class WeaponsComposite {

    let weapons: [Shooting]

    init(weapons: [Shooting]) {
        self.weapons = weapons
    }

    func shoot() -> [String] {
        return weapons.map { $0.shoot() }
    }
}

let laser = LaserBeam()
var weapons = WeaponsComposite(weapons: [laser])

weapons.shoot()

// 로켓 런처. 로켓을 쏠 수 있다.
// ⚠️ 로켓 런처를 추가하기 위해 기존 클래스에서 아무것도 변경할 필요가 없다.
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()

```

# 👥 The Liskov Substitution Principle (리스코프 치환 원칙)

파생된 클래스는 기본 클래스를 대체할 수 있어야 한다. ([자세히](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgNzAzZjA5ZmItNjU3NS00MzQ5LTkwYjMtMDJhNDU5ZTM0MTlh&hl=en))

예시:

```swift

let requestKey: String = "NSURLRequestKey"

// NSError 서브클래스. 추가적인 기능을 제공하지만 원래 기능을 엉망으로 만들진 않는다.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// 데이터를 가져오지 못하면 RequestError를 반환한다.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// RequestError가 무엇인지 모르고 실패할 것이며, NSError를 반환한다.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// ⚠️ 확인. 이것은 내 관점에서 완벽한 NSError 인스턴스이다.
let error: Int? = result.error?.code

// ⚠️ 하지만 이봐! 이게 무슨 일이죠? RequestError이기도 하다! 대단해!
if let requestError = result.error as? RequestError {
    requestError.request
}

```

# 🍴 The Interface Segregation Principle (인터페이스 분리 원칙)

클라이언트별로 세분화된 인터페이스를 만들어야 한다. ([자세히](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgOTViYjJhYzMtMzYxMC00MzFjLWJjMzYtOGJiMDc5N2JkYmJi&hl=en))

예시:
 
```swift

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
```

# 🔝 The Dependency Inversion Principle (의존관계 역전 원칙)

구체화에 의존하지 말고 추상화에 의존하라. ([자세히](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgMjdlMWIzNGUtZTQ0NC00ZjQ5LTkwYzQtZjRhMDRlNTQ3ZGMz&hl=en))

예시:

```swift

protocol TimeTraveling {
    func travelInTime(time: TimeInterval) -> String
}

final class DeLorean: TimeTraveling {
    func travelInTime(time: TimeInterval) -> String {
        return "Used Flux Capacitor and travelled in time by: \(time)s"
    }
}

final class EmmettBrown {
    private let timeMachine: TimeTraveling

    // ⚠️ Emmet Brown은 `DeLorean`을 구체적인 클래스인 `DeLorean`이 아닌, `TimeTraveling` 장치로 받는다.
    init(timeMachine: TimeTraveling) {
        self.timeMachine = timeMachine
    }

    func travelInTime(time: TimeInterval) -> String {
        return timeMachine.travelInTime(time: time)
    }
}

let timeMachine = DeLorean()

let mastermind = EmmettBrown(timeMachine: timeMachine)
mastermind.travelInTime(time: -3600 * 8760)
```


Info
====

📖 Descriptions from: [The Principles of OOD by Uncle Bob](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)
