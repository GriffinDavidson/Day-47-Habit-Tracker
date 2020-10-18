//
//  ContentView.swift
//  Day47_HabitTrackerChallenge
//
//  Created by Griffin Davidson on 10/11/20.
//

//To-do extras: if there are no habits (newly downloaded /
//deleted all), show big blue button to create a new habit

import SwiftUI

struct UserHabits: Identifiable, Codable {
    let title: String
    let description: String
    let timesCompleted: Int
    var id = UUID()
}

class Habits: ObservableObject, Identifiable {
    @Published var items = [UserHabits]() {
        
        // I need to ditch UserDefaults
        
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Habits")
            }
        }
    }
    
    init() {
        if let habits = UserDefaults.standard.data(forKey: "Habits") {
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode([UserHabits].self, from: habits) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
    
}

struct ContentView: View {
    
    @StateObject var habits = Habits()
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.items.indices, id: \.self) { index in
                    //Need to say id: \.id
                    NavigationLink(destination: DetailView(habits: self.habits, index: index)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(habits.items[index].title)
                                    .font(.headline)
                                Text(habits.items[index].description)
                            }
                            Spacer()
                            
                            Text("\(habits.items[index].timesCompleted)")
                                .padding(.trailing)
                        }
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("Habitual")
            .navigationBarItems(leading:
                Button(action: {
                    //showingAddView.toggle()
                    //disabled AddView to create autoentries for Debugging. Helps
                    //Demonstrate the need to tell swift to identify by the UUID
                    let userInput = UserHabits(title: "Test", description: "This is a test", timesCompleted: 1)
                    self.habits.items.append(userInput)
                    
                }) {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showingAddView) {
                    AddView(habits: self.habits, title: "", description: "", timesCompleted: 1, pageTitle: "Add New Habit", comingFromContentView: true)
                }, trailing: EditButton()
            )
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        habits.items.remove(atOffsets: offsets)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
