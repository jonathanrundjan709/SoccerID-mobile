# SoccerID - Mobile

## Tugas 7

###  Pengertian Widget Tree dan Hubungan Parent-Child Antar Widget

**Widget tree** adalah struktur hierarki yang menggambarkan bagaimana widget saling tersusun dalam aplikasi Flutter. Dalam hal ini, widget tree disusun secara bertingkat seperti pohon.

#### Hubungan Parent-Child
- Widget **parent** (induk) mengatur/membungkus widget **child** (anak)
- Parent menentukan bagaimana posisi dan child ditampilkan
- Child dapat menggunakan properti dari parent, namun tidak dapat mengubah struktur parent

---

###  Widget yang Digunakan dalam Proyek dan Fungsinya

| Widget | Fungsi |
|--------|--------|
| `MaterialApp` | Root aplikasi Flutter dengan konfigurasi tema, navigasi, dan struktur Material Design |
| `Scaffold` | Kerangka dasar halaman (app bar, body, floating button, drawer, dll) |
| `AppBar` | Bagian atas halaman berisi judul |
| `Text` | Menampilkan teks |
| `Icon` | Menampilkan ikon |
| `Card` | Membuat tampilan kotak berisi informasi |
| `Container` | Wadah serbaguna untuk padding, margin, size, dan decoration |
| `Column` | Menyusun widget secara vertikal |
| `Row` | Menyusun widget secara horizontal |
| `GridView.count` | Menampilkan item dalam bentuk grid dengan jumlah kolom tertentu |
| `InkWell` | Memberi efek tap/klik dengan animasi ripple |
| `Material` | Memberi styling berbasis Material Design (warna, elevasi) |
| `Padding` / `SizedBox` | Memberikan jarak antar widget |
| `SnackBar` | Menampilkan notifikasi singkat di bagian bawah layar |
| `ScaffoldMessenger` | Mengontrol tampilan SnackBar |

---

###  Fungsi MaterialApp, Mengapa Sering Digunakan untuk Widget Root?

`MaterialApp` adalah widget utama untuk aplikasi Flutter berbasis Material Design. Fungsinya antara lain:

- Mengatur theme dan color scheme
- Menentukan halaman awal (`home`)
- Mengatur navigasi antar halaman
- Mengaktifkan font, warna, dan behavior Material Design

Widget ini sering dipakai sebagai root karena memberikan struktur dasar dan fitur global yang dibutuhkan aplikasi modern di Flutter.

---

###  StatelessWidget vs StatefulWidget: Kapan Menggunakannya?

| StatelessWidget | StatefulWidget |
|-----------------|----------------|
| Tidak memiliki state (data tidak berubah) | Memiliki state (data bisa berubah) |
| UI tetap sama sepanjang lifecycle | UI dapat berubah seiring perubahan data |
| Cocok untuk tampilan statis, label, ikon, halaman statis | Cocok untuk input user, counter, form, animasi, data dinamis |

#### Contoh Penggunaan:
- **StatelessWidget**: tampilan informasi profil, judul halaman
- **StatefulWidget**: form input, tombol counter, daftar produk real-time

---

###  Pentingnya BuildContext dan Penggunaannya dalam Metode Build

`BuildContext` adalah objek yang menyimpan informasi posisi widget dalam widget tree dan memberikan akses ke parent widget serta resource aplikasi (theme, navigator, scaffold, dll).

#### Penting karena:
- Dipakai untuk mencari parent widget dalam tree
- Digunakan untuk menampilkan `SnackBar`, navigasi halaman, mengambil tema, dll

---

###  Konsep "Hot Reload" dan Perbedaannya dengan "Hot Restart"

| Hot Reload | Hot Restart |
|------------|-------------|
| Memasukkan perubahan kode ke app yang sedang berjalan | Restart aplikasi dari awal |
| State aplikasi **tetap tersimpan** | State aplikasi **reset** ke awal |
| Cepat, cocok saat desain UI | Lebih lambat, digunakan jika perubahan fundamental |

---
## Tugas 8

### Navigator.push() vs Navigator.pushReplacement()
- `Navigator.push()` menambahkan route baru ke atas stack sehingga pengguna masih bisa kembali dengan tombol Back. Saya memakainya ketika tombol **Tambah Produk** ditekan (via `ItemCard`) agar setelah mengisi formulir pengguna bisa kembali ke beranda dengan gesture Back.
- `Navigator.pushReplacement()` mengganti route teratas, sehingga halaman sebelumnya tidak bisa kembali otomatis. Pola ini saya gunakan pada `LeftDrawer` ketika berpindah antar menu agar drawer navigation terasa seperti memilih tab (route lama diganti dengan route baru supaya stack tidak menumpuk).

