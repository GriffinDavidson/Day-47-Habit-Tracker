//
//  DetailView.swift
//  Habitual
//
//  Created by Griffin Davidson on 11/18/20.
//

import SwiftUI

struct DetailView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let habit: Habits
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(habit.body ?? "Unknown Body")
                .padding(.horizontal)
            
            Spacer()
            
            Text("\(habit.timesCompleted)")
                .padding(.bottom)
        }
        .navigationBarTitle(habit.title ?? "Unknown Title", displayMode: .inline)
        .navigationBarItems(trailing: VStack {
                                Menu("Edit...") {
                                    Button(action: {
                                        showingDeleteAlert.toggle()
                                    }) {
                                        Text("Delete Habit")
                                        Image(systemName: "trash")
                                    }
                                    
                                    Button(action: {
                                        //Do Something
                                    }) {
                                        Text("Edit Habit")
                                        Image(systemName: "square.and.pencil")
                                    }
                                    .disabled(true)
                                }
                            }

                            .alert(isPresented: $showingDeleteAlert) {
                                Alert(title: Text("Delete Habit"),
                                    message: Text("You are about to delete your \"\(habit.title ?? "NONAME")\" habit.\nAre you sure?"),
                                    primaryButton: .cancel(),
                                    secondaryButton: .destructive(Text("Delete")) {
                                        deleteHabit()
                                    })
                            }
        )
    }
    
    func deleteHabit() {
        moc.delete(habit)
        
        try? self.moc.save()
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let previewHabit = Habits()
        previewHabit.title = "Demo"
        previewHabit.body = "This is a demo"
        previewHabit.timesCompleted = Int16(1)
        
        return DetailView(habit: previewHabit)
    }
}
