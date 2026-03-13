/*:
Princípios de Design Orientado a Objetos em Swift 5
=========================

A short cheat-sheet with Playground ([OOD-Principles-In-Swift-pt-BR.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift-pt-BR.playground.zip)).

👷 Project maintained by: [@oktawian](https://bsky.app/profile/oktawian.bsky.social) (Oktawian Chojnacki)

S.O.L.I.D.
==========

* [The Single Responsibility Principle (Princípio da Responsabilidade Única)](#-the-single-responsibility-principle-princípio-da-responsabilidade-única)
* [The Open Closed Principle (Princípio Aberto-Fechado)](#-the-open-closed-principle-princípio-aberto-fechado)
* [The Liskov Substitution Principle (Princípio da Substituição de Liskov)](#-the-liskov-substitution-principle-princípio-da-substituição-de-liskov)
* [The Interface Segregation Principle (Princípio da Segregação de Interfaces)](#-the-interface-segregation-principle-princípio-da-segregação-de-interfaces)
* [The Dependency Inversion Principle (Princípio da Inversão de Dependência)](#-the-dependency-inversion-principle-princípio-da-inversão-de-dependência)

*/

import Foundation

/*:
# 🔐 The Single Responsibility Principle (Princípio da Responsabilidade Única)

Uma classe deve ter um, e apenas um, motivo para mudar.

Uma formulação mais refinada: um módulo deve ser responsável perante um, e
apenas um, ator (parte interessada). O SRP não é sobre "fazer uma coisa" — é
sobre agrupar as coisas que mudam pelas mesmas razões e separar aquelas que
mudam por razões diferentes. Quando uma classe atende múltiplos atores,
mudanças solicitadas por um ator podem quebrar as expectativas de outro.

Exemplo:
*/

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// Eu sou a porta. Tenho um estado encapsulado e você pode alterá-lo usando métodos.
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

// Sou responsável apenas por abrir, não sei o que há dentro nem como fechar.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// Sou responsável apenas por fechar, não sei o que há dentro nem como abrir.
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


// ⚠️ Apenas o `DoorOpener` é responsável por abrir a porta.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ Se ao fechar a porta for necessário executar uma operação adicional,
// como acionar o alarme, não é preciso alterar a classe `DoorOpener`.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()
/*:
# ✋ The Open Closed Principle (Princípio Aberto-Fechado)

Deve ser possível estender o comportamento de uma classe sem modificá-la.

Entidades de software (classes, módulos, funções) devem ser abertas para
extensão, mas fechadas para modificação. A percepção-chave é que, quando uma
única mudança se propaga em cascata pelos módulos dependentes, o design é
frágil. Ao depender de abstrações (protocolos), novos comportamentos podem ser
adicionados escrevendo novo código — sem alterar o código existente e funcional.

Exemplo:
 */

protocol Shooting {
    func shoot() -> String
}

// Eu sou um feixe de laser. Eu posso disparar.
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// Eu tenho armas e, acredite, posso dispará-las todas de uma vez. Bum! Bum! Bum!
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

// Eu sou um lançador de foguetes. Eu posso lançar um foguete.
// ⚠️ Para adicionar suporte ao lançador de foguetes, não preciso alterar nada nas classes existentes.
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()
/*:
# 👥 The Liskov Substitution Principle (Princípio da Substituição de Liskov)

Classes derivadas devem ser substituíveis por suas classes base.

Os subtipos devem respeitar o contrato comportamental de seus supertipos: não
devem fortalecer pré-condições, enfraquecer pós-condições ou violar invariantes.
Um chamador que trabalha com o tipo base deve poder usar qualquer subtipo sem
saber disso, e o programa deve continuar funcionando corretamente. Violações
deste princípio levam a hierarquias frágeis onde verificações de tipo `if/else`
surgem no código cliente.

Exemplo:
*/

let requestKey: String = "NSURLRequestKey"

// Sou uma subclasse de NSError. Forneço funcionalidade adicional sem interferir na original.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// Eu falho ao buscar dados e retornarei RequestError.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// Não sei o que é RequestError e vou falhar e retornar um NSError.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// Ok. Da minha perspectiva, esta é uma instância perfeita de NSError.
let error: Int? = result.error?.code

// ⚠️ Mas espere! O que é isso? Também é um RequestError! Excelente!
if let requestError = result.error as? RequestError {
    requestError.request
}
/*:
# 🍴 The Interface Segregation Principle (Princípio da Segregação de Interfaces)

Crie interfaces granulares e específicas para cada cliente.

Nenhum cliente deve ser forçado a depender de métodos que não utiliza. Quando uma
interface cresce demais, seus clientes ficam acoplados a métodos que nunca chamam
— e mudanças nesses métodos não relacionados podem forçar os clientes a
recompilar ou reimplantar. Dividir interfaces inchadas em protocolos menores e
específicos por função mantém as dependências estreitas e coesas.

Exemplo:
 */

// Eu tenho um local de pouso.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// Eu posso pousar em objetos LandingSiteHaving.
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// Eu tenho carga útil.
protocol PayloadHaving {
    var payload: String { get }
}

// Eu posso buscar carga útil de um veículo (ex.: via Canadarm).

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ A estação espacial não tem ideia sobre as capacidades de pouso do SpaceXCRS8.
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// Eu sou uma barcaça — tenho um local de pouso (bem, você entendeu).
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// Eu tenho carga útil e posso pousar em coisas que têm local de pouso.
// Sou um veículo espacial muito limitado, eu sei.
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ O CRS8 conhece apenas as informações do local de pouso.
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
# 🔝 The Dependency Inversion Principle (Princípio da Inversão de Dependência)

Dependa de abstrações, não de implementações concretas.

Duas regras formais definem este princípio: (1) Módulos de alto nível não devem
depender de módulos de baixo nível — ambos devem depender de abstrações. (2)
Abstrações não devem depender de detalhes — detalhes devem depender de
abstrações. Ao inverter a dependência do código-fonte para que aponte para
políticas em vez de mecanismos, a lógica de negócio de alto nível torna-se imune
a mudanças na infraestrutura e nos detalhes de implementação.

Exemplo:
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

    // ⚠️ Emmett Brown recebe um dispositivo `TimeTraveling`, não a classe concreta `DeLorean`!
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
