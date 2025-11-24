import SwiftUI
import MessageUI

struct FeedbackView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var feedbackType = 0
    @State private var message = ""
    @State private var showingMailView = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let feedbackTypes = ["Hata Bildirimi", "Öneri", "Diğer"]
    let recipientEmail = "mehmetdemirkok@gmail.com"
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Geri Bildirim & Destek")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(BusTheme.textPrimary)
                        
                        Text("Uygulama ile ilgili görüşlerinizi, önerilerinizi veya karşılaştığınız hataları bize bildirin.")
                            .font(.subheadline)
                            .foregroundColor(BusTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                    Form {
                        Section(header: Text("Bildirim Türü")) {
                            Picker("Tür Seçiniz", selection: $feedbackType) {
                                ForEach(0..<feedbackTypes.count, id: \.self) { index in
                                    Text(self.feedbackTypes[index])
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.vertical, 4)
                        }
                        
                        Section(header: Text("Mesajınız")) {
                            TextEditor(text: $message)
                                .frame(minHeight: 150)
                                .overlay(
                                    Group {
                                        if message.isEmpty {
                                            Text("Lütfen mesajınızı buraya yazın...")
                                                .foregroundColor(.gray)
                                                .padding(.horizontal, 4)
                                                .padding(.vertical, 8)
                                                .allowsHitTesting(false)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                        }
                                    }
                                )
                        }
                        
                        Section {
                            Button(action: {
                                sendEmail()
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Gönder")
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                            }
                            .foregroundColor(.white)
                            .listRowBackground(BusTheme.primaryBlue)
                        }
                    }
                    .background(Color.clear)
                }
            }
            .navigationBarTitle("Geri Bildirim", displayMode: .inline)
            .navigationBarItems(leading: Button("Kapat") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showingMailView) {
                MailView(result: $mailResult,
                         recipients: [recipientEmail],
                         subject: "MuavinBey - \(feedbackTypes[feedbackType])",
                         body: message)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Bilgi"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
            }
        }
    }
    
    func sendEmail() {
        if message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            alertMessage = "Lütfen bir mesaj yazınız."
            showAlert = true
            return
        }
        
        if MFMailComposeViewController.canSendMail() {
            showingMailView = true
        } else {
            // Fallback for devices/simulators without mail account
            if let url = createMailtoUrl() {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                    alertMessage = "Cihazınızda e-posta göndermek için kurulu bir uygulama bulunamadı."
                    showAlert = true
                }
            } else {
                alertMessage = "E-posta oluşturulamadı."
                showAlert = true
            }
        }
    }
    
    func createMailtoUrl() -> URL? {
        let subject = "MuavinBey - \(feedbackTypes[feedbackType])"
        let body = message
        
        // URL encoding
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString = "mailto:\(recipientEmail)?subject=\(subjectEncoded)&body=\(bodyEncoded)"
        return URL(string: urlString)
    }
}

#Preview {
    FeedbackView()
}
