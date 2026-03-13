/*:
# 👥 The Liskov Substitution Principle (Zasada podstawienia Liskov)

Klasy pochodne muszą być podstawialne w miejsce klas bazowych.

Podtypy muszą respektować kontrakt behawioralny swoich nadtypów: nie mogą
wzmacniać warunków wstępnych, osłabiać warunków końcowych ani naruszać
niezmienników. Wywołujący, który pracuje z typem bazowym, musi móc użyć
dowolnego podtypu nie wiedząc o tym, a program powinien nadal działać poprawnie.
Naruszenia tej zasady prowadzą do kruchych hierarchii, w których w kodzie
klienta pojawiają się sprawdzenia typu `if/else`.

Przykład:
*/

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

