//
//  ContentView.swift
//  Endling v. 1.2
//
//  Created by artsw0rd on 10/31/25.
//

import SwiftUI

struct ContentView: View {
    // Struct-wide variables
    @State private var message = "ENDLING"
    @State private var imageName = ""
    @State private var lastImageNumber = -1
    @State private var dice1Number: Int = Int.random(in: 1...6)
    @State private var dice2Number: Int = Int.random(in: 1...6)
    @State private var isRollingDice1 = false
    @State private var isRollingDice2 = false
    
    // Stat tracking
    @State private var willStat = 6
    @State private var foodStat = 3
    @State private var fuelStat = 3
    @State private var gearStat = 3
    
    // Dice roll animation
    @State private var showDiceRoll = false
    @State private var rollingNumber = 1
    @State private var currentRollingStat: StatType? = nil
    
    let range = 1...6
    let numberOfOracles = 22
    let numberOfWildCiv = 28
    
    enum StatType {
        case will, food, fuel, gear
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                Button("ENDLING") {
                    imageName = ""
                }
                .buttonStyle(.borderedProminent)
                .buttonStyle(.glassProminent)
                .foregroundStyle(.accent)
                .tint(.white)
                .font(.custom("ArchivoBlack-Regular", size: 50))
                
                HStack{
                    // 2d6 Dice#1
                    Button(action: {
                        rollSingleDie(diceNumber: 1)
                    }) {
                        Text("\(dice1Number)")
                            .font(.custom("ArchivoBlack-Regular", size: 50))
                            .foregroundColor(.white)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.accent)
                    }
                    .aspectRatio(1.0, contentMode: .fit)
                    .cornerRadius(8)
                    .disabled(isRollingDice1 || isRollingDice2)
                    
                    Button(action: {
                        rollBothDice()
                    }) {
                        Image("hexflower")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
                    .disabled(isRollingDice1 || isRollingDice2)
                    
                    // 2d6 Dice#2
                    Button(action: {
                        rollSingleDie(diceNumber: 2)
                    }) {
                        Text("\(dice2Number)")
                            .font(.custom("ArchivoBlack-Regular", size: 50))
                            .foregroundColor(.white)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.accent)
                    }
                    .aspectRatio(1.0, contentMode: .fit)
                    .cornerRadius(8)
                    .disabled(isRollingDice1 || isRollingDice2)
                }
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .shadow(radius: 30)
                
                Spacer()
                
                Button("Oracle") {
                    var oracleNumber: Int
                    repeat {
                        oracleNumber = Int.random(in: 0...(numberOfOracles-1))
                    } while oracleNumber == lastImageNumber
                    imageName = "oracle\(oracleNumber)"
                    lastImageNumber = oracleNumber
                }
                .buttonStyle(.borderedProminent)
                .buttonStyle(.glassProminent)
                .tint(.accentColor)
                .font(.custom("ArchivoBlack-Regular", size: 20))
                
