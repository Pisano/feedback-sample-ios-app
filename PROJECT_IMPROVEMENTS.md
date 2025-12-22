# Feedback Sample iOS App — Yapılanlar / Durum / Sonraki Adımlar

Bu doküman `Pisano/feedback-sample-ios-app` reposunda yapılan düzenlemeleri ve senin paylaştığın **Amaç/Kapsam / Yapılacaklar / Kabul Kriterleri** maddelerine göre durum özetini içerir.

> Not: Bu repo **SDK kaynak kodu değil**; iki ayrı **sample iOS app** içerir. SDK, SPM ile binary olarak çekilir.

---

## 1) Amaç / Kapsam (senin maddelerin)

**Hedef**: iOS sample uygulamada kodun sadeleştirilmesi, standartlara çekilmesi ve debug/izlenebilirlik için loglama eklenmesi.

Bu çalışma kapsamında ağırlıklı olarak:

- SDK entegrasyonunun güncellenmesi/sağlamlaştırılması (SPM, 1.0.16)
- Konfigürasyonun tek yerden ve güvenli şekilde yapılması (Info.plist)
- Dokümantasyonun güncellenmesi
- Build/test otomasyonu için basit smoke test hedefleri
- IDE/araç çıktılarının git’e girmemesi

Yani “log stratejisi + network edge-case handling + kapsamlı refactor” gibi başlıkların bir kısmı **tamamlanmadı** (aşağıdaki checklist’te açık).

---

## 2) Yapılacaklar Checklist (Durum)

### 2.1 Kod gözden geçirme, naming / folder structure iyileştirmeleri

- **[Kısmi]** Sample isimleri daha anlaşılır hale getirildi:
  - App display name’leri ayrıştırıldı: **`Pisano Feedback (Web)`** ve **`Pisano Feedback (Native)`**.
- **[Kısmi]** README’de “Web-Based vs Native” ayrımı netleştirildi:
  - SDK **1.0.16’da tek product/modül** olduğu ve “ayrımın kullanım stilini” anlattığı not edildi.
- **[Yapılmadı]** Root folder yapısını (örn. `Samples/Web`, `Samples/Native`) yeniden düzenleme:
  - Bu değişiklik “yapıyı bozma” riski taşıdığı için yapılmadı.

### 2.2 Refactor: tekrar eden parçaların ayrıştırılması, daha okunabilir akış

- **[Kısmi/Tamam]** Konfigürasyon okuma tekrarları azaltıldı:
  - Her iki sample’da `Info.plist` üzerinden okuyan `PisanoSDKConfig` helper’ı eklendi.
- **[Kısmi]** Boot/init akışı standardize edildi:
  - “Boş string ile init” gibi durumlar temizlendi.
- **[Yapılmadı]** UI/VM/component tarafında büyük ölçekli refactor:
  - Örn. iki sample’ın ortak view/component’lerini tek package/module’a ayırma vb. yapılmadı.

### 2.3 Gereksiz bağımlılık/dosya temizliği

- **[Kısmi]** Build’i kıran eksik `GoogleService-Info.plist` için placeholder eklendi.
  - Firebase kullanılmıyorsa bu dosyalar kullanılmayabilir; ama Xcode projede kaynak olarak bekleniyordu.
- **[Yapılmadı]** Repo genelinde “dependency audit” / gereksiz dosya kaldırma:
  - Örn. Firebase entegrasyonu gereksizse Xcode projeden tamamen çıkarmak gibi bir temizlik yapılmadı.

### 2.4 Network error handling ve edge-case’lerin düzenlenmesi

- **[Kısmi]** Konfig eksikliği için guard + uyarı mesajı eklendi (ör. config missing).
- **[Yapılmadı]** UI seviyesinde kapsamlı error handling:
  - init başarısız, healthCheck fail, network fail, invalid credentials vb. için kullanıcıya gösterim/handling genişletilmedi.
  - SDK binary olduğu için network katmanının tamamı değiştirilemez; ancak sample UI’da durum gösterilebilir.

### 2.5 Loglama (init, auth/config load, survey load, submit, fail case’leri)

- **[Kısmi]** “Config missing” gibi kritik yerde log/print var.
- **[Yapılmadı]** Standart bir log altyapısı (`os.Logger`/`OSLog`) ve event bazlı log noktaları:
  - init/boot result, show çağrısı, healthCheck sonucu, submit callback, error mapping vb.
  - Hassas veriler (accessKey, appId vb.) loglanmayacak şekilde maskeleme politikası.

### 2.6 README + build/run dokümantasyonu güncelleme

- **[Tamam]** README ve ilgili md’ler güncellendi:
  - SPM + CocoaPods örnekleri **1.0.16**.
  - “Bu repo sample; Podfile yok” açıklaması.
  - API reference genişletme (CloseStatus, eventUrl, track/clear notları vb.).

### 2.7 Basit smoke test checklist

