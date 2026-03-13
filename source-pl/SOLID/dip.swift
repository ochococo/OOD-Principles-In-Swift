/*:
# 🔝 The Dependency Inversion Principle (Zasada odwrócenia zależności)

Zależność powinna być od abstrakcji, nie od konkretu.

Dwie formalne reguły definiują tę zasadę: (1) Moduły wysokopoziomowe nie
powinny zależeć od modułów niskopoziomowych — oba powinny zależeć od
abstrakcji. (2) Abstrakcje nie powinny zależeć od szczegółów — szczegóły
powinny zależeć od abstrakcji. Odwracając zależność kodu źródłowego tak, by
wskazywała na polityki zamiast mechanizmów, logika biznesowa wysokiego poziomu
staje się odporna na zmiany w infrastrukturze i szczegółach implementacji.

Przykład:
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

    // ⚠️ Emmet Brown otrzymuje urządzenie `TimeTraveling`, a nie konkretną klasę `DeLorean`!
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
