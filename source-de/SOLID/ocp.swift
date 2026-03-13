/*:
# ✋ The Open Closed Principle (Offen-Geschlossen-Prinzip)

Es sollte möglich sein, das Verhalten einer Klasse zu erweitern, ohne sie zu modifizieren.

Software-Entitäten (Klassen, Module, Funktionen) sollten offen für
Erweiterungen, aber geschlossen für Modifikationen sein. Die zentrale Erkenntnis
ist, dass wenn eine einzelne Änderung sich kaskadenartig durch abhängige Module
ausbreitet, das Design fragil ist. Durch das Stützen auf Abstraktionen
(Protokolle) kann neues Verhalten durch Schreiben von neuem Code hinzugefügt
werden — ohne bestehenden, funktionierenden Code zu ändern.

Beispiel:
 */

protocol Shooting {
    func shoot() -> String
}

// Ich bin ein Laserstrahl. Ich kann schießen.
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// Ich habe Waffen und glaubt mir, ich kann sie alle auf einmal abfeuern. Bumm! Bumm! Bumm!
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

// Ich bin ein Raketenwerfer. Ich kann eine Rakete abschießen.
// ⚠️ Um Raketenwerfer-Unterstützung hinzuzufügen, muss nichts an den bestehenden Klassen geändert werden.
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()