                HStack {
                    Button("Wilderness") {
                        var wildernessNumber: Int
                        repeat {
                            wildernessNumber = Int.random(in: 0...(numberOfWildCiv-1))
                        } while wildernessNumber == lastImageNumber
                        imageName = "wilderness\(wildernessNumber)"
                        lastImageNumber = wildernessNumber
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonStyle(.glassProminent)
                    .tint(.accentColor)
                    .font(.custom("ArchivoBlack-Regular", size: 20))
                    
                    Button("Civilization") {
                        var civilizationNumber: Int
                        repeat {
                            civilizationNumber = Int.random(in: 0...(numberOfWildCiv-1))
                        } while civilizationNumber == lastImageNumber
                        imageName = "civilization\(civilizationNumber)"
                        lastImageNumber = civilizationNumber
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonStyle(.glassProminent)
                    .tint(.accentColor)
                    .font(.custom("ArchivoBlack-Regular", size: 20))
                }
                
                // STAT TRACKER
                HStack(spacing: 15) {
                    // Will Stat
                    StatBox(
                        statName: "Will",
                        statValue: willStat,
                        onRoll: {
                            rollStat(.will)
                        },
                        onIncrement: {
                            incrementStat(.will)
                        }
                    )
                    
                    // Food Stat
                    StatBox(
                        statName: "Food",
                        statValue: foodStat,
                        onRoll: {
                            rollStat(.food)
                        },
                        onIncrement: {
                            incrementStat(.food)
                        }
                    )
                    
                    // Fuel Stat
                    StatBox(
                        statName: "Fuel",
                        statValue: fuelStat,
                        onRoll: {
                            rollStat(.fuel)
                        },
                        onIncrement: {
                            incrementStat(.fuel)
                        }
                    )
                    
                    // Gear Stat
                    StatBox(
                        statName: "Gear",
                        statValue: gearStat,
                        onRoll: {
                            rollStat(.gear)
                        },
                        onIncrement: {
                            incrementStat(.gear)
                        }
                    )
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            .padding()
            
            // Dice Roll Overlay
            if showDiceRoll {
                DiceRollOverlay(
                    rollingNumber: $rollingNumber,
                    isShowing: $showDiceRoll,
                    statName: statNameForType(currentRollingStat ?? .will)
                )
            }
        }
    }
    
    // MARK: - Dice Rolling Functions
    
    func rollSingleDie(diceNumber: Int) {
        if diceNumber == 1 {
            isRollingDice1 = true
            animateDiceRoll(diceNumber: 1)
        } else {
            isRollingDice2 = true
            animateDiceRoll(diceNumber: 2)
        }
    }
    
    func rollBothDice() {
        isRollingDice1 = true
        isRollingDice2 = true
        animateDiceRoll(diceNumber: 1)
        animateDiceRoll(diceNumber: 2)
    }
    
    func animateDiceRoll(diceNumber: Int) {
        var animationCount = 0
        let maxAnimations = 15
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            animationCount += 1
            
            let randomValue = Int.random(in: 1...6)
            if diceNumber == 1 {
                dice1Number = randomValue
            } else {
                dice2Number = randomValue
            }
            
            if animationCount >= maxAnimations {
                timer.invalidate()
                
                // Set final value
                let finalValue = Int.random(in: 1...6)
                if diceNumber == 1 {
                    dice1Number = finalValue
                    isRollingDice1 = false
                } else {
                    dice2Number = finalValue
                    isRollingDice2 = false
                }
            }
        }
    }
    
    // MARK: - Stat Increment Function
    
    func incrementStat(_ stat: StatType) {
        switch stat {
        case .will:
            willStat = min(6, willStat + 2)
        case .food:
            foodStat = min(6, foodStat + 2)
        case .fuel:
            fuelStat = min(6, fuelStat + 2)
        case .gear:
            gearStat = min(6, gearStat + 2)
        }
    }
    
    // MARK: - Stat Rolling Logic
    
    func rollStat(_ stat: StatType) {
        // Determine which stat to actually roll
        let statToRoll: StatType
        let currentValue: Int
        
        switch stat {
        case .will:
            if willStat == 0 {
                // Game over - Will is depleted
                return
            }
            statToRoll = .will
            currentValue = willStat
            
        case .food:
            if foodStat == 0 {
                // Roll Will instead
                statToRoll = .will
                currentValue = willStat
            } else {
                statToRoll = .food
                currentValue = foodStat
            }
            
        case .fuel:
            if fuelStat == 0 {
                // Roll Will instead
                statToRoll = .will
                currentValue = willStat
            } else {
                statToRoll = .fuel
                currentValue = fuelStat
            }
            
        case .gear:
            if gearStat == 0 {
                // Roll Will instead
                statToRoll = .will
                currentValue = willStat
            } else {
                statToRoll = .gear
                currentValue = gearStat
            }
        }
        
        currentRollingStat = statToRoll
        showDiceRoll = true
        
        // Animate the roll
        var animationCount = 0
        let maxAnimations = 15
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            animationCount += 1
            rollingNumber = Int.random(in: 1...6)
            
            if animationCount >= maxAnimations {
                timer.invalidate()
                
                // Final roll result
                let finalRoll = Int.random(in: 1...6)
                rollingNumber = finalRoll
                
                // Apply the roll result after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    applyRollResult(finalRoll, to: statToRoll, currentValue: currentValue)
                    
                    // Hide the overlay after showing result
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        showDiceRoll = false
                    }
                }
            }
        }
    }
    
    func applyRollResult(_ roll: Int, to stat: StatType, currentValue: Int) {
        // If rolled number >= current stat value, reduce stat by 1
        if roll >= currentValue {
            switch stat {
            case .will:
                willStat = max(0, willStat - 1)
            case .food:
                foodStat = max(0, foodStat - 1)
            case .fuel:
                fuelStat = max(0, fuelStat - 1)
            case .gear:
                gearStat = max(0, gearStat - 1)
            }
        }
    }
    
    func statNameForType(_ type: StatType) -> String {
        switch type {
        case .will: return "Will"
        case .food: return "Food"
        case .fuel: return "Fuel"
        case .gear: return "Gear"
        }
    }
}

