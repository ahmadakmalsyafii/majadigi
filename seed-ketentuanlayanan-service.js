const admin = require("firebase-admin");

const serviceAccount = require("./majadigi-app-firebase-adminsdk-fbsvc-ede6407d47.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://majadigi-app-default-rtdb.firebaseio.com",
});

const db = admin.firestore();

/**
 * Seeder berdasarkan UUID field "id"
 * GANTI UUID DI BAWAH SESUAI FIREBASE KAMU
 */
const ketentuanLayananSeeder = {
  // Islamic Center
  "9ddfa8e3-7ebf-46fd-911b-a16c326fcd9d": {
    manfaat: [
      "Kemudahan pemesanan fasilitas Islamic Centre Surabaya secara online, memungkinkan perencanaan acara Islami kapan pun dan dari mana pun, dengan kenyamanan dan kualitas terbaik."
    ],
    sistem_mekanisme_prosedur: [
      "Platform pemesanan digital fasilitas Islamic Centre yang menyediakan informasi terkait fasilitas yang tersedia, harga, serta jadwal penggunaan. Prosedur pemesanan fasilitas Islamic Centre secara online:",
      "1. Akses situs web Islamic Center Jawa Timur.",
      "2. Telusuri informasi fasilitas seperti aula, asrama, ruang pelatihan, dan lainnya.",
      "3. Pilih menu Pemesanan Fasilitas yang diinginkan.",
      "4. Isi formulir pemesanan online dengan data lengkap dan sesuai kebutuhan.",
      "5. Lakukan pembayaran sesuai ketentuan yang berlaku.",
      "6. Pemesanan selesai dan siap digunakan sesuai jadwal yang telah ditentukan.",
      "7. Hubungi pihak terkait apabila terdapat kendala."
    ]
  },
  // Nomor Darurat
  "aabb98eb-fe75-4cea-a541-ffbfa4022a3e": {
    manfaat: [
      "Layanan nomor darurat memberikan akses cepat dan mudah untuk mencari pertolongan saat seseorang mengalami atau mengetahui situasi darurat seperti kebakaran, banjir, kecelakaan lalu lintas, kriminalitas, dan lainnya. Dengan begitu, layanan ini diharapkan mampu mempercepat penanganan keadaan darurat dan meminimalisir dampak buruk yang muncul akibat situasi darurat. Layanan nomor darurat beroperasi 24 jam sehari, dan 7 hari seminggu. Sehingga masyarakat bisa mengaksesnya kapanpun dan dari manapun."
    ],
    sistem_mekanisme_prosedur: [
      "Kontak darurat biasanya lebih pendek atau sedikit dengan tujuan agar mudah diingat. Pastikan Anda menyimpan daftar kontak darurat di ponsel Anda atau tempat yang mudah dijangkau. Terakhir, pastikan Anda memberikan informasi secara jelas mengenai kejadian dan lokasinya agar petugas bisa mengeksekusinya lebih cepat."
    ]
  },
  // RSUD Daha Husada
  "64728adf-9828-45e2-9127-7584a1d6473c": {
    manfaat: [
      "RSUD Daha Husada mempunyai tugas melaksanakan sebagian tugas Dinas Kesehatan di bidang promotif, preventif, kuratif, rehabilitatif, penelitian pengembangan, dan melaksanakan UKM Strata II di wilayah kerjanya. Untuk melaksanakan tugas tersebut, RSUD Daha Husada mempunyai fungsi, diantaranya:",
      "1. Penyusunan rencana dan program RSUD Daha Husada",
      "2. Pelaksanaan ketatausahaan",
      "3. Pengawasan dan pengendalian operasional rumah sakit",
      "4. Pelayanan medis",
      "5. Penyelenggaraan pelayanan penunjang medis dan non medis",
      "6. Pelaksanaan pelayanan kesehatan umum masyarakat",
      "7. Penyelenggaraan pelayanan dan asuhan keperawatan",
      "8. Penyelenggaraan pelayanan rujukan pasien, spesimen, IPTEK dan program",
      "9. Penyelenggaraan koordinasi dan kemitraan kegiatan Rumah Sakit Umum Daha Husada",
      "10. Penyelenggaraan penelitian, pengembangan dan diklat",
      "11. Pelaksanaan monitoring dan evaluasi program",
      "12. Pelaksanaan pembinaan wilayah di bidang teknis",
      "13. Pelaksanaan pelayanan kesehatan masyarakat (promotif, preventif, kuratif dan rehabilitatif) baik UKP maupun UKM di dalam gedung maupun di luar gedung di wilayah kerjanya",
      "14. Pelaksanaan tugas lain yang diberikan oleh kepala dinas"
    ],
    sistem_mekanisme_prosedur: [
      "Pendaftaran online di poli RSUD Daha Husada:",
      "1. Bagi pasien BPJS Kesehatan, pendaftaran menggunakan aplikasi Mobile JKN",
      "2. Untuk pasien umum dan asuransi lain, bisa daftar melalui WhatsApp. Caranya, kunjungi web resmi RSUD Daha Husada, pilih menu informasi, dan klik layanan pendaftaran online",
      "3. Pengguna akan diarahkan ke pesan WhatsApp admin RSUD Daha Husada",
      "Pendaftaran online via Mobile JKN (khusus pasien BPJS Kesehatan):",
      "1. Silakan download aplikasi Mobile JKN di Playstore/Appstore",
      "2. Bagi pengguna baru, silakan buat akun Mobile JKN terlebih dahulu. Siapkan NIK, no HP dan pastikan Anda punya pulsa reguler minimal 5 ribu.",
      "3. Setelah membuat akun dan sudah terverifikasi, berikutnya ambil antrian di menu \"Ambil antrian\". Pastikan Anda punya surat rujukan dari FKTP atau memiliki jadwal kontrol di poli RSUD Daha Husada."
    ]
  },
  // RSUD Karsa Husada Batu
  "074ff2a2-9595-4eb3-be4c-fbaae8b0a808": {
    manfaat: [
      "1. Sebagai Badan Layanan Umum Daerah (BLUD), rumah sakit ini menyediakan layanan kesehatan dengan biaya yang lebih terjangkau dibandingkan rumah sakit swasta.",
      "2. Dengan fasilitas medis yang memadai dan tenaga medis profesional, RSUD Karsa Husada Batu berkomitmen untuk memberikan pelayanan kesehatan yang berkualitas kepada masyarakat.",
      "3. RSUD Karsa Husada Batu terus berinovasi dalam meningkatkan layanan kesehatan, termasuk melalui pengembangan fasilitas dan teknologi medis."
    ],
    sistem_mekanisme_prosedur: [
      "Alur Pendaftaran Pasien RSUD Karsa Husada Batu",
      "1. Pasien dapat melakukan pendaftaran kapan saja dan di mana saja melalui aplikasi Mobile JKN.",
      "2. Aplikasi bisa diunduh di: Google Play Store (Android): Mobile JKN di Play Store dan App Store (iOS): Mobile JKN di App Store",
      "3. Selain itu, pasien juga dapat mengakses website resmi RSU Karsa Husada",
      "4. Pilih menu Pelayanan, lalu buka bagian Alur dan Persyaratan untuk melihat informasi mengenai: Rawat Jalan, Rawat Inap dan Instalasi Gawat Darurat (IGD)",
      "5. Jika ingin mendaftar secara online, pilih menu Daftar Online lalu tekan Medical Tourism."
    ]
  },
  // RSUD Haji Prov. Jatim
  "6e195adc-7646-4425-9c07-a5b175c19173": {
    manfaat: [
      "Pendaftaran pasien online merupakan inovasi RSUD Haji Provinsi Jawa Timur yang menjadikan proses pelayanan lebih cepat dan efisien, baik dari sisi pasien maupun rumah sakit. Pasien juga bisa lebih mudah mengetahui jumlah ketersediaan kamar di RSUD Haji Provinsi Jawa Timur. Dengan sistem yang lebih tertata, pelayanan dan informasi rekam medis pasien lebih terorganisir. Pasien lebih mudah mengambil nomor antrian tanpa harus datang ke rumah sakit, juga bisa mengakses berbagai informasi penting kapanpun, dan dari manapun."
    ],
    sistem_mekanisme_prosedur: [
      "1. Ketik app.rsuhaji.jatimprov.go.id/online di mesin pencari perangkat Anda atau bisa langsung klik Pendaftaran Pasien Online RSUD Haji Provinsi Jawa Timur",
      "2. Pilih kategori layanan yang dituju (khusus member RSUD Haji Jatim)",
      "3. Jika Anda belum terdaftar sebagai member, silakan pilih menu pasien baru",
      "4. Isi formulir pendaftaran pasien online sampai selesai",
      "Syarat & Ketentuan pendaftaran pasien online:",
      "1. Pendaftaran online hanya berlaku bagi pasien yang sudah terdaftar sebagai member RSUD Haji Provinsi Jawa Timur",
      "2. Untuk pasien baru, silakan daftar sebagai member dengan memilih menu Pasien Baru di halaman registrasi online",
      "3. Khusus Pasien Baru Anak (belum punya KTP) bisa menuliskan NIK yang tertera di Kartu Keluarga, dan mengupload foto KK sebagai ganti foto KTP",
      "4. Pilih menu Medical Checkup untuk layanan vaksin dan medical check up (CPNS)",
      "5. Pendaftaran online untuk layanan vaksin dan medical check up (CPNS) bisa dilakukan baik oleh pasien yang sudah terdaftar sebagai member maupun belum",
      "6. Pendaftaran online hanya bisa dilakukan satu kali sampai layanan di poli selesai",
      "7. Pendaftaran online belum bisa digunakan untuk asuransi pihak ketiga"
    ]
  },
  // Harga Bahan Pokok (SISKAPERBAPO)
  "21db6ffe-4f0a-46e8-bd04-61e906ce2cdd": {
    manfaat: [
      "1. Akses informasi harga bahan pokok secara harian dan transparan.",
      "2. Pemantauan ketersediaan bahan pokok dengan mudah, kapan saja.",
      "3. Mendukung pengendalian inflasi dan menjaga stabilitas harga bahan pokok."
    ],
    sistem_mekanisme_prosedur: [
      "Sistem: Website milik Disperindag Jatim yang menyediakan data harian harga dan ketersediaan bahan pokok secara detail.",
      "Cek Harga Sembako Lewat SISKAPERBAPO:",
      "1. Akses situs web resmi SISKAPERBAPO",
      "2. Telusuri data harga bahan pokok berdasarkan kategori bahan pokok.",
      "3. Pilih lokasi atau wilayah kabupaten/kota yang ingin dipantau.",
      "4. Lihat grafik tren harga harian dan informasi ketersediaan barang.",
      "5. Gunakan fitur perbandingan harga produsen dan konsumen untuk analisis."
    ]
  },
  // Data Penerima & Info Program Bansos (SAPA BANSOS)
  "844063ff-2ca9-41ca-9f44-56f55a68ffc3": {
    manfaat: [
      "Sapa Bansos memudahkan warga Jatim mengakses info program bansos, jadwal pencairan, dan daftar penerima dana secara real-time, transparan, dan akuntabel."
    ],
    sistem_mekanisme_prosedur: [
      "Persyaratan:",
      "1. Penerima bansos terdaftar dalam Data Terpadu Kesejahteraan Sosial (DTKS)",
      "2. Penerima bansos memenuhi kriteria sosial ekonomi tertentu seperti keluarga miskin atau rentan miskin, lanjut usia, dan penyandang disabilitas berat.",
      "3. Punya Nomor Induk Kependudukan (NIK) yang valid untuk validasi data penerima.",
      "4. Tidak berstatus sebagai Aparatur Sipil Negara (ASN), TNI, atau Polri.",
      "Cek Bansos lewat Sapa Bansos:",
      "1. Akses layanan Sapa Bansos melalui aplikasi Majadigi",
      "2. Pilih layanan Info Bansos",
      "3. Masukkan NIK untuk cek data penerima bansos",
      "4. Pilih informasi program untuk info detail rekapitulasi penyaluran tiap program bansos."
    ]
  },
  // Destinasi Wisata
  "fe5e13bc-e21d-4224-a4b3-9513d8299910": {
    manfaat: [
      "Aplikasi SIDITA (Sistem Informasi Daya Tarik Wisata) merupakan platform yang menyediakan layanan informasi terkait data kepariwisataan, khususnya di wilayah Jawa Timur. Manfaat yang diperoleh pengguna dari aplikasi ini antara lain:",
      "1. Data dan informasi valid",
      "2. Fitur maps dan direction ke destinasi tujuan",
      "3. Data diperbarui secara real time"
    ],
    sistem_mekanisme_prosedur: [
      "Pengunjung perlu menyiapkan 3 hal ini untuk menikmati layanan 360 East Java Virtual Tour, seperti:",
      "1. Perangkat elektronik, berupa handphone atau laptop",
      "2. Koneksi internet stabil",
      "3. Browser yang update",
      "Sistem:",
      "Layanan SIDITA dilengkapi dengan 2 fitur, yaitu:",
      "1. SIDITA berbasis website untuk memudahkan pengunjung menikmati layanannya tanpa perlu instal aplikasi.",
      "2. Titik koordinat wisata sebagai panduan perjalanan ke lokasi tujuan"
    ]
  },
  // Klinik Hoaks
  "fd3d8f06-ae35-4b48-9028-3c8c2842e76b": {
    manfaat: [
      "1. Membantu masyarakat memverifikasi informasi yang meragukan agar terhindar dari hoaks.",
      "2. Melindungi publik dari dampak negatif informasi palsu yang menyesatkan.",
      "3. Meningkatkan kesadaran dan literasi digital masyarakat melalui klarifikasi informasi.",
      "4. Mendukung terciptanya ruang digital yang sehat dan bebas hoaks.",
      "5. Menyediakan akses transparan terhadap hasil verifikasi informasi."
    ],
    sistem_mekanisme_prosedur: [
      "Prosedur menggunakan situs Klinik Hoaks:",
      "1. Akses laman https://klinikhoaks.jatimprov.go.id/",
      "2. Masukkan kata kunci informasi atau berita yang dicari",
      "3. Sistem akan menampilkan hasil temuan sesuai kata kunci yang dicari, termasuk status dan penjelasannya.",
      "Jika informasi yang dicari tidak ditemukan, pengguna bisa ajukan permohonan klarifikasi sebagai berikut:",
      "1. Klik menu di laman Klinik Hoaks",
      "2. Pilih menu permohonan klarifikasi",
      "3. Isi formulir data dengan informasi yang diminta, lalu klik tombol kirim."
    ]
  },
  // RSUD Dr. Saiful Anwar
  "cf8c31f4-2b33-4b87-8ff5-c01a1b8a937b": {
    manfaat: [
      "1. Memudahkan pasien mendapatkan layanan rawat jalan dengan jadwal operasional yang jelas.",
      "2. Tersedia dua opsi pendaftaran: offline langsung di RS atau online melalui aplikasi, sehingga pasien dapat memilih metode sesuai kebutuhan.",
      "3. Mengurangi antrean fisik di rumah sakit karena adanya sistem pengambilan nomor antrean secara online.",
      "4. Akses informasi yang mudah melalui website resmi RSSA"
    ],
    sistem_mekanisme_prosedur: [
      "Persyaratan Umum",
      "1. Memiliki identitas diri (KTP/SIM/Paspor) atau kartu pasien RSSA.",
      "2. Untuk pasien BPJS Kesehatan, wajib membawa kartu BPJS dan surat rujukan sesuai ketentuan.",
      "3. Untuk pasien umum, cukup membawa identitas dan bersedia membayar sesuai tarif yang berlaku.",
      "4. Pasien harus datang sesuai jadwal dan jam operasional yang ditentukan.",
      "Sistem dan Mekanisme Pendaftaran Online",
      "1. Unduh aplikasi Antrian Poliklinik RSSA atau \"Mobile JKN\" melalui Play Store (Android) atau Apple Store (iOS)",
      "2. Lakukan registrasi akun dan login",
      "3. Pilih layanan poliklinik, tanggal kunjungan, dan jam yang diinginkan",
      "4. Simpan bukti pendaftaran digital (biasanya berupa QR code atau nomor antrean)",
      "5. Datang ke rumah sakit sesuai jadwal yang telah dipilih untuk verifikasi dan pelayanan",
      "Prosedur saat Hari Kunjungan untuk Pasien Online",
      "1. Datang sesuai waktu yang dipilih di aplikasi",
      "2. Menuju loket khusus pendaftaran online untuk scan QR code/bukti pendaftaran",
      "3. Langsung diarahkan menuju poliklinik terkait sesuai jadwal"
    ]
  }
};

async function seedKetentuanLayanan() {
  try {
    const snapshot = await db.collection("services").get();

    if (snapshot.empty) {
      console.log("Collection services kosong");
      return;
    }

    let updated = 0;

    for (const doc of snapshot.docs) {
      const data = doc.data();

      // UUID dari field id
      const serviceId = data.id;

      if (!serviceId) {
        console.log(`Skip doc ${doc.id} (tidak ada field id)`);
        continue;
      }

      const seedData = ketentuanLayananSeeder[serviceId];

      if (!seedData) {
        console.log(`Skip ${serviceId} (tidak ada data seeder ketentuan_layanan)`);
        continue;
      }

      await db.collection("services").doc(doc.id).update({
        ketentuan_layanan: seedData
      });

      updated++;

      console.log(`✅ Updated: ${data.name || serviceId}`);
    }

    console.log(`\nSeeder selesai. ${updated} service berhasil diupdate ketentuan_layanannya`);

    process.exit(0);
  } catch (error) {
    console.error("❌ Seeder gagal:", error);
    process.exit(1);
  }
}

seedKetentuanLayanan();