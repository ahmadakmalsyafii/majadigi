const admin = require("firebase-admin");
const serviceAccount = require("./majadigi-app-firebase-adminsdk-fbsvc-ede6407d47.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://majadigi-app-default-rtdb.firebaseio.com",
});

const db = admin.firestore();

/**
 * Default jam operasional
 */
function defaultJamOperasional() {
  return {
    items: [
      {
        hari: "senin",
        buka: null,
        tutup: null,
        keterangan: "24 Jam",
      },
      {
        hari: "selasa",
        buka: null,
        tutup: null,
        keterangan: "24 Jam",
      },
      {
        hari: "rabu",
        buka: null,
        tutup: null,
        keterangan: "24 Jam",
      },
      {
        hari: "kamis",
        buka: null,
        tutup: null,
        keterangan: "24 Jam",
      },
      {
        hari: "jumat",
        buka: null,
        tutup: null,
        keterangan: "24 Jam",
      },
      {
        hari: "sabtu",
        buka: null,
        tutup: null,
        keterangan: "24 Jam",
      },
      {
        hari: "minggu",
        buka: null,
        tutup: null,
        keterangan: "24 Jam",
      },
    ],
  };
}

function RSUDDahaOperasional() {
  return {
    items: [
      {
        hari: "senin",
        buka: "07:00",
        tutup: "21:00",
        keterangan: null,
      },
      {
        hari: "selasa",
        buka: "07:00",
        tutup: "21:00",
        keterangan: null,
      },
      {
        hari: "rabu",
        buka: "07:00",
        tutup: "21:00",
        keterangan: null,
      },
      {
        hari: "kamis",
        buka: "07:00",
        tutup: "21:00",
        keterangan: null,
      },
      {
        hari: "jumat",
        buka: "07:00",
        tutup: "21:00",
        keterangan: null,
      },
    ],
  };
}

function RSUDKarsaJamOperasional() {
  return {
    items: [
      {
        hari: "senin",
        buka: "08:00",
        tutup: "13:00",
        keterangan: null,
      },
      {
        hari: "selasa",
        buka: "08:00",
        tutup: "13:00",
        keterangan: null,
      },
      {
        hari: "rabu",
        buka: "08:00",
        tutup: "13:00",
        keterangan: null,
      },
      {
        hari: "kamis",
        buka: "08:00",
        tutup: "13:00",
        keterangan: null,
      },
      {
        hari: "jumat",
        buka: "08:00",
        tutup: "11:00",
        keterangan: null,
      },
    ],
  };
}

function RSUDSaifulJamOperasional() {
  return {
    items: [
      {
        hari: "senin",
        buka: "07:00",
        tutup: "13:30",
        keterangan: null,
      },
      {
        hari: "selasa",
        buka: "07:00",
        tutup: "13:30",
        keterangan: null,
      },
      {
        hari: "rabu",
        buka: "07:00",
        tutup: "13:30",
        keterangan: null,
      },
      {
        hari: "kamis",
        buka: "07:00",
        tutup: "13:30",
        keterangan: null,
      },
      {
        hari: "jumat",
        buka: "07:00",
        tutup: "11:00",
        keterangan: null,
      },
    ],
  };
}

/**
 * Seeder berdasarkan UUID field "id"
 * GANTI UUID DI BAWAH SESUAI FIREBASE KAMU
 */
