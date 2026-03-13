/*:
# ✋ The Open Closed Principle

You should be able to extend a class's behavior, without modifying it.

Software entities (classes, modules, functions) should be open for extension
but closed for modification. The key insight is that when a single change
ripples through dependent modules, the design is fragile. By relying on
abstractions (protocols), new behavior can be added by writing new code —
not by changing existing, working code.

Example:
 */

protocol Shooting {
    func shoot() -> String
}

// I'm a laser beam. I can shoot.
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// I have weapons and trust me I can fire them all at once. Boom! Boom! Boom!
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

// I'm a rocket launcher. I can shoot a rocket.
// ⚠️ To add rocket launcher support I don't need to change anything in existing classes.
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()

