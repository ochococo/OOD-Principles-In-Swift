---
layout: default
title: "Zasady projektowania obiektowego w Swift 5"
lang: pl
permalink: /pl
---

Zasady projektowania obiektowego w Swift 5
=========================

Ściągawka z Playground ([OOD-Principles-In-Swift-pl.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift-pl.playground.zip)).

🇵🇱 Tłumaczenie: [@oktawian](https://bsky.app/profile/oktawian.bsky.social) (Oktawian Chojnacki)

S.O.L.I.D.
==========

* [The Single Responsibility Principle (Zasada jednej odpowiedzialności)](#-the-single-responsibility-principle-zasada-jednej-odpowiedzialności)
* [The Open Closed Principle (Zasada otwarte-zamknięte)](#-the-open-closed-principle-zasada-otwarte-zamknięte)
* [The Liskov Substitution Principle (Zasada podstawienia Liskov)](#-the-liskov-substitution-principle-zasada-podstawienia-liskov)
* [The Interface Segregation Principle (Zasada segregacji interfejsów)](#-the-interface-segregation-principle-zasada-segregacji-interfejsów)
* [The Dependency Inversion Principle (Zasada odwrócenia zależności)](#-the-dependency-inversion-principle-zasada-odwrócenia-zależności)



# 🔐 The Single Responsibility Principle (Zasada jednej odpowiedzialności)

Klasa powinna mieć jeden, i tylko jeden, powód do zmiany.

Bardziej precyzyjna definicja: moduł powinien odpowiadać przed jednym, i tylko
jednym, aktorem (interesariuszem). SRP nie oznacza „rób jedną rzecz" — chodzi
o grupowanie razem tego, co zmienia się z tych samych powodów, i oddzielanie
tego, co zmienia się z różnych powodów. Gdy klasa obsługuje wielu aktorów,
zmiany żądane przez jednego aktora mogą naruszyć oczekiwania innego.

Przykład:

```swift

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// Jestem drzwiami. Mam hermetyzowany stan, który można zmienić za pomocą metod.
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

// Odpowiadam tylko za otwieranie, nie wiem co jest w środku ani jak zamykać.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// Odpowiadam tylko za zamykanie, nie wiem co jest w środku ani jak otwierać.
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


// ⚠️ Tylko `DoorOpener` jest odpowiedzialny za otwieranie drzwi.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ Jeśli przy zamykaniu drzwi trzeba wykonać dodatkową operację,
// np. włączyć alarm, nie trzeba zmieniać klasy `DoorOpener`.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()

```

# ✋ The Open Closed Principle (Zasada otwarte-zamknięte)

Powinno być możliwe rozszerzenie zachowania klasy bez jej modyfikacji.

Klasy, moduły i funkcje powinny być otwarte na rozszerzenia,
ale zamknięte na modyfikacje. Kluczowe spostrzeżenie jest takie, że gdy
pojedyncza zmiana rozchodzi się kaskadowo przez zależne moduły, projekt jest
kruchy. Opierając się na abstrakcjach (np. protokołach), nowe zachowanie można dodać
pisząc nowy kod — bez zmieniania istniejącego, działającego kodu.

Przykład:
 
```swift

protocol Shooting {
    func shoot() -> String
}

// Jestem wiązką laserową. Potrafię strzelać.
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// Mam broń i uwierzcie mi, potrafię wystrzelić wszystko naraz. Bum! Bum! Bum!
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

// Jestem wyrzutnią rakiet. Potrafię wystrzelić rakietę.
// ⚠️ Aby dodać obsługę wyrzutni rakiet, nie muszę zmieniać niczego w istniejących klasach.
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()
```

# 👥 The Liskov Substitution Principle (Zasada podstawienia Liskov)

Klasy pochodne muszą być podstawialne w miejsce klas bazowych.

Podtypy muszą respektować kontrakt behawioralny swoich nadtypów: nie mogą
wzmacniać warunków wstępnych, osłabiać warunków końcowych ani naruszać
niezmienników. Wywołujący, który pracuje z typem bazowym, musi móc użyć
dowolnego podtypu nie wiedząc o tym, a program powinien nadal działać poprawnie.
Naruszenia tej zasady prowadzą do kruchych hierarchii, w których w kodzie
klienta pojawiają się sprawdzenia typu `if/else`.

Przykład:

```swift

let requestKey: String = "NSURLRequestKey"

// Jestem podklasą NSError. Dostarczam dodatkową funkcjonalność, ale nie psuję oryginalnej.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// Nie udaje mi się pobrać danych i zwrócę RequestError.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// Nie wiem czym jest RequestError i zwrócę NSError.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// OK. Z mojej perspektywy to doskonała instancja NSError.
let error: Int? = result.error?.code

// ⚠️ Ale chwileczkę! Co to? To również RequestError! Świetnie!
if let requestError = result.error as? RequestError {
    requestError.request
}

```

# 🍴 The Interface Segregation Principle (Zasada segregacji interfejsów)

Twórz drobnoziarniste interfejsy dopasowane do konkretnego klienta.

Żaden klient nie powinien być zmuszony do zależności od metod, których nie
używa. Gdy interfejs rozrasta się nadmiernie, jego klienci zostają sprzężeni
z metodami, których nigdy nie wywołują — a zmiany w tych niezwiązanych metodach
mogą wymusić rekompilację lub ponowne wdrożenie klientów. Dzielenie rozbudowanych
interfejsów na mniejsze, wyspecjalizowane protokoły utrzymuje zależności wąskie
i spójne.

Przykład:
 
```swift

// Mam miejsce do lądowania.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// Potrafię lądować na obiektach LandingSiteHaving.
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// Mam ładunek.
protocol PayloadHaving {
    var payload: String { get }
}

// Potrafię pobrać ładunek z pojazdu (np. za pomocą Canadarm).

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ Stacja kosmiczna nie ma pojęcia o zdolnościach lądowania SpaceXCRS8.
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// Jestem barką — mam miejsce do lądowania (no, rozumiecie o co chodzi).
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// Mam ładunek i potrafię lądować na obiektach z miejscem do lądowania.
// Jestem bardzo ograniczonym pojazdem kosmicznym, wiem o tym.
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 zna tylko informacje o miejscu lądowania.
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

# 🔝 The Dependency Inversion Principle (Zasada odwrócenia zależności)

Zależność powinna być od abstrakcji, nie od konkretu.

Dwie formalne reguły definiują tę zasadę: (1) Moduły wysokopoziomowe nie
powinny zależeć od modułów niskopoziomowych — oba powinny zależeć od
abstrakcji. (2) Abstrakcje nie powinny zależeć od szczegółów — szczegóły
powinny zależeć od abstrakcji. Odwracając zależność kodu źródłowego tak, by
wskazywała na polityki zamiast mechanizmów, logika biznesowa wysokiego poziomu
staje się odporna na zmiany w infrastrukturze i szczegółach implementacji.

Przykład:

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
```


Info
====

📖 Na podstawie: [The Principles of OOD by Uncle Bob](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)