//
//  DetailView.swift
//  Day47_HabitTrackerChallenge
//
//  Created by Griffin Davidson on 10/11/20.
//

import SwiftUI

struct DetailView: View {
    
    let detailedHabit: Habits
    @State private var showingEditView = false
    
    var body: some View {
        Text("\(detailedHabit.items[0].description)")
            .navigationBarTitle("\(detailedHabit.items[0].title)", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showingEditView.toggle()
            }) {
                Image(systemName: "square.and.pencil")
            })
            .sheet(isPresented: $showingEditView) {
                AddView(habits: self.detailedHabit, title: detailedHabit.items[0].title, description: detailedHabit.items[0].description, timesCompleted: detailedHabit.items[0].timesCompleted, pageTitle: "Edit Habit", comingFromContentView: false)
            }
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(detailedHabit: Habits())
    }
}