- **[Tamam]** XCTest smoke test target’ları eklendi (Native + Web):
  - `xcodebuild test` çalışır.
  - Credentials yoksa test **skip** olur (CI’da kırmaz).
  - Credentials girilirse **boot + healthCheck** ile API erişimi doğrulanır.
- **[İsteğe bağlı]** README’ye manuel smoke checklist maddeleri ayrıca eklenebilir.

---

## 3) Kabul Kriterleri (Durum)

### 3.1 Uygulama derlenir, çalışır, temel akış sorunsuz tamamlanır

- **Derleme**: ✅ Native + Web projeleri `xcodebuild build` ile derleniyor.
- **Test**: ✅ Native + Web `xcodebuild test` **başarılı** (credentials yoksa skip, varsa API doğrulama).
- **Temel akış**: “show/survey submit” uçtan uca akış için manuel test gerekiyor (flow/backend konfigürasyonuna bağlı).

### 3.2 Kod okunabilirliği belirgin artmış, tekrarlı parçalar azaltılmış

- **Kısmi**: Konfig/boot tarafı sadeleşti.
- **Eksik**: UI/VM tarafında büyük refactor yapılmadı.

### 3.3 Kritik noktalarda loglar var ve hassas veri loglanmıyor

- **Kısmi**: Hassas veriler repoya/teste gömülmedi, loglanmıyor.
- **Eksik**: Kapsamlı log stratejisi (boot/show/survey lifecycle) eklenmedi.

### 3.4 README güncel

- ✅ Güncel.

---

## 4) Entegrasyon Gerçekliği: “Web” vs “Native” ne?

Bu repo iki sample app içerir:

- `iOS SDK Web-Based/pisano-feedback.xcodeproj`
- `iOS SDK Native/pisano-feedback.xcodeproj`

SDK **1.0.16**’da SPM paketi tek product sağlar:

- **Product/Module**: `PisanoFeedback`

Dolayısıyla iki sample da `import PisanoFeedback` ile çalışır. Ayrım “farklı paket” değil, **farklı kullanım senaryosu** olarak konumlanır.

---

## 5) Konfigürasyon (Secrets yok, müşteriye örnek var)

Her iki sample’da SDK ayarları `Info.plist` key’leri ile yapılır:

- `PISANO_APP_ID`
- `PISANO_ACCESS_KEY`
- `PISANO_API_URL`
- `PISANO_FEEDBACK_URL`
- `PISANO_EVENT_URL` (opsiyonel, boş bırakılabilir)

> Bu repo’da bu key’ler **boş** bırakılabilir; gerçek değerler git’e girmez.

---

## 6) Build / Test (Komutlar)

### 6.1 Web-Based build

```bash
xcodebuild -project "iOS SDK Web-Based/pisano-feedback.xcodeproj" \
  -scheme "pisano-feedback" \
  -configuration Debug \
  -destination "platform=iOS Simulator,name=iPhone 16 Pro" \
  build
```

### 6.2 Native build

```bash
xcodebuild -project "iOS SDK Native/pisano-feedback.xcodeproj" \
  -scheme "pisano-feedback" \
  -configuration Debug \
  -destination "platform=iOS Simulator,name=iPhone 16 Pro" \
  build
```

### 6.3 Test (her iki proje için)

```bash
xcodebuild -project "iOS SDK Web-Based/pisano-feedback.xcodeproj" \
  -scheme "pisano-feedback" \
  -configuration Debug \
  -destination "platform=iOS Simulator,name=iPhone 16 Pro" \
  test

xcodebuild -project "iOS SDK Native/pisano-feedback.xcodeproj" \
  -scheme "pisano-feedback" \
  -configuration Debug \
  -destination "platform=iOS Simulator,name=iPhone 16 Pro" \
  test
```

> Credentials `Info.plist`’te yoksa smoke test **skip** olur (başarısız sayılmaz).

---

## 7) Güvenlik / Git Hijyeni

- `.gitignore` güncellendi:
  - IDE/araç çıktıları git’e girmez.
- Test dosyalarında **hardcoded credential yok**.

---

## 8) “Yapıyı bozmadan” önerilen sonraki adımlar

Bu adımlar repo yapısını bozmadan (path/target isimleriyle oynamadan) yapılabilir:

1. **Logger altyapısı**: `os.Logger` tabanlı tek bir `Logger+Pisano.swift` veya `AppLogger.swift`
   - boot/show/healthCheck sonuçları (hassas veri maskeleme)
2. **UI error handling**:
   - initFailed/healthCheckFailed durumlarını kullanıcıya minimal banner/label ile gösterme
3. **Manual smoke checklist**:
   - README’ye “1) Info.plist doldur 2) boot ok 3) show 4) closeStatus 5) submit” gibi kısa checklist
4. **Dependency clean** (opsiyonel):
   - Firebase kullanılmıyorsa GoogleService referanslarını projeden kaldırmak (placeholder yerine)


