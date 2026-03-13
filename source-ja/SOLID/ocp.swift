/*:
# ✋ The Open Closed Principle (開放閉鎖の原則)

クラスの振る舞いを変更せずに拡張できるべきです。

ソフトウェアエンティティ（クラス、モジュール、関数）は拡張に対して開いており、
修正に対して閉じているべきです。重要な洞察は、単一の変更が依存モジュールに連鎖的
に波及する場合、その設計は脆弱であるということです。抽象（プロトコル）に依存する
ことで、既存の動作するコードを変更せずに、新しいコードを書くことで新しい振る舞い
を追加できます。

例：
 */

protocol Shooting {
    func shoot() -> String
}

// 私はレーザービームです。射撃できます。
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// 私は武器を持っていて、全部一斉に発射できます。ドカン！ドカン！ドカン！
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

// 私はロケットランチャーです。ロケットを発射できます。
// ⚠️ ロケットランチャーのサポートを追加するために、既存のクラスを変更する必要はありません。
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()
