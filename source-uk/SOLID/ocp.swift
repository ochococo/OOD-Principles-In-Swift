/*:
# ✋ The Open Closed Principle (Принцип відкритості-закритості)

Має бути можливо розширити поведінку класу без його модифікації.

Програмні сутності (класи, модулі, функції) повинні бути відкриті для
розширення, але закриті для модифікації. Ключове спостереження полягає в тому,
що коли одна зміна каскадно поширюється через залежні модулі, проєкт є крихким.
Спираючись на абстракції (протоколи), нову поведінку можна додати, написавши
новий код — без зміни наявного, працюючого коду.

Приклад:
 */

protocol Shooting {
    func shoot() -> String
}

// Я — лазерний промінь. Я вмію стріляти.
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// Я маю зброю, і повірте, я можу вистрілити з усього одразу. Бум! Бум! Бум!
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

// Я — ракетна установка. Я вмію запускати ракету.
// ⚠️ Щоб додати підтримку ракетної установки, не потрібно змінювати нічого в існуючих класах.
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()
