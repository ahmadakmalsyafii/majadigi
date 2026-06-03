# Laporan Implementasi Manajemen Fitur On-Demand (Deferred Component)

Laporan ini mengupas tentang arsitektur fitur *on-demand* pada aplikasi `majadigi` dengan memanfaatkan kemampuan **Deferred Components** di Flutter/Dart. Pola ini memampukan aplikasi untuk hanya memuat potongan (*chunk*) kode dari fitur-fitur besar (seperti Harga Bahan Pokok, Antrean Pasien) ke dalam memori ponsel saat pengguna sungguh-sungguh mengeklik fitur tersebut. Keuntungannya, ukuran aplikasi (*app size*) saat awal diluncurkan jauh lebih efisien, ringan, dan cepat.

---

## 1. Deklarasi Import Deferred (Memecah Kode)

Inti dari *deferred component* bermula pada bagaimana kita mengimpor (menyisipkan) file halaman (*page*). Sistem ini diimplementasikan di dua tempat utama: `lib/core/router/app_router.dart` (untuk rute/navigasi) dan `lib/features/detail_layanan/presentation/widgets/layanan_tab_view.dart` (untuk menu pemicu unduhan).

```dart
// Potongan kode dari app_router.dart
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/pages/harga_bahan_pokok_page.dart' deferred as harga_bahan_pokok;
import 'package:majadigi/deffered_feature/ketersediaan_kamar/presentation/pages/ketersediaan_kamar_page.dart' deferred as ketersediaan_kamar;
import 'package:majadigi/deffered_feature/antrean_pasien/presentation/pages/antrean_pasien_page.dart' deferred as antrean_pasien;
// ... dan seterusnya
```

**Penjelasan dan Cara Kerja:**
Alih-alih memakai sintaks `import` reguler, kita menggunakan tambahan sintaks `deferred as [nama_alias]`. Hal ini adalah instruksi khusus (*compiler directive*) kepada *Dart Compiler* untuk: **"Potong kode halaman ini dan dependensinya menjadi file `.so` atau `.js` tersendiri. Jangan paksa masuk ke dalam ruang memori utama saat aplikasi pertama kali menyala."**

---

## 2. BLoC Manajemen Status Fitur (`FeatureManagerBloc`)

Untuk menghadirkan pengalaman pengguna yang halus, aplikasi perlu mengingat status dari setiap fitur—apakah ia '*Sudah Terinstal*' (`installed`), '*Belum Terinstal*' (`notInstalled`), atau '*Sedang Menginstal*' (`installing`). Logika ini dipusatkan pada `FeatureManagerBloc` di dalam `lib/core/feature_manager/presentation/bloc/feature_manager_bloc.dart`. BLoC ini membaca/menulis memori menetap via `SharedPreferences`.

```dart
class FeatureManagerBloc extends Bloc<FeatureManagerEvent, FeatureManagerState> {
  // ...

  Future<void> _onInstallFeature(InstallFeatureEvent event, Emitter<FeatureManagerState> emit) async {
    // 1. Ubah state UI untuk memunculkan loading (Sedang Menginstal)
    emit(state.copyWith(
      statuses: {event.featureName: FeatureStatus.installing},
      progresses: {event.featureName: 0.0}
    ));

    bool isDone = false;
    bool isError = false;

    // 2. Memicu perintah asli dari dart untuk menarik/mendownload file library
    event.loadLibraryFuture().then((_) {
      isDone = true; // Selesai ditarik
    }).catchError((_) {
      isError = true; // Gagal (contoh: gangguan internet)
    });

    // 3. Menghasilkan animasi bar loading buatan (simulasi) selagi fitur aslinya ditarik
    double currentProgress = 0.0;
    while (!isDone && currentProgress < 0.9) {
      await Future.delayed(const Duration(milliseconds: 200));
      currentProgress += 0.1;
      emit(state.copyWith(progresses: {event.featureName: currentProgress}));
    }

    // 4. Tahap validasi akhir
    if (isError) {
      emit(state.copyWith(statuses: {event.featureName: FeatureStatus.notInstalled}));
    } else {
      // Catat di disk permanen (Shared Preferences) bahwa fitur X resmi terpasang
      await manageFeatureUsecase.markAsInstalled(event.featureName);
      emit(state.copyWith(
        statuses: {event.featureName: FeatureStatus.installed},
        progresses: {event.featureName: 1.0} // Penuh (100%)
      ));
    }
  }
}
```

**Penjelasan dan Cara Kerja:**
Event utama di atas bertugas menyembunyikan jeda *lag* (*latency*) ketika proses eksekusi unduhan library (`loadLibraryFuture`) dari repositori PlayStore (Android) atau memori lokal terjadi. Selama menunggu *Future* diselesaikan, BLoC perlahan-lahan menyiarkan nilai *progress* untuk diterjemahkan oleh antarmuka menjadi elemen '*LinearProgressIndicator*'. Jika berhasil, bendera (*flag*) fitur disimpan dengan label '*installed*'.

