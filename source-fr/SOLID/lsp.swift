/*:
# 👥 The Liskov Substitution Principle (Principe de substitution de Liskov)

Les classes derivees doivent pouvoir se substituer a leurs classes de base.

Les sous-types doivent respecter le contrat comportemental de leurs supertypes :
ils ne doivent pas renforcer les preconditions, affaiblir les postconditions ni
violer les invariants. Un appelant qui travaille avec un type de base doit pouvoir
utiliser n'importe quel sous-type sans le savoir, et le programme doit continuer
a fonctionner correctement. Les violations de ce principe menent a des hierarchies
fragiles ou des verifications de type `if/else` s'infiltrent dans le code client.

Exemple :
*/

let requestKey: String = "NSURLRequestKey"

// Je suis une sous-classe de NSError. Je fournis des fonctionnalites supplementaires sans perturber les originales.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// Je n'ai pas reussi a recuperer les donnees et je vais retourner une RequestError.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// Je ne sais pas ce qu'est une RequestError et je vais echouer et retourner une NSError.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// OK. De mon point de vue, c'est une instance parfaite de NSError.
let error: Int? = result.error?.code

// ⚠️ Mais attendez ! Qu'est-ce que c'est ? C'est aussi une RequestError ! Genial !
if let requestError = result.error as? RequestError {
    requestError.request
}
