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
