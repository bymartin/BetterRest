//
//  ContentView.swift
//  BetterRest
//
//  Created by Barry Martin on 5/15/20.
//  Copyright © 2020 Barry Martin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //@State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
//    @State private var alertTitle = ""
//    @State private var alertMessage = ""
//    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time",
                               selection: $wakeUp,
                               displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        // use old style due to bug in animation in forms
                        .datePickerStyle(WheelDatePickerStyle()) // iOS only
                }
                
                Section(header: Text("Desired amount of sleep")) {
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header: Text("Daily coffee intake")) {
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(1..<21) {
                            Text($0 == 1 ? "\($0) cup" : "\($0) cups")
                        }
                    }
                    .labelsHidden()
                    //.pickerStyle(WheelPickerStyle())
                }
                
                Section(header: Text("Your recommended bed time is: ")) {
                    HStack {
                        Spacer()
                        Text(calculateBedTime())
                            .font(.largeTitle)
                            .foregroundColor(.purple)
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("BetterRest")
                
            // Challenge 3: Remove Calculate button
            // Will display results all the time instead
//            .navigationBarItems(trailing:
//                Button(action: calculateBedTime) {
//                    Text("Calculate")
//                }
//            )
//                .alert(isPresented: $showingAlert) {
//                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedTime() -> String {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try
                model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            //alertTitle = "Your ideal bedtime is ..."
            //alertMessage = formatter.string(from: sleepTime)
            return formatter.string(from: sleepTime)
            
        } catch {
            //alertTitle = "Error"
            //alertMessage = "Sorry, there was a problem calculating your bedtime."
            return "Error calculating your bedtime!"
        }
        
        //showingAlert = true
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
