/*:
Principes de conception orientee objet en Swift 5
=========================

Aide-memoire avec Playground ([OOD-Principles-In-Swift-fr.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift-fr.playground.zip)).

👷 Project maintained by: [@oktawian](https://bsky.app/profile/oktawian.bsky.social) (Oktawian Chojnacki)

S.O.L.I.D.
==========

* [The Single Responsibility Principle (Principe de responsabilite unique)](#-the-single-responsibility-principle-principe-de-responsabilite-unique)
* [The Open Closed Principle (Principe ouvert/ferme)](#-the-open-closed-principle-principe-ouvertferme)
* [The Liskov Substitution Principle (Principe de substitution de Liskov)](#-the-liskov-substitution-principle-principe-de-substitution-de-liskov)
* [The Interface Segregation Principle (Principe de segregation des interfaces)](#-the-interface-segregation-principle-principe-de-segregation-des-interfaces)
* [The Dependency Inversion Principle (Principe d'inversion des dependances)](#-the-dependency-inversion-principle-principe-dinversion-des-dependances)
*/

import Foundation

/*:
# 🔐 The Single Responsibility Principle (Principe de responsabilite unique)

Une classe ne devrait avoir qu'une seule raison de changer.

Formulation plus precise : un module ne devrait etre responsable que devant un
seul acteur (partie prenante). Le SRP ne signifie pas « faire une seule chose »
— il s'agit de regrouper ce qui change pour les memes raisons et de separer ce
qui change pour des raisons differentes. Quand une classe sert plusieurs acteurs,
les modifications demandees par un acteur risquent de compromettre les attentes
d'un autre.

Exemple :
*/

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// Je suis la porte. J'ai un etat encapsule que vous pouvez modifier via des methodes.
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

// Je suis uniquement responsable de l'ouverture, je ne sais pas ce qu'il y a a l'interieur ni comment fermer.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// Je suis uniquement responsable de la fermeture, je ne sais pas ce qu'il y a a l'interieur ni comment ouvrir.
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


// ⚠️ Seul `DoorOpener` est responsable de l'ouverture de la porte.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ Si une autre operation doit etre effectuee lors de la fermeture de la porte,
// comme activer l'alarme, il n'est pas necessaire de modifier la classe `DoorOpener`.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()
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
/*:
# 👥 The Liskov Substitution Principle (Principe de substitution de Liskov)

Les classes derivees doivent pouvoir se substituer a leurs classes de base.

Les sous-types doivent respecter le contrat comportemental de leurs supertypes :
ils ne doivent pas renforcer les preconditions, affaiblir les postconditions ni
violer les invariants. Un appelant qui travaille avec un type de base doit pouvoir
utiliser n'importe quel sous-type sans le savoir, et le programme doit continuer
a fonctionner correctement. Les violations de ce principe menent a des hierarchies
fragiles ou des verifications de type `if/else` s'infiltrent dans le code client.

Exemple :
*/

let requestKey: String = "NSURLRequestKey"

// Je suis une sous-classe de NSError. Je fournis des fonctionnalites supplementaires sans perturber les originales.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// Je n'ai pas reussi a recuperer les donnees et je vais retourner une RequestError.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// Je ne sais pas ce qu'est une RequestError et je vais echouer et retourner une NSError.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// OK. De mon point de vue, c'est une instance parfaite de NSError.
let error: Int? = result.error?.code

// ⚠️ Mais attendez ! Qu'est-ce que c'est ? C'est aussi une RequestError ! Genial !
if let requestError = result.error as? RequestError {
    requestError.request
}
/*:
# 🍴 The Interface Segregation Principle (Principe de segregation des interfaces)

Creez des interfaces a granularite fine adaptees a chaque client.

Aucun client ne devrait etre force de dependre de methodes qu'il n'utilise pas.
Quand une interface devient trop volumineuse, ses clients se retrouvent couples
a des methodes qu'ils n'appellent jamais — et les modifications de ces methodes
non liees peuvent forcer les clients a recompiler ou a se redeployer. Diviser
les interfaces trop larges en protocoles plus petits et specialises maintient
les dependances etroites et coherentes.

Exemple :
 */

// J'ai un site d'atterrissage.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// Je peux atterrir sur des objets LandingSiteHaving.
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// J'ai une charge utile.
protocol PayloadHaving {
    var payload: String { get }
}

// Je peux recuperer la charge utile d'un vehicule (par ex. via le Canadarm).

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ La station spatiale ignore tout des capacites d'atterrissage de SpaceXCRS8.
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// Je suis une barge — j'ai un site d'atterrissage (enfin, vous voyez l'idee).
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// J'ai une charge utile et je peux atterrir sur des objets ayant un site d'atterrissage.
// Je suis un vehicule spatial tres limite, je le sais.
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 ne connait que les informations relatives au site d'atterrissage.
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
# 🔝 The Dependency Inversion Principle (Principe d'inversion des dependances)

Dependez des abstractions, pas des implementations concretes.

Deux regles formelles definissent ce principe : (1) Les modules de haut niveau
ne doivent pas dependre des modules de bas niveau — les deux doivent dependre
d'abstractions. (2) Les abstractions ne doivent pas dependre des details — les
details doivent dependre des abstractions. En inversant la dependance du code
source pour qu'elle pointe vers les politiques plutot que les mecanismes, la
logique metier de haut niveau devient immunisee contre les changements
d'infrastructure et de details d'implementation.

Exemple :
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

    // ⚠️ Emmett Brown recoit un dispositif `TimeTraveling`, pas la classe concrete `DeLorean` !
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
