<?php
// Fungsi untuk membuat koneksi ke database
function connectToDatabase() {
    $servername = "localhost";
    $username = "username"; // Ganti dengan username Anda
    $password = "password"; // Ganti dengan password Anda
    $dbname = "db_mybank"; // Ganti dengan nama database Anda

    // Buat koneksi
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Periksa koneksi
    if ($conn->connect_error) {
        die("Koneksi gagal: " . $conn->connect_error);
    }

    return $conn;
}

// Fungsi untuk membuat data nasabah baru
function createNasabah($nama, $alamat, $jenis_kelamin, $tanggal_lahir, $saldo) {
    $conn = connectToDatabase();
    $query = "INSERT INTO Nasabah (nama, alamat, jenis_kelamin, tanggal_lahir, saldo) VALUES ('$nama', '$alamat', '$jenis_kelamin', '$tanggal_lahir', '$saldo')";
    $result = $conn->query($query);
    $conn->close();
    return $result;
}

// Fungsi untuk membaca data nasabah
function readNasabah() {
    $conn = connectToDatabase();
    $query = "SELECT * FROM Nasabah";
    $result = $conn->query($query);
    $conn->close();
    return $result;
}

// Fungsi untuk memperbarui data nasabah
function updateNasabah($id_nasabah, $saldo_baru) {
    $conn = connectToDatabase();
    $query = "UPDATE Nasabah SET saldo = '$saldo_baru' WHERE id_nasabah = $id_nasabah";
    $result = $conn->query($query);
    $conn->close();
    return $result;
}

// Fungsi untuk menghapus data nasabah
function deleteNasabah($id_nasabah) {
    $conn = connectToDatabase();
    $query = "DELETE FROM Nasabah WHERE id_nasabah = $id_nasabah";
    $result = $conn->query($query);
    $conn->close();
    return $result;
}

// Fungsi untuk membuat data laporan baru
function createLaporan($id_nasabah, $tanggal_laporan, $total_transaksi, $saldo_awal, $saldo_akhir) {
    $conn = connectToDatabase();
    $query = "INSERT INTO Laporan (id_nasabah, tanggal_laporan, total_transaksi, saldo_awal, saldo_akhir) VALUES ($id_nasabah, '$tanggal_laporan', $total_transaksi, '$saldo_awal', '$saldo_akhir')";
    $result = $conn->query($query);
    $conn->close();
    return $result;
}

// Fungsi untuk membaca data laporan
function readLaporan() {
    $conn = connectToDatabase();
    $query = "SELECT * FROM Laporan";
    $result = $conn->query($query);
    $conn->close();
    return $result;
}

// Fungsi untuk memperbarui data laporan
function updateLaporan($id_laporan, $saldo_akhir_baru) {
    $conn = connectToDatabase();
    $query = "UPDATE Laporan SET saldo_akhir = '$saldo_akhir_baru' WHERE id_laporan = $id_laporan";
    $result = $conn->query($query);
    $conn->close();
    return $result;
}

// Fungsi untuk menghapus data laporan
function deleteLaporan($id_laporan) {
    $conn = connectToDatabase();
    $query = "DELETE FROM Laporan WHERE id_laporan = $id_laporan";
    $result = $conn->query($query);
    $conn->close();
    return $result;
}

// Fungsi untuk membuat data passbook print baru
function createPassbookPrint($id_nasabah, $tanggal_print, $transaksi_terakhir, $saldo_terakhir) {
    $conn = connectToDatabase();
    $query = "INSERT INTO Passbook_Print (id_nasabah, tanggal_print, transaksi_terakhir, saldo_terakhir) VALUES ($id_nasabah, '$tanggal_print', '$transaksi_terakhir', '$saldo_terakhir')";
    $result = $conn->query($query);
    $conn->close();
    return $result;
}

// Fungsi untuk membaca data passbook print
function readPassbookPrint() {
    $conn = connectToDatabase();
    $query = "SELECT * FROM Passbook_Print";
    $result = $conn->query($query);
    $conn->close();
    return $result;
}

// Fungsi untuk memperbarui data passbook print
function updatePassbookPrint($id_print, $saldo_terakhir_baru) {
    $conn = connectToDatabase();
    $query = "UPDATE Passbook_Print SET saldo_terakhir = '$saldo_terakhir_baru' WHERE id_print = $id_print";
    $result = $conn->query($query);
    $conn->close();
    return $result;
}

// Fungsi untuk menghapus data passbook print
function deletePassbookPrint($id_print) {
    $conn = connectToDatabase();
    $query = "DELETE FROM Passbook_Print WHERE id_print = $id_print";
    $result = $conn->query($query);
    $conn->close();
    return $result;
}

// Fungsi untuk membaca data rekapitulasi
function readRekapitulasi() {
    $conn = connectToDatabase();
    $query = "SELECT * FROM Rekapitulasi";
    $result = $conn->query($query);
    $conn->close();
    return $result;
}

// Fungsi untuk membaca data transaksi
function readTransaksi() {
    $conn = connectToDatabase();
    $query = "SELECT * FROM Transaksi";
    $result = $conn->query($query);
    $conn->close();
    return $result;
}

// Fungsi untuk membaca data saldo nasabah view
function readSaldoNasabahView() {
    $conn = connectToDatabase();
    $query = "SELECT * FROM Saldo_Nasabah_View";
    $result = $conn->query($query);
    $conn->close();
    return $result;
}
?>
