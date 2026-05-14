CREATE DATABASE HospitalDB;
USE HospitalDB;

CREATE TABLE Patients (
    Patient_ID INT AUTO_INCREMENT PRIMARY KEY,
    Full_Name VARCHAR(100),
    Phone VARCHAR(20),
    Age INT,
    Address VARCHAR(255)
);

-- =========================
-- TẠO DỮ LIỆU MẪU
-- =========================

DELIMITER //

CREATE PROCEDURE SeedPatients()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 500000 DO
        INSERT INTO Patients (Full_Name, Phone, Age, Address)
        VALUES (
            CONCAT('Patient ', i),
            CONCAT('090', LPAD(i, 7, '0')),
            FLOOR(RAND() * 100),
            'Ho Chi Minh City'
        );

        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

CALL SeedPatients();

-- =========================
-- 1. ĐO TỐC ĐỘ TRUY VẤN KHI CHƯA CÓ INDEX
-- =========================

SET profiling = 1;

SELECT *
FROM Patients
WHERE Phone = '0900001000';

SHOW PROFILES;

-- =========================
-- 2. PHÂN TÍCH EXPLAIN TRƯỚC KHI TẠO INDEX
-- =========================

EXPLAIN
SELECT *
FROM Patients
WHERE Phone = '0900001000';

-- Kết quả thường sẽ là:
-- type = ALL
-- nghĩa là quét toàn bộ bảng (Full Table Scan)

-- =========================
-- 3. TẠO INDEX
-- =========================

CREATE INDEX idx_phone
ON Patients(Phone);

-- =========================
-- 4. ĐO TỐC ĐỘ TRUY VẤN SAU KHI CÓ INDEX
-- =========================

SELECT *
FROM Patients
WHERE Phone = '0900001000';

SHOW PROFILES;

-- =========================
-- 5. PHÂN TÍCH EXPLAIN SAU KHI TẠO INDEX
-- =========================

EXPLAIN
SELECT *
FROM Patients
WHERE Phone = '0900001000';

-- Kết quả thường sẽ là:
-- type = ref
-- key = idx_phone
-- nghĩa là MySQL đã sử dụng Index để tìm kiếm

-- =========================
-- 6. BÁO CÁO NHẬN XÉT
-- =========================

/*
NHẬN XÉT:

1. Khi chưa có INDEX:
- MySQL phải quét toàn bộ 500000 dòng dữ liệu.
- Tốc độ truy vấn chậm hơn.
- EXPLAIN hiển thị type = ALL.

2. Sau khi tạo INDEX:
- MySQL tìm dữ liệu nhanh hơn nhờ cây chỉ mục.
- Tốc độ truy vấn giảm đáng kể.
- EXPLAIN hiển thị key = idx_phone và type = ref.

3. Đánh đổi của INDEX:
Ưu điểm:
- Tăng tốc SELECT, WHERE, JOIN.

Nhược điểm:
- Tốn thêm bộ nhớ lưu index.
- INSERT, UPDATE, DELETE sẽ chậm hơn vì phải cập nhật index.
*/