### Memanfaatkan Scaffold, AppBar, dan Drawer
- `Scaffold` menjadi rangka utama di seluruh halaman (`MyHomePage` dan `NewsFormPage`) sehingga AppBar, body, serta Drawer selalu berada di posisi yang sama.
- `AppBar` menampilkan identitas “Football Shop” lengkap dengan warna tema yang konsisten, membantu user mengenali konteks halaman apa pun.
- `Drawer` dipisahkan ke widget `LeftDrawer`, lalu disematkan ke semua `Scaffold` sehingga opsi navigasi (Halaman Utama & Tambah Produk) selalu tersedia tanpa duplikasi kode.

### Manfaat Padding, SingleChildScrollView, dan ListView
- `Padding` menjaga jarak antar-elemen form supaya tidak terlihat rapat dan memudahkan pengguna menyentuh tiap field (misal pada field nama, harga, dan deskripsi di `NewsFormPage`).
- `SingleChildScrollView` membungkus seluruh form sehingga konten dapat digulir ketika tinggi layar lebih pendek dari total elemen (tidak ada field yang “hilang” tertutup keyboard).
- `ListView` (dengan `shrinkWrap`) saya letakkan di dalam `SingleChildScrollView` untuk merangkai input secara vertikal tanpa perlu menghitung tinggi tiap widget; pendekatan ini mempermudah ketika jumlah field bertambah dan tetap responsif.

### Penyesuaian Tema untuk Identitas Brand
- Di `main.dart` saya mengganti `ThemeData` menjadi `ColorScheme.fromSeed(seedColor: Colors.indigo)` dan aksen oranye, lalu memakai warna tersebut pada AppBar, tombol `Save`, hingga header drawer.
- Pendekatan ini memastikan seluruh halaman memakai palet yang sama (ungu tua untuk elemen utama, oranye sebagai aksen), sehingga aplikasi Football Shop punya identitas visual konsisten.

--- 
## Tugas 9

### 1. Mengapa Perlu Membuat Model untuk Mengambil/Mengirim Data JSON?

**Model Dart penting karena:**
- **Type Safety**: Mencegah error tipe data saat compile-time
- **Null Safety**: Memaksa deklarasi field nullable/non-nullable
- **Autocomplete**: IDE bisa suggest properti
- **Maintainability**: Perubahan struktur hanya di satu tempat
- **Readability**: `product.name` lebih jelas daripada `data['name']`

**Konsekuensi tanpa model:**
```dart
// ❌ Tanpa Model
var data = jsonDecode(response);
String name = data['nama'];  // Typo, tidak terdeteksi
int price = data['price'];   // Runtime error jika String

// ✅ Dengan Model  
Product product = Product.fromJson(data);
String name = product.name;  // Compile-time safe
int price = product.price;   // Type guaranteed
```

---

### 2. Fungsi Library `http` dan `CookieRequest`

| Library | Fungsi | Use Case |
|---------|--------|----------|
| **`http`** | HTTP request standar tanpa session management | API publik, REST stateless |
| **`CookieRequest`** | HTTP + otomatis handle cookies & session Django | Django dengan session-based auth |

**Perbedaan utama:**
- `http`: Tidak simpan cookies, setiap request independen
- `CookieRequest`: Otomatis simpan & kirim cookies (session persisten)

---

### 3. Mengapa CookieRequest Perlu Dibagikan ke Semua Komponen?

**Alasan:**
1. **Session Consistency**: Semua komponen perlu akses session yang sama
2. **Single Instance**: Efisien, semua widget pakai satu instance
3. **State Management**: User login sekali, session tersedia di semua halaman

---

### 4. Konfigurasi Konektivitas Flutter-Django

#### **A. ALLOWED_HOSTS dengan `10.0.2.2`**
```python
# settings.py
ALLOWED_HOSTS = ['localhost', '127.0.0.1', '10.0.2.2']
```
**Mengapa?** Android Emulator tidak bisa akses `localhost` langsung. `10.0.2.2` adalah IP spesial yang map ke `127.0.0.1` host machine.

**Tanpa ini:** ❌ `Connection refused` atau `Bad Request 400`

#### **B. CORS (Cross-Origin Resource Sharing)**
```python
# settings.py
INSTALLED_APPS = ['corsheaders', ...]
MIDDLEWARE = ['corsheaders.middleware.CorsMiddleware', ...]

CORS_ALLOW_ALL_ORIGINS = True
CORS_ALLOW_CREDENTIALS = True
```
**Mengapa?** Browser/Flutter block request dari origin berbeda (security policy).

**Tanpa ini:** ❌ `CORS policy error` - request ditolak

