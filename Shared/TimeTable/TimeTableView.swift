//
//  TimeTableView.swift
//  HomeWorkPlanner (iOS)
//
//  Created by Marvin Hülsmann on 23.03.21.
//

import SwiftUI

struct TimeTableView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    /// get all timetables
    private var timeTable: FetchedResults<TimeTableData>
    
    var body: some View {
        NavigationView {
            
            List {
                if !TimeTableHandler().getChangeSubjectsForNextDayIn(results: timeTable).isEmpty {
                    Section(header: Text("Einpacken")) {
                        ForEach(TimeTableHandler().getChangeSubjectsForNextDayIn(results: timeTable), id: \.self) { table in
                            
                            Text(table)
                        }
                    }
                    if !TimeTableHandler().getChangeSubjectsForNextDayOut(results: timeTable).isEmpty {
                        Section(header: Text("Auspacken")) {
                            ForEach(TimeTableHandler().getChangeSubjectsForNextDayOut(results: timeTable), id: \.self) { table in
                                
                                Text(table)
                            }
                        }
                    }
                } else {
                    Text("Du musst deinen Stundenplan für \(TimeTableHandler().getCurrentWeekDayName(forNextDay: true)) ausfüllen!")
                        .bold()
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Stundenplan", destination: WeekDaysView())
                }
            })
            .listStyle(PlainListStyle())
            .navigationTitle("Für \(TimeTableHandler().getCurrentWeekDayName(forNextDay: true))")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TimeTableView_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableView()
    }
}
