/*:
# 🍴 The Interface Segregation Principle (Принцип розділення інтерфейсів)

Створюйте дрібнозернисті інтерфейси, адаптовані до конкретного клієнта.

Жоден клієнт не повинен бути змушений залежати від методів, які він не
використовує. Коли інтерфейс надмірно розростається, його клієнти стають
зв'язаними з методами, які вони ніколи не викликають — а зміни в цих
непов'язаних методах можуть змусити клієнтів перекомпілювати або повторно
розгортати. Розділення громіздких інтерфейсів на менші, спеціалізовані
протоколи підтримує залежності вузькими та зв'язними.

Приклад:
 */

// Я маю місце для посадки.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// Я можу приземлитися на об'єкти LandingSiteHaving.
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// Я маю вантаж.
protocol PayloadHaving {
    var payload: String { get }
}

// Я можу забрати вантаж з транспортного засобу (наприклад, за допомогою Canadarm).

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ Космічна станція нічого не знає про здатність SpaceXCRS8 до посадки.
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// Я — баржа, у мене є місце для посадки (ну, ви розумієте ідею).
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// Я маю вантаж і можу приземлитися на об'єкти з місцем для посадки.
// Я дуже обмежений космічний апарат, я знаю.
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 знає лише інформацію про місце посадки.
    func land(on: LandingSiteHaving) -> String {
        return "Landed on \(on.landingSite) at April 8, 2016 20:52 UTC"
    }
}

let crs8 = SpaceXCRS8()
let barge = OfCourseIStillLoveYouBarge()
let spaceStation = InternationalSpaceStation()

spaceStation.fetchPayload(vehicle: crs8)
crs8.land(on: barge)
