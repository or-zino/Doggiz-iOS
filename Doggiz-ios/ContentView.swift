//
//  ContentView.swift
//  Doggiz-ios
//
//  Created by Or Zino on 13/06/2022.
//

import SwiftUI
import Firebase
import FirebaseStorage
import SimpleToast

struct ContentView: View {
    @State public var userName = ""
    @State private var password = ""
    @State private var wrongUserName = 0
    @State private var wrongPassword = 0
    @State private var showingLoginScreen = false
    @State private var imagee:UIImage?
    @State private var showToast = false
    
    private let toastOptions = SimpleToastOptions(
        alignment: .top, hideAfter: 5, backdrop: Color.black.opacity(0.2), animation: .easeInOut, modifierType: .slide
    )
    
    public static var loginUser = ""
    public static var myaddress = ""
    public static var myphone   = ""
    public static var myimage   = ""
    public static var myName    = ""
    public static var haveDog   = ""
    public static var myId      = ""
    public static var ImageDownload:UIImage?
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView{
            
            ZStack{
                Color.blue.ignoresSafeArea()
                Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
                Circle().scale(1.35).foregroundColor(.white.opacity(0.9))
                

                
                VStack{
                    
                    Image("doggizlogo")
                        .resizable()
                        .frame(width: 420, height: 120)
            
                    Spacer()
                
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    TextField("UserName", text:$userName)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUserName))
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                    
                    Button("Login"){
                        login()
//
                        //downloadImage()

                        
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    NavigationLink(destination: PersonProfile() , isActive: $showingLoginScreen){
                        //Text("You are logged in @\(userName)")
                        
                    }
                    
                    
                    Spacer().frame(height: 20)
                    
                    
                    NavigationLink(destination: Register()){
                        Text("Click here to Register")
                            .colorMultiply(Color.black)
                    }
                    
//                    Button{
//
//                    }label: {
//                        Text("Click here to Register")
//                            .colorMultiply(Color.black)
//                    }
                    
                    
                    Spacer().frame(height: 250)
                    
                    
                }
            }
        }
        .navigationBarHidden(true)
        .simpleToast(isPresented: $showToast, options: toastOptions){

                Text("Your email or password are wrong!\nPlease try again!").bold()

            .padding(20)
            .background(Color.black.opacity(0.8))
            .foregroundColor(Color.white)
            .cornerRadius(14)
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail: userName, password: password) { result, error in if error != nil {
            showToast.toggle()
            print(error!.localizedDescription)
        }else{
            //Thread.sleep(forTimeInterval: 5000)
            //dataManager.fetchPersons()
            
            ContentView.loginUser = userName
            for person in dataManager.persons{
                if(person.email.lowercased() == userName.lowercased()){
                    ContentView.myaddress = person.address
                    ContentView.myphone = person.phone
                    ContentView.myimage = person.image
                    ContentView.myName  = person.Name
                    ContentView.haveDog = person.haveDog
                    ContentView.myId    = person.id
                    downloadImage()
                }
            }
            
        }
            
        }
    }
    
    
    func downloadImage(){
        Storage.storage().reference().child(ContentView.myimage).getData(maxSize: 1 * 1024 * 1024){
            (imageData,err) in
                if let err = err{
                    print("an error has occirred - \(err.localizedDescription)")
            } else {
                if let imageData = imageData {
                    self.imagee = UIImage(data:imageData)
                    if self.imagee != nil{
                        ContentView.ImageDownload = self.imagee
                        showingLoginScreen = true
                    }
                }else{
                    print("couldn't unwrap image data")
                }
    }
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
