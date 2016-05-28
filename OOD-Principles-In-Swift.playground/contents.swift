import Swift
import Foundation

/*:

The Principles of OOD in Swift 1.2
==================================

A short cheat-sheet with Xcode 6.3 Playground ([OOD-Principles-In-Swift.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift.playground.zip)).

👷 Project maintained by: [@nsmeme](http://twitter.com/nsmeme) (Oktawian Chojnacki)

S.O.L.I.D.
==========

* [The Single Responsibility Principle](#-the-single-responsibility-principle)
* [The Open Closed Principle](#-the-open-closed-principle)
* [The Liskov Substitution Principle](#-the-liskov-substitution-principle)
* [The Interface Segregation Principle](#-the-interface-segregation-principle)
* [The Dependency Inversion Principle](#-the-dependency-inversion-principle)

*//*:
# 🔐 The Single Responsibility Principle

A class should have one, and only one, reason to change.

Example:
*/

protocol CanBeOpened {
    func open()
}

protocol CanBeClosed {
    func close()
}

// I'm the door. I have an encapsulated state and you can change it using methods.
final class PodBayDoor : CanBeOpened, CanBeClosed {
    private var stateOpen = false

    func open() {
        stateOpen = true
    }

    func close() {
        stateOpen = false
    }
}

// I'm only responsible for opening, no idea what's inside or how to close.
class DoorOpener {
    let door:CanBeOpened

    init(door: CanBeOpened) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// I'm only responsible for closing, no idea what's inside or how to open.
class DoorCloser {
    let door:CanBeClosed

    init(door: CanBeClosed) {
        self.door = door
    }

    func execute() {
        door.close()
    }
}

let door = PodBayDoor()
let doorOpener = DoorOpener(door: door)
let doorCloser = DoorCloser(door: door)
doorOpener.execute()
doorCloser.execute()
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
final class WeaponsComposite {

    let weapons:[CanShoot]

    init(_ weapons:[CanShoot]) {
        self.weapons = weapons
    }

    func shoot() -> [String] {
        return weapons.map { $0.shoot() }
    }
}

let laser = LaserBeam()
var weapons = WeaponsComposite([laser])

weapons.shoot()

// I'm a rocket launcher. I can shoot a rocket.
// NOTE: To add rocket launcher support I don't need to change anything in existing classes.
final class RocketLauncher : CanShoot {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite([laser, rocket])
weapons.shoot()
/*:
# 👥 The Liskov Substitution Principle

Derived classes must be substitutable for their base classes.

*/

let requestKey:NSString = "NSURLRequestKey"

// I'm a NSError subclass. I provide additional functionality but don't mess with original ones.
class RequestError : NSError {

    var request : NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// I fail to fetch data and will return RequestError.
func fetchData(request:NSURLRequest) -> (data:NSData?, error:RequestError?) {

    let userInfo:[NSObject:AnyObject] = [ requestKey : request ]

    return (nil, RequestError(domain:"DOMAIN", code: 1, userInfo: userInfo))
}

// I don't know what RequestError is and will fail and return a NSError.
func willReturnObjectOrError() -> (object:AnyObject?, error:NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request)

    return (result.data , result.error)
}

let result = willReturnObjectOrError()

// Ok. This is a perfect NSError instance from my perspective.
let error:Int? = result.error?.code

// But hey! What's that? It's also a RequestError! Nice!
if let requestError = result.error as? RequestError {
    requestError.request;
}
/*:
# 🍴 The Interface Segregation Principle

Make fine grained interfaces that are client specific.
 */

// I have a landing site.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// I can land on LandingSiteHaving objects.
protocol Landing {
    func landOn(on: LandingSiteHaving) -> String
}

// I have payload.
protocol PayloadHaving {
    var payload: String { get }
}

// I can fetch payload from vehicle (ex. via Canadarm).
final class InternationalSpaceStation {
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// I'm a barge - I have landing site (well, you get the idea).
final class OfCourseIStillLoveYouBarge : LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// I have payload and can land on things having landing site.
// I'm a very limited Space Vehicle, I know.
final class SpaceXCRS8 : Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    func landOn(on: LandingSiteHaving) -> String {
        return "Landed on \(on.landingSite) at April 8, 2016 20:52 UTC"
    }
}

// Actors
let crs8 = SpaceXCRS8()
let barge = OfCourseIStillLoveYouBarge()
let spaceStation = InternationalSpaceStation()

// NOTE: Space station has no idea about landing capabilities of SpaceXCRS8.
spaceStation.fetchPayload(crs8)

// NOTE: CRS8 knows only about the landing site information.
crs8.landOn(barge)
/*:
# 🚧 The Dependency Inversion Principle

Depend on abstractions, not on concretions.

*//*:
Info
====

📖 Descriptions from: [Uncle Bob](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)

*/