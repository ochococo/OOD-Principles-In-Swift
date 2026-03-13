/*:
# 🔝 The Dependency Inversion Principle (Принцип інверсії залежностей)

Залежність повинна бути від абстракцій, а не від конкретних реалізацій.

Дві формальні правила визначають цей принцип: (1) Модулі високого рівня не
повинні залежати від модулів низького рівня — обидва повинні залежати від
абстракцій. (2) Абстракції не повинні залежати від деталей — деталі повинні
залежати від абстракцій. Інвертуючи залежність вихідного коду так, щоб вона
вказувала на політики, а не на механізми, бізнес-логіка високого рівня стає
несприйнятливою до змін в інфраструктурі та деталях реалізації.

Приклад:
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

    // ⚠️ Еммет Браун отримує пристрій `TimeTraveling`, а не конкретний клас `DeLorean`!
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
