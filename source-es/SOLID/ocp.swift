/*:
# ✋ The Open Closed Principle (Principio abierto-cerrado)

Debería ser posible extender el comportamiento de una clase sin modificarla.

Las entidades de software (clases, módulos, funciones) deben estar abiertas
a la extensión pero cerradas a la modificación. La idea clave es que cuando
un solo cambio se propaga en cascada a través de módulos dependientes, el diseño
es frágil. Al apoyarse en abstracciones (protocolos), se puede añadir nuevo
comportamiento escribiendo código nuevo — sin cambiar el código existente
que ya funciona.

Ejemplo:
 */

protocol Shooting {
    func shoot() -> String
}

// Soy un rayo láser. Puedo disparar.
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// Tengo armas y créanme, puedo dispararlas todas a la vez. ¡Bum! ¡Bum! ¡Bum!
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

// Soy un lanzacohetes. Puedo lanzar un cohete.
// ⚠️ Para añadir soporte de lanzacohetes no necesito cambiar nada en las clases existentes.
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()
