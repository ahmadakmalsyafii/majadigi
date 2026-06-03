# Laporan Implementasi Fitur Harga Bahan Pokok

Laporan ini menjelaskan alur implementasi fitur **Harga Bahan Pokok** pada project `majadigi`, dengan fokus pada bagian-bagian inti: pengambilan data dari internet (Remote Datasource), pengelolaan state menggunakan arsitektur BLoC, dan penggunaannya pada tampilan antarmuka (UI/Page).

---

## 1. Pengambilan Data di Data Source (Remote Datasource)

Lapisan *Data Source* bertugas sebagai pintu keluar untuk melakukan pemanggilan API langsung ke server (Internet). Kode ini berada di `lib/deffered_feature/harga_bahan_pokok/data/datasources/harga_bahan_pokok_remote_data_source.dart`.

```dart
class HargaBahanPokokRemoteDataSourceImpl implements HargaBahanPokokRemoteDataSource {
  final DioClient dioClient;

  HargaBahanPokokRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<CommodityResponse> getCommodityPriceList({int page = 1, int limit = 999}) async {
    try {
      final response = await dioClient.dio.get(
        '/t/jatimprov.go.id/kominfo/transformer/v1/disperindag/commodity/price',
        queryParameters: {
          'page': page,
          'limit': limit,
          'sort': 'name',
        },
      );
      return CommodityResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
  
  // ... fungsi-fungsi lain (getCommodityDetail & getCityPriceList) ...
}
```

**Penjelasan dan Cara Kerja:**
- **`DioClient`**: Class datasource ini di-*inject* (disuntikkan) dengan objek `DioClient`. Artinya, datasource tidak mengkonfigurasi jaringan dari awal, melainkan langsung menggunakan koneksi `Dio` yang sudah disisipkan URL dasar, API key, maupun *timeout*.
- **Pemanggilan API (`dio.get`)**: Fungsi `getCommodityPriceList` memanggil method GET menggunakan path spesifik dari dinas terkait, kemudian menyisipkan *query parameters* seperti pembatas halaman (`page` & `limit`) serta opsi pengurutan (`sort`).
- **Parsing JSON (`fromJson`)**: Data respons mentah (berupa peta JSON dalam bentuk `response.data`) dikonversi secara langsung menjadi model/objek *Dart* (`CommodityResponse`). Hal ini mempermudah lapisan lain di aplikasi untuk berinteraksi dengan data.
- **Pelemaparan Error (`rethrow`)**: Blok fungsi dibalut dengan pelindung `try-catch`. Jika ada masalah jaringan, error ditangkap untuk sesaat sebelum dilempar lagi (`rethrow`) ke layer *Repository* agar nantinya diproses menjadi pesan kegagalan (*Failure*) yang standar.

---

## 2. Pengelolaan State Management (BLoC)

BLoC (Business Logic Component) bertindak sebagai otak fitur. Komponen ini yang menerima aksi/event dari user, meminta data ke layer bawah, lalu mengubahnya menjadi state (status tampilan). File ini berada di `lib/deffered_feature/harga_bahan_pokok/presentation/bloc/harga_bahan_pokok_bloc.dart`.

```dart
class HargaBahanPokokBloc extends Bloc<HargaBahanPokokEvent, HargaBahanPokokState> {
  final GetCommodityPriceListUseCase getCommodityPriceList;
  // ... usecase lainnya ...

  HargaBahanPokokBloc({
    required this.getCommodityPriceList,
  }) : super(HargaBahanPokokInitial()) {
    on<FetchCommodityList>(_onFetchCommodityList);
  }

  Future<void> _onFetchCommodityList(FetchCommodityList event, Emitter<HargaBahanPokokState> emit) async {
    // 1. Pancarkan state Loading
    emit(CommodityListLoading());
    
    // 2. Minta data ke UseCase (yang nantinya memanggil API di Datasource)
    final result = await getCommodityPriceList(page: event.page, limit: event.limit);
    
    // 3. Tangani hasil kembalian (menggunakan arsitektur FP Either)
    result.fold(
      (failure) => emit(CommodityListError(failure.message)), // Jika Gagal: Pancarkan state Error
      (response) {
        var items = response.data.priceList;
        // Fitur Filter lokal jika ada event.searchQuery
        if (event.searchQuery.isNotEmpty) {
          items = items.where((item) => 
            item.commodityName.toLowerCase().contains(event.searchQuery.toLowerCase())
          ).toList();
        }
        // Jika Sukses: Pancarkan state Loaded dengan membawa datanya
        emit(CommodityListLoaded(items)); 
      },
    );
  }
}
```

