import UIKit

// KVO: Key Value Observing
// observing pattern like NotificationCenter

// one-to-many pattern relationship opposed to delegation which is one-to-one

// KVO is an objective-C runtime API
// some objective-C essentials are required:
// 1. the object being observed needs to be a class
// 2. the class needs to inherit from NSObject (the top abstract class in objective c) and prefixed with @objc
// 3. Any property being marked for observation needs to be prefixed with @objc dynamic.

// Dynamic vs Static:
// Dynamic means the property is being dispatched (at runtime the complier verifies the underlying property)
// In swift types -> statically dispatched types - they are checked at compile time.

@objc class Dog: NSObject { //KVO compliant
    var name: String
    @objc dynamic var age: Int //we need @objc dynamic to listen to these property changes === observable property
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
}

//observer class
class DogWalker {
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation? //similar to listener in firebase... a handle for the property being observed
    
    init(dog: Dog) {
        self.dog = dog
        configureBirthdayObservation()
    }
    
    private func configureBirthdayObservation() {
        birthdayObservation = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            //in a real app --> update UI accordingly in the ViewController class
            guard let age = change.newValue else {
                return
            }
            print("\(dog.name) was \(change.oldValue ?? 0) years old")
            print("\(dog.name), happy \(age) birthday! From the dog walker")
        })
    }
}
//observer class
class DogGroomer {
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation?
    
    init(dog: Dog) {
        self.dog = dog
        configureBirthdayObservation()
    }
    
    private func configureBirthdayObservation() {
        birthdayObservation = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            guard let age = change.newValue else {
                return
            }
            print("\(dog.name) was \(change.oldValue ?? 0) years old")
            print("\(dog.name) happy \(age) birthday! From the dog groomer")
        })
    }
}

//testing KVO on Dog age property

let brucey = Dog(name: "Brucey", age: 17)
let walker = DogWalker(dog: brucey)
let groomer = DogGroomer(dog: brucey)

brucey.age += 1
walker.birthdayObservation
groomer.birthdayObservation
