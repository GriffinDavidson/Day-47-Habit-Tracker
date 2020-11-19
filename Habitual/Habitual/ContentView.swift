//
//  ContentView.swift
//  Habitual
//
//  Created by Griffin Davidson on 11/18/20.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Habits.entity(), sortDescriptors: []) var habits: FetchedResults<Habits>
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits, id: \.self) { habit in
                    NavigationLink(destination: DetailView(habit: habit)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(habit.title ?? "Unknown Title")
                                    .font(.headline)
                                
                                Text(habit.body ?? "Unknown Body")
                                    .foregroundColor(.secondary)
                                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                            }
                            
                            Spacer()
                            
                            Text(("\(habit.timesCompleted)"))
                                .padding(.leading)
                        }
                    }
                }.onDelete(perform: delete)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Habitual")
            .navigationBarItems(leading: EditButton(), trailing:
                Button(action: {
                    showingAddView.toggle()
                    
//                    let habit = Habits(context: self.moc)
//                    habit.title = "Demo"
//                    habit.body = "This is a demonstration of how this app works and is intended for development purposes only"
//                    habit.timesCompleted = Int16(1)
                }) {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showingAddView) {
                    AddView(title: "", description: "", timesCompleted: 1, comingFromDetailView: false, habit: Habits()).environment(\.managedObjectContext, self.moc)
                }
            )
        }
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let habit = habits[offset]
            moc.delete(habit)
        }
        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
