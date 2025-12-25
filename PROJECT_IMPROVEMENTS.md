# Feedback Sample iOS App — Improvements / Yapılanlar (Müşteri Raporu)

Bu doküman, `Pisano/feedback-sample-ios-app` reposunda yapılan düzenlemeleri ve nedenlerini (eski yapı → yeni yapı) müşteri paylaşımına uygun şekilde özetler.

> Not: Bu repo **SDK kaynak kodu değildir**. Repo, Pisano Feedback iOS SDK’nın nasıl entegre edilip kullanılacağını gösteren **sample iOS uygulamaları** içerir.

---

## Kısa Özet (Ne değişti?)

- Eskiden repo içinde **“Native” örnek** vardı çünkü geçmişte SDK tarafında “native UI” olarak konumlanan bir kullanım tarzı vardı.
- Zaman içinde SDK tarafı **tek modül/product** altında toplandı (**`PisanoFeedback`**) ve widget arayüzü pratikte **web tabanlı** çalıştığı için “Native vs Web-Based” ayrımı sample repo tarafında **anlamsız/tekrarlı** hale geldi.
- Bu yüzden **Native örnek tamamen kaldırıldı**.
- Repo artık iki modern sample app içeriyor:
  - **SwiftUI sample** (SwiftUI ile örnek UI akışı)
  - **UIKit sample** (tamamen UIKit ile aynı akış)

---

## Repo’nun Son Hali (Yeni yapı)

Repo iki sample uygulama içerir (aynı SDK, farklı UI framework):

- **SwiftUI sample**: `pisano-ios-sdk-sample-app/pisano-ios-sdk-sample-app.xcodeproj`
- **UIKit (Swift) sample**: `pisano-ios-sdk-sample-app-uikit/pisano-ios-sdk-sample-app.xcodeproj`

Her iki uygulama da:

- SDK’yı **SPM ile** alır
- **`import PisanoFeedback`** ile entegre olur
- Uygulama açılışında **`Pisano.boot(...)`** yapar
- Kullanıcı aksiyonuyla **`Pisano.show(...)`** çağırır

---

## Neleri Kaldırdık?

- **Native sample proje** kaldırıldı (tekrarlı/yanıltıcı ayrım oluşturduğu için).
- Dokümanlarda kalan eski referanslar temizlendi:
  - Eski product/import isimleri (`Feedback` gibi) → **`PisanoFeedback`**
- Repo’dan **hardcoded credential / API key** çıkarıldı.

---

## Neler Ekledik?

### UIKit sample (yeni)

- SwiftUI örneğiyle aynı UI/flow’u takip eden **UIKit tabanlı** örnek uygulama eklendi.
- Akış iki ekranlı:
  - **Welcome** → **Form**
- UIKit’te klavye deneyimi iyileştirildi:
  - scroll ile kapatma
  - tap ile kapatma
  - return ile next/close
  - phonePad için toolbar “Done”

### Secrets yönetimi (local-only)

- Her iki sample için `PisanoSecrets.example.plist` eklendi.
- Local geliştirmede:
  - `PisanoSecrets.example.plist` → `PisanoSecrets.plist` kopyalanır
  - `PISANO_APP_ID`, `PISANO_ACCESS_KEY`, `PISANO_API_URL`, `PISANO_FEEDBACK_URL` (opsiyonel: `PISANO_EVENT_URL`) doldurulur
- `PisanoSecrets.plist` **gitignore**’dadır (repo’ya girmez).

### Smoke test

- Her iki sample’da `AppTests/PisanoSmokeTests.swift` eklendi.
- Credentials yoksa test **skip** olur (CI kırmaması için).
- Credentials varsa **boot + healthCheck** ile API erişimi doğrulanır.

---

## Neleri Geliştirdik?

### Dokümantasyon

- `README.md` kapsamlı hale getirildi:
  - iki sample path’i
  - kurulum (SPM/CocoaPods, **1.0.16**)
  - secrets akışı
  - SDK kullanımı (Swift + Objective‑C örnekleri)
  - build/run + test komutları
  - troubleshooting

### Konfig / entegrasyon standardı

- SDK module/product: **`PisanoFeedback`**
- SDK versiyonu: **1.0.16**
- Konfig okuma tekilleştirildi: `PisanoSDKConfig` (bundle secrets → Info.plist fallback)

### Logging / izlenebilirlik

- Kritik noktalara `OSLog` eklendi:
  - app launch + config durumu (eksik key listesi)
  - `Pisano.boot` sonucu
  - `Pisano.healthCheck` sonucu
  - `Pisano.show` çağrısı + callback status
  - `Pisano.clear`
- Hassas veri (appId/accessKey) **loglanmıyor**.

### Network / edge-case handling

- Show öncesi **healthCheck preflight** eklendi:
  - SwiftUI: ekranda status (“HealthCheck ok/failed”)
  - UIKit: fail durumunda status + alert
- Config eksikliği durumda crash yok; kullanıcıya yönlendirme var.

---

## Yapılacaklar (Checklist)

### Kod gözden geçirme, naming / folder structure iyileştirmeleri — ✅

- Repo iki sample app olarak netleştirildi (SwiftUI + UIKit).

### Refactor: tekrar eden parçaların ayrıştırılması, daha okunabilir akış — ⚠️ (kısmi)

- Konfig okuma ve SDK çağrıları tekilleştirildi.
- Kapsamlı “folder restructure / ortak module çıkarma” yapılmadı (sample repo yapısını bozma riski).

### Gereksiz bağımlılık/dosya temizliği — ✅

- Gereksiz kalıntılar temizlendi, gitignore sıkılaştırıldı.

### Network error handling ve edge-case’lerin düzenlenmesi — ✅

- healthCheck preflight + kullanıcıya status/alert.

### Loglama: init, authentication/konfig yükleme, survey load, submit, fail case’leri — ✅

- OSLog ile boot/show/healthCheck/callback/clear logları eklendi.
- Hassas veri loglanmıyor.

### README + build/run dokümantasyonu güncelleme — ✅

- README güncel ve tek kaynak.

### Basit smoke test checklist — ✅

- Smoke testler eklendi ve README’ye test komutları yazıldı.

---

## Kabul Kriterleri

### Uygulama derlenir, çalışır, temel akış sorunsuz tamamlanır — ✅

- SwiftUI + UIKit projeleri `xcodebuild build` ile doğrulandı.

### Kod okunabilirliği belirgin artmış, tekrarlı parçalar azaltılmış — ✅ (targeted)

- Entegrasyon/config/logging/docs tarafında net sadeleşme.

### Kritik noktalarda loglar var ve hassas veri loglanmıyor — ✅

- OSLog var; secret değerleri loglanmıyor.

### README güncel — ✅

- Kurulum + kullanım + test + troubleshooting içeriyor.

---

## Kanıt / İlgili dosyalar (yüksek seviye)

- **Docs**: `README.md`, `PROJECT_IMPROVEMENTS.md`
- **Config**: `*/App/Shared/PisanoSDKConfig.swift`
- **Boot logging**: `*/App/Shared/feedbackApp.swift`
- **Show/healthCheck logging**: `*/App/Shared/FeedbackManager.swift`
- **Edge-case UI**:
  - SwiftUI: `pisano-ios-sdk-sample-app/App/Screens/FormViewModel.swift`, `FormView.swift`
  - UIKit: `pisano-ios-sdk-sample-app-uikit/App/Screens/FormViewController.swift`
- **Smoke tests**: `*/AppTests/PisanoSmokeTests.swift`
