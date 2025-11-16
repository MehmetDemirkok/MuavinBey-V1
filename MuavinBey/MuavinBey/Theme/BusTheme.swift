import SwiftUI

// MARK: - Bus Theme Colors
struct BusTheme {
    // Primary Colors - Otobüs mavisi ve turuncu
    static let primaryBlue = Color(red: 0.0, green: 0.4, blue: 0.8) // Koyu mavi
    static let primaryOrange = Color(red: 1.0, green: 0.5, blue: 0.0) // Turuncu
    static let accentBlue = Color(red: 0.2, green: 0.6, blue: 1.0) // Açık mavi
    static let accentOrange = Color(red: 1.0, green: 0.7, blue: 0.3) // Açık turuncu
    
    // Background Colors
    static let backgroundLight = Color(red: 0.98, green: 0.98, blue: 0.99)
    static let backgroundCard = Color.white
    static let backgroundDark = Color(red: 0.1, green: 0.1, blue: 0.15)
    
    // Text Colors
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let textOnPrimary = Color.white
    
    // Status Colors
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let errorRed = Color(red: 0.9, green: 0.2, blue: 0.2)
    
    // Seat Colors
    static let seatOccupied = primaryBlue
    static let seatEmpty = Color.gray.opacity(0.2)
    static let seatSelected = accentOrange
}

// MARK: - Custom Button Styles
struct BusPrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Group {
                    if isEnabled {
                        LinearGradient(
                            colors: [BusTheme.primaryBlue, BusTheme.accentBlue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        LinearGradient(
                            colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    }
                }
            )
            .cornerRadius(12)
            .shadow(color: isEnabled ? BusTheme.primaryBlue.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed && isEnabled ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct BusSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(BusTheme.primaryBlue)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                BusTheme.primaryBlue.opacity(0.1)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(BusTheme.primaryBlue, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Card Style
struct BusCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(BusTheme.backgroundCard)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

extension View {
    func busCard() -> some View {
        modifier(BusCard())
    }
}

// MARK: - Section Header Style
struct BusSectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(BusTheme.primaryBlue)
                .font(.system(size: 16, weight: .semibold))
            Text(title)
                .font(.headline)
                .foregroundColor(BusTheme.primaryBlue)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Seat Badge Style
struct SeatBadge: View {
    let number: Int
    let isOccupied: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    isOccupied ?
                    LinearGradient(
                        colors: [BusTheme.seatOccupied, BusTheme.accentBlue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) :
                    LinearGradient(
                        colors: [BusTheme.seatEmpty, BusTheme.seatEmpty],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 50, height: 50)
            
            Text("\(number)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(isOccupied ? .white : BusTheme.textPrimary)
        }
        .shadow(color: isOccupied ? BusTheme.primaryBlue.opacity(0.3) : Color.clear, radius: 4, x: 0, y: 2)
    }
}

// MARK: - Stop Badge Style
struct StopBadge: View {
    let name: String
    let passengerCount: Int?
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(BusTheme.primaryOrange)
                .font(.system(size: 20))
            
            Text(name)
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
            
            if let count = passengerCount, count > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.caption)
                    Text("\(count)")
                        .font(.headline)
                }
                .foregroundColor(BusTheme.primaryBlue)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(BusTheme.primaryBlue.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [BusTheme.backgroundCard, BusTheme.primaryBlue.opacity(0.05)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(BusTheme.primaryBlue.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Info Card Style
struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.2), color.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 22, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(BusTheme.textSecondary)
                Text(value)
                    .font(.headline)
                    .foregroundColor(BusTheme.textPrimary)
            }
            
            Spacer()
        }
        .padding()
        .background(BusTheme.backgroundCard)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

