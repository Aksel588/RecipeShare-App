import SwiftUI

struct TimePickerView: View {
    @Binding var cookingTime: String
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                // Time Display
                Text("\(hours)h \(minutes)m")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.orange)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(15)
                    .padding()
                
                // Time Pickers
                HStack(spacing: 20) {
                    // Hours
                    VStack {
                        Text("Hours")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Picker("Hours", selection: $hours) {
                            ForEach(0...12, id: \.self) { hour in
                                Text("\(hour)")
                                    .tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                    }
                    
                    // Minutes
                    VStack {
                        Text("Minutes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Picker("Minutes", selection: $minutes) {
                            ForEach(0...59, id: \.self) { minute in
                                Text("\(minute)")
                                    .tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 100)
                    }
                }
                .padding()
                
                // Quick Presets
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(["15m", "30m", "45m", "1h", "1h 30m", "2h"], id: \.self) { preset in
                            Button(action: {
                                setPresetTime(preset)
                            }) {
                                Text(preset)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Cooking Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        saveTime()
                    }
                }
            }
        }
    }
    
    private func setPresetTime(_ preset: String) {
        switch preset {
        case "15m":
            hours = 0; minutes = 15
        case "30m":
            hours = 0; minutes = 30
        case "45m":
            hours = 0; minutes = 45
        case "1h":
            hours = 1; minutes = 0
        case "1h 30m":
            hours = 1; minutes = 30
        case "2h":
            hours = 2; minutes = 0
        default:
            break
        }
    }
    
    private func saveTime() {
        if hours == 0 {
            cookingTime = "\(minutes) mins"
        } else if minutes == 0 {
            cookingTime = "\(hours) hour\(hours > 1 ? "s" : "")"
        } else {
            cookingTime = "\(hours)h \(minutes)m"
        }
        dismiss()
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    TimePickerView(cookingTime: .constant("30 mins"))
} 