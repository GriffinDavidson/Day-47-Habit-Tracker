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
    
    @State private var title = ""
    @State private var description = ""
    @State private var timesCompleted = 1
    
    var isDisabled: Bool {
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
            .navigationBarTitle("Add New Habit", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button(action: {
                let newHabit = Habits(context: self.moc)
                newHabit.title = self.title
                newHabit.body = self.description
                newHabit.timesCompleted = Int16(self.timesCompleted)
                
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
        AddView()
    }
}
