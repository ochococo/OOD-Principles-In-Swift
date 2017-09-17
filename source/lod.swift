/*:
 # Law of Demeter
 
Law of Demeter (LoD) or principle of least knowledge is a design guideline for developing software, particularly object-oriented programs. In its general form, the LoD is a specific case of loose coupling.
 
 Read more:
 * [Wiki](https://en.wikipedia.org/wiki/Law_of_Demeter)
 * [Stack Overflow](https://softwareengineering.stackexchange.com/questions/181699/how-does-the-law-of-demeter-apply-to-object-oriented-systems-regarding-coupling)
 
Example:
*/

// This is bad, since Dog knows too much about Master.
// That's not nessary. Dog just needs to know there is func playWithDog in Master.

class Master {
  func playWithDog(_ dog: Dog) {
    print("Hi, \(dog.name)")
  }

  func watchTV() {
    print("I am watching TV now")
  }

  func doHomework() {
    print("Time to do homework")
  }
}

class Dog {
  weak var master: Master?
  let name: String

  init(_ name: String) {
    self.name = name
  }

  func playWithMaster() {
    master?.playWithDog(self)
  }

  func playAlone() {
    print("Have Fun")
  }
}

let dog = Dog("Luke")
let master = Master()
dog.master = master
dog.playWithMaster()

// We can use protocol to define Dog Delegate. That will let Master just exposure func playWithDog to Dog.

protocol DogDelegate: class {
  func playWithDog(_ dog: DogWithLoD)
}

class DogWithLoD {
  weak var delegate: DogDelegate?
  let name: String

  init(_ name: String) {
    self.name = name
  }

  func playWithMaster() {
    delegate?.playWithDog(self)
  }

  func playAlone() {
    print("Have Fun")
  }
}

class MasterWithLoD: DogDelegate {
  func playWithDog(_ dog: DogWithLoD) {
    print("Hi, \(dog.name)")
  }

  func watchTV() {
    print("I am watching TV now")
  }

  func doHomework() {
    print("Time to do homework")
  }
}

let dogWithLoD = DogWithLoD("Smart Luke")
let masterWithLoD = MasterWithLoD()
dogWithLoD.delegate = masterWithLoD
dogWithLoD.playWithMaster()

