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

class Habits: ObservableObject {
    @Published var items = [UserHabits]() {
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
    
    @ObservedObject var habits = Habits()
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.items) { index in
                    NavigationLink(destination: DetailView(title: index.title, description: index.description, timesCompleted: index.timesCompleted)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(index.title)
                                    .font(.headline)
                                Text(index.description)
                            }
                            Spacer()
                            
                            Text("\(index.timesCompleted)")
                                .padding(.trailing)
                        }
                    }
                }
                .onDelete(perform: removeItems)
                
            }
            .navigationBarTitle("Habitual")
            .navigationBarItems(leading: EditButton(), trailing:
                Button(action: {
                    showingAddView.toggle()
                    
                }) {
                    Image(systemName: "plus")
                    
                }
                .sheet(isPresented: $showingAddView) {
                    AddView(habits: self.habits, title: "", description: "", timesCompleted: 1, pageTitle: "Add New Habit", comingFromContentView: true)
                }
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
