//
//  DetailView.swift
//  Day47_HabitTrackerChallenge
//
//  Created by Griffin Davidson on 10/11/20.
//

import SwiftUI

struct DetailView: View {
    
    @State private var showingEditView = false
    @ObservedObject var habits: Habits
    @State public var index: Int
    
    var body: some View {
        Text("\(habits.items[index].description)")
            .navigationBarTitle("\(habits.items[index].title)", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showingEditView.toggle()
            }) {
                Text("Edit")
            })
            .sheet(isPresented: $showingEditView) {
                AddView(habits: Habits(),
                        title: habits.items[index].title,
                        description: habits.items[index].description,
                        timesCompleted: habits.items[index].timesCompleted,
                        index: index,
                        pageTitle: "Edit Habit",
                        comingFromContentView: false
                    )}
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(habits: Habits(), index: 0)
            .preferredColorScheme(.light)
    }
}