// MARK: - Stat Box Component

struct StatBox: View {
    let statName: String
    let statValue: Int
    let onRoll: () -> Void
    let onIncrement: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            // Stat value box - NOW CLICKABLE TO ADD +2
            Button(action: onIncrement) {
                Text(statValue == 0 ? "DEP" : "\(statValue)")
                    .font(.custom("ArchivoBlack-Regular", size: 43))
                    .foregroundColor(.white)
                    .frame(width: 70, height: 70)
                    .background(Color.accent)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Stat name button - ROLLS THE STAT
            Button(action: onRoll) {
                Text(statName.uppercased())
                    .font(.custom("ArchivoBlack-Regular", size: 20))
                    .foregroundColor(.accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .cornerRadius(5)
            }
        }
    }
}

// MARK: - Dice Roll Overlay

struct DiceRollOverlay: View {
    @Binding var rollingNumber: Int
    @Binding var isShowing: Bool
    let statName: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("ROLLING \(statName.uppercased())")
                    .font(.custom("ArchivoBlack-Regular", size: 24))
                    .foregroundColor(.white)
                
                Text("\(rollingNumber)")
                    .font(.custom("ArchivoBlack-Regular", size: 80))
                    .foregroundColor(.white)
                    .frame(width: 150, height: 150)
                    .background(Color.accent)
                    .cornerRadius(20)
                    .shadow(radius: 20)
            }
        }
    }
}

#Preview("Light Mode") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}

