# TestFlight Hazırlık Rehberi - MuavinBey

## ✅ Yapılan Ayarlar

1. **Uygulama Adı**: "MuavinBey" olarak ayarlandı
2. **Bundle Identifier**: `com.mehmet.MuavinBey`
3. **Version**: 1.0
4. **Build Number**: 1

## 📱 App Icon Ekleme

Uygulama ikonu için aşağıdaki adımları takip edin:

### 1. İkon Dosyası Hazırlama
- **Boyut**: 1024x1024 piksel
- **Format**: PNG (şeffaf arka plan olabilir)
- **Tasarım**: Otobüs temalı, modern ve profesyonel bir ikon

### 2. İkonu Xcode'a Ekleme

1. Xcode'da projeyi açın
2. Sol panelde `MuavinBey` > `Assets.xcassets` > `AppIcon` klasörüne gidin
3. 1024x1024 boyutundaki ikon dosyanızı sürükleyip bırakın
4. Aşağıdaki boyutlar için aynı ikonu kullanabilirsiniz (Xcode otomatik ölçeklendirir):
   - Universal: 1024x1024
   - Dark Mode: 1024x1024
   - Tinted: 1024x1024

### 3. İkon Tasarım Önerileri

- Otobüs silüeti veya ikonu
- Mavi/turuncu tema renkleri (BusTheme ile uyumlu)
- Basit ve tanınabilir
- Küçük boyutlarda da okunabilir olmalı

## 🚀 TestFlight'a Yükleme

### 1. Archive Oluşturma

1. Xcode'da **Product** > **Scheme** > **Any iOS Device** seçin
2. **Product** > **Archive** seçin
3. Archive tamamlandığında **Organizer** penceresi açılacak

### 2. TestFlight'a Yükleme

1. Organizer'da archive'ınızı seçin
2. **Distribute App** butonuna tıklayın
3. **App Store Connect** seçeneğini seçin
4. **Upload** seçeneğini seçin
5. **Automatically manage signing** seçeneğini işaretleyin
6. **Upload** butonuna tıklayın

### 3. App Store Connect'te TestFlight Ayarları

1. [App Store Connect](https://appstoreconnect.apple.com) sitesine giriş yapın
2. Uygulamanızı seçin (yoksa oluşturun)
3. **TestFlight** sekmesine gidin
4. Build'in işlenmesini bekleyin (10-30 dakika)
5. Build hazır olduğunda:
   - **Internal Testing** veya **External Testing** ekleyin
   - Test kullanıcılarını ekleyin
   - Test bilgilerini doldurun

### 4. Test Kullanıcıları Ekleme

1. **Users and Access** > **Testers** bölümüne gidin
2. Test kullanıcılarının Apple ID'lerini ekleyin
3. Test kullanıcılarına TestFlight uygulaması üzerinden davet gönderilecek

## 📋 Kontrol Listesi

- [ ] App Icon eklendi (1024x1024)
- [ ] Bundle Display Name "MuavinBey" olarak ayarlandı ✅
- [ ] Version ve Build Number ayarlandı ✅
- [ ] Archive oluşturuldu
- [ ] TestFlight'a yüklendi
- [ ] Test kullanıcıları eklendi
- [ ] Test bilgileri dolduruldu

## 🔧 Ek Ayarlar

### Version ve Build Number Güncelleme

Her yeni build için:
1. Xcode'da proje ayarlarına gidin
2. **General** sekmesinde:
   - **Version**: 1.0, 1.1, 1.2... (kullanıcıya görünen)
   - **Build**: 1, 2, 3... (her build için artırılmalı)

### Minimum iOS Version

Şu anda: **iOS 26.0** (Xcode 26.0.1 için)
- TestFlight için minimum iOS 15.0 önerilir
- Proje ayarlarından `IPHONEOS_DEPLOYMENT_TARGET` değerini değiştirebilirsiniz

## 📝 Notlar

- İlk TestFlight build'i genellikle 24-48 saat içinde onaylanır
- Sonraki build'ler daha hızlı onaylanır
- External testing için App Review gerekebilir
- Internal testing için review gerekmez

## 🎨 İkon Tasarım Kaynakları

İkon tasarlamak için şu araçları kullanabilirsiniz:
- **Figma** (ücretsiz, web tabanlı)
- **Sketch** (Mac için)
- **Adobe Illustrator** (profesyonel)
- **Canva** (hızlı ve kolay)

Veya bir tasarımcıdan yardım alabilirsiniz.

