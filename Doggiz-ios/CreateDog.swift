//
//  CreateDog.swift
//  Doggiz-ios
//
//  Created by Or Zino on 15/06/2022.
//

import SwiftUI
import FirebaseStorage
import SimpleToast

struct CreateDog: View {
    
    @State private var dogName = ""
    @State private var myid = ""
    @State private var breed = ""
    @State private var dateOfBirth = ""
    @State private var time:Int64 = 0
    @State var showingPersonScreen = false
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    public static var haveDog = false
    @State private var showToast = false
    
    public let toastOptions = SimpleToastOptions(
        alignment: .center, hideAfter: 4, backdrop: Color.black.opacity(0.2), animation: .easeInOut, modifierType: .slide
    )
    
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) private var dismiss
    
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
            Spacer().frame(height: 30)
            
            Text("Dog's Details")
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
            
            Spacer().frame(height: 50)
            
            TextField("Dog's Name", text: $dogName)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
            
            TextField("Dog's Breed", text: $breed)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
            
            TextField("Date Of Birth", text: $dateOfBirth)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
            
        }
        
        Spacer().frame(height: 70)
                
                
                VStack{
                    Button(action: {
                        if let thisImage = self.image{
                            self.uploadImage(image: thisImage)
                        } else{
                            print("couldn't upload image - no image present")
                        }
                        createNewDog()
                        dataManager.haveDogChange(id: ContentView.myId, haveDog: "true")
                        CreateDog.haveDog = true
                        showToast.toggle()
                    }, label: {
                        Text("Add Dog")
                            .bold()
                            .frame(width: 160, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    })
                    
                    Button(action: {
                        dataManager.fetchDogs()
                        dataManager.fetchPersons()
                        showingPersonScreen = true
                    }, label: {
                        Text("Done")
                            .bold()
                            .frame(width: 160, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    })
                    NavigationLink(destination: PersonProfile(), isActive: $showingPersonScreen){
                        
                    }
                    
                }
                
        }
            .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
                ImagePicker(image: $image)
                    .ignoresSafeArea()
            }
        }
    }.navigationBarHidden(true)
            .simpleToast(isPresented: $showToast, options: toastOptions, onDismiss: {
            }){
                Text("\(dogName) added as your new dog!").bold()
                    .padding(20)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(Color.white)
                    .cornerRadius(14)
            }
    }
        
    
    func createNewDog(){
        dataManager.addDog(name: self.dogName, breed: self.breed, date: self.dateOfBirth, image: String(time), food: 0, walk: 0, owner: ContentView.loginUser)
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

struct CreateDog_Previews: PreviewProvider {
    static var previews: some View {
        CreateDog()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    
    private let controller = UIImagePickerController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        
        let parent: ImagePicker
        
        init(parent: ImagePicker){
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
