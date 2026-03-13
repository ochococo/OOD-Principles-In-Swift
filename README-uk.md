---
layout: default
title: "Принципи об'єктно-орієнтованого проєктування у Swift 5"
lang: uk
permalink: /uk
---

Принципи об'єктно-орієнтованого проєктування у Swift 5
=========================

A short cheat-sheet with Playground ([OOD-Principles-In-Swift-uk.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift-uk.playground.zip)).

👷 Project maintained by: [@oktawian](https://bsky.app/profile/oktawian.bsky.social) (Oktawian Chojnacki)

S.O.L.I.D.
==========

* [The Single Responsibility Principle (Принцип єдиної відповідальності)](#-the-single-responsibility-principle-принцип-єдиної-відповідальності)
* [The Open Closed Principle (Принцип відкритості-закритості)](#-the-open-closed-principle-принцип-відкритості-закритості)
* [The Liskov Substitution Principle (Принцип підстановки Лісков)](#-the-liskov-substitution-principle-принцип-підстановки-лісков)
* [The Interface Segregation Principle (Принцип розділення інтерфейсів)](#-the-interface-segregation-principle-принцип-розділення-інтерфейсів)
* [The Dependency Inversion Principle (Принцип інверсії залежностей)](#-the-dependency-inversion-principle-принцип-інверсії-залежностей)



# 🔐 The Single Responsibility Principle (Принцип єдиної відповідальності)

Клас повинен мати одну, і тільки одну, причину для зміни.

Точніше формулювання: модуль повинен відповідати перед одним, і тільки одним,
актором (зацікавленою стороною). SRP — це не про «робити одну річ», а про
групування разом того, що змінюється з однакових причин, і відокремлення того,
що змінюється з різних причин. Коли клас обслуговує кількох акторів, зміни,
запитані одним актором, можуть порушити очікування іншого.

Приклад:

```swift

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// Я — двері. Маю інкапсульований стан, який можна змінити за допомогою методів.
struct PodBayDoor: Openable, Closeable {

    private enum State {
        case open
        case closed
    }

    private var state: State = .closed

    mutating func open() {
        state = .open
    }

    mutating func close() {
        state = .closed
    }
}

// Я відповідаю лише за відкривання, не знаю що всередині і як закривати.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// Я відповідаю лише за закривання, не знаю що всередині і як відкривати.
final class DoorCloser {
    private var door: Closeable

    init(door: Closeable) {
        self.door = door
    }

    func execute() {
        door.close()
    }
}

let door = PodBayDoor()


// ⚠️ Тільки `DoorOpener` відповідає за відкривання дверей.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ Якщо при закриванні дверей потрібно виконати додаткову операцію,
// наприклад, увімкнути сигналізацію, не потрібно змінювати клас `DoorOpener`.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()
```

# ✋ The Open Closed Principle (Принцип відкритості-закритості)

Має бути можливо розширити поведінку класу без його модифікації.

Програмні сутності (класи, модулі, функції) повинні бути відкриті для
розширення, але закриті для модифікації. Ключове спостереження полягає в тому,
що коли одна зміна каскадно поширюється через залежні модулі, проєкт є крихким.
Спираючись на абстракції (протоколи), нову поведінку можна додати, написавши
новий код — без зміни наявного, працюючого коду.

Приклад:
 
```swift

protocol Shooting {
    func shoot() -> String
}

// Я — лазерний промінь. Я вмію стріляти.
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// Я маю зброю, і повірте, я можу вистрілити з усього одразу. Бум! Бум! Бум!
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

// Я — ракетна установка. Я вмію запускати ракету.
// ⚠️ Щоб додати підтримку ракетної установки, не потрібно змінювати нічого в існуючих класах.
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()
```

# 👥 The Liskov Substitution Principle (Принцип підстановки Лісков)

Похідні класи повинні бути підставними замість базових класів.

Підтипи повинні дотримуватися поведінкового контракту своїх надтипів: вони не
повинні посилювати передумови, послаблювати постумови або порушувати інваріанти.
Викликаючий код, який працює з базовим типом, повинен мати можливість
використовувати будь-який підтип, не знаючи про це, і програма повинна
продовжувати працювати правильно. Порушення цього принципу призводять до крихких
ієрархій, де в клієнтському коді з'являються перевірки типу `if/else`.

Приклад:

```swift

let requestKey: String = "NSURLRequestKey"

// Я — підклас NSError. Я надаю додаткову функціональність, але не порушую оригінальну.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// Мені не вдається отримати дані, і я поверну RequestError.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// Я не знаю що таке RequestError і поверну NSError.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// OK. З моєї точки зору це ідеальний екземпляр NSError.
let error: Int? = result.error?.code

// ⚠️ Але зачекайте! Що це? Це також RequestError! Чудово!
if let requestError = result.error as? RequestError {
    requestError.request
}
```

# 🍴 The Interface Segregation Principle (Принцип розділення інтерфейсів)

Створюйте дрібнозернисті інтерфейси, адаптовані до конкретного клієнта.

Жоден клієнт не повинен бути змушений залежати від методів, які він не
використовує. Коли інтерфейс надмірно розростається, його клієнти стають
зв'язаними з методами, які вони ніколи не викликають — а зміни в цих
непов'язаних методах можуть змусити клієнтів перекомпілювати або повторно
розгортати. Розділення громіздких інтерфейсів на менші, спеціалізовані
протоколи підтримує залежності вузькими та зв'язними.

Приклад:
 
```swift

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
```

# 🔝 The Dependency Inversion Principle (Принцип інверсії залежностей)

Залежність повинна бути від абстракцій, а не від конкретних реалізацій.

Дві формальні правила визначають цей принцип: (1) Модулі високого рівня не
повинні залежати від модулів низького рівня — обидва повинні залежати від
абстракцій. (2) Абстракції не повинні залежати від деталей — деталі повинні
залежати від абстракцій. Інвертуючи залежність вихідного коду так, щоб вона
вказувала на політики, а не на механізми, бізнес-логіка високого рівня стає
несприйнятливою до змін в інфраструктурі та деталях реалізації.

Приклад:

```swift

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
```


Info
====

📖 Descriptions from: [The Principles of OOD by Uncle Bob](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)
