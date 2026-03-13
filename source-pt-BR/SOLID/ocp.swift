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
