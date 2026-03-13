/*:
# 👥 The Liskov Substitution Principle (Liskovsches Substitutionsprinzip)

Abgeleitete Klassen müssen durch ihre Basisklassen ersetzbar sein.

Untertypen müssen den Verhaltensvertrag ihrer Obertypen einhalten: Sie dürfen
Vorbedingungen nicht verschärfen, Nachbedingungen nicht abschwächen und
Invarianten nicht verletzen. Ein Aufrufer, der mit einem Basistyp arbeitet,
muss jeden Untertyp verwenden können, ohne davon zu wissen, und das Programm
sollte weiterhin korrekt funktionieren. Verletzungen dieses Prinzips führen zu
fragilen Hierarchien, in denen `if/else`-Typprüfungen im Client-Code auftauchen.

Beispiel:
*/

let requestKey: String = "NSURLRequestKey"

// Ich bin eine NSError-Unterklasse. Ich biete zusätzliche Funktionalität, ohne die ursprüngliche zu beeinträchtigen.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// Ich kann die Daten nicht abrufen und werde einen RequestError zurückgeben.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// Ich weiß nicht was RequestError ist und werde einen NSError zurückgeben.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// OK. Aus meiner Sicht ist das eine perfekte NSError-Instanz.
let error: Int? = result.error?.code

// ⚠️ Aber Moment! Was ist das? Es ist auch ein RequestError! Großartig!
if let requestError = result.error as? RequestError {
    requestError.request
}
