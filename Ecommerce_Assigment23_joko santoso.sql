-- =========================================================
-- ADVANCED SQL QUERIES AND DATA ANALYSIS
-- Data Analyst Bootcamp
-- Nama    : Joko Santoso
-- Dataset : dataset_ecomm
-- DBMS    : PostgreSQL
-- =========================================================


-- =========================================================
-- DATA PREPARATION
-- =========================================================

-- Menampilkan 10 data pertama

SELECT *
FROM dataset_ecomm
LIMIT 10;


-- Mengecek struktur tabel

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name='dataset_ecomm';


-- Mengecek jumlah data

SELECT COUNT(*) AS total_data
FROM dataset_ecomm;


-- Mengecek NULL

SELECT
COUNT(*) total_data,
COUNT("ProductID") productid_not_null,
COUNT("ProductName") productname_not_null,
COUNT("Category") category_not_null,
COUNT("CustomerLocation") customerlocation_not_null,
COUNT("PurchaseDate") purchasedate_not_null
FROM dataset_ecomm;


-- Validasi data numerik

SELECT
MIN("Price") minimum_price,
MAX("Price") maximum_price,
AVG("Price") average_price,
MIN("Discount") minimum_discount,
MAX("Discount") maximum_discount
FROM dataset_ecomm;



-- ============================================================================================================================
-- 														  STUDI KASUS 1
-- 														STRING FUNCTIONS
-- ============================================================================================================================

-- Soal 1
-- Membuat Product Code
-- Format:
-- 3 huruf pertama ProductName + "-" + 2 digit terakhir ProductID

SELECT
    "ProductID",
    "ProductName",
    CONCAT(
        LEFT("ProductName",3),           -- Mengambil 3 huruf pertama ProductName
        '-',
        RIGHT("ProductID"::TEXT,2)       -- Mengambil 2 digit terakhir ProductID
    ) AS product_code
FROM dataset_ecomm;


-- Soal 2
-- Mengubah CustomerLocation menjadi huruf kapital

SELECT
    "CustomerLocation" AS before_location,      -- Data sebelum diubah
    UPPER("CustomerLocation") AS after_location -- Data setelah menjadi UPPERCASE
FROM dataset_ecomm;



-- Soal 3
-- Mengganti simbol "&" menjadi kata "and"

SELECT
    "Category" AS before_category,                        -- Data sebelum dibersihkan
    REPLACE("Category",'&','and') AS after_category       -- Data setelah dibersihkan
FROM dataset_ecomm;



-- Tambahan
-- Menggunakan fungsi SUBSTRING()

SELECT
    "ProductName",
    SUBSTRING("ProductName" FROM 1 FOR 5)
    AS first_5_character      -- Mengambil 5 karakter pertama ProductName
FROM dataset_ecomm;



-- Tambahan
-- Menggunakan fungsi LOWER()

SELECT
    "ProductName",

    LOWER("ProductName")
    AS lowercase_productname    -- Mengubah ProductName menjadi huruf kecil

FROM dataset_ecomm;



-- Tambahan
-- Menggunakan fungsi LENGTH()

SELECT
    "ProductName",

    LENGTH("ProductName")
    AS total_character          -- Menghitung jumlah karakter ProductName

FROM dataset_ecomm;

-- ============================================================
-- INSIGHT / OBSERVATION
-- ============================================================

-- 1. Product Code berhasil dibuat dengan format:
--    3 huruf pertama ProductName + "-" + 2 digit terakhir ProductID.

-- 2. CustomerLocation berhasil distandarkan menjadi huruf kapital
--    sehingga penulisan lokasi menjadi lebih konsisten.

-- 3. Simbol '&' pada Category berhasil diganti menjadi 'and'
--    sehingga data kategori lebih rapi dan mudah dianalisis.

-- 4. Fungsi SUBSTRING(), LOWER(), dan LENGTH() berhasil digunakan
--    untuk eksplorasi dan data cleaning ProductName.

-- ============================================================
-- Penjelasan STUDI KASUS 1
-- ============================================================

-- LEFT(), RIGHT() dan CONCAT()
-- digunakan untuk membuat Product Code.

-- UPPER()
-- digunakan untuk standarisasi CustomerLocation.

-- REPLACE()
-- digunakan untuk membersihkan penulisan Category.

-- SUBSTRING(), LOWER() dan LENGTH()
-- digunakan untuk eksplorasi karakter ProductName.




-- ============================================================================================================================
-- 														STUDI KASUS 2
-- 											TIMESTAMP ANALYSIS (MONTHLY TREND)
-- ============================================================================================================================

-- Soal 1
-- Menghitung Net Revenue setiap transaksi
-- Rumus:
-- Net Revenue = Price × QuantitySold × (1 - Discount/100)



SELECT
    "ProductID",
    "ProductName",
    "Price",
    "QuantitySold",
    "Discount",
    ("Price"*"QuantitySold"*(1 - "Discount" / 100.0)) AS net_revenue          -- Pendapatan bersih setelah diskon
    FROM dataset_ecomm;



-- Soal 2
-- Menampilkan total transaksi dan total Net Revenue setiap bulan

SELECT
    DATE_TRUNC('month', "PurchaseDate"::DATE) AS transaction_month,		-- Mengelompokkan berdasarkan bulan
    COUNT(*) AS total_transaction,										-- Total transaksi
    SUM("Price" * "QuantitySold" * (1 - "Discount" / 100.0)) AS total_net_revenue	-- Total pendapatan bersih	
FROM dataset_ecomm
GROUP BY DATE_TRUNC('month', "PurchaseDate"::DATE)
ORDER BY transaction_month;



-- Soal 3
-- Mengambil Tahun dan Bulan menggunakan EXTRACT()