---

## 3. Dinamika Tampilan Kartu Layanan (UI Pemicu)

Bagian kotak kartu menu di aplikasi sengaja dibuat "pintar" agar bisa berubah corak tergantung siklus pemasangannya. Ini diletakkan pada `lib/features/detail_layanan/presentation/widgets/layanan_tab_view.dart`.

```dart
// Di dalam class LayananTabView

BlocBuilder<FeatureManagerBloc, FeatureManagerState>(
  builder: (context, state) {
    // Dapatkan status terkini dari Poin 2
    final status = isDeferred ? state.getStatus(featureKey) : FeatureStatus.installed;
    final isNotInstalled = status == FeatureStatus.notInstalled;
    final isInstalling = status == FeatureStatus.installing;

    return GestureDetector(
      onTap: () {
        if (isNotInstalled) {
          // Jika belum terinstal: Munculkan Modal Konfirmasi
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Unduh Fitur'),
              actions: [
                TextButton(
                  onPressed: () {
                    // Ketika disetujui, kirim Event ke BLoC (menyerahkan fungsi callback loadLibrary)
                    _featureManagerBloc.add(InstallFeatureEvent(
                      featureName: featureKey,
                      loadLibraryFuture: () => harga_bahan_pokok.loadLibrary(),
                    ));
                  }
                ),
              ],
            ),
          );
        } else if (!isInstalling) {
          // Jika tidak sedang menginstal (artinya sudah terinstal): Arahkan ke Routing Normal
          context.push('/harga-bahan-pokok');
        }
      },
      child: Container(
        // Desain UI diburamkan (abu-abu) jika belum terinstal
        color: isNotInstalled || isInstalling ? Colors.grey.shade300 : Colors.white,
        child: Stack(
          children: [
            // Ikon penanda Download Muncul Otomatis
            if (isNotInstalled) 
               const Positioned(bottom: 0, right: 0, child: Icon(Icons.download_rounded)),
            
            // Render palang progres (LinearProgressIndicator) di bawah kartu
            if (isInstalling) 
               Positioned(bottom: 0, child: LinearProgressIndicator(value: progress)),
          ],
        ),
      ),
    );
  }
)
```

**Penjelasan dan Cara Kerja:**
`BlocBuilder` menyimak sinyal yang dikirimkan oleh `FeatureManagerBloc`. Jika suatu kartu menu dikenali sebagai *deferred component* (misalnya: *isDeferred* true) dan terdeteksi *NotInstalled*, maka warna dasar dirubah, diberi ikon *download*, dan interaksi tap-nya tidak mengarahkan navigasi—melainkan memunculkan `AlertDialog` ("Unduh Fitur"). Pemanggilan fungsi sakti `loadLibrary()` dipantik di dalam tombol *Setuju* (Ya) dialog tersebut.

---

## 4. Eksekusi Router Pelindung (*Safeguard Navigation*)

Setelah tombol ditekan dan library berhasil dimuat di memori, pengguna boleh melanjutkan perjalanannya (masuk ke halaman yang sesungguhnya). Karena itu, file rute (`lib/core/router/app_router.dart`) juga wajib diikatkan pengamanan menggunakan `FutureBuilder`.

```dart
GoRoute(
  path: '/harga-bahan-pokok',
  name: 'harga_bahan_pokok',
  builder: (BuildContext context, GoRouterState state) {
    // Menjadi lapis pertahanan tambahan, membungkus loadLibrary() dalam FutureBuilder
    return FutureBuilder(
      future: harga_bahan_pokok.loadLibrary(),
      builder: (context, snapshot) {
        
        // Cek: Apakah jalinan kode (chunk library) sudah 100% diproses?
        if (snapshot.connectionState == ConnectionState.done) {
          // Ya. Render Halamannya secara normal.
          // (Kita memanggil kelas aslinya menggunakan prefix alias 'harga_bahan_pokok.')
          return harga_bahan_pokok.HargaBahanPokokPage();
        }
        
        // Tidak. Jika karena suatu insiden tak terduga pengguna diarahkan 
        // ke rute ini tapi mesin belum siap, perlihatkan saja Layar Kosong dengan Spinner Loading.
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  },
),
```

**Penjelasan dan Cara Kerja:**
Kode pada router adalah gawang (*goal*) terakhir. Memanggil `loadLibrary()` untuk kedua kalinya di dalam gawang tidak memberatkan sistem, karena Dart cukup pandai menyadari jika paket tersebut sudah termuat (*cached*). Jika sudah termuat, status *ConnectionState* langsung jatuh pada *done*, sehingga *Class Widget* `HargaBahanPokokPage` dimunculkan seketika dengan aman. Hal ini meredam bahaya *Application Crash* (Force Close) akibat pencarian memori kosong.
