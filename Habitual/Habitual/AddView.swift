//
//  AddView.swift
//  Habitual
//
//  Created by Griffin Davidson on 11/18/20.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State var title: String
    @State var description: String
    @State var timesCompleted: Int16
    
    let comingFromDetailView: Bool
    // I can use this variable also to choose between saving a new habit and overwriting one
    
    private var pageTitle: String {
        switch comingFromDetailView {
        case true: return "Edit Habit"
        case false: return "Add New Habit"
        }
    }
    
    private var isDisabled: Bool {
        if title.isEmpty || description.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                }
                
                Section {
                    Stepper(value: $timesCompleted, in: 1...100, step: 1) {
                        Text("Times Completed: \(timesCompleted)")
                    }
                }
            }
            .font(.body)
            .navigationBarTitle(pageTitle, displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button(action: {
                
                 //How can I overwrite already saved data?
                
                let newHabit = Habits(context: self.moc)
                newHabit.title = self.title
                newHabit.body = self.description
                newHabit.timesCompleted = self.timesCompleted
                
                try? self.moc.save()
                
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
            }.disabled(isDisabled))
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(title: "", description: "", timesCompleted: 1, comingFromDetailView: false)
    }
}