SELECT
    EXTRACT(YEAR FROM "PurchaseDate"::DATE) AS year,
    EXTRACT(MONTH FROM "PurchaseDate"::DATE) AS month,
    COUNT(*) AS total_transaction,
    SUM("Price" * "QuantitySold" * (1 - "Discount" / 100.0)) AS total_net_revenue
FROM dataset_ecomm
GROUP BY
    EXTRACT(YEAR FROM "PurchaseDate"::DATE),
    EXTRACT(MONTH FROM "PurchaseDate"::DATE)
ORDER BY year, month;


-- ============================================================
-- INSIGHT / OBSERVATION
-- ============================================================

-- 1. Total Net Revenue dihitung setelah memperhitungkan diskon
--    pada setiap transaksi.Dengan Top revenue sebesar 42664.5 dari produk Refrigenerator

-- 2. Berdasarkan hasil query, bulan dengan Total Net Revenue
--    tertinggi adalah Oktober 2023 sebesar 315329.68.

-- 3. DATE_TRUNC() berhasil digunakan untuk mengelompokkan
--    transaksi per bulan.

-- 4. EXTRACT() menghasilkan Tahun dan Bulan yang sesuai
--    dengan hasil pengelompokan DATE_TRUNC().

-- ============================================================
-- Penjelasan STUDI KASUS 2
-- ============================================================

-- DATE_TRUNC() digunakan untuk mengelompokkan transaksi
-- berdasarkan bulan.

-- EXTRACT() digunakan untuk mengambil Tahun dan Bulan
-- sebagai validasi hasil grouping.

-- Net Revenue dihitung setelah memperhitungkan diskon.



-- ============================================================================================================================
-- 															STUDI KASUS 3
-- 													Time Filter dengan ADD/SUB Interval
-- ============================================================================================================================

-- Soal 1
-- Menampilkan transaksi 7 hari terakhir dari tanggal paling akhir pada dataset

SELECT *
FROM dataset_ecomm
WHERE "PurchaseDate"::DATE >= (
    SELECT MAX("PurchaseDate"::DATE)
    FROM dataset_ecomm
) - interval '6 days';


-- Soal 2
-- Menampilkan waktu sistem menggunakan NOW()

SELECT
    NOW() AS current_time;


-- Menampilkan waktu sistem menggunakan CURRENT_TIMESTAMP
   
SELECT
    CURRENT_TIMESTAMP AS current_timestamp;


-- ============================================================
-- INSIGHT / OBSERVATION
-- ============================================================

-- 1. Query berhasil menampilkan transaksi selama 7 hari terakhir
--    berdasarkan tanggal maksimum pada dataset.

-- 2. Berdasarkan hasil query terdapat 8 transaksi
--    pada periode tersebut.

-- 3. NOW() dan CURRENT_TIMESTAMP menampilkan
--    waktu sistem PostgreSQL saat query dijalankan.
   
   
   
   
-- ============================================================================================================================
-- 																STUDI KASUS 4
-- 															  SUBQUERY DAN CTE
-- ============================================================================================================================

-- Soal 1
-- Menampilkan transaksi dengan Price di atas rata-rata Price

SELECT *
FROM dataset_ecomm
WHERE "Price" > (
	SELECT AVG("Price")
	FROM dataset_ecomm);


-- Soal 2
-- Menggunakan CTE untuk mencari Net Revenue di atas rata-rata

WITH revenue AS (
    SELECT *,
           ("Price" * "QuantitySold" * (1 - "Discount" / 100.0)) AS net_revenue
    FROM dataset_ecomm
)
SELECT *
FROM revenue
WHERE net_revenue > (
    SELECT AVG(net_revenue)
    FROM revenue
);


-- ============================================================
-- INSIGHT / OBSERVATION
-- ============================================================

-- 1. Terdapat 482 transaksi dengan Price
--    di atas rata-rata harga produk.

-- 2. Terdapat 378 transaksi dengan Net Revenue
--    di atas rata-rata Net Revenue.

-- 3. Penggunaan CTE membuat proses perhitungan
--    Net Revenue menjadi lebih sederhana dan mudah dipahami.




-- ============================================================================================================================
-- 													STUDI KASUS 5
-- 												WINDOW FUNCTION (RANK)
-- ============================================================================================================================

-- Soal 1
-- Ranking Top 10 Produk berdasarkan QuantitySold

SELECT *
FROM (
    SELECT
        "ProductID",
        "ProductName",
        SUM("QuantitySold") AS total_quantity,
        RANK() OVER (ORDER BY SUM("QuantitySold") DESC) AS ranking
    FROM dataset_ecomm
    GROUP BY "ProductID", "ProductName"
) AS t
WHERE ranking <= 10;


-- Soal 2
-- Ranking Top 3 Produk pada setiap Category
SELECT *
FROM (
    SELECT
        "Category",
        "ProductID",
        "ProductName",
        SUM("QuantitySold") AS total_quantity,
        RANK() OVER (
            PARTITION BY "Category"
            ORDER BY SUM("QuantitySold") DESC
        ) AS ranking
    FROM dataset_ecomm
    GROUP BY "Category", "ProductID", "ProductName"
) AS t
WHERE ranking <= 3
ORDER BY "Category", ranking;



-- ============================================================
-- INSIGHT / OBSERVATION
-- ============================================================

-- 1. Ranking global menunjukkan 10 produk
--    dengan QuantitySold tertinggi.
-- 	  Berdasarkan hasil query, terdapat 10 produk dengan
--    penjualan tertinggi dan semua memperoleh rangking 1.

-- 2. Ranking Top 3 per Category berada pada category Beauty,Clothing, Electronics, Home & Garden, dan Sports

