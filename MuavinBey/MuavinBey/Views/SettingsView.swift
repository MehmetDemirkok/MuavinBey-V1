import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [BusTheme.backgroundLight, BusTheme.primaryBlue.opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // App Logo/Icon
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [BusTheme.primaryBlue, BusTheme.accentBlue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .shadow(color: BusTheme.primaryBlue.opacity(0.3), radius: 12, x: 0, y: 6)
                            
                            Image(systemName: "bus.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                        
                        Text("MuavinBey")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(BusTheme.textPrimary)
                        
                        Text("v1.0.0")
                            .font(.subheadline)
                            .foregroundColor(BusTheme.textSecondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(BusTheme.primaryBlue.opacity(0.1))
                            .cornerRadius(20)
                    }
                    .padding(.top, 40)
                    
                    // Info Cards
                    VStack(spacing: 16) {
                        SettingsCard(icon: "info.circle.fill", title: "Hakkında", content: "MuavinBey, otobüs seferlerinizi kolayca yönetmenizi sağlayan bir asistan uygulamasıdır.")
                        
                        SettingsCard(icon: "person.fill", title: "Geliştirici", content: "Mehmet Demirkök")
                        
                        SettingsCard(icon: "envelope.fill", title: "İletişim", content: "iletisim@muavinbey.com")
                    }
                    .padding()
                    
                    Spacer()
                    
                    Text("© 2025 MuavinBey")
                        .font(.caption)
                        .foregroundColor(BusTheme.textSecondary)
                        .padding(.bottom)
                }
            }
            .navigationTitle("Ayarlar")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsCard: View {
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(BusTheme.primaryBlue)
                .font(.title3)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(BusTheme.textPrimary)
                
                Text(content)
                    .font(.subheadline)
                    .foregroundColor(BusTheme.textSecondary)
            }
            
            Spacer()
        }
        .padding()
        .background(BusTheme.backgroundCard)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    SettingsView()
}