const serviceSeeder = {
  //islamic center
  "9ddfa8e3-7ebf-46fd-911b-a16c326fcd9d": {
    address: "Jl. Raya Dukuh Kupang No.122-124, Kec. Dukuhpakis, Surabaya",
    website_url: "https://islamiccenter.jatimprov.go.id/",

    feature: [
      {
        id: "10ca1bd0-db67-40be-9f71-e4060db99c97",
        layanan_id: "9ddfa8e3-7ebf-46fd-911b-a16c326fcd9d",
        judul: "Gedung Islamic Center",
      },
    ],

    operational_hours: defaultJamOperasional(),
  },
  //program bansos
  "844063ff-2ca9-41ca-9f44-56f55a68ffc3": {
    address:
      "Jl. Gayung Kebonsari No.56b, Gayungan, Kec. Gayungan, Kota Surabaya, Jawa Timur 60235",
    website_url: "https://sapabansos.dinsos.jatimprov.go.id/",

    feature: [
      {
        id: "03213978-aaaf-4d47-9007-4506615a33a0",
        layanan_id: "844063ff-2ca9-41ca-9f44-56f55a68ffc3",
        judul: "Data Penerima & Info Program Bansos",
      },
    ],

    operational_hours: defaultJamOperasional(),
  },
  //rsud saiful anwar
  "cf8c31f4-2b33-4b87-8ff5-c01a1b8a937b": {
    address: "Info ketersediaan kamar rawat RSUD Dr. Saiful Anwar",
    website_url: "https://rsusaifulanwar.jatimprov.go.id/v2/",

    feature: [
      {
        id: "95cea926-6f8c-432c-a275-f710982f9bc9",
        layanan_id: "cf8c31f4-2b33-4b87-8ff5-c01a1b8a937b",
        judul: "Ketersediaan Kamar Rawat",
      },
    ],

    operational_hours: RSUDSaifulJamOperasional(),
  },
  //rsud karsahusada
  "074ff2a2-9595-4eb3-be4c-fbaae8b0a808": {
    address:
      "Jl. Ahmad Yani No.11-13, Ngaglik, Kec. Batu, Kota Batu, Jawa Timur 65311",
    website_url:
      "https://www.rsukarsahusadabatu.jatimprov.go.id/?fbclid=IwY2xjawMJcLBleHRuA2FlbQIxMABicmlkETFEa2tLbnRLc0ZDZXpreE1XAR4lcfbCdATj_9lPnoWekQhAJ92XXeTgk3JCYRcP5urkKlfltsZQH8ns2gaMFA_aem_IHc4TFJdIv8-_L88uvYVwA",

    feature: [
      {
        id: "e5965d41-c156-4f20-a64f-8d7571be1ce1",
        layanan_id: "074ff2a2-9595-4eb3-be4c-fbaae8b0a808",
        judul: "Ketersediaan Kamar Rawat",
      },
    ],

    operational_hours: RSUDKarsaJamOperasional(),
  },
  //nomor darurat
  "aabb98eb-fe75-4cea-a541-ffbfa4022a3e": {
    address: "Seluruh kota",
    website_url: null,

    feature: [
      {
        id: "9f5e89e3-35e3-4b0c-a089-12a5f921372a",
        layanan_id: "aabb98eb-fe75-4cea-a541-ffbfa4022a3e",
        judul: "Kontak Darurat",
      },
    ],

    operational_hours: defaultJamOperasional(),
  },
  //harga bahan pokok
  "21db6ffe-4f0a-46e8-bd04-61e906ce2cdd": {
    address: "Jl. Siwalankerto Utara II/42 Surabaya",
    website_url: "https://siskaperbapo.jatimprov.go.id/",

    feature: [
      {
        id: "8013f5a6-b745-4eb1-910a-0a779f1e7ed2",
        layanan_id: "21db6ffe-4f0a-46e8-bd04-61e906ce2cdd",
        judul: "Harga Bahan Pokok (SISKAPERBAPO)",
      },
    ],

    operational_hours: defaultJamOperasional(),
  },
  //rsud daha husada
  "64728adf-9828-45e2-9127-7584a1d6473c": {
    address: "Jl. Veteran No.48, Mojoroto, Kec. Mojoroto, Kota Kediri 64112",
    website_url: "https://rsuddahahusada.jatimprov.go.id/",

    feature: [
      {
        id: "987cf26e-6205-48f6-8bd5-f593e39be445",
        layanan_id: "64728adf-9828-45e2-9127-7584a1d6473c",
        judul: "Ketersediaan Kamar Rawat",
      },
      {
        id: "393b674d-85de-46fc-aa40-68352c0a2194",
        layanan_id: "64728adf-9828-45e2-9127-7584a1d6473c",
        judul: "Jadwal Operasi",
      },
      {
        id: "b84c3ead-c2af-4c6f-910c-fbdd2fdf5930",
        layanan_id: "64728adf-9828-45e2-9127-7584a1d6473c",
        judul: "Info Antrian Pasien",
      },
    ],

    operational_hours: RSUDDahaOperasional(),
  },
  //klinik hoaks
  "fd3d8f06-ae35-4b48-9028-3c8c2842e76b": {
    address: "Jl. A. Yani 242 - 244, Gayungan, Surabaya.",
    website_url: "https://klinikhoaks.jatimprov.go.id/",

    feature: [
      {
        id: "10ca1bd0-db67-40be-9f71-e4060db99c97",
        layanan_id: "fd3d8f06-ae35-4b48-9028-3c8c2842e76b",
        judul: "Gedung Islamic Center",
      },
    ],

    operational_hours: defaultJamOperasional(),
  },
  //desytinasi wisata
  "fe5e13bc-e21d-4224-a4b3-9513d8299910": {
    address:
      "Jalan Wisata Menanggal, Dukuh Menanggal, Kec. Gayungan Kota Surabaya, Provinsi Jawa Timur 60234",
    website_url: "https://sidita.disbudpar.jatimprov.go.id/",

    feature: [
      {
        id: "a193ba7c-b6a8-49ac-b055-6bc391ab5daa",
        layanan_id: "fe5e13bc-e21d-4224-a4b3-9513d8299910",
        judul: "SIDITA",
      },
    ],

    operational_hours: defaultJamOperasional(),
  },
  //rsud haji jatimprov
  "6e195adc-7646-4425-9c07-a5b175c19173": {
    address:
      "Jl. Manyar Kertoadi, Klampis Ngasem, Kec. Sukolilo, Surabaya, Jawa Timur Kodepos 60116",
    website_url: "https://app.rsuhaji.jatimprov.go.id/online/",

    feature: [
      {
        id: "c5ddb8d8-c75a-43cd-a1cb-e643c1726fdc",
        layanan_id: "6e195adc-7646-4425-9c07-a5b175c19173",
        judul: "Info Kamar RSUD Haji",
      },
    ],

    operational_hours: defaultJamOperasional(),
  },
};

async function seedServices() {
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

      const seedData = serviceSeeder[serviceId];

      if (!seedData) {
        console.log(`Skip ${serviceId} (tidak ada data seeder)`);
        continue;
      }

      await db.collection("services").doc(doc.id).update({
        address: seedData.address,
        website_url: seedData.website_url,
        feature: seedData.feature,
        operational_hours: seedData.operational_hours,
      });

      updated++;

      console.log(`✅ Updated: ${data.name}`);
    }

    console.log(`\nSeeder selesai. ${updated} service berhasil diupdate`);

    process.exit(0);
  } catch (error) {
    console.error("❌ Seeder gagal:", error);
    process.exit(1);
  }
}

seedServices();
