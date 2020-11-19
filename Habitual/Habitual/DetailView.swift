//
//  DetailView.swift
//  Habitual
//
//  Created by Griffin Davidson on 11/18/20.
//

import SwiftUI
import CoreData

struct DetailView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    @State private var showingEditView = false
    
    let habit: Habits
    
    private var dynamicText: String {
        if habit.timesCompleted == 1 {
            return "time"
        } else {
            return "times"
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(habit.body ?? "Unknown Body")
                .padding(.horizontal)
            
            Spacer()
            
            Text("Completed: \(habit.timesCompleted) \(dynamicText) ")
                .padding(.bottom)
        }
        .navigationBarTitle(habit.title ?? "Unknown Title", displayMode: .inline)
        .navigationBarItems(trailing: VStack {
                                Menu("\(Image(systemName: "ellipsis.circle"))") {
                                    Button(action: {
                                        showingEditView.toggle()
                                    }) {
                                        Text("Edit Habit")
                                        Image(systemName: "highlighter")
                                    }
                                    
                                    Button(action: {
                                        showingDeleteAlert.toggle()
                                    }) {
                                        Text("Delete Habit")
                                        Image(systemName: "trash")
                                    }
                                }
                            }

                            .alert(isPresented: $showingDeleteAlert) {
                                Alert(title: Text("Delete Habit"),
                                    message: Text("You are about to delete your habit named \"\(habit.title ?? "NONAME")\".\nAre you sure?"),
                                    primaryButton: .cancel(),
                                    secondaryButton: .destructive(Text("Delete")) {
                                        deleteHabit()
                                    })
                            }
        
                            .sheet(isPresented: $showingEditView) {
                                AddView(title: habit.title ?? "", description: habit.body ?? "", timesCompleted: habit.timesCompleted, comingFromDetailView: true, habit: habit).environment(\.managedObjectContext, self.moc)
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
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let previewHabit = Habits(context: moc)
        previewHabit.title = "Demo"
        previewHabit.body = "This is a demo"
        previewHabit.timesCompleted = Int16(1)
        
        return NavigationView {
            DetailView(habit: previewHabit)
        }
    }
}
