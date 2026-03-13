/*:
Prinzipien des objektorientierten Designs in Swift 5
=========================

A short cheat-sheet with Playground ([OOD-Principles-In-Swift-de.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift-de.playground.zip)).

👷 Project maintained by: [@oktawian](https://bsky.app/profile/oktawian.bsky.social) (Oktawian Chojnacki)

S.O.L.I.D.
==========

* [The Single Responsibility Principle (Prinzip der einzigen Verantwortung)](#-the-single-responsibility-principle-prinzip-der-einzigen-verantwortung)
* [The Open Closed Principle (Offen-Geschlossen-Prinzip)](#-the-open-closed-principle-offen-geschlossen-prinzip)
* [The Liskov Substitution Principle (Liskovsches Substitutionsprinzip)](#-the-liskov-substitution-principle-liskovsches-substitutionsprinzip)
* [The Interface Segregation Principle (Schnittstellentrennungsprinzip)](#-the-interface-segregation-principle-schnittstellentrennungsprinzip)
* [The Dependency Inversion Principle (Prinzip der Abhängigkeitsinversion)](#-the-dependency-inversion-principle-prinzip-der-abhängigkeitsinversion)
*/

import Foundation

/*:
# 🔐 The Single Responsibility Principle (Prinzip der einzigen Verantwortung)

Eine Klasse sollte einen, und nur einen, Grund zur Änderung haben.

Eine präzisere Formulierung: Ein Modul sollte gegenüber einem, und nur einem,
Akteur (Stakeholder) verantwortlich sein. Das SRP bedeutet nicht „mach nur eine
Sache" — es geht darum, Dinge zusammenzufassen, die sich aus denselben Gründen
ändern, und Dinge zu trennen, die sich aus unterschiedlichen Gründen ändern. Wenn
eine Klasse mehreren Akteuren dient, können Änderungen, die von einem Akteur
angefordert werden, die Erwartungen eines anderen verletzen.

Beispiel:
*/

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// Ich bin eine Tür. Ich habe einen gekapselten Zustand, der über Methoden geändert werden kann.
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

// Ich bin nur für das Öffnen zuständig, ich weiß nicht was drin ist oder wie man schließt.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// Ich bin nur für das Schließen zuständig, ich weiß nicht was drin ist oder wie man öffnet.
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


// ⚠️ Nur der `DoorOpener` ist für das Öffnen der Tür verantwortlich.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ Wenn beim Schließen der Tür eine zusätzliche Operation ausgeführt werden soll,
// z. B. das Einschalten des Alarms, muss die Klasse `DoorOpener` nicht geändert werden.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()
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
/*:
# 👥 The Liskov Substitution Principle (Liskovsches Substitutionsprinzip)

Abgeleitete Klassen müssen durch ihre Basisklassen ersetzbar sein.

Untertypen müssen den Verhaltensvertrag ihrer Obertypen einhalten: Sie dürfen
Vorbedingungen nicht verschärfen, Nachbedingungen nicht abschwächen und
Invarianten nicht verletzen. Ein Aufrufer, der mit einem Basistyp arbeitet,
muss jeden Untertyp verwenden können, ohne davon zu wissen, und das Programm
sollte weiterhin korrekt funktionieren. Verletzungen dieses Prinzips führen zu
fragilen Hierarchien, in denen `if/else`-Typprüfungen im Client-Code auftauchen.

Beispiel:
*/

let requestKey: String = "NSURLRequestKey"

// Ich bin eine NSError-Unterklasse. Ich biete zusätzliche Funktionalität, ohne die ursprüngliche zu beeinträchtigen.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// Ich kann die Daten nicht abrufen und werde einen RequestError zurückgeben.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// Ich weiß nicht was RequestError ist und werde einen NSError zurückgeben.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// OK. Aus meiner Sicht ist das eine perfekte NSError-Instanz.
let error: Int? = result.error?.code

// ⚠️ Aber Moment! Was ist das? Es ist auch ein RequestError! Großartig!
if let requestError = result.error as? RequestError {
    requestError.request
}
/*:
# 🍴 The Interface Segregation Principle (Schnittstellentrennungsprinzip)

Erstelle feingranulare Schnittstellen, die auf den jeweiligen Client zugeschnitten sind.

Kein Client sollte gezwungen sein, von Methoden abzuhängen, die er nicht
verwendet. Wenn eine Schnittstelle zu groß wird, werden ihre Clients an Methoden
gekoppelt, die sie nie aufrufen — und Änderungen an diesen nicht verwandten
Methoden können Clients zur Neukompilierung oder erneuten Bereitstellung zwingen.
Das Aufteilen umfangreicher Schnittstellen in kleinere, spezialisierte Protokolle
hält Abhängigkeiten schmal und kohäsiv.

Beispiel:
 */

// Ich habe einen Landeplatz.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// Ich kann auf LandingSiteHaving-Objekten landen.
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// Ich habe Nutzlast.
protocol PayloadHaving {
    var payload: String { get }
}

// Ich kann Nutzlast von einem Fahrzeug abholen (z. B. über Canadarm).

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ Die Raumstation hat keine Ahnung von den Landefähigkeiten der SpaceXCRS8.
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// Ich bin ein Lastkahn — ich habe einen Landeplatz (nun ja, Sie verstehen schon).
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// Ich habe Nutzlast und kann auf Objekten mit Landeplatz landen.
// Ich bin ein sehr eingeschränktes Raumfahrzeug, ich weiß.
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 kennt nur die Information über den Landeplatz.
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
# 🔝 The Dependency Inversion Principle (Prinzip der Abhängigkeitsinversion)

Abhängigkeiten sollten auf Abstraktionen basieren, nicht auf Konkretionen.

Zwei formale Regeln definieren dieses Prinzip: (1) Module höherer Ebene sollten
nicht von Modulen niedrigerer Ebene abhängen — beide sollten von Abstraktionen
abhängen. (2) Abstraktionen sollten nicht von Details abhängen — Details sollten
von Abstraktionen abhängen. Durch die Umkehrung der Quellcode-Abhängigkeit, so
dass sie auf Richtlinien statt auf Mechanismen zeigt, wird die Geschäftslogik
höherer Ebene immun gegen Änderungen in der Infrastruktur und den
Implementierungsdetails.

Beispiel:
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

    // ⚠️ Emmett Brown erhält ein `TimeTraveling`-Gerät, nicht die konkrete Klasse `DeLorean`!
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
