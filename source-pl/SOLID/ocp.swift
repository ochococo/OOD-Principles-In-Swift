/*:
# ✋ The Open Closed Principle (Zasada otwarte-zamknięte)

Powinno być możliwe rozszerzenie zachowania klasy bez jej modyfikacji.

Klasy, moduły i funkcje powinny być otwarte na rozszerzenia,
ale zamknięte na modyfikacje. Kluczowe spostrzeżenie jest takie, że gdy
pojedyncza zmiana rozchodzi się kaskadowo przez zależne moduły, projekt jest
kruchy. Opierając się na abstrakcjach (np. protokołach), nowe zachowanie można dodać
pisząc nowy kod — bez zmieniania istniejącego, działającego kodu.

Przykład:
 */

protocol Shooting {
    func shoot() -> String
}

// Jestem wiązką laserową. Potrafię strzelać.
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// Mam broń i uwierzcie mi, potrafię wystrzelić wszystko naraz. Bum! Bum! Bum!
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

// Jestem wyrzutnią rakiet. Potrafię wystrzelić rakietę.
// ⚠️ Aby dodać obsługę wyrzutni rakiet, nie muszę zmieniać niczego w istniejących klasach.
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()