#### **C. Cookie Settings (SameSite & Secure)**
```python
# settings.py
CSRF_COOKIE_SAMESITE = 'None'
SESSION_COOKIE_SAMESITE = 'None'
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_SECURE = True
```
**Mengapa?** Modern browsers block cookies `SameSite=Lax` pada cross-origin request. `None` membolehkan cookies dikirim dari Flutter.

**Tanpa ini:** ❌ Cookies tidak tersimpan/terkirim - user logout otomatis setiap request

#### **D. Internet Permission (Android)**
```xml
<!-- android/app/src/main/AndroidManifest.xml -->

```
**Mengapa?** Android require explicit permission untuk network access.

**Tanpa ini:** ❌ `SocketException: Network unreachable` - tidak bisa HTTP request sama sekali

#### **Ringkasan Konsekuensi:**

| Konfigurasi Missing | Error yang Terjadi |
|---------------------|-------------------|
| `10.0.2.2` di ALLOWED_HOSTS | Connection refused / Bad Request |
| CORS tidak aktif | CORS policy error |
| SameSite cookies tidak di-set | Session hilang setiap request |
| Internet permission | Network unreachable exception |

---


### 5. Mekanisme Pengiriman Data dari Input hingga Tampil di Flutter

**Flow:**
1. **Input**: User isi form di Flutter
2. **Validasi**: Form divalidasi client-side
3. **Konversi**: Data dikonversi ke JSON dengan `jsonEncode()`
4. **Kirim**: POST request ke Django dengan `request.postJson()`
5. **Proses**: Django buat object & simpan ke database
6. **Response**: Django return JSON `{"status": "success"}`
7. **Navigate**: Flutter pindah ke list page
8. **Fetch**: GET request ambil semua data
9. **Parse**: JSON diparsing jadi List<Product>
10. **Render**: Data ditampilkan dengan ListView

---

### 6. Mekanisme Autentikasi dari Login, Register, hingga Logout

#### **Login:**
```
Flutter Input → POST ke /auth/login/ → Django authenticate() 
→ Django set session cookies → Flutter simpan cookies via CookieRequest 
→ Navigate ke HomePage
```

#### **Register:**
```
Flutter Input → POST ke /auth/register/ → Django validasi 
→ Django create User → Return success → Navigate ke LoginPage
```

#### **Logout:**
```
Flutter request.logout() → POST ke /auth/logout/ 
→ Django hapus session → Flutter hapus cookies 
→ Navigate ke LoginPage
```

**Key Point:** Setelah login, semua request otomatis include cookies session → Django tahu user mana yang request.

---

### 7. Implementasi Checklist Step-by-Step

#### **Setup Django**
1. Buat app `authentication`, install `django-cors-headers`
2. Tambah ke `INSTALLED_APPS` & `MIDDLEWARE`
3. Set `CORS_ALLOW_ALL_ORIGINS = True`, `CORS_ALLOW_CREDENTIALS = True`
4. Set `CSRF_COOKIE_SAMESITE = 'None'`, `SESSION_COOKIE_SAMESITE = 'None'`
5. Buat views login, register, logout di `authentication/views.py`
6. Tambah `@login_required` di `create_product_flutter` view

#### **Setup Flutter**
1. Install packages: `flutter pub add provider pbp_django_auth`
2. Wrap `MaterialApp` dengan `Provider` di `main.dart` untuk share `CookieRequest`
3. Tambah permission internet di `AndroidManifest.xml`

#### **Buat Model**
1. Copy JSON response dari Django
2. Convert di https://app.quicktype.io/ ke Dart
3. Save sebagai `lib/models/product_entry.dart`

#### **Implementasi Fitur**
1. **Login**: Buat `login.dart`, call `request.login()`, navigate jika sukses
2. **Register**: Buat `register.dart`, call `request.postJson()`, navigate ke login
3. **List Products**: 
   - Buat `product_entry_list.dart`
   - Fetch data dengan `request.get()`
   - Parse JSON jadi `List<Product>`
   - Display dengan `FutureBuilder` + `ListView.builder`
4. **Create Product**:
   - Buat form di `productlist_form.dart`
   - Validasi input
   - POST dengan `request.postJson()`
5. **Product Detail**: 
   - Buat `product_detail.dart`
   - Terima `Product` object via constructor
   - Display semua field
6. **Filter My Products**:
   - Tambah parameter `?filter=my` di URL
   - Backend filter berdasarkan `request.user`
7. **Logout**:
   - Call `request.logout()`
   - Navigate ke `LoginPage` dengan `pushAndRemoveUntil`

#### **Styling**
1. Ganti semua `Colors.indigo` jadi `Color(0xFFf97316)` (orange)
2. Update theme di `main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFf97316)
  ).copyWith(secondary: const Color(0xFFea580c)),
)
```
3. Apply ke semua AppBar, Button, dan accent colors