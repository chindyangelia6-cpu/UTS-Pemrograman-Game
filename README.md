# UTS Pemrograman Game (IN-47347) — Godot 4 + GDScript

## Identitas Mahasiswa
- **Nama:** Chindita Angelia Puteri
- **NIM:** [52304110006 - 6]
- **Program Studi / Kelas:** Informatika / VII / A
- **Varian Tugas (Digit 6–7):** Collectible Kunci (`Key`) — Mengumpulkan 3 kunci membuka gerbang (`Gate`)

## Kontrol Permainan
- **W / A / S / D**: Menggerakkan karakter (`Player`) mengikuti arah kamera
- **Mouse / Panah Kiri-Kanan**: Memutar kamera 360° (`CameraPivot`)
- **Spasi**: Melompat
- **M / Tab / Tombol Settings**: Membuka/menutup panel pengaturan volume audio bus `SFX`
- **Esc / Klik Layar**: Melepas atau mengunci kembali kursor mouse

## Daftar Script (`.gd`) yang Ditambahkan / Diubah
1. `scenes/key.gd` *(Diubah)*: Mengatur animasi melayang & rotasi model kunci 3D, deteksi `Area3D` dengan `Player`, pemutaran efek suara ke audio bus `SFX`, dan pemancaran signal `key_collected`.
2. `scripts/player.gd` *(Diubah)*: Menambahkan rotasi kamera 360° (`CameraPivot`), animasi karakter (`idle`, `run`, `air_jump`), enkapsulasi jumlah kunci (`_keys`), setter `add_key()`, getter `get_keys()`, serta signal `keys_changed` dan `gate_unlocked`.
3. `scripts/hud.gd` *(Baru)*: Memperbarui label `"Kunci: n/3"` dari signal `Player` dan mengatur volume bus `SFX` menggunakan `HSlider`.
4. `scripts/world.gd` *(Baru)*: Menghubungkan signal antara 5 instance kunci (`Keys`), `Player`, `HUD`, serta menganimasikan dan menghapus gerbang (`Gate` / `StaticBody3D`) saat 3 kunci terkumpul.
