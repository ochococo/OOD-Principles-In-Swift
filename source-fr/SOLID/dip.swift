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
