---
layout: default
title: "객체지향 설계 원칙 in Swift 5"
lang: ko-KR
permalink: /ko-KR
---

객체지향 설계 원칙 in Swift 5
=========================

A short cheat-sheet with Playground ([OOD-Principles-In-Swift-ko-KR.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift-ko-KR.playground.zip)).

👷 Project maintained by: [@oktawian](https://bsky.app/profile/oktawian.bsky.social) (Oktawian Chojnacki)

🇰🇷 Translated by: [jwonyLee](https://github.com/jwonyLee) (JiWon Lee)

S.O.L.I.D.
==========

* [The Single Responsibility Principle (단일 책임 원칙)](#-the-single-responsibility-principle-단일-책임-원칙)
* [The Open Closed Principle (개방 폐쇄 원칙)](#-the-open-closed-principle-개방-폐쇄-원칙)
* [The Liskov Substitution Principle (리스코프 치환 원칙)](#-the-liskov-substitution-principle-리스코프-치환-원칙)
* [The Interface Segregation Principle (인터페이스 분리 원칙)](#-the-interface-segregation-principle-인터페이스-분리-원칙)
* [The Dependency Inversion Principle (의존관계 역전 원칙)](#-the-dependency-inversion-principle-의존관계-역전-원칙)




# 🔐 The Single Responsibility Principle (단일 책임 원칙)

클래스에는 단 한 가지 변경 이유만 존재해야 한다.

보다 정제된 정의: 모듈은 하나의, 오직 하나의 액터(이해관계자)에 대해서만
책임져야 한다. SRP는 "한 가지 일만 하라"는 것이 아니라, 같은 이유로 변경되는
것들을 모으고 다른 이유로 변경되는 것들을 분리하는 것이다. 하나의 클래스가
여러 액터를 담당하면, 한 액터가 요청한 변경이 다른 액터의 기대를 깨뜨릴 수 있다.

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

클래스의 동작을 수정하지 않고, 확장할 수 있어야 한다.

소프트웨어 엔티티(클래스, 모듈, 함수)는 확장에는 열려 있어야 하지만 수정에는
닫혀 있어야 한다. 핵심 통찰은, 하나의 변경이 의존하는 모듈들에 연쇄적으로
퍼지면 설계가 취약하다는 것이다. 추상화(프로토콜)에 의존함으로써 기존의 동작하는
코드를 변경하지 않고 새로운 코드를 작성하여 새로운 동작을 추가할 수 있다.

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

파생된 클래스는 기본 클래스를 대체할 수 있어야 한다.

하위 타입은 상위 타입의 행위적 계약을 준수해야 한다: 사전 조건을 강화하거나,
사후 조건을 약화하거나, 불변 조건을 위반해서는 안 된다. 기본 타입으로 작업하는
호출자는 하위 타입을 알지 못한 채 사용할 수 있어야 하며, 프로그램은 여전히
올바르게 동작해야 한다. 이 원칙을 위반하면 클라이언트 코드에 `if/else` 타입
검사가 스며드는 취약한 계층 구조가 생긴다.

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

클라이언트별로 세분화된 인터페이스를 만들어야 한다.

클라이언트는 자신이 사용하지 않는 메서드에 의존하도록 강제되어서는 안 된다.
인터페이스가 지나치게 커지면 클라이언트는 호출하지 않는 메서드에까지 결합되며,
그 관련 없는 메서드가 변경되면 클라이언트도 재컴파일하거나 재배포해야 할 수 있다.
비대한 인터페이스를 작고 역할별로 특화된 프로토콜로 분리하면 의존성을 좁고
응집력 있게 유지할 수 있다.

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

구체화에 의존하지 말고 추상화에 의존하라.

이 원칙을 정의하는 두 가지 규칙: (1) 고수준 모듈은 저수준 모듈에 의존해서는
안 된다 — 둘 다 추상화에 의존해야 한다. (2) 추상화는 세부 사항에 의존해서는
안 된다 — 세부 사항이 추상화에 의존해야 한다. 소스 코드 의존성을 메커니즘이 아닌
정책 방향으로 역전시킴으로써, 고수준 비즈니스 로직은 인프라와 구현 세부 사항의
변경으로부터 보호된다.

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