**Penjelasan dan Cara Kerja:**
- **State Awal (`HargaBahanPokokInitial`)**: Keadaan mula-mula saat BLoC pertama kali diciptakan di memori.
- **Mendengar Event (`on<FetchCommodityList>`)**: Ini adalah pendaftaran fungsi. Jika halaman UI menembakkan event `FetchCommodityList`, BLoC tahu bahwa ia harus mengeksekusi metode `_onFetchCommodityList`.
- **Alur Emitting (`emit`)**: 
  1. Pertama kali fungsi dijalankan, BLoC menyiarkan status `CommodityListLoading` ke UI agar UI bisa menampilkan animasi *loading*.
  2. BLoC kemudian menunggu (*await*) proses pengambilan data dari lapisan arsitektur di bawahnya (`getCommodityPriceList`).
  3. Menggunakan pola pemrograman fungsional (`fold` pada `Either`), BLoC menilai hasilnya:
     - Jika terdeteksi gagal, pancarkan `CommodityListError` beserta pesannya.
     - Jika berhasil, data diolah (contohnya melakukan *filtering pencarian* di sisi aplikasi jika `searchQuery` diisi user). Lalu hasilnya dipancarkan sebagai `CommodityListLoaded`.

---

## 3. Penggunaan BLoC pada Halaman (UI)

Pada layer antarmuka, *Widget* dipasangkan dengan BLoC agar bisa mengubah gambaran layar secara otomatis. Berada di `lib/deffered_feature/harga_bahan_pokok/presentation/pages/harga_bahan_pokok_page.dart`.

```dart
class HargaBahanPokokPage extends StatelessWidget {
  const HargaBahanPokokPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. BlocProvider: Menyuntikkan Bloc agar dikenali oleh semua keturunan widget.
    // Sekaligus memicu penarikan data secara langsung (FetchCommodityList) tanpa menunggu klik.
    return BlocProvider(
      create: (_) => sl<HargaBahanPokokBloc>()..add(FetchCommodityList()),
      child: const HargaBahanPokokView(),
    );
  }
}

// ... di dalam HargaBahanPokokView ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... (potongan AppBar & Layout) ...
      
      // 2. BlocBuilder: Widget yang selalu bereaksi (rebuild) saat state dalam Bloc berubah.
      body: BlocBuilder<HargaBahanPokokBloc, HargaBahanPokokState>(
        builder: (context, state) {
          
          if (state is CommodityListLoading) {
            // Tampilan saat data sedang diambil (Loading)
            return const Center(child: CircularProgressIndicator());
            
          } else if (state is CommodityListError) {
            // Tampilan saat terjadi kesalahan (Error)
            return Center(child: Text(state.message));
            
          } else if (state is CommodityListLoaded) {
            // Tampilan saat data berhasil tiba (Loaded)
            final totalItems = state.commodities;
            
            if (totalItems.isEmpty) {
              return const Center(child: Text('Tidak ada data.'));
            }
            
            // Merender Daftar Harga
            return ListView.builder(
              itemCount: totalItems.length,
              itemBuilder: (context, index) {
                final item = totalItems[index];
                return CommodityItemCard(item: item);
              },
            );
          }
          
          return const SizedBox(); // Tampilan default 
        },
      ),
    );
  }
```

*(Catatan: Susunan List/Scrollview pada blok UI di atas disederhanakan dari aslinya yang menggunakan CustomScrollView & Sliver agar inti konsep implementasi Bloc mudah dipahami).*

**Penjelasan dan Cara Kerja:**
- **`BlocProvider`**: Ini adalah pintu masuk. Komponen ini membuat instance dari `HargaBahanPokokBloc` dan mengeksposnya ke *child widget*-nya (`HargaBahanPokokView`). Penggunaan tanda kaskade `..add(FetchCommodityList())` membuat aplikasi secara otomatis langsung melakukan request pertama saat layar diakses pengguna.
- **`BlocBuilder`**: Merupakan telinga yang mendengar *state* dari otak (BLoC).
  - Ketika BLoC membunyikan "Loading", `BlocBuilder` mengubah tubuh halamannya menjadi ikon *CircularProgressIndicator* (muter-muter).
  - Ketika BLoC membunyikan "Error", dia akan mengganti tubuh halaman dengan teks peringatan.
  - Ketika BLoC membunyikan "Loaded", dia akan menerima kardus berisi barang-barang dari BLoC (dalam hal ini *list of commodities*), membongkarnya, dan menyusunnya satu per satu menggunakan fungsi pe-render daftar (`ListView` / `SliverList`) untuk membentuk `CommodityItemCard` pada layar pengguna.
