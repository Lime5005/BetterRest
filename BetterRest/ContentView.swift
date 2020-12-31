//
//  ContentView.swift
//  BetterRest
//
//  Created by Lime on 29/12/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 0
    @State private var sleepTime = 8.0
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section {
                    Text("Disired amount of sleep:")
                    Stepper(value: $sleepTime, in: 4...12, step: 0.25) {
                        Text("\(sleepTime, specifier: "%g") hours")
                    }
                }
                
//                Section {
//                    Text("Daily coffee intake:")
//                    Stepper(value: $coffeeAmount, in: 1...20) {
//                        if coffeeAmount == 1 {
//                            Text("1 cup")
//                        } else {
//                            Text("\(coffeeAmount) cups")
//                        }
//                    }
//                }
                
                Section(header: Text("Daily coffee intake:")) {
                    Picker("coffee", selection: $coffeeAmount) {
                        ForEach(1 ..< 21) {
                            if $0 == 1 {
                                Text("\($0) cup")
                            } else {
                                Text("\($0) cups")
                            }
                        }
                    }
                }
                
                Section {
                    Text("\(alertTitle)")
                    Text("\(alertMessage)")
                        .foregroundColor(.blue)
                        .font(.largeTitle)
                }
                Spacer()
                
            }
            .navigationBarTitle("BetterRest")
            .onAppear(){
                self.calculateBedTime()
            }
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedTime () {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepTime, coffee: Double(coffeeAmount))

            let sleepAmount = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short

            alertMessage = formatter.string(from: sleepAmount)
            alertTitle = "Your ideal bedtime is…"
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
