/*:
# ✋ The Open Closed Principle (개방 폐쇄 원칙)

클래스의 동작을 수정하지 않고, 확장할 수 있어야 한다.

소프트웨어 엔티티(클래스, 모듈, 함수)는 확장에는 열려 있어야 하지만 수정에는
닫혀 있어야 한다. 핵심 통찰은, 하나의 변경이 의존하는 모듈들에 연쇄적으로
퍼지면 설계가 취약하다는 것이다. 추상화(프로토콜)에 의존함으로써 기존의 동작하는
코드를 변경하지 않고 새로운 코드를 작성하여 새로운 동작을 추가할 수 있다.

예시:
 */

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