////
////  ContentView.swift
////  Endling v. 1.1
////
////  Created by artsw0rd on 10/31/25.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    // Struct-wide variables
//    @State private var message = "ENDLING"
//    @State private var imageName = ""
//    @State private var lastImageNumber = -1
//    @State private var currentNumber: Int = Int.random(in: 1...6)
//    
//    // Stat tracking
//    @State private var willStat = 6
//    @State private var foodStat = 3
//    @State private var fuelStat = 3
//    @State private var gearStat = 3
//    
//    // Dice roll animation
//    @State private var showDiceRoll = false
//    @State private var rollingNumber = 1
//    @State private var currentRollingStat: StatType? = nil
//    
//    let range = 1...6
//    let numberOfOracles = 22
//    let numberOfWildCiv = 28
//    
//    enum StatType {
//        case will, food, fuel, gear
//    }
//    
//    var body: some View {
//        ZStack {
//            Color.white.ignoresSafeArea()
//            
//            VStack {
//                Button("ENDLING") {
//                    imageName = ""
//                }
//                .buttonStyle(.borderedProminent)
//                .buttonStyle(.glassProminent)
//                .foregroundStyle(.accent)
//                .tint(.white)
//                .font(.custom("ArchivoBlack-Regular", size: 50))
//                
//                HStack{
//                    // 2d6 Dice#1
//                    Button(action: {
//                        currentNumber = Int.random(in: range)
//                    }) {
//                        Text("\(currentNumber)")
//                            .font(.custom("ArchivoBlack-Regular", size: 50))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: 70, maxHeight: 70)
//                            .background(Color.accent)
//                    }
//                    .aspectRatio(1.0, contentMode: .fit)
//                    .cornerRadius(8)
//                    
//                    Button(action: {
//                        
//                    }) {
//                        Image("hexflower") // Replace "YourImageName" with the actual name of your image asset
//                            .resizable() // Makes the image resizable
//                            .aspectRatio(contentMode: .fit) // Maintains aspect ratio when resizing
//                            .frame(width: 100, height: 100) // Sets a specific size for the image
//                    }
//                    
//                    // 2d6 Dice#2
//                    Button(action: {
//                        currentNumber = Int.random(in: range)
//                    }) {
//                        Text("\(currentNumber)")
//                            .font(.custom("ArchivoBlack-Regular", size: 50))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: 70, maxHeight: 70)
//                            .background(Color.accent)
//                    }
//                    .aspectRatio(1.0, contentMode: .fit)
//                    .cornerRadius(8)
//                }
//                Image(imageName)
//                    .resizable()
//                    .scaledToFit()
//                    .clipShape(RoundedRectangle(cornerRadius: 30))
//                    .shadow(radius: 30)
//                
//                Spacer()
//                
//                Button("Oracle") {
//                    var oracleNumber: Int
//                    repeat {
//                        oracleNumber = Int.random(in: 0...(numberOfOracles-1))
//                    } while oracleNumber == lastImageNumber
//                    imageName = "oracle\(oracleNumber)"
//                    lastImageNumber = oracleNumber
//                }
//                .buttonStyle(.borderedProminent)
//                .buttonStyle(.glassProminent)
//                .tint(.accentColor)
//                .font(.custom("ArchivoBlack-Regular", size: 20))
//                
//                HStack {
//                    Button("Wilderness") {
//                        var wildernessNumber: Int
//                        repeat {
//                            wildernessNumber = Int.random(in: 0...(numberOfWildCiv-1))
//                        } while wildernessNumber == lastImageNumber
//                        imageName = "wilderness\(wildernessNumber)"
//                        lastImageNumber = wildernessNumber
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .buttonStyle(.glassProminent)
//                    .tint(.accentColor)
//                    .font(.custom("ArchivoBlack-Regular", size: 20))
//                    
//                    Button("Civilization") {
//                        var civilizationNumber: Int
//                        repeat {
//                            civilizationNumber = Int.random(in: 0...(numberOfWildCiv-1))
//                        } while civilizationNumber == lastImageNumber
//                        imageName = "civilization\(civilizationNumber)"
//                        lastImageNumber = civilizationNumber
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .buttonStyle(.glassProminent)
//                    .tint(.accentColor)
//                    .font(.custom("ArchivoBlack-Regular", size: 20))
//                }
//                
//                // STAT TRACKER
//                HStack(spacing: 15) {
//                    // Will Stat
//                    StatBox(
//                        statName: "Will",
//                        statValue: willStat,
//                        onRoll: {
//                            rollStat(.will)
//                        }
//                    )
//                    
//                    // Food Stat
//                    StatBox(
//                        statName: "Food",
//                        statValue: foodStat,
//                        onRoll: {
//                            rollStat(.food)
//                        }
//                    )
//                    
//                    // Fuel Stat
//                    StatBox(
//                        statName: "Fuel",
//                        statValue: fuelStat,
//                        onRoll: {
//                            rollStat(.fuel)
//                        }
//                    )
//                    
//                    // Gear Stat
//                    StatBox(
//                        statName: "Gear",
//                        statValue: gearStat,
//                        onRoll: {
//                            rollStat(.gear)
//                        }
//                    )
//                }
//                .padding(.top, 20)
//                .padding(.bottom, 20)
//            }
//            .padding()
//            
//            // Dice Roll Overlay
//            if showDiceRoll {
//                DiceRollOverlay(
//                    rollingNumber: $rollingNumber,
//                    isShowing: $showDiceRoll,
//                    statName: statNameForType(currentRollingStat ?? .will)
//                )
//            }
//        }
//    }
//    
//    // MARK: - Stat Rolling Logic
//    
//    func rollStat(_ stat: StatType) {
//        // Determine which stat to actually roll
//        let statToRoll: StatType
//        let currentValue: Int
//        
//        switch stat {
//        case .will:
//            if willStat == 0 {
//                // Game over - Will is depleted
//                return
//            }
//            statToRoll = .will
//            currentValue = willStat
//            
//        case .food:
//            if foodStat == 0 {
//                // Roll Will instead
//                statToRoll = .will
//                currentValue = willStat
//            } else {
//                statToRoll = .food
//                currentValue = foodStat
//            }
//            
//        case .fuel:
//            if fuelStat == 0 {
//                // Roll Will instead
//                statToRoll = .fuel
//                currentValue = willStat
//            } else {
//                statToRoll = .fuel
//                currentValue = fuelStat
//            }
//            
//        case .gear:
//            if gearStat == 0 {
//                // Roll Will instead
//                statToRoll = .will
//                currentValue = willStat
//            } else {
//                statToRoll = .gear
//                currentValue = gearStat
//            }
//        }
//        
//        currentRollingStat = statToRoll
//        showDiceRoll = true
//        
//        // Animate the roll
//        var animationCount = 0
//        let maxAnimations = 15
//        
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
//            animationCount += 1
//            rollingNumber = Int.random(in: 1...6)
//            
//            if animationCount >= maxAnimations {
//                timer.invalidate()
//                
//                // Final roll result
//                let finalRoll = Int.random(in: 1...6)
//                rollingNumber = finalRoll
//                
//                // Apply the roll result after a short delay
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    applyRollResult(finalRoll, to: statToRoll, currentValue: currentValue)
//                    
//                    // Hide the overlay after showing result
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                        showDiceRoll = false
//                    }
//                }
//            }
//        }
//    }
//    
//    func applyRollResult(_ roll: Int, to stat: StatType, currentValue: Int) {
//        // If rolled number >= current stat value, reduce stat by 1
//        if roll >= currentValue {
//            switch stat {
//            case .will:
//                willStat = max(0, willStat - 1)
//            case .food:
//                foodStat = max(0, foodStat - 1)
//            case .fuel:
//                fuelStat = max(0, fuelStat - 1)
//            case .gear:
//                gearStat = max(0, gearStat - 1)
//            }
//        }
//    }
//    
//    func statNameForType(_ type: StatType) -> String {
//        switch type {
//        case .will: return "Will"
//        case .food: return "Food"
//        case .fuel: return "Fuel"
//        case .gear: return "Gear"
//        }
//    }
//}
//
//// MARK: - Stat Box Component
//
//struct StatBox: View {
//    let statName: String
//    let statValue: Int
//    let onRoll: () -> Void
//    
//    var body: some View {
//        VStack(spacing: 8) {
//            // Stat value box
//            Text(statValue == 0 ? "DEP" : "\(statValue)")
//                .font(.custom("ArchivoBlack-Regular", size: 43))
//                .foregroundColor(.white)
//                .frame(width: 70, height: 70)
//                .background(Color.accent)
//                .cornerRadius(8)
//            
//            // Stat name button
//            Button(action: onRoll) {
//                Text(statName.uppercased())
//                    .font(.custom("ArchivoBlack-Regular", size: 20))
//                    .foregroundColor(.accent)
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 6)
//                    .background(Color.white)
//                    .cornerRadius(5)
//            }
//        }
//    }
//}
//
//// MARK: - Dice Roll Overlay
//
//struct DiceRollOverlay: View {
//    @Binding var rollingNumber: Int
//    @Binding var isShowing: Bool
//    let statName: String
//    
//    var body: some View {
//        ZStack {
//            Color.black.opacity(0.7)
//                .ignoresSafeArea()
//            
//            VStack(spacing: 30) {
//                Text("ROLLING \(statName.uppercased())")
//                    .font(.custom("ArchivoBlack-Regular", size: 24))
//                    .foregroundColor(.white)
//                
//                Text("\(rollingNumber)")
//                    .font(.custom("ArchivoBlack-Regular", size: 80))
//                    .foregroundColor(.white)
//                    .frame(width: 150, height: 150)
//                    .background(Color.accent)
//                    .cornerRadius(20)
//                    .shadow(radius: 20)
//            }
//        }
//    }
//}
//
//#Preview("Light Mode") {
//    ContentView()
//        .preferredColorScheme(.light)
//}
//
//#Preview("Dark Mode") {
//    ContentView()
//        .preferredColorScheme(.dark)
//}




