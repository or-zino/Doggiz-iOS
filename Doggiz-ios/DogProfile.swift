//
//  DogProfile.swift
//  Doggiz-ios
//
//  Created by Or Zino on 15/06/2022.
//

import SwiftUI
import FirebaseStorage

struct DogProfile: View {
    @State private var initFood = true
    @State private var initWalk = true
    @State private var numberFood = 5
    @State private var numberWalks = 5
    @State private var maxFood = 5
    @State private var maxWalk = 5

    @State var myImage:UIImage?
    
    @State private var showPopup = false
    
    @EnvironmentObject var dataManager: DataManager
    var body: some View {
        ZStack{
            Image("BlueBackground")
            VStack{
        
        VStack {
            
            Image("doggizlogo")
                .resizable()
                .frame(width: 420, height: 120)
                .offset(y: -30.0)
            
            if PersonProfile.dogImageDownload != nil{
                Image(uiImage: PersonProfile.dogImageDownload!)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                
            } else{
                Image("paw")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            }
            
            
            Text(PersonProfile.dogName)
                .font(.title)
                .bold()
            
        }
        
        //Spacer().frame(height: 10)
        
        VStack(spacing: 5) {

            Text(PersonProfile.dogbreed)
            Text(PersonProfile.dogDate)
        }
                Image("dogbowl")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                HStack{

                    Button(action:{
                        
                        if(PersonProfile.dogFood > 0){
                            PersonProfile.dogFood-=1
                            numberFood = PersonProfile.dogFood
                            initFood = false
                            dataManager.updateDog(id: PersonProfile.dogId, field: "food", num: numberFood)
                        }
                    },label:{
                        Image("minus")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    })
                    
                    if(!initFood){
                    Text(String(numberFood))
                        .font(.title)
                        .bold()
                        .frame(width: 100, height: 100)
                    } else {
                        Text(String(PersonProfile.dogFood))
                            .font(.title)
                            .bold()
                            .frame(width: 100, height: 100)
                    }
                    Button(action:{
                        if(PersonProfile.dogFood < maxFood){
                            PersonProfile.dogFood+=1
                            numberFood = PersonProfile.dogFood
                            initFood = false
                            dataManager.updateDog(id: PersonProfile.dogId, field: "food", num: numberFood)
                        }
                    },label:{
                        Image("pluse")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    })

                }
                Image("walk")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                HStack{
                    
                    Button(action:{
                        if(PersonProfile.dogWalk > 0){
                            PersonProfile.dogWalk-=1
                            numberWalks = PersonProfile.dogWalk
                            initWalk = false
                            dataManager.updateDog(id: PersonProfile.dogId, field: "walk", num: numberWalks)
                        }
                    },label:{
                        Image("minus")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    })
                    if(!initWalk){
                    Text(String(numberWalks))
                        .font(.title)
                        .bold()
                        .frame(width: 100, height: 100)
                    } else {
                        Text(String(PersonProfile.dogWalk))
                            .font(.title)
                            .bold()
                            .frame(width: 100, height: 100)
                    }
                    
                    Button(action:{
                        if(PersonProfile.dogWalk < maxWalk){
                            PersonProfile.dogWalk+=1
                            numberWalks = PersonProfile.dogWalk
                            initWalk = false
                            dataManager.updateDog(id: PersonProfile.dogId, field: "walk", num: numberWalks)
                        }
                    },label:{
                        Image("pluse")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    })

                }
        Spacer().frame(height: 10)
                
                if(PersonProfile.dogShare == ""){
                    Button(action: {
                        if(!ShareDog.dogShared){
                        showPopup.toggle()
                        }
                    }, label: {
                        Text("Share")
                            .bold()
                            .frame(width: 160, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .offset(y: -10)
                    })
                    .sheet(isPresented: $showPopup){
                        ShareDog()
                    }
                }

            }

        }
    }

    
}

struct DogProfile_Previews: PreviewProvider {
    static var previews: some View {
        DogProfile()
    }
}
