//
//  FinishWorkDetailView.swift
//  HomeWorkPlanner
//
//  Created by Marvin Hülsmann on 16.03.21.
//

import SwiftUI

struct FinishWorkDetailView: View {
    var homework: FinishWorkData
    
    @State var showDeleteAlert: Bool = false
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        
        VStack {
            VStack {
                VStack {
                    Text(homework.subject ?? "Undefined")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("\(checkDate()) um \(checkTime(date: homework.timeEnd ?? Date())) (\(checkDateName(date: homework.timeEnd ?? Date())))")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }
                
                VStack {
                    HStack {
                        Text("Aufgabe:")
                            .padding(.leading, 25)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(homework.name ?? "Undefined")
                        
                        Spacer()
                    }
                }
                .padding(.top, 50)
                
                if homework.notice != "" {
                    VStack {
                        HStack {
                            Text("Notizen:")
                                .padding(.leading, 25)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            ScrollView {
                                Text(homework.notice ?? "Undefined")
                            }
                            Spacer()
                            
                        }
                    }
                    .padding(.top, 15)
                }
                
//                if homework.link != "" {
//                    VStack {
//                        HStack {
//                            Text("Aufgaben einreichen:")
//                                .padding(.leading, 25)
//                                .font(.headline)
//                                .foregroundColor(.primary)
//
//
//
//                            Spacer()
//                        }
//                    }
//                    .padding(.top, 15)
//                }
                
//                HStack(alignment: .center) {
//                    Spacer()
//                    Button("Erledigt") {
//                        showDeleteAlert = true
//                    }
//                    .foregroundColor(.black)
//                    Spacer()
//                }
//                .padding()
//                .background(Color.white)
//                .cornerRadius(5)
//                .shadow(radius: 10)
//                .padding()
//                .alert(isPresented: $showDeleteAlert) {
//                    Alert(
//                        title: Text("Bist du sicher?"),
//                        message: Text("Diese Aufgabe wird von deiner Liste gelöscht!"),
//                        primaryButton: .default(
//                            Text("Abbrechen")
//                        ),
//                        secondaryButton: .destructive(
//                            Text("Fertig"),
//                            action: deleteHomeWork
//                        )
//                    )
//                }
//                .onTapGesture {
//                    showDeleteAlert = true
//                }
                
     
             Spacer()
                
            }
        }
    }
    
    /// Saves the homework list
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
    /// To delete one HomeWork
    func deleteHomeWork() {
        
        viewContext.delete(homework)
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        
        saveContext()
        mode.wrappedValue.dismiss()
    }
    
    func checkTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.setLocalizedDateFormatFromTemplate("HH:mm")
        formatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "UTC") // Eastern Standard Time
        
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func checkDateName(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.setLocalizedDateFormatFromTemplate("dd.MM")
        formatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation() ?? "UTC") // Eastern Standard Time
        
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func checkDate() -> String {
        let calender = Calendar.current
        
        if homework.timeEnd ?? Date() < Date()  {
            if calender.isDateInToday(homework.timeEnd ?? Date()) {
                return "Heute Abgelaufen"
            } else if calender.isDateInYesterday(homework.timeEnd ?? Date()) {
                return "Gestern Abgelaufen"
            } else {
                return "Abgelaufen"
            }
        }
        
        if calender.isDateInToday(homework.timeEnd ?? Date()) {
            return "Heute fällig"
        } else if calender.isDateInTomorrow(homework.timeEnd ?? Date()) {
            return "Morgen fällig"
        } else if calender.isDateInWeekend(homework.timeEnd ?? Date()) {
            return "In dieser Woche fällig"
        } else {
            return "In einiger Zeit fällig"
        }
    }
}
