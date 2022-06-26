//
//  DataManager.swift
//  Doggiz-ios
//
//  Created by Or Zino on 19/06/2022.
//

import SwiftUI
import Firebase

class DataManager: ObservableObject{
    @Published var persons: [Per] = []
    @Published var dogs: [Dog] = []
    
    init(){
        fetchPersons()
        fetchDogs()
    }
    
    
    func fetchPersons(){
        persons.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Persons")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents{
                    let data = document.data()
                    
                    
                    let id = data["id"] as? String ?? ""
                    let address = data["address"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let phone = data["phone"] as? String ?? ""
                    let image = data["image"] as? String ?? ""
                    let name  = data["Name"] as? String ?? ""
                    let dog   = data["haveDog"] as? String ?? ""
                    
                    let person = Per(address: address, email: email, id: id, image: image, phone: phone,Name: name,haveDog: dog)
                    self.persons.append(person)
                }
            }
        }
    }
    
    func fetchDogs(){
        dogs.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Dogs")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents{
                    let data = document.data()
                    
                    let id      = data["id"]      as? String ?? ""
                    let sharing = data["sharing"] as? String ?? ""
                    let owner   = data["owner"]   as? String ?? ""
                    let date    = data["date"]    as? String ?? ""
                    let image   = data["image"]   as? String ?? ""
                    let name    = data["name"]    as? String ?? ""
                    let breed   = data["breed"]   as? String ?? ""
                    let food    = data["food"]    as? Int ?? 0
                    let walk    = data["walk"]    as? Int ?? 0
                    
                    
                    let dog = Dog(id: id, name: name, breed: breed, owner: owner, date: date, image: image, sharing: sharing, food: food, walk: walk)
                    self.dogs.append(dog)
                }
            }
    }
    }
    
    
    func updateDog(id: String, field: String, num: Int){
        let db = Firestore.firestore()
        let ref = db.collection("Dogs")
        ref.document(id).updateData([field : num])
    }
    
    
    
    func shareDog(id:String, email: String){
        let db = Firestore.firestore()
        let ref = db.collection("Dogs")
        ref.document(id).updateData(["sharing" : email])
    }
    
    func haveDogChange(id:String, haveDog: String){
        let db = Firestore.firestore()
        let ref = db.collection("Persons")
        ref.document(id).updateData(["haveDog" : haveDog])
    }
    
    
    func addPerson(name: String, address: String, email: String, image: String, phone: String){
        
        let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
        let db = Firestore.firestore()
        let ref = db.collection("Persons").document(String(timeStamp))
        ref.setData(["Name": name, "address": address, "email": email, "phone": phone, "image": image, "haveDog": "false", "id": String(timeStamp)]){ error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    func addDog(name: String, breed: String, date: String, image: String, food: Int, walk: Int, owner: String){
        
        let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)
        let db = Firestore.firestore()
        let ref = db.collection("Dogs").document(String(timeStamp))
        ref.setData(["name": name, "breed": breed, "owner": owner, "date": date, "image": image, "food": food, "walk": walk, "id": String(timeStamp), "sharing": ""]){ error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
}
