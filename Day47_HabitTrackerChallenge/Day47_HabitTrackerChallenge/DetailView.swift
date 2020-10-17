//
//  DetailView.swift
//  Day47_HabitTrackerChallenge
//
//  Created by Griffin Davidson on 10/11/20.
//

import SwiftUI

struct DetailView: View {
    
    @State private var showingEditView = false
    
    var title: String
    var description: String
    var timesCompleted: Int

    var body: some View {
        Text("\(description)")
            .navigationBarTitle("\(title)", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showingEditView.toggle()
            }) {
                Text("Edit")
            })
            .sheet(isPresented: $showingEditView) {
                AddView(habits: Habits(),
                        title: self.title,
                        description: self.description,
                        timesCompleted: self.timesCompleted,
                        pageTitle: "Edit Habit",
                        comingFromContentView: false
                    )}
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(title: "", description: "", timesCompleted: 0)
            .preferredColorScheme(.light)
    }
}
