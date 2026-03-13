/*:
# 🔝 The Dependency Inversion Principle (Bagimlilik Tersine Cevirme Ilkesi)

Somut siniflara degil, soyutlamalara bagli olun.

Bu ilkeyi iki resmi kural tanimlar: (1) Yuksek seviyeli moduller dusuk seviyeli
modullere bagli olmamalidir — her ikisi de soyutlamalara bagli olmalidir. (2)
Soyutlamalar detaylara bagli olmamalidir — detaylar soyutlamalara bagli olmalidir.
Kaynak kodu bagimliligini mekanizmalar yerine politikalara yonlendirerek
tersine cevirmek, yuksek seviyeli is mantigi altyapi ve uygulama detaylarindaki
degisikliklere karsi bagisik hale gelir.

Ornek:
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

    // ⚠️ Emmett Brown'a somut `DeLorean` sinifi degil, bir `TimeTraveling` cihazi veriliyor!
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
