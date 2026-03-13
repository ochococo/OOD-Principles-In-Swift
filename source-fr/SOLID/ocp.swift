/*:
# ✋ The Open Closed Principle (Principe ouvert/ferme)

Il devrait etre possible d'etendre le comportement d'une classe sans la modifier.

Les entites logicielles (classes, modules, fonctions) doivent etre ouvertes
a l'extension mais fermees a la modification. L'observation cle est que lorsqu'un
changement unique se propage en cascade a travers les modules dependants, la
conception est fragile. En s'appuyant sur des abstractions (protocoles), un
nouveau comportement peut etre ajoute en ecrivant du nouveau code — sans modifier
le code existant et fonctionnel.

Exemple :
 */

protocol Shooting {
    func shoot() -> String
}

// Je suis un rayon laser. Je peux tirer.
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// J'ai des armes et croyez-moi, je peux toutes les tirer en meme temps. Boum ! Boum ! Boum !
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

// Je suis un lance-roquettes. Je peux tirer une roquette.
// ⚠️ Pour ajouter la prise en charge du lance-roquettes, je n'ai pas besoin de modifier quoi que ce soit dans les classes existantes.
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()
