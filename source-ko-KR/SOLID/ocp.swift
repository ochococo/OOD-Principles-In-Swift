/*:
# ✋ The Open Closed Principle (개방 폐쇄 원칙)

클래스의 동작을 수정하지 않고, 확장할 수 있어야 한다. ([자세히](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgN2M5MTkwM2EtNWFkZC00ZTI3LWFjZTUtNTFhZGZiYmUzODc1&hl=en))

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

