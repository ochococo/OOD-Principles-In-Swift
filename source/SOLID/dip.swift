/*:
# 🔝 The Dependency Inversion Principle

Depend on abstractions, not on concretions.

Two formal rules define this principle: (1) High-level modules should not
depend on low-level modules — both should depend on abstractions. (2)
Abstractions should not depend on details — details should depend on
abstractions. By inverting the source-code dependency so that it points toward
policies rather than mechanisms, high-level business logic becomes immune to
changes in infrastructure and implementation details.

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
