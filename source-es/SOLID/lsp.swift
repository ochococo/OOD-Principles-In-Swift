/*:
# 👥 The Liskov Substitution Principle (Principio de sustitución de Liskov)

Las clases derivadas deben poder sustituir a sus clases base.

Los subtipos deben respetar el contrato de comportamiento de sus supertipos: no
deben fortalecer las precondiciones, debilitar las postcondiciones ni violar los
invariantes. Un llamador que trabaja con un tipo base debe poder usar cualquier
subtipo sin saberlo, y el programa debe seguir comportándose correctamente. Las
violaciones de este principio conducen a jerarquías frágiles donde aparecen
comprobaciones de tipo `if/else` en el código cliente.

Ejemplo:
*/

let requestKey: String = "NSURLRequestKey"

// Soy una subclase de NSError. Proporciono funcionalidad adicional pero no rompo la original.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// No logro obtener los datos y devolveré un RequestError.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// No sé qué es RequestError y devolveré un NSError.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// OK. Desde mi perspectiva es una instancia perfecta de NSError.
let error: Int? = result.error?.code

// ⚠️ ¡Pero espera! ¿Qué es eso? ¡También es un RequestError! ¡Genial!
if let requestError = result.error as? RequestError {
    requestError.request
}
