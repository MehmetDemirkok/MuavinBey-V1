# MuavinBey - App Store Yayın Checklist

Bu checklist, uygulamanızı App Store'a yayınlamadan önce tamamlamanız gereken tüm adımları içerir.

## ✅ Proje Yapılandırması

### Xcode Proje Ayarları
- [x] Minimum iOS version: 15.0 (✅ Düzeltildi)
- [x] Bundle Identifier: com.mehmet.MuavinBey
- [x] Version: 1.0
- [x] Build: 1
- [x] Development Team: N3YV95WVGY
- [x] Code Signing: Automatic
- [x] Export Compliance: ITSAppUsesNonExemptEncryption = NO (✅ Eklendi)
- [x] Privacy Descriptions: NSUserTrackingUsageDescription (✅ Eklendi)

### Build Configuration
- [x] Release build optimizasyonları (✅ Eklendi)
- [x] Swift optimization level: -O (Release)
- [x] Swift compilation mode: wholemodule (Release)

## ✅ App Store Connect Hazırlığı

### 1. App Store Connect'te Uygulama Oluşturma
- [ ] App Store Connect'e giriş yapın (https://appstoreconnect.apple.com)
- [ ] "My Apps" > "+" > "New App" tıklayın
- [ ] Uygulama bilgilerini girin:
  - [ ] Name: MuavinBey
  - [ ] Primary Language: Turkish
  - [ ] Bundle ID: com.mehmet.MuavinBey
  - [ ] SKU: MuavinBey-001 (benzersiz bir değer)