//
////
////  ContentView.swift
////  Endling v. 1.0
////
////  Created by artsw0rd on 10/31/25.
////
//
//import SwiftUI
//
//
//struct ContentView: View {
//    // Struct-wide variables
//    @State private var message = "ENDLING"
//    @State private var imageName = ""
//    @State private var lastImageNumber = -1
//    @State private var currentNumber: Int = Int.random(in: 1...6)
//    let range = 1...6
//    let numberOfOracles = 22
//    let numberOfWildCiv = 28
//
//    var body: some View {
//
//        ZStack {
//
//            Color.white.ignoresSafeArea()
//
//            VStack {
//                Button("ENDLING") {
//                    imageName = ""
//                }
//                .buttonStyle(.borderedProminent)
//                .buttonStyle(.glassProminent)
//                .foregroundStyle(.accent)
//                .tint(.white)
//                .font(.custom("ArchivoBlack-Regular", size: 50))
//
//                Button(action: {
//                            // 2. Action: Generate a new random number when the button is pressed
//                            currentNumber = Int.random(in: range)
//                        }) {
//                            // 3. Label: The content of the button (a Text view)
//                            Text("\(currentNumber)")
//                                .font(.custom("ArchivoBlack-Regular", size: 50))
//                                .foregroundColor(.white)
//                                .frame(maxWidth: 100, maxHeight: 100) // Make text fill available space
//                                .background(Color.accent) // Set a background color for visibility
//                        }
//                        // 4. Modifiers to make it square and visually appealing
//                        .aspectRatio(1.0, contentMode: .fit) // Enforce a 1:1 aspect ratio (square)
//                        .cornerRadius(10) // Optional: Add rounded corners
//
//
//
//
//
////                Button(action: {
////
////                }) {
////                    Image("hexflower") // Replace "YourImageName" with the actual name of your image asset
////                        .resizable() // Makes the image resizable
////                        .aspectRatio(contentMode: .fit) // Maintains aspect ratio when resizing
////                        .frame(width: 150, height: 150) // Sets a specific size for the image
////                }
//
//                Image(imageName)
//                    .resizable()
//                    .scaledToFit()
//                    .clipShape(RoundedRectangle(cornerRadius: 30))
//                    .shadow(radius: 30)
//
//
//
//                Spacer()
//
//                Button("Oracle") {
//                    var oracleNumber: Int
//                    repeat {
//                        oracleNumber = Int.random(in: 0...(numberOfOracles-1))
//                    } while oracleNumber == lastImageNumber
//                    imageName = "oracle\(oracleNumber)"
//                    lastImageNumber = oracleNumber
//
//                }
//                .buttonStyle(.borderedProminent)
//                .buttonStyle(.glassProminent)
//                .tint(.accentColor)
//                .font(.custom("ArchivoBlack-Regular", size: 20))
//
//                HStack {
//                    Button("Wilderness") {
//                        var wildernessNumber: Int
//                        repeat {
//                            wildernessNumber = Int.random(in: 0...(numberOfWildCiv-1))
//                        } while wildernessNumber == lastImageNumber
//                        imageName = "wilderness\(wildernessNumber)"
//                        lastImageNumber = wildernessNumber
//
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .buttonStyle(.glassProminent)
//                    .tint(.accentColor)
//                    .font(.custom("ArchivoBlack-Regular", size: 20))
//
//                    Button("Civilization") {
//                        var civilizationNumber: Int
//                        repeat {
//                            civilizationNumber = Int.random(in: 0...(numberOfWildCiv-1))
//                        } while civilizationNumber == lastImageNumber
//                        imageName = "civilization\(civilizationNumber)"
//                        lastImageNumber = civilizationNumber
//
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .buttonStyle(.glassProminent)
//                    .tint(.accentColor)
//                    .font(.custom("ArchivoBlack-Regular", size: 20))
//                }
//
//            }
//            .padding()
//        }
//    }
//}
//
//#Preview("Light Mode") {
//    ContentView()
//        .preferredColorScheme(.light)
//}
//
//#Preview("Dark Mode") {
//    ContentView()
//        .preferredColorScheme(.dark)
//}
