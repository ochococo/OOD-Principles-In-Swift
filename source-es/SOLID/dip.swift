/*:
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
