//
//  Register.swift
//  Doggiz-ios
//
//  Created by Or Zino on 16/06/2022.
//

import SwiftUI
import Firebase
import FirebaseStorage
import SimpleToast

struct Register: View {
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var phone = ""
    @State private var address = ""
    @State private var time:Int64 = 0
    @State private var showToast = false
    
    public let toastOptions = SimpleToastOptions(
        alignment: .center, hideAfter: 4, backdrop: Color.black.opacity(0.2), animation: .easeInOut, modifierType: .slide
    )
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    
    var body: some View {
        ZStack{
            Image("BlueBackground")
            VStack{
        
        VStack {
            Image("doggizlogo")
                .resizable()
                .frame(width: 420, height: 120)
            Spacer().frame(height: 30)
            
            Text("Register")
                .font(.title)
                .bold()
            
            Spacer().frame(height: 30)
            
            Button{
                shouldShowImagePicker.toggle()
                
            } label: {
                VStack {
                if let image = self.image{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 143, height: 143)
                        .cornerRadius(80)
                }else {
                    Image("plus")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                }

                }
            }
            
            TextField("Full Name", text: $name)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
            
            TextField("Email", text: $email)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
            
            SecureField("Password", text: $password)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
            
            TextField("Phone Number", text: $phone)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
            
            TextField("Address", text: $address)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
            
        }
        
        Spacer().frame(height: 100)
        
                Button(action: {
                    registeremailPassword()
                    showToast.toggle()
                    dataManager.fetchPersons()
                    

                }, label: {
                    Text("Register")
                        .bold()
                        .frame(width: 160, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                })
                

//        NavigationLink(destination: ContentView()){
//
//        }
                    
                
                
        }
            .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
                ImagePicker(image: $image)
                    .ignoresSafeArea()
            }
        }
        .simpleToast(isPresented: $showToast, options: toastOptions, onDismiss: {
            dismiss()
        }){
            Text("\(name) welcome to doggiz").bold()
                .padding(20)
                .background(Color.blue.opacity(0.8))
                .foregroundColor(Color.white)
                .cornerRadius(14)
        }
    }
    
    
    func registeremailPassword(){
        Auth.auth().createUser(withEmail: email, password: password) {
            result, error in if error != nil {
                print(error!.localizedDescription)
            }
        }
        
        if let thisImage = self.image{
            self.uploadImage(image: thisImage)
        } else{
            print("couldn't upload image - no image present")
        }

        dataManager.addPerson(name: self.name, address: self.address, email: self.email, image: String(time), phone: self.phone)
    }
    
        func uploadImage(image:UIImage){
            self.time = Int64(Date().timeIntervalSince1970 * 1000)
            if let imageData = image.jpegData(compressionQuality: 1){
                let storage = Storage.storage()
                storage.reference().child(String(self.time)).putData(imageData, metadata:nil){
                    (_,err) in
                    if let err = err{
                        print("an error has occurred - \(err.localizedDescription)")
                    } else {
                        print("image uploaded successfully")
                    }
                }
            } else{
                print("couldn't unwrap image as data")
            }
        }
        
    }




struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}



