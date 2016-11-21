/*:
# 👥 The Liskov Substitution Principle

Derived classes must be substitutable for their base classes. ([read more](http://docs.google.com/a/cleancoder.com/viewer?a=v&pid=explorer&chrome=true&srcid=0BwhCYaYDn8EgNzAzZjA5ZmItNjU3NS00MzQ5LTkwYjMtMDJhNDU5ZTM0MTlh&hl=en))

Example:
*/

let requestKey: String = "URLRequestKey"

// I'm a NSError subclass. I provide additional functionality but don't mess with original ones.
class RequestError: NSError {
  
  var request: URLRequest? {
    return self.userInfo[requestKey] as? URLRequest
  }
}

// I fail to fetch data and will return RequestError.
func fetchData(_ request: URLRequest) -> (data: Data?, error: RequestError?) {
  
  let userInfo: [AnyHashable: Any] = [ requestKey : request ]
  
  return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// I don't know what RequestError is and will fail and return a NSError.
func willReturnObjectOrError(from URL: URL) -> (object: Any?, error: NSError?) {
  
  let request = URLRequest(url: URL)
  let result = fetchData(request)
  
  return (result.data, result.error)
}

let result = willReturnObjectOrError(from: URL(string: "https://github.com/ochococo/OOD-Principles-In-Swift")!)

// Ok. This is a perfect NSError instance from my perspective.
let error: Int? = result.error?.code

// But hey! What's that? It's also a RequestError! Nice!
if let requestError = result.error as? RequestError {
  requestError.request
}

