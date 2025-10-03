class ErrorUtils {
  static String friendlyMessage(Object error) {
    final text = error.toString();
    if (text.contains('Throttle') ||
        text.contains('Too Many Attempts') ||
        text.contains('429')) {
      return 'Terlalu banyak permintaan. Coba lagi beberapa detik lagi.';
    }
    if (text.contains('Failed host lookup') ||
        text.contains('SocketException')) {
      return 'Tidak bisa terhubung ke server. Periksa koneksi internet Anda.';
    }
    if (text.contains('timeout')) {
      return 'Permintaan waktu habis. Coba lagi nanti.';
    }
    if (text.contains('404')) {
      return 'Data tidak ditemukan.';
    }
    return 'Terjadi kesalahan. ${_compact(text)}';
  }

  static String _compact(String input) {
    final s = input.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ');
    return s.length > 160 ? s.substring(0, 160) + '…' : s;
  }
}
