
Swift 5'te Nesne Yonelimli Tasarim Ilkeleri
=========================

Playground ile kisa notlar ([OOD-Principles-In-Swift-tr.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift-tr.playground.zip)).

👷 Project maintained by: [@oktawian](https://bsky.app/profile/oktawian.bsky.social) (Oktawian Chojnacki)

S.O.L.I.D.
==========

* [The Single Responsibility Principle (Tek Sorumluluk Ilkesi)](#-the-single-responsibility-principle-tek-sorumluluk-ilkesi)
* [The Open Closed Principle (Acik/Kapali Ilkesi)](#-the-open-closed-principle-acikkapali-ilkesi)
* [The Liskov Substitution Principle (Liskov Yerine Gecme Ilkesi)](#-the-liskov-substitution-principle-liskov-yerine-gecme-ilkesi)
* [The Interface Segregation Principle (Arayuz Ayrimi Ilkesi)](#-the-interface-segregation-principle-arayuz-ayrimi-ilkesi)
* [The Dependency Inversion Principle (Bagimlilik Tersine Cevirme Ilkesi)](#-the-dependency-inversion-principle-bagimlilik-tersine-cevirme-ilkesi)



# 🔐 The Single Responsibility Principle (Tek Sorumluluk Ilkesi)

Bir sinifin degismek icin bir ve yalnizca bir nedeni olmalidir.

Daha rafine bir ifade: bir modul bir ve yalnizca bir aktore (paydasa) karsi
sorumlu olmalidir. SRP "tek bir sey yap" anlamina gelmez — ayni nedenlerle
degisen seyleri bir araya toplamak ve farkli nedenlerle degisen seyleri
birbirinden ayirmakla ilgilidir. Bir sinif birden fazla aktore hizmet ettiginde,
bir aktor tarafindan talep edilen degisiklikler digerinin beklentilerini
bozma riski tasir.

Ornek:

```swift

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// Ben kapiyim. Kapsullanmis bir durumum var ve bunu metodlar ile degistirebilirsiniz.
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

// Ben yalnizca acmaktan sorumluyum, icinde ne oldugunu ya da nasil kapatilacagini bilmiyorum.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// Ben yalnizca kapatmaktan sorumluyum, icinde ne oldugunu ya da nasil acilacagini bilmiyorum.
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


// ⚠️ Yalnizca `DoorOpener` kapiyi acmaktan sorumludur.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ Kapi kapatilirken baska bir islem yapilmasi gerekiyorsa,
// ornegin alarmin etkinlestirilmesi, `DoorOpener` sinifini degistirmeye gerek yoktur.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()
```

# ✋ The Open Closed Principle (Acik/Kapali Ilkesi)

Bir sinifin davranisini, onu degistirmeden genisletebilmelisiniz.

Yazilim varliklari (siniflar, moduller, fonksiyonlar) genislemeye acik ancak
degisiklige kapali olmalidir. Temel fikir sudur: tek bir degisiklik bagli
modullere zincirleme olarak yayildiginda, tasarim kirilgandir. Soyutlamalara
(protokollere) dayanarak, yeni davranis yeni kod yazilarak eklenebilir —
mevcut, calisan kodu degistirmeden.

Ornek:
 
```swift

protocol Shooting {
    func shoot() -> String
}

// Ben bir lazer isiniyim. Ates edebilirim.
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// Silahlarim var ve inanin bana hepsini ayni anda atesleyebilirim. Bum! Bum! Bum!
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

// Ben bir roketatarim. Roket atabilirim.
// ⚠️ Roketatar destegi eklemek icin mevcut siniflarda hicbir seyi degistirmeme gerek yok.
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()
```

# 👥 The Liskov Substitution Principle (Liskov Yerine Gecme Ilkesi)

Turetilmis siniflar, temel siniflarin yerine gecilebilir olmalidir.

Alt tipler, ust tiplerinin davranissal sozlesmesine uymalidirlar: on kosullari
guclendirmemeli, son kosullari zayiflatmamali veya degismezleri ihlal
etmemelidirler. Temel bir tiple calisan bir cagiran, herhangi bir alt tipi
bilmeden kullanabilmeli ve program dogru sekilde calismaya devam etmelidir.
Bu ilkenin ihlalleri, istemci kodunda `if/else` tip kontrollerinin belirdigi
kirilgan hiyerarsiler olusturur.

Ornek:

```swift

let requestKey: String = "NSURLRequestKey"

// Ben bir NSError alt sinifiyim. Ek islevsellik sagliyorum ama orijinallerini bozmuyorum.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// Veri cekmekte basarisiz oldum ve RequestError dondurecegim.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// RequestError'in ne oldugunu bilmiyorum ve basarisiz olup NSError dondurecegim.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// Tamam. Benim bakis acimdan bu mukemmel bir NSError ornegi.
let error: Int? = result.error?.code

// ⚠️ Ama durun! Bu da ne? Bu ayni zamanda bir RequestError! Harika!
if let requestError = result.error as? RequestError {
    requestError.request
}
```

# 🍴 The Interface Segregation Principle (Arayuz Ayrimi Ilkesi)

Istemciye ozel ince taneli arayuzler olusturun.

Hicbir istemci kullanmadigi metodlara bagimli olmaya zorlanmamalidir. Bir
arayuz cok buyudugunde, istemcileri hic cagirmadiklari metodlara baglanir —
ve bu ilgisiz metodlardaki degisiklikler istemcileri yeniden derlemeye veya
yeniden dagitima zorlayabilir. Siskin arayuzleri daha kucuk, role ozgu
protokollere bolmek bagimliliklari dar ve tutarli tutar.

Ornek:
 
```swift

// Bir inis saham var.
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// LandingSiteHaving nesnelerine inebilirim.
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// Yukum var.
protocol PayloadHaving {
    var payload: String { get }
}

// Aractan yuk alabilirim (ornegin Canadarm ile).

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ Uzay istasyonunun SpaceXCRS8'in inis yetenekleri hakkinda hicbir fikri yok.
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// Ben bir mavnayim — inis saham var (yani, anliyorsunuz).
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// Yukum var ve inis sahasi olan seylere inebilirim.
// Cok sinirli bir uzay araciyim, biliyorum.
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 yalnizca inis sahasi bilgisini bilir.
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

# 🔝 The Dependency Inversion Principle (Bagimlilik Tersine Cevirme Ilkesi)

Somut siniflara degil, soyutlamalara bagli olun.

Bu ilkeyi iki resmi kural tanimlar: (1) Yuksek seviyeli moduller dusuk seviyeli
modullere bagli olmamalidir — her ikisi de soyutlamalara bagli olmalidir. (2)
Soyutlamalar detaylara bagli olmamalidir — detaylar soyutlamalara bagli olmalidir.
Kaynak kodu bagimliligini mekanizmalar yerine politikalara yonlendirerek
tersine cevirmek, yuksek seviyeli is mantigi altyapi ve uygulama detaylarindaki
degisikliklere karsi bagisik hale gelir.

Ornek:

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
```

Info
====

📖 Descriptions from: [The Principles of OOD by Uncle Bob](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)
