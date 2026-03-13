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
