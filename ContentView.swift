//
//  ContentView.swift
//  assignment0
//
//  Created by Kevin Jones on 2/19/25.
//

import SwiftUI

typealias hobbyTuple = (String, String)
let green = Color(red: 35/255.0, green: 206/255.0, blue: 107/255.0)
let darkBlue = Color(red: 10/255.0, green: 46/255.0, blue: 54/255.0)
let blue = Color(red: 3/255.0, green: 15/255.0, blue: 17/255.0)





struct ContentView: View {
    @State private var showingSheet = false
    @State var showingAlert: Bool = false
    @State private var hobbies:[hobbyTuple] = [
        ("Running", "🏃‍♂️"),
        ("Biking", "🚴"),
        ("Swimming", "🏊"),
        ("Role-playing Game", "🧝‍♂️"),
        ("Video Games", "🕹️"),
        ("Cooking", "🧑‍🍳"),
        ("Dancing", "🕺"),
        ("Gardening", "🧑‍🌾"),
        ("Bird Watching", "🐦"),
        ("Watching TV", "📺")
    ]
    var body: some View {
        NavigationView{
            ZStack {
                darkBlue.ignoresSafeArea(.all)
                VStack {
                    
                    if hobbies.isEmpty {
                        Text("Add a Hobby using the '+' button")
                            .font(.title2)
                            .bold()
                            .foregroundColor(green)
                            .padding(.top,-50)
                    }else {
                        List{
                            
                            ForEach(hobbies, id:\.0)
                            { hobby in
                                HStack{
                                    Text(hobby.0)
                                        .foregroundColor(blue)
                                        .bold()
                                    Spacer()
                                    Text(hobby.1)
                                }
                                .listRowBackground(green.opacity(0.65))
                                .padding(10)
                                
                            }
                        }
                        .padding()
                        .frame(width:400)
                        .scrollContentBackground(.hidden)
                        
                    }
                    
                    
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarItems (leading: Text("Hobby List")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(green),
                    
                    trailing:
                    Button(action: {
                    showingSheet.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(green)
                        .padding()
                })
                .sheet(isPresented: $showingSheet){
                    AddHobbyView(showingSheet: $showingSheet, hobbies:$hobbies, showingAlert:$showingAlert)
                }
            }
        }
    }
}
    

private extension ContentView {
    struct AddHobbyView: View {
        
        @Binding var showingSheet: Bool
        @Binding var hobbies: [hobbyTuple]
        @Binding var showingAlert: Bool
        @FocusState private var isTextFieldFocused: Bool
        @State var hobby: String = ""
        @State var selectedEmoji = 0
        let emojis = ["🏀", "🎶", "🏓", "✈️", "⚙️", "📸", "🖍️", "📖", "📝", "🤿", "🏁", "🧘", "🛹", "🧑‍🍳", "🪡", "🏕️", "📺", "🐶", "🌹", "💫", "🎹"]
        
        func submit(hobbyName: String, emoji: String) {
            if hobbies.contains(where: { $0.0.lowercased() == hobbyName.lowercased() }) {
                showingAlert = true
            } else {
                hobbies.append((hobbyName, emoji))
                showingAlert = false
            }
        }
        
        var body: some View {
            NavigationView {
                VStack {
                    HStack {
                        Text("Add a Hobby")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(green)
                        Spacer()
                        Button(action: {
                            showingSheet.toggle()
                        }) {
                            Image(systemName: "xmark")
                                .font(.largeTitle)
                                .foregroundColor(green)
                        }
                    }
                    .padding(.top, 30)
                    .padding(.horizontal)
                    .frame(alignment: .top)
                    
                    VStack {
                        TextField("Enter Hobby", text: $hobby)
                            .padding()
                            .background(green)
                            .foregroundColor(blue)
                            .cornerRadius(10)
                            .font(.title2)
                            .frame(width: 300)
                            .focused($isTextFieldFocused)
                        
                        Picker(selection: $selectedEmoji, label: Text("Emoji").font(.title)) {
                            ForEach(0..<emojis.count, id: \.self) { index in
                                Text(emojis[index]).tag(index)
                                    .font(.largeTitle)
                            }
                        }
                        
                        Button(action: {
                            submit(hobbyName: hobby, emoji: emojis[selectedEmoji])
                            if !showingAlert { // Only close the sheet if no alert is shown
                                showingSheet = false
                            }
                        }) {
                            Text("Submit")
                                .font(.system(size:20, weight: .bold))
                                .foregroundColor(blue)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).fill(hobby.count < 3 ? green.opacity(0.5) : green.opacity(1)))
                        }
                        .disabled(hobby.count < 3)
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Hobby Already Added"), message: Text("The hobby entered is already listed"))
                        
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                }
                .background(darkBlue)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer() // Push the button to the right
                        Button(action: {
                            isTextFieldFocused = false
                        }) {
                            Text("Done")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
