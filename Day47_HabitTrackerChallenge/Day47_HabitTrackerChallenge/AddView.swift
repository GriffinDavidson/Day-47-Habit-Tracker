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
                    //I need to fix this, and migrate away from
                    //UserDefaults
                    //
                    //As of right now, it works fine if the habit is the first
                    //item in the list, but if its not the first, the edits are
                    //duplicated and the first habit is destroyed.
                    self.habits.items.remove(at: 0)
                    self.habits.items.append(userInput)
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
        AddView(habits: Habits(), title: "", description: "", timesCompleted: 1, pageTitle: "Add New Habit", comingFromContentView: true)
            .preferredColorScheme(.light)
    }
}
