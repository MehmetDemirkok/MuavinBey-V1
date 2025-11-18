# Muavin Bey - Otobüs Muavini Sefer Takip Uygulaması

iOS SwiftUI ile geliştirilmiş offline sefer takip uygulaması.

## 🚀 Hızlı Başlangıç

### Xcode'da Proje Oluşturma

1. **Xcode'u açın** ve `File > New > Project` seçin
2. **iOS** sekmesinden **App** seçin ve **Next**'e basın
3. Proje bilgilerini girin:
   - Product Name: `MuavinBey`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Minimum iOS: **15.0**
4. Projeyi kaydedin ve **Create**'e basın

### Dosyaları Ekleme

1. Xcode'da proje klasörüne sağ tıklayın ve **Add Files to "MuavinBey"...** seçin
2. Bu klasördeki tüm dosyaları seçin:
   - `Models/` klasörü
   - `Storage/` klasörü
   - `ViewModels/` klasörü
   - `Views/` klasörü
   - `MuavinApp.swift`
3. **"Copy items if needed"** seçeneğini işaretleyin
4. **Add**'e basın

### Ana Dosyayı Değiştirme

1. Xcode'da varsayılan `MuavinBeyApp.swift` dosyasını silin veya içeriğini değiştirin
2. `MuavinApp.swift` dosyasını açın ve içeriğinin doğru olduğundan emin olun

### Çalıştırma

1. Simulator seçin (iPhone 15 Pro önerilir)
2. **⌘ + R** tuşlarına basın veya **Run** butonuna tıklayın

## 📱 Kullanım

1. **Yeni Sefer** sekmesinde:
   - Araç tipi seçin (Otobüs, Midibüs, Minibüs)
   - Koltuk düzeni seçin (2+1 veya 2+2)
   - Koltuk sayısını girin
   - Güzergah başlangıç ve bitiş noktalarını girin
   - **Sefer Oluştur** butonuna basın

2. **Duraklar** sekmesinde:
   - Durak ekleyin
   - Durakları sıralayın veya silin

3. **Koltuklar** sekmesinde:
   - Her koltuk için iniş durağı seçin
   - Dolu/Boş durumunu toggle ile değiştirin

4. **Özet** sekmesinde:
   - Toplam yolcu sayısını görün
   - Durak bazında iniş istatistiklerini görün

## 🏗️ Proje Yapısı

```
MuavinBey/
├── Models/
│   ├── Trip.swift          # Sefer modeli
│   ├── Stop.swift          # Durak modeli
│   └── Seat.swift          # Koltuk modeli
├── Storage/
│   └── TripsStorage.swift  # Lokal veri saklama
├── ViewModels/
│   └── TripViewModel.swift # MVVM ViewModel
├── Views/
│   ├── StartView.swift              # Giriş ekranı
│   ├── StopManagementView.swift     # Durak yönetimi
│   ├── SeatAssignmentView.swift     # Koltuk yönetimi
│   └── TripSummaryView.swift        # Özet ekranı
└── MuavinApp.swift          # Ana uygulama
```

## ✨ Özellikler

- ✅ Offline çalışma (UserDefaults ile lokal saklama)
- ✅ MVVM mimarisi
- ✅ Dark Mode desteği
- ✅ iOS 15+ uyumlu
- ✅ Büyük butonlu, kullanıcı dostu arayüz
- ✅ Durak sıralama ve silme
- ✅ Koltuk bazında yolcu takibi
- ✅ Durak bazında istatistikler

## 🔧 Teknik Detaylar

- **Framework**: SwiftUI
- **Mimari**: MVVM
- **Veri Saklama**: UserDefaults ve FileManager
- **Minimum iOS**: 15.0
- **Dil**: Swift 5.0+
- **App Store**: Yayına hazır ✅

## 📦 App Store Yayını

Bu proje App Store'a yayın için hazırlanmıştır. Yayın süreci için aşağıdaki dosyalara bakın:

- **[APP_STORE_CHECKLIST.md](APP_STORE_CHECKLIST.md)** - Detaylı yayın checklist'i
- **[APP_STORE_METADATA.md](APP_STORE_METADATA.md)** - App Store metadata ve açıklamalar
- **[PRIVACY_POLICY.md](PRIVACY_POLICY.md)** - Gizlilik politikası

### Yapılan Hazırlıklar

✅ Minimum iOS version: 15.0 (daha geniş cihaz desteği)  
✅ Privacy descriptions eklendi  
✅ Export Compliance ayarları yapıldı  
✅ Release build optimizasyonları eklendi  
✅ App Store metadata hazırlandı  
✅ Privacy Policy oluşturuldu  
✅ Yayın checklist'i hazırlandı  

### Yayın Öncesi Kontrol Listesi

1. [ ] App Store Connect'te uygulama oluşturuldu
2. [ ] Ekran görüntüleri hazırlandı
3. [ ] Privacy Policy web'de yayınlandı
4. [ ] Support URL hazırlandı (Opsiyonel - e-posta adresi yeterli)
5. [ ] TestFlight ile test edildi
6. [ ] Archive oluşturuldu ve yüklendi
7. [ ] App Store incelemesi için gönderildi

