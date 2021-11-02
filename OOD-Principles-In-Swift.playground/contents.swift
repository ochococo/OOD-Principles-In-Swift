/*:

The Principles of OOD in Swift 5
================================

A short cheat-sheet with Playground ([OOD-Principles-In-Swift.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift.playground.zip)).

👷 Project maintained by: [@nsmeme](http://twitter.com/nsmeme) (Oktawian Chojnacki)

S.O.L.I.D.
==========

* [The Single Responsibility Principle](#-the-single-responsibility-principle)
* [The Open Closed Principle](#-the-open-closed-principle)
* [The Liskov Substitution Principle](#-the-liskov-substitution-principle)
* [The Interface Segregation Principle](#-the-interface-segregation-principle)
* [The Dependency Inversion Principle](#-the-dependency-inversion-principle)

*/

import Foundation

/*:
# 🔐 The Single Responsibility Principle

A class should have one, and only one, reason to change. ([read more](https://docs.google.com/open?id=0ByOwmqah_nuGNHEtcU5OekdDMkk))

Example:
*/

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// I'm the door. I have an encapsulated state and you can change it using methods.
struct PodBayDoor: Openable, Closeable {

    private enum State {
        case open
        case closed
    }

    private var state: State = .closed

    mutating func open() {
        state = .open
    }

    mutating func close() {
        state = .closed
    }
}

// I'm only responsible for opening, no idea what's inside or how to close.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// I'm only responsible for closing, no idea what's inside or how to open.
final class DoorCloser {
    private var door: Closeable

    init(door: Closeable) {
        self.door = door
    }

    func execute() {
        door.close()
    }
}

let door = PodBayDoor()

 
// ⚠️ Only the `DoorOpener` is responsible for opening the door.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ If another operation should be made upon closing the door,
// like switching on the alarm, you don't have to change the `DoorOpener` class.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()

/*:
# ✋ The Open Closed Principle

You should be able to extend a classes behavior, without modifying it. ([read more](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgN2M5MTkwM2EtNWFkZC00ZTI3LWFjZTUtNTFhZGZiYmUzODc1&hl=en))

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

/*:
# 👥 The Liskov Substitution Principle

Derived classes must be substitutable for their base classes. ([read more](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgNzAzZjA5ZmItNjU3NS00MzQ5LTkwYjMtMDJhNDU5ZTM0MTlh&hl=en))

Example:
*/

let requestKey: String = "NSURLRequestKey"

// I'm a NSError subclass. I provide additional functionality but don't mess with original ones.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// I fail to fetch data and will return RequestError.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// I don't know what RequestError is and will fail and return a NSError.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// Ok. This is a perfect NSError instance from my perspective.
let error: Int? = result.error?.code

// ⚠️ But hey! What's that? It's also a RequestError! Nice!
if let requestError = result.error as? RequestError {
    requestError.request
}

/*:
# 🍴 The Interface Segregation Principle

Make fine grained interfaces that are client specific. ([read more](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgOTViYjJhYzMtMzYxMC00MzFjLWJjMzYtOGJiMDc5N2JkYmJi&hl=en))

Example:
 */

// I have a landing site.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// I can land on LandingSiteHaving objects.
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// I have payload.
protocol PayloadHaving {
    var payload: String { get }
}

// I can fetch payload from vehicle (ex. via Canadarm).

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ Space station has no idea about landing capabilities of SpaceXCRS8.
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// I'm a barge - I have landing site (well, you get the idea).
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// I have payload and can land on things having landing site.
// I'm a very limited Space Vehicle, I know.
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 knows only about the landing site information.
    func land(on: LandingSiteHaving) -> String {
        return "Landed on \(on.landingSite) at April 8, 2016 20:52 UTC"
    }
}

let crs8 = SpaceXCRS8()
let barge = OfCourseIStillLoveYouBarge()
let spaceStation = InternationalSpaceStation()

spaceStation.fetchPayload(vehicle: crs8)
crs8.land(on: barge)
/*:
# 🔝 The Dependency Inversion Principle

Depend on abstractions, not on concretions. ([read more](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgMjdlMWIzNGUtZTQ0NC00ZjQ5LTkwYzQtZjRhMDRlNTQ3ZGMz&hl=en))

Example:
*/

protocol TimeTraveling {
    func travelInTime(time: TimeInterval) -> String
}

final class DeLorean: TimeTraveling {
	func travelInTime(time: TimeInterval) -> String {
		return "Used Flux Capacitor and travelled in time by: \(time)s"
	}
}

final class EmmettBrown {
	private let timeMachine: TimeTraveling

    // ⚠️ Emmet Brown is given a `TimeTraveling` device, not the concrete class `DeLorean`!
	init(timeMachine: TimeTraveling) {
		self.timeMachine = timeMachine
	}

	func travelInTime(time: TimeInterval) -> String {
		return timeMachine.travelInTime(time: time)
	}
}

let timeMachine = DeLorean()

let mastermind = EmmettBrown(timeMachine: timeMachine)
mastermind.travelInTime(time: -3600 * 8760)
/*:

Info
====

📖 Descriptions from: [The Principles of OOD by Uncle Bob](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)

*/
