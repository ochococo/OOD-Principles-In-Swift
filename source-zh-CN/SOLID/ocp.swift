/*:
# ✋ The Open Closed Principle (开闭原则)

应该能够扩展类的行为，而无需修改它。

软件实体（类、模块、函数）应该对扩展开放，但对修改关闭。关键的洞察是，当单一
变更在依赖模块中级联传播时，设计是脆弱的。通过依赖抽象（协议），可以通过编写
新代码来添加新行为——而不是修改现有的、可正常工作的代码。

示例：
 */

protocol Shooting {
    func shoot() -> String
}

// 我是一束激光。我可以射击。
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// 我拥有武器，相信我，我可以同时发射所有武器。轰！轰！轰！
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

// 我是一个火箭发射器。我可以发射火箭。
// ⚠️ 要添加火箭发射器的支持，我不需要修改现有类中的任何内容。
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()
