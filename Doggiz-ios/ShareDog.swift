//
//  ShareDog.swift
//  Doggiz-ios
//
//  Created by Or Zino on 20/06/2022.
//

import SwiftUI
import SimpleToast

struct ShareDog: View {
    
    @State private var sha          = ""
    @State private var wrongEmail   = 0
    @State private var check        = true
    @State private var showToast    = false
    @State private var showErrToast = false
    public static var dogShared     = false
    
    public let toastOptions = SimpleToastOptions(
        alignment: .center, hideAfter: 4, backdrop: Color.black.opacity(0.2), animation: .easeInOut, modifierType: .slide
    )
    
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack{
            Color.blue.ignoresSafeArea()
            Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
            Circle().scale(1.35).foregroundColor(.white.opacity(0.9))
            
            VStack{

                Image("doggizlogo")
                    .resizable()
                    .frame(width: 420, height: 120)
                
                Spacer().frame(height: 190)
                Text("Share - Enter Email")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                TextField("Share with whom?", text:$sha)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(wrongEmail))
                Spacer().frame(height: 20)
                

                Button(action: {
                    for person in dataManager.persons{
                        if(person.email.lowercased() == sha.lowercased()){
                            if(person.haveDog == "false"){
                                dataManager.shareDog(id: PersonProfile.dogId, email: sha)
                                dataManager.haveDogChange(id: person.id, haveDog: "true")
                                check = false
                                showToast.toggle()
                                ShareDog.dogShared = true
                            }
                        }
                    }
                    if(check){
                        wrongEmail = 1
                        showErrToast.toggle()
                    }
                    
                }, label: {
                    Text("Share!")
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
                
                Spacer()
            }
        }
        .simpleToast(isPresented: $showToast, options: toastOptions, onDismiss: {
            dismiss()
        }){

            Text("\(sha) is shared with your dog").bold()
                .padding(20)
                .background(Color.blue.opacity(0.8))
                .foregroundColor(Color.white)
                .cornerRadius(14)
        }
        
        .simpleToast(isPresented: $showErrToast, options: toastOptions){
            
            Text("Your dog can not be shared with \(sha)").bold()
            .padding(20)
            .background(Color.blue.opacity(0.8))
            .foregroundColor(Color.white)
            .cornerRadius(14)
        }
    }
}

struct ShareDog_Previews: PreviewProvider {
    static var previews: some View {
        ShareDog()
    }
}
