//
//  AddView.swift
//  Day47_HabitTrackerChallenge
//
//  Created by Griffin Davidson on 10/11/20.
//

import SwiftUI

struct AddView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habits: Habits
    @State var title: String
    @State var description: String
    @State var timesCompleted: Int
    
    var index: Int?
    
    var pageTitle: String
    var comingFromContentView: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    Stepper(value: $timesCompleted, in: 1...100) {
                        Text("Times Completed: \(timesCompleted)")
                    }
                }.font(.system(size: 17, weight: .regular))
            }
            .navigationBarTitle(pageTitle, displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            },
            
            trailing: Button(action: {
                let userInput = UserHabits(title: self.title, description: self.description, timesCompleted: self.timesCompleted)
                if comingFromContentView {
                    self.habits.items.append(userInput)
                } else {
                    self.habits.items.remove(at: index!)
                    self.habits.items.append(userInput)
                    //Now...How do I save edits rather than deleting
                    //And re-adding?
                }
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
            })
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(habits: Habits(), title: "", description: "", timesCompleted: 1, index: 0, pageTitle: "Add New Habit", comingFromContentView: true)
            .preferredColorScheme(.light)
    }
}
