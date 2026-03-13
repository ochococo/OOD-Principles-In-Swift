/*:
# 🔐 The Single Responsibility Principle (Tek Sorumluluk Ilkesi)

Bir sinifin degismek icin bir ve yalnizca bir nedeni olmalidir.

Daha rafine bir ifade: bir modul bir ve yalnizca bir aktore (paydasa) karsi
sorumlu olmalidir. SRP "tek bir sey yap" anlamina gelmez — ayni nedenlerle
degisen seyleri bir araya toplamak ve farkli nedenlerle degisen seyleri
birbirinden ayirmakla ilgilidir. Bir sinif birden fazla aktore hizmet ettiginde,
bir aktor tarafindan talep edilen degisiklikler digerinin beklentilerini
bozma riski tasir.

Ornek:
*/

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