### 2. Uygulama Bilgileri (App Information)
- [ ] Category: Productivity
- [ ] Subcategory: (Opsiyonel)
- [ ] Privacy Policy URL: [Privacy Policy URL'inizi ekleyin]

### 3. Fiyatlandırma ve Kullanılabilirlik (Pricing and Availability)
- [ ] Price: Free
- [ ] Availability: Tüm ülkeler veya seçili ülkeler

### 4. Uygulama Metadata (App Metadata)

#### Versiyon Bilgileri (Version Information)
- [ ] Version: 1.0
- [ ] Copyright: © 2025 [Adınız]
- [ ] What's New: [APP_STORE_METADATA.md dosyasındaki "Yeni Özellikler" bölümünü kullanın]

#### Açıklama (Description)
- [ ] Türkçe açıklama: [APP_STORE_METADATA.md dosyasından kopyalayın]
- [ ] İngilizce açıklama: [APP_STORE_METADATA.md dosyasından kopyalayın]

#### Promosyon Metni (Promotional Text)
- [ ] Türkçe: [APP_STORE_METADATA.md dosyasından kopyalayın]
- [ ] İngilizce: [APP_STORE_METADATA.md dosyasından kopyalayın]

#### Anahtar Kelimeler (Keywords)
- [ ] Keywords: otobüs, muavin, sefer, takip, yolcu, durak, koltuk (100 karakter limiti)

#### Destek URL (Support URL) - Opsiyonel ama Önerilen
- [ ] Support URL: [Destek sayfanızın URL'i veya mailto: e-posta adresiniz]
- **Not:** Zorunlu değildir, ancak önerilir. E-posta adresi yeterli: `mailto:destek@example.com`

#### Marketing URL (Opsiyonel)
- [ ] Marketing URL: [Web siteniz varsa]

### 5. Ekran Görüntüleri (Screenshots)

#### iPhone Ekran Görüntüleri
- [ ] 6.7" iPhone (iPhone 14 Pro Max, 15 Pro Max): En az 1, en fazla 10
- [ ] 6.5" iPhone (iPhone 11 Pro Max, XS Max): En az 1, en fazla 10
- [ ] 5.5" iPhone (iPhone 8 Plus): En az 1, en fazla 10

#### iPad Ekran Görüntüleri
- [ ] 12.9" iPad Pro: En az 1, en fazla 10
- [ ] 11" iPad Pro: En az 1, en fazla 10

**Önerilen Ekran Görüntüleri:**
1. Ana ekran (Sefer listesi)
2. Yeni sefer oluşturma ekranı
3. Koltuk yerleşim planı
4. Durak yönetimi
5. İstatistikler/Özet ekranı

### 6. App Icon
- [x] App Icon: Assets.xcassets içinde mevcut (✅ Kontrol edildi)
- [ ] 1024x1024 PNG formatında (App Store Connect için)

### 7. Gizlilik Uygulamaları (Privacy Practices)
- [x] Veri Toplama: Hayır (✅ Uygulama veri toplamıyor)
- [x] Veri Paylaşımı: Hayır (✅ Uygulama veri paylaşmıyor)
- [ ] App Store Connect'te "Data Not Collected" olarak işaretleyin

### 8. Yaş Sınırı (Age Rating)
- [ ] Yaş Sınırı: 4+ (Her yaş için uygun)
- [ ] App Store Connect'te yaş sınırı anketini doldurun

## ✅ Build ve Yükleme

### 1. Archive Oluşturma
- [ ] Xcode'da Product > Destination > Any iOS Device seçin
- [ ] Product > Archive tıklayın
- [ ] Archive başarıyla oluşturuldu mu kontrol edin

### 2. App Store Connect'e Yükleme
- [ ] Organizer penceresinde (Window > Organizer) archive'ı seçin
- [ ] "Distribute App" butonuna tıklayın
- [ ] "App Store Connect" seçeneğini seçin
- [ ] "Upload" seçeneğini seçin
- [ ] Distribution options'ı kontrol edin:
  - [ ] "Upload your app's symbols" (opsiyonel, crash raporları için)
  - [ ] "Manage Version and Build Number" (otomatik)
- [ ] "Upload" butonuna tıklayın
- [ ] Upload tamamlanana kadar bekleyin (birkaç dakika sürebilir)

### 3. Build Yükleme Sonrası
- [ ] App Store Connect'te "TestFlight" bölümüne gidin
- [ ] Build'in işlenmesini bekleyin (15-60 dakika)
- [ ] Build durumu "Ready to Submit" olana kadar bekleyin

## ✅ TestFlight (Opsiyonel ama Önerilen)

### 1. TestFlight Kurulumu
- [ ] App Store Connect > TestFlight bölümüne gidin
- [ ] Internal Testing grubu oluşturun
- [ ] Kendinizi test kullanıcısı olarak ekleyin
- [ ] Build'i test grubuna atayın
- [ ] TestFlight uygulamasından uygulamayı test edin

### 2. Beta Test
- [ ] Uygulamayı gerçek cihazlarda test edin
- [ ] Tüm özelliklerin çalıştığını doğrulayın
- [ ] Crash veya hata var mı kontrol edin

## ✅ Son Kontroller

### Kod Kontrolü
- [ ] Debug print'ler kaldırıldı mı? (Opsiyonel)
- [ ] Test kodları kaldırıldı mı?
- [ ] Tüm özellikler çalışıyor mu?
- [ ] Memory leak var mı kontrol edildi mi?

### UI/UX Kontrolü
- [ ] Tüm ekranlar doğru görünüyor mu?
- [ ] Dark Mode test edildi mi?
- [ ] Farklı ekran boyutlarında test edildi mi?
- [ ] iPad'de test edildi mi?

### Performans Kontrolü
- [ ] Uygulama hızlı açılıyor mu?
- [ ] Animasyonlar akıcı mı?
- [ ] Büyük veri setlerinde performans iyi mi?

## ✅ Gönderim (Submission)

### 1. App Store Connect'te Gönderim
- [ ] App Store Connect > App Store bölümüne gidin
- [ ] "1.0 Prepare for Submission" bölümüne gidin
- [ ] Tüm zorunlu alanların doldurulduğunu kontrol edin:
  - [ ] Screenshots
  - [ ] Description
  - [ ] Keywords
  - [ ] Support URL
  - [ ] Privacy Policy URL
  - [ ] Age Rating
  - [ ] Build seçildi mi?

### 2. İnceleme Notları (Review Notes)
- [ ] Review Notes bölümüne şunları ekleyin:
  ```
  Bu uygulama tamamen offline çalışır ve hiçbir veri toplamaz veya paylaşmaz.
  Tüm veriler kullanıcının cihazında lokal olarak saklanır.
  Test için özel bir hesap veya giriş gerektirmez.
  ```

### 3. Gönderim
- [ ] "Submit for Review" butonuna tıklayın
- [ ] Export Compliance sorularını yanıtlayın:
  - [ ] "Does your app use encryption?" → NO (✅ Zaten ayarlandı)
- [ ] "Submit" butonuna tıklayın

## ✅ İnceleme Sonrası

### 1. İnceleme Durumu Takibi
- [ ] App Store Connect'te "App Review" durumunu takip edin
- [ ] Durumlar:
  - Waiting for Review
  - In Review
  - Pending Developer Release
  - Ready for Sale
  - Rejected (eğer reddedilirse)

### 2. Reddedilme Durumunda
- [ ] Reddedilme nedenini okuyun
- [ ] Gerekli düzeltmeleri yapın
- [ ] Yeni build yükleyin
- [ ] Tekrar gönderin

### 3. Onaylandıktan Sonra
- [ ] Uygulama otomatik olarak yayınlanır (eğer "Automatic Release" seçildiyse)
- [ ] Veya manuel olarak "Release This Version" butonuna tıklayın
- [ ] App Store'da uygulamanızı kontrol edin

## 📝 Ek Notlar

### Önemli Hatırlatmalar
1. **Privacy Policy URL**: Privacy Policy'nizi bir web sitesinde yayınlamanız gerekiyor. GitHub Pages, Netlify, veya kendi web sitenizi kullanabilirsiniz.

2. **Support URL**: Zorunlu değildir, ancak önerilir. E-posta adresi (`mailto:`) formatında veya basit bir web sayfası yeterli. Boş bırakabilirsiniz, ancak Apple ek bilgi isteyebilir.

3. **Screenshots**: En az 1 ekran görüntüsü zorunludur. Daha fazla ekran görüntüsü daha iyi görünüm sağlar.

4. **Review Süresi**: İlk gönderimde inceleme süresi genellikle 24-48 saat arasındadır.

5. **Version Updates**: Gelecekte güncelleme yapmak için:
   - Version numarasını artırın (1.0 → 1.1)
   - Build numarasını artırın (1 → 2)
   - Yeni build yükleyin
   - "What's New" bölümünü güncelleyin

### Yardımcı Kaynaklar
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

---

**Son Güncelleme:** 17 Kasım 2025

**Hazırlayan:** [Adınız]

**Durum:** ✅ Proje yapılandırması tamamlandı, App Store Connect hazırlığı bekleniyor

