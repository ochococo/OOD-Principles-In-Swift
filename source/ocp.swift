/*:
# ✋ The Open Closed Principle

You should be able to extend a classes behavior, without modifying it.

*/

protocol CanShoot {
    func shoot() -> String
}

// I'm a laser beam. I can shoot.
final class LaserBeam : CanShoot {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// I have weapons and trust me I can fire them all at once. Boom! Boom! Boom!
final class DeathStar {

    let weapons: [CanShoot]

    init(_ weapons: [CanShoot]) {
        self.weapons = weapons
    }

    func shoot() -> [String] {
        return weapons.forEach { $0.shoot() }
    }
}

let laser = LaserBeam()
var weapons = DeathStar([laser])

weapons.shoot()

// I'm a rocket launcher. I can shoot a rocket.
// NOTE: To add rocket launcher support I don't need to change anything in existing classes.
final class RocketLauncher : CanShoot {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = DeathStar([laser, rocket])
weapons.shoot()
