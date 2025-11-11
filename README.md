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
