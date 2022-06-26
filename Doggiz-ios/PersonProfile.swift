//
//  SwiftUIView.swift
//  Doggiz-ios
//
//  Created by Or Zino on 14/06/2022.
//

import SwiftUI
import FirebaseStorage
import SimpleToast

struct PersonProfile: View {
    
    @State var myImage:UIImage?
    @State private var showingMyDogScreen = false
    @State private var showingNewDogScreen = false
    @State private var showingLoginScreen = false
    @State private var showToast = false
    @State private var imagee:UIImage?
    
    public static var dogName   = ""
    public static var dogbreed  = ""
    public static var dogDate   = ""
    public static var dogFood   = 0
    public static var dogWalk   = 0
    public static var dogOwner  = ""
    public static var dogimage  = ""
    public static var dogId     = ""
    public static var dogShare  = ""
    public static var dogImageDownload:UIImage?
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    public let toastOptions = SimpleToastOptions(
        alignment: .center, hideAfter: 4, backdrop: Color.black.opacity(0.2), animation: .easeInOut, modifierType: .slide
    )
    
    var body: some View {
        NavigationView{
        ZStack{
            Image("BlueBackground")
            VStack{
        
        VStack {

            
            Image("doggizlogo")
                .resizable()
                .frame(width: 420, height: 120)
                .offset(y: -60.0)
            Spacer().frame(height: 10)
                

            if ContentView.ImageDownload != nil{
                //Image(uiImage: downloadImage())
                //.resizable()
                //.frame(width: 180, height: 180)
                //.clipShape(Circle())
                Image(uiImage: ContentView.ImageDownload!)
                    .resizable()
                    .frame(width: 220, height: 220)
                    .clipShape(Circle())
            } else {
                Image("user")
                    .resizable()
                    .frame(width: 220, height: 220)
                    .clipShape(Circle())
            }
            Spacer().frame(height: 20)
            
            Text(ContentView.myName)
                .font(.title)
                .bold()
            
        }
        
        Spacer().frame(height: 60)
        
        VStack(alignment: .leading, spacing: 12) {
            
                Text(ContentView.loginUser)
                    .font(.headline)
            

                Text(ContentView.myaddress)
                    .font(.headline)
                
            
                Text(ContentView.myphone)
                    .font(.headline)

        }
        
        Spacer().frame(height: 70)
                
                

                if(ContentView.haveDog == "true" || CreateDog.haveDog){
                    
                    Button(action: {
                        getDog()
                        downloadImage()
                    }, label: {
                        Text("My Dog")
                            .bold()
                            .frame(width: 160, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    })
                    NavigationLink(destination: DogProfile(), isActive: $showingMyDogScreen){
                        //Text("You are logged in @\(userName)")
                        
                    }

        
                } else{
                    
                    
                    Button(action: {
                        showingNewDogScreen = true
                        
                    }, label: {
                        Text("New Dog")
                            .bold()
                            .frame(width: 160, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    })
                    NavigationLink(destination: CreateDog(), isActive: $showingNewDogScreen){
                        //Text("You are logged in @\(userName)")
                        
                    }
                    
                    

        }
                
                Spacer().frame(height: 20)
                Button(action: {
                    dataManager.fetchPersons()
                    dataManager.fetchDogs()
                    CreateDog.haveDog = false
                    ShareDog.dogShared = false
                    showToast.toggle()
                }, label: {
                    Text("Logout")
                        //.resizable()
                        .bold()
                        .frame(width: 160, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                })
                NavigationLink(destination: ContentView(), isActive: $showingLoginScreen){
                    //Text("You are logged in @\(userName)")
                    
                }
                
                    //NavigationLink(destination: DogProfile(), isActive: $showingLoginScreen){
                    //}
                }
                
        }
            
        }.navigationBarHidden(true)
            .simpleToast(isPresented: $showToast, options: toastOptions, onDismiss: {
                dismiss()
            }){
                Text("You have been logged out").bold()
                    .padding(20)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(Color.white)
                    .cornerRadius(14)
            }
    }

    
    
    func getDog(){
        
        for dog in dataManager.dogs{
        
            if(dog.owner.lowercased() == ContentView.loginUser.lowercased() || dog.sharing.lowercased() == ContentView.loginUser.lowercased()){
                PersonProfile.dogName  = dog.name
                PersonProfile.dogDate  = dog.date
                PersonProfile.dogbreed = dog.breed
                PersonProfile.dogimage = dog.image
                PersonProfile.dogFood  = dog.food
                PersonProfile.dogWalk  = dog.walk
                PersonProfile.dogId    = dog.id
                PersonProfile.dogShare = dog.sharing
                
            }
        }

    }
    
    func downloadImage(){
        Storage.storage().reference().child(PersonProfile.dogimage).getData(maxSize: 1 * 1024 * 1024){
            (imageData,err) in
                if let err = err{
                    print("an error has occirred - \(err.localizedDescription)")
            } else {
                if let imageData = imageData {
                    self.imagee = UIImage(data:imageData)
                    if self.imagee != nil{
                        PersonProfile.dogImageDownload = self.imagee
                        showingMyDogScreen = true
                    }
                }else{
                    print("couldn't unwrap image data")
                }
    }
        }
        
    }
    
}



struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PersonProfile()
    }
}
