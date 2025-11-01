//
//  ContentView.swift
//  Endling v1.5
//
//  Created by artsw0rd on 11/01/25.
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
    
    // Name generation
    @State private var showNameGeneration = false
    @State private var currentFirstName = ""
    @State private var currentLastName = ""
    
    // Manual stat editing
    @State private var showStatEditor = false
    @State private var editingStat: StatType? = nil
    @State private var editingStatValue = 0
    
    let range = 1...6
    let numberOfOracles = 22
    let numberOfWildCiv = 28
    
    // Names data
    let firstNames = [
        "Ash", "Ember", "Rust", "Cinder", "Shard", "Raven", "Storm", "Flint",
        "Grim", "Slate", "Dust", "Forge", "Iron", "Steel", "Thorn", "Wraith",
        "Shade", "Smoke", "Coal", "Blade", "Stone", "Sable", "Vex", "Zero",
        "Cipher", "Nox", "Void", "Dusk", "Echo", "Frost"
    ]
    
    let lastNames = [
        "Wasteson", "Ashborne", "Ruinwalker", "Deadwood", "Blackwater", "Ironheart",
        "Stormcrow", "Darkwind", "Bloodstone", "Nightfall", "Graveyard", "Steelhand",
        "Shadowmere", "Cinderfell", "Thornwood", "Barrens", "Dustwalker", "Emberfall",
        "Grimshaw", "Blightborn", "Scorchmoor", "Desolace", "Voidheart", "Ravencroft",
        "Frostbane", "Ashfeld", "Stonewall", "Blackthorn", "Ironside", "Deadmire"
    ]
    
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
                .foregroundStyle(.accent)
                .tint(.white)
                .font(.custom("ArchivoBlack-Regular", size: 50))
                
                HStack(spacing: 10) {
                    // 2d6 Dice#1
                    Button(action: {
                        rollSingleDie(diceNumber: 1)
                    }) {
                        Text("\(dice1Number)")
                            .font(.custom("ArchivoBlack-Regular", size: 50))
                            .foregroundColor(.white)
                            .frame(width: 70, height: 70)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(isRollingDice1 || isRollingDice2)
                    
                    Button(action: {
                        rollBothDice()
                    }) {
                        Image("hexflower")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(isRollingDice1 || isRollingDice2)
                    
                    // 2d6 Dice#2
                    Button(action: {
                        rollSingleDie(diceNumber: 2)
                    }) {
                        Text("\(dice2Number)")
                            .font(.custom("ArchivoBlack-Regular", size: 50))
                            .foregroundColor(.white)
                            .frame(width: 70, height: 70)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(isRollingDice1 || isRollingDice2)
                }
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .shadow(radius: 30)
                
                Spacer()
                
                HStack(spacing: 10) {
                    // Oracle Button
                    Button(action: {
                        var oracleNumber: Int
                        repeat {
                            oracleNumber = Int.random(in: 0...(numberOfOracles-1))
                        } while oracleNumber == lastImageNumber
                        imageName = "oracle\(oracleNumber)"
                        lastImageNumber = oracleNumber
                    }) {
                        Text("Oracle")
                            .font(.custom("ArchivoBlack-Regular", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Names Button
                    Button(action: {
                        generateName()
                    }) {
                        Text("Names")
                            .font(.custom("ArchivoBlack-Regular", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                HStack(spacing: 10) {
                    // Wilderness Button
                    Button(action: {
                        var wildernessNumber: Int
                        repeat {
                            wildernessNumber = Int.random(in: 0...(numberOfWildCiv-1))
                        } while wildernessNumber == lastImageNumber
                        imageName = "wilderness\(wildernessNumber)"
                        lastImageNumber = wildernessNumber
                    }) {
                        Text("Wilderness")
                            .font(.custom("ArchivoBlack-Regular", size: 15))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Civilization Button
                    Button(action: {
                        var civilizationNumber: Int
                        repeat {
                            civilizationNumber = Int.random(in: 0...(numberOfWildCiv-1))
                        } while civilizationNumber == lastImageNumber
                        imageName = "civilization\(civilizationNumber)"
                        lastImageNumber = civilizationNumber
                    }) {
                        Text("Civilization")
                            .font(.custom("ArchivoBlack-Regular", size: 15))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // STAT TRACKER
                HStack(spacing: 10) {
                    // Will Stat
                    StatBox(
                        statName: "Will",
                        statValue: willStat,
                        onRoll: {
                            rollStat(.will)
                        },
                        onIncrement: {
                            incrementStat(.will)
                        },
                        onLongPress: {
                            openStatEditor(.will)
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
                        },
                        onLongPress: {
                            openStatEditor(.food)
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
                        },
                        onLongPress: {
                            openStatEditor(.fuel)
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
                        },
                        onLongPress: {
                            openStatEditor(.gear)
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
            
            // Name Generation Overlay
            if showNameGeneration {
                NameGenerationOverlay(
                    firstName: $currentFirstName,
                    lastName: $currentLastName,
                    isShowing: $showNameGeneration
                )
            }
            
            // Stat Editor Overlay
            if showStatEditor, let stat = editingStat {
                StatEditorOverlay(
                    statName: statNameForType(stat),
                    statValue: $editingStatValue,
                    isShowing: $showStatEditor,
                    onSave: {
                        saveEditedStat(stat)
                    }
                )
            }
        }
    }
    
    // MARK: - Name Generation
    
    func generateName() {
        showNameGeneration = true
        
        var animationCount = 0
        let maxAnimations = 20
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            animationCount += 1
            
            currentFirstName = firstNames.randomElement() ?? "Unknown"
            currentLastName = lastNames.randomElement() ?? "Unknown"
            
            if animationCount >= maxAnimations {
                timer.invalidate()
                
                // Set final name
                currentFirstName = firstNames.randomElement() ?? "Unknown"
                currentLastName = lastNames.randomElement() ?? "Unknown"
                
                // Hide overlay after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    showNameGeneration = false
                }
            }
        }
    }
    
    // MARK: - Stat Editor Functions
    
    func openStatEditor(_ stat: StatType) {
        editingStat = stat
        editingStatValue = getStatValue(stat)
        showStatEditor = true
    }
    
    func saveEditedStat(_ stat: StatType) {
        switch stat {
        case .will:
            willStat = editingStatValue
        case .food:
            foodStat = editingStatValue
        case .fuel:
            fuelStat = editingStatValue
        case .gear:
            gearStat = editingStatValue
        }
        showStatEditor = false
    }
    
    func getStatValue(_ stat: StatType) -> Int {
        switch stat {
        case .will: return willStat
        case .food: return foodStat
        case .fuel: return fuelStat
        case .gear: return gearStat
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
    let onLongPress: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            // Stat value box - TAP to add +2, LONG PRESS to manually edit
            Button(action: onIncrement) {
                Text(statValue == 0 ? "DEP" : "\(statValue)")
                    .font(.custom("ArchivoBlack-Regular", size: 38))
                    .foregroundColor(.white)
                    .frame(width: 70, height: 70)
                    .background(Color.accentColor)
                    .cornerRadius(8)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
            .buttonStyle(PlainButtonStyle())
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.5)
                    .onEnded { _ in
                        onLongPress()
                    }
            )
            
            // Stat name button - ROLLS THE STAT
            Button(action: onRoll) {
                Text(statName.uppercased())
                    .font(.custom("ArchivoBlack-Regular", size: 14))
                    .foregroundColor(Color.accentColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 6)
                    .frame(minWidth: 60)
                    .background(Color.white)
                    .cornerRadius(5)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
            }
            .buttonStyle(PlainButtonStyle())
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
                    .background(Color.accentColor)
                    .cornerRadius(20)
                    .shadow(radius: 20)
            }
        }
    }
}

// MARK: - Name Generation Overlay

struct NameGenerationOverlay: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("YOUR NAME IS")
                    .font(.custom("ArchivoBlack-Regular", size: 24))
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    Text(firstName)
                        .font(.custom("ArchivoBlack-Regular", size: 32))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                    
                    Text(lastName)
                        .font(.custom("ArchivoBlack-Regular", size: 32))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                }
                .padding(30)
                .frame(width: 280, height: 200)
                .background(Color.accentColor)
                .cornerRadius(20)
                .shadow(radius: 20)
            }
        }
    }
}

// MARK: - Stat Editor Overlay

struct StatEditorOverlay: View {
    let statName: String
    @Binding var statValue: Int
    @Binding var isShowing: Bool
    let onSave: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("EDIT \(statName.uppercased())")
                    .font(.custom("ArchivoBlack-Regular", size: 24))
                    .foregroundColor(.white)
                
                HStack(spacing: 20) {
                    // Minus Button
                    Button(action: {
                        statValue = max(0, statValue - 1)
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(Color.accentColor)
                            .frame(width: 60, height: 60)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Stat Value Display
                    VStack(spacing: 15) {
                        Text(statValue == 0 ? "DEP" : "\(statValue)")
                            .font(.custom("ArchivoBlack-Regular", size: 60))
                            .foregroundColor(.white)
                            .frame(width: 120, height: 120)
                            .background(Color.accentColor)
                            .cornerRadius(15)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        
                        Text(statName.uppercased())
                            .font(.custom("ArchivoBlack-Regular", size: 20))
                            .foregroundColor(Color.accentColor)
                    }
                    
                    // Plus Button
                    Button(action: {
                        statValue = min(6, statValue + 1)
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(Color.accentColor)
                            .frame(width: 60, height: 60)
                            .background(Color.white)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Save Button
                Button(action: onSave) {
                    Text("SAVE")
                        .font(.custom("ArchivoBlack-Regular", size: 20))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
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
////  Endling v1.4
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
//    @State private var dice1Number: Int = Int.random(in: 1...6)
//    @State private var dice2Number: Int = Int.random(in: 1...6)
//    @State private var isRollingDice1 = false
//    @State private var isRollingDice2 = false
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
//                .foregroundStyle(.accent)
//                .tint(.white)
//                .font(.custom("ArchivoBlack-Regular", size: 50))
//                
//                HStack(spacing: 10) {
//                    // 2d6 Dice#1
//                    Button(action: {
//                        rollSingleDie(diceNumber: 1)
//                    }) {
//                        Text("\(dice1Number)")
//                            .font(.custom("ArchivoBlack-Regular", size: 50))
//                            .foregroundColor(.white)
//                            .frame(width: 70, height: 70)
//                            .background(Color.accent)
//                            .cornerRadius(8)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    .disabled(isRollingDice1 || isRollingDice2)
//                    
//                    Button(action: {
//                        rollBothDice()
//                    }) {
//                        Image("hexflower")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 100, height: 100)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    .disabled(isRollingDice1 || isRollingDice2)
//                    
//                    // 2d6 Dice#2
//                    Button(action: {
//                        rollSingleDie(diceNumber: 2)
//                    }) {
//                        Text("\(dice2Number)")
//                            .font(.custom("ArchivoBlack-Regular", size: 50))
//                            .foregroundColor(.white)
//                            .frame(width: 70, height: 70)
//                            .background(Color.accent)
//                            .cornerRadius(8)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    .disabled(isRollingDice1 || isRollingDice2)
//                }
//                
//                Image(imageName)
//                    .resizable()
//                    .scaledToFit()
//                    .clipShape(RoundedRectangle(cornerRadius: 30))
//                    .shadow(radius: 30)
//                
//                Spacer()
//                
//                Button(action: {
//                    var oracleNumber: Int
//                    repeat {
//                        oracleNumber = Int.random(in: 0...(numberOfOracles-1))
//                    } while oracleNumber == lastImageNumber
//                    imageName = "oracle\(oracleNumber)"
//                    lastImageNumber = oracleNumber
//                }) {
//                    Text("Oracle")
//                        .font(.custom("ArchivoBlack-Regular", size: 16))
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 10)
//                        .background(Color.accent)
//                        .cornerRadius(10)
//                }
//                .buttonStyle(PlainButtonStyle())
//                
//                HStack(spacing: 10) {
//                    Button(action: {
//                        var wildernessNumber: Int
//                        repeat {
//                            wildernessNumber = Int.random(in: 0...(numberOfWildCiv-1))
//                        } while wildernessNumber == lastImageNumber
//                        imageName = "wilderness\(wildernessNumber)"
//                        lastImageNumber = wildernessNumber
//                    }) {
//                        Text("Wilderness")
//                            .font(.custom("ArchivoBlack-Regular", size: 15))
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 12)
//                            .padding(.vertical, 10)
//                            .background(Color.accent)
//                            .cornerRadius(10)
//                            .minimumScaleFactor(0.8)
//                            .lineLimit(1)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    
//                    Button(action: {
//                        var civilizationNumber: Int
//                        repeat {
//                            civilizationNumber = Int.random(in: 0...(numberOfWildCiv-1))
//                        } while civilizationNumber == lastImageNumber
//                        imageName = "civilization\(civilizationNumber)"
//                        lastImageNumber = civilizationNumber
//                    }) {
//                        Text("Civilization")
//                            .font(.custom("ArchivoBlack-Regular", size: 15))
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 12)
//                            .padding(.vertical, 10)
//                            .background(Color.accent)
//                            .cornerRadius(10)
//                            .minimumScaleFactor(0.8)
//                            .lineLimit(1)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                }
//                
//                // STAT TRACKER
//                HStack(spacing: 10) {
//                    // Will Stat
//                    StatBox(
//                        statName: "Will",
//                        statValue: willStat,
//                        onRoll: {
//                            rollStat(.will)
//                        },
//                        onIncrement: {
//                            incrementStat(.will)
//                        }
//                    )
//                    
//                    // Food Stat
//                    StatBox(
//                        statName: "Food",
//                        statValue: foodStat,
//                        onRoll: {
//                            rollStat(.food)
//                        },
//                        onIncrement: {
//                            incrementStat(.food)
//                        }
//                    )
//                    
//                    // Fuel Stat
//                    StatBox(
//                        statName: "Fuel",
//                        statValue: fuelStat,
//                        onRoll: {
//                            rollStat(.fuel)
//                        },
//                        onIncrement: {
//                            incrementStat(.fuel)
//                        }
//                    )
//                    
//                    // Gear Stat
//                    StatBox(
//                        statName: "Gear",
//                        statValue: gearStat,
//                        onRoll: {
//                            rollStat(.gear)
//                        },
//                        onIncrement: {
//                            incrementStat(.gear)
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
//    // MARK: - Dice Rolling Functions
//    
//    func rollSingleDie(diceNumber: Int) {
//        if diceNumber == 1 {
//            isRollingDice1 = true
//            animateDiceRoll(diceNumber: 1)
//        } else {
//            isRollingDice2 = true
//            animateDiceRoll(diceNumber: 2)
//        }
//    }
//    
//    func rollBothDice() {
//        isRollingDice1 = true
//        isRollingDice2 = true
//        animateDiceRoll(diceNumber: 1)
//        animateDiceRoll(diceNumber: 2)
//    }
//    
//    func animateDiceRoll(diceNumber: Int) {
//        var animationCount = 0
//        let maxAnimations = 15
//        
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
//            animationCount += 1
//            
//            let randomValue = Int.random(in: 1...6)
//            if diceNumber == 1 {
//                dice1Number = randomValue
//            } else {
//                dice2Number = randomValue
//            }
//            
//            if animationCount >= maxAnimations {
//                timer.invalidate()
//                
//                // Set final value
//                let finalValue = Int.random(in: 1...6)
//                if diceNumber == 1 {
//                    dice1Number = finalValue
//                    isRollingDice1 = false
//                } else {
//                    dice2Number = finalValue
//                    isRollingDice2 = false
//                }
//            }
//        }
//    }
//    
//    // MARK: - Stat Increment Function
//    
//    func incrementStat(_ stat: StatType) {
//        switch stat {
//        case .will:
//            willStat = min(6, willStat + 2)
//        case .food:
//            foodStat = min(6, foodStat + 2)
//        case .fuel:
//            fuelStat = min(6, fuelStat + 2)
//        case .gear:
//            gearStat = min(6, gearStat + 2)
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
//                statToRoll = .will
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
//    let onIncrement: () -> Void
//    
//    var body: some View {
//        VStack(spacing: 8) {
//            // Stat value box - NOW CLICKABLE TO ADD +2
//            Button(action: onIncrement) {
//                Text(statValue == 0 ? "DEP" : "\(statValue)")
//                    .font(.custom("ArchivoBlack-Regular", size: 38))
//                    .foregroundColor(.white)
//                    .frame(width: 70, height: 70)
//                    .background(Color.accent)
//                    .cornerRadius(8)
//                    .minimumScaleFactor(0.5)
//                    .lineLimit(1)
//            }
//            .buttonStyle(PlainButtonStyle())
//            
//            // Stat name button - ROLLS THE STAT
//            Button(action: onRoll) {
//                Text(statName.uppercased())
//                    .font(.custom("ArchivoBlack-Regular", size: 14))
//                    .foregroundColor(Color.accent)
//                    .padding(.horizontal, 6)
//                    .padding(.vertical, 6)
//                    .frame(minWidth: 60)
//                    .background(Color.white)
//                    .cornerRadius(5)
//                    .minimumScaleFactor(0.8)
//                    .lineLimit(1)
//            }
//            .buttonStyle(PlainButtonStyle())
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
