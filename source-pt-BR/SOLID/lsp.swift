/*:
# 👥 The Liskov Substitution Principle (Princípio da Substituição de Liskov)

Classes derivadas devem ser substituíveis por suas classes base.

Os subtipos devem respeitar o contrato comportamental de seus supertipos: não
devem fortalecer pré-condições, enfraquecer pós-condições ou violar invariantes.
Um chamador que trabalha com o tipo base deve poder usar qualquer subtipo sem
saber disso, e o programa deve continuar funcionando corretamente. Violações
deste princípio levam a hierarquias frágeis onde verificações de tipo `if/else`
surgem no código cliente.

Exemplo:
*/

let requestKey: String = "NSURLRequestKey"

// Sou uma subclasse de NSError. Forneço funcionalidade adicional sem interferir na original.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// Eu falho ao buscar dados e retornarei RequestError.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// Não sei o que é RequestError e vou falhar e retornar um NSError.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// Ok. Da minha perspectiva, esta é uma instância perfeita de NSError.
let error: Int? = result.error?.code

// ⚠️ Mas espere! O que é isso? Também é um RequestError! Excelente!
if let requestError = result.error as? RequestError {
    requestError.request
}
