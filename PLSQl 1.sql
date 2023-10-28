--1. Buatlah  program  PL/SQL  menghitung  gaji  bersih  karyawan  yang  memiliki  id  =  101 dengan ketentuan: 
-- Jika gaji <5000 maka nilai gaji bersih adalah gaji – pajak sebesar 1% dari gaji.
-- Jika gaji <10000 maka nilai gaji bersih adalah gaji –pajak sebesar 2% dari gaji.
-- Jika selaiannya, nilai gaji bersih adalah gaji –pajak sebesar 3% dari gaji.
--Gunakan tabel employees kolom salary.

DECLARE
v_emp_id employees.employee_id%TYPE;
v_salary employees.salary%TYPE;
v_gajibersih NUMBER;
BEGIN
SELECT employee_id, salary
INTO v_emp_id, v_salary
FROM employees
WHERE employee_id = 101;
IF v_salary < 5000 THEN v_gajibersih := v_salary - (0.01 * v_salary);
ELSIF v_salary < 10000 THEN v_gajibersih := v_salary - (0.02 * v_salary);
ELSE v_gajibersih := v_salary - (0.03 * v_salary);
DBMS_OUTPUT.PUT_LINE('Id Karyawan = ' || v_emp_id || ' gaji kotor = ' || v_salary || ' dan gaji setelah dipotong pajak = ' || v_gajibersih );
END IF;
END;

--Buatlah  kode  program  PL/SQL  untuk  melakukan  statemen  select  employee  yang memiliki manager id = 300. Program harus dilengkapi dengan exception handling untuk menangani kondisi error:
--Jika  statemen  select  mengembalikan  hasil  lebih  dari  satu  baris  tampilkan  pesan ‘Data  yang Anda cari tidak ditemukan.’
--Jika statemen select tidak mengembalikan hasil tampilkan pesan ‘Terdapat data lebih  dari  1 baris.’
--Selain kedua kondisi di atas tampilkan pesan ‘ Terjadi error lainnya.’ 

DECLARE
v_lname VARCHAR2(15);
BEGIN
SELECT last_name INTO v_lname
FROM employees WHERE manager_id = '300';
DBMS_OUTPUT.PUT_LINE('The lastname of manager id 300 : ' || v_lname);
EXCEPTION
WHEN TOO_MANY_ROWS THEN
DBMS_OUTPUT.PUT_LINE('terdapat data lebih dari 1 baris.');
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Data yang anda cari tidak ditemukan.');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('terjadi error lainnya.');
END;

--3.  Buatlah    code    program    PL/SQL    menggunakan cursor    with    parametersuntuk menampilkan capitol, country name, dan currency! 
--Tampilkan maksimal 5 baris output dan urutkan capitol berdasarkan alfabet. 
--Gunakan tabel countries dan currency.

DECLARE 
v_currency_name currencies.currency_name%TYPE;
CURSOR cur_country(p_region_id NUMBER ) IS 
SELECT country_id, country_name, capitol, currency_name
FROM countries c join currencies t
ON c.currency_code = t.currency_code
WHERE region_id = p_region_id
ORDER BY capitol;
v_country_record cur_country%ROWTYPE;
BEGIN
OPEN cur_country(155);
LOOP
FETCH cur_country INTO v_country_record;
EXIT WHEN cur_country%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(v_country_record.capitol ||' Is In '|| v_country_record.country_name || 'and the currency is ' || v_country_record.currency_name );
END LOOP;
CLOSE cur_country;
END;

--4.  Buatlah  code  program  PL/SQL  untuk  menampilkan  nama  profesi  (Job  title)  dan  nama karyawan yang memiliki profesi tersebut! 
--Gunakan tabel employees dan tabel jobs. 

DECLARE
CURSOR cur_job IS SELECT * FROM jobs
ORDER BY job_title;
CURSOR cur_emp (p_jobid jobs.job_id%TYPE) IS
SELECT * FROM employees WHERE job_id = p_jobid
ORDER BY first_name;
v_jobrec cur_job%ROWTYPE;
v_emprec cur_emp%ROWTYPE;
BEGIN
OPEN cur_job;
LOOP
FETCH cur_job INTO v_jobrec;
EXIT WHEN cur_job%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(v_jobrec.job_title);
OPEN cur_emp (v_jobrec.job_id);
LOOP
FETCH cur_emp INTO v_emprec;
EXIT WHEN cur_emp%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('     '||v_emprec.first_name || ' ' || v_emprec.last_name);
END LOOP;
CLOSE cur_emp;
END LOOP;
CLOSE cur_job;
END;

