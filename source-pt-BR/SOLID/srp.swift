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
