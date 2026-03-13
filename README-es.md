---
layout: default
title: "Principios de diseño orientado a objetos en Swift 5"
lang: es
permalink: /es
---

Principios de diseño orientado a objetos en Swift 5
=========================

A short cheat-sheet with Playground ([OOD-Principles-In-Swift-es.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift-es.playground.zip)).

👷 Project maintained by: [@oktawian](https://bsky.app/profile/oktawian.bsky.social) (Oktawian Chojnacki)

S.O.L.I.D.
==========

* [The Single Responsibility Principle (Principio de responsabilidad única)](#-the-single-responsibility-principle-principio-de-responsabilidad-única)
* [The Open Closed Principle (Principio abierto-cerrado)](#-the-open-closed-principle-principio-abierto-cerrado)
* [The Liskov Substitution Principle (Principio de sustitución de Liskov)](#-the-liskov-substitution-principle-principio-de-sustitución-de-liskov)
* [The Interface Segregation Principle (Principio de segregación de interfaces)](#-the-interface-segregation-principle-principio-de-segregación-de-interfaces)
* [The Dependency Inversion Principle (Principio de inversión de dependencias)](#-the-dependency-inversion-principle-principio-de-inversión-de-dependencias)



# 🔐 The Single Responsibility Principle (Principio de responsabilidad única)

Una clase debe tener una, y solo una, razón para cambiar.

Una formulación más precisa: un módulo debe ser responsable ante uno, y solo
uno, actor (interesado). El SRP no se trata de "hacer una sola cosa" — se
trata de agrupar las cosas que cambian por las mismas razones y separar las
que cambian por razones diferentes. Cuando una clase sirve a múltiples actores,
los cambios solicitados por un actor pueden romper las expectativas de otro.

Ejemplo:

```swift

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// Soy una puerta. Tengo un estado encapsulado que se puede cambiar mediante métodos.
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

// Solo soy responsable de abrir, no sé qué hay dentro ni cómo cerrar.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// Solo soy responsable de cerrar, no sé qué hay dentro ni cómo abrir.
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


// ⚠️ Solo `DoorOpener` es responsable de abrir la puerta.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ Si al cerrar la puerta se debe realizar una operación adicional,
// como activar la alarma, no es necesario cambiar la clase `DoorOpener`.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()
```

# ✋ The Open Closed Principle (Principio abierto-cerrado)

Debería ser posible extender el comportamiento de una clase sin modificarla.

Las entidades de software (clases, módulos, funciones) deben estar abiertas
a la extensión pero cerradas a la modificación. La idea clave es que cuando
un solo cambio se propaga en cascada a través de módulos dependientes, el diseño
es frágil. Al apoyarse en abstracciones (protocolos), se puede añadir nuevo
comportamiento escribiendo código nuevo — sin cambiar el código existente
que ya funciona.

Ejemplo:
 
```swift

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
```

# 👥 The Liskov Substitution Principle (Principio de sustitución de Liskov)

Las clases derivadas deben poder sustituir a sus clases base.

Los subtipos deben respetar el contrato de comportamiento de sus supertipos: no
deben fortalecer las precondiciones, debilitar las postcondiciones ni violar los
invariantes. Un llamador que trabaja con un tipo base debe poder usar cualquier
subtipo sin saberlo, y el programa debe seguir comportándose correctamente. Las
violaciones de este principio conducen a jerarquías frágiles donde aparecen
comprobaciones de tipo `if/else` en el código cliente.

Ejemplo:

```swift

let requestKey: String = "NSURLRequestKey"

// Soy una subclase de NSError. Proporciono funcionalidad adicional pero no rompo la original.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// No logro obtener los datos y devolveré un RequestError.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// No sé qué es RequestError y devolveré un NSError.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// OK. Desde mi perspectiva es una instancia perfecta de NSError.
let error: Int? = result.error?.code

// ⚠️ ¡Pero espera! ¿Qué es eso? ¡También es un RequestError! ¡Genial!
if let requestError = result.error as? RequestError {
    requestError.request
}
```

# 🍴 The Interface Segregation Principle (Principio de segregación de interfaces)

Crea interfaces de grano fino adaptadas al cliente específico.

Ningún cliente debería verse obligado a depender de métodos que no utiliza.
Cuando una interfaz crece demasiado, sus clientes quedan acoplados a métodos
que nunca invocan — y los cambios en esos métodos no relacionados pueden forzar
a los clientes a recompilar o redesplegar. Dividir las interfaces grandes en
protocolos más pequeños y especializados mantiene las dependencias estrechas
y cohesivas.

Ejemplo:
 
```swift

// Tengo un sitio de aterrizaje.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// Puedo aterrizar en objetos LandingSiteHaving.
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// Tengo carga útil.
protocol PayloadHaving {
    var payload: String { get }
}

// Puedo recoger la carga útil de un vehículo (por ejemplo, mediante Canadarm).

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ La estación espacial no sabe nada sobre las capacidades de aterrizaje de SpaceXCRS8.
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// Soy una barcaza — tengo un sitio de aterrizaje (bueno, ya entienden la idea).
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// Tengo carga útil y puedo aterrizar en objetos con sitio de aterrizaje.
// Soy un vehículo espacial muy limitado, lo sé.
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 solo conoce la información del sitio de aterrizaje.
    func land(on: LandingSiteHaving) -> String {
        return "Landed on \(on.landingSite) at April 8, 2016 20:52 UTC"
    }
}

let crs8 = SpaceXCRS8()
let barge = OfCourseIStillLoveYouBarge()
let spaceStation = InternationalSpaceStation()

spaceStation.fetchPayload(vehicle: crs8)
crs8.land(on: barge)
```

# 🔝 The Dependency Inversion Principle (Principio de inversión de dependencias)

Depende de abstracciones, no de concreciones.

Dos reglas formales definen este principio: (1) Los módulos de alto nivel no
deben depender de módulos de bajo nivel — ambos deben depender de abstracciones.
(2) Las abstracciones no deben depender de los detalles — los detalles deben
depender de las abstracciones. Al invertir la dependencia del código fuente para
que apunte hacia las políticas en lugar de los mecanismos, la lógica de negocio
de alto nivel se vuelve inmune a los cambios en la infraestructura y los
detalles de implementación.

Ejemplo:

```swift

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

    // ⚠️ Emmett Brown recibe un dispositivo `TimeTraveling`, ¡no la clase concreta `DeLorean`!
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
```


Info
====

📖 Descriptions from: [The Principles of OOD by Uncle Bob](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)
