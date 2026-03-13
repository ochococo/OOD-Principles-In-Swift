/*:
# ✋ The Open Closed Principle (Acik/Kapali Ilkesi)

Bir sinifin davranisini, onu degistirmeden genisletebilmelisiniz.

Yazilim varliklari (siniflar, moduller, fonksiyonlar) genislemeye acik ancak
degisiklige kapali olmalidir. Temel fikir sudur: tek bir degisiklik bagli
modullere zincirleme olarak yayildiginda, tasarim kirilgandir. Soyutlamalara
(protokollere) dayanarak, yeni davranis yeni kod yazilarak eklenebilir —
mevcut, calisan kodu degistirmeden.

Ornek:
 */

protocol Shooting {
    func shoot() -> String
}

// Ben bir lazer isiniyim. Ates edebilirim.
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// Silahlarim var ve inanin bana hepsini ayni anda atesleyebilirim. Bum! Bum! Bum!
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

// Ben bir roketatarim. Roket atabilirim.
// ⚠️ Roketatar destegi eklemek icin mevcut siniflarda hicbir seyi degistirmeme gerek yok.
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()
