--1. Ketikkan  kode  program  untuk  membuat  salinan  tabel d_typedan  beri  nama  tabel tersebut copy_d_type!

CREATE TABLE copy_d_types AS
SELECT * FROM d_types;

--2. Buat package manage_songs_pkgyang berisi kode program berikut: 
--a.Procedure add_music_typeuntuk menambahkan baris data pada tabel copy_d_type.
--b.Function song_typeuntuk menampilkan output berupa deskripsi lagu dengan input judul lagu. 
--c.Function untuk menghitung jumlah unique tipe lagu yang ada di dalam tabel songs.
--Catatan: semua procedure dan function harus bisa diakses dari luar package.

CREATE OR REPLACE PACKAGE manage_songs_pkg 
IS
PROCEDURE add_music_type
(p_code IN d_types.code%TYPE,
p_description IN d_types.description%TYPE);
FUNCTION song_type
(p_title d_songs.title%TYPE) RETURN VARCHAR2;
PROCEDURE unique_code;
END manage_songs_pkg;

CREATE OR REPLACE PACKAGE BODY manage_songs_pkg IS
PROCEDURE add_music_type
(p_code IN d_types.code%TYPE,
p_description IN d_types.description%TYPE) 
IS BEGIN
INSERT INTO copy_d_types(code, description)
VALUES(p_code, p_description);
END add_music_type;
FUNCTION song_type (p_title d_songs.title%TYPE) RETURN VARCHAR2 IS
v_description d_types.description%TYPE;
BEGIN
select description INTO 
v_description FROM 
d_songs e join copy_d_types d
ON e.type_code = d.code
WHERE title = p_title;
RETURN (v_description);
END song_type;
PROCEDURE unique_code IS
v_hasil NUMBER;
BEGIN
SELECT COUNT(DISTINCT type_code) INTO
v_hasil
from d_songs;
DBMS_OUTPUT.PUT_LINE(' The Number of unique songs type is ' || v_hasil);
END unique_code;
END manage_songs_pkg;

--3. Buat  kode  program  untuk  memanggil  procedure add_music_typedengan  memasukkan dua input yaitu code = 100 dan description = Dangdut:

BEGIN
manage_songs_pkg.add_music_type(100, 'Dangdut');
END;

--4. Buatlah kode program untuk mengeksekusi function song_type!Jika diberikan input: Coast to Coast

DECLARE
o_hasil VARCHAR2(50);
BEGIN
o_hasil := manage_songs_pkg.song_type('Its Finally Over');
DBMS_OUTPUT.PUT_LINE('Output = ' || o_hasil);
END;

--5. Buatlah kode program untuk mengeksekusi function unique_song_type!

BEGIN
manage_songs_pkg.unique_code;
END;

--6. Buatlah  tabel log_delete_datayang  harus  memiliki  kolom  dengan  tipe  data  sebagai berikut user_idvarchar2, logon_datedate, codenumber, dan descriptionvarchar2!

CREATE TABLE log_delete_data(
user_id VARCHAR2(20),
logon_date DATE,
code NUMBER,
description VARCHAR2(50));

--7. Buatlah row level trigger copy_d_type_triggeryang secara otomatis dijalankan setelah user menghapus data dari tabel copy_d_type! Trigger copy_d_type_triggerdapat mencatat data ke dalam tabel log_delete_data. Data yang dicatat yaitu: user, tanggal menghapus data, data yang dihapus (code dan description). 

CREATE OR REPLACE TRIGGER copy_d_types_trigger
AFTER DELETE ON copy_d_types FOR EACH ROW
BEGIN
INSERT INTO log_delete_data(user_id, logon_date, code, description)
VALUES (user, sysdate, :OLD.code, :OLD.description);
END;

--8. Buatlah   kode   program   untuk   menghapus   data   dengan   code   =   100   pada   tabel copy_d_type!

DELETE FROM copy_d_types
WHERE code = 100;

--9. Buatlah kode program untuk menampilkan baris data dari tabel log_delete_data!

SELECT * FROM log_delete_data;

--10. Buatlah kode program untuk menghapus package manage_songs_pkg!DROP PACKAGE manage_songs_pkg

DROP PACKAGE manage_songs_pkg;

--11. Buatlah kode program untuk menghapus trigger copy_d_type_trigger!

DROP TRIGGER copy_d_types_trigger;
