CREATE DATABASE HospitalDB;
USE HospitalDB;

CREATE TABLE Patients (
    Patient_ID INT AUTO_INCREMENT PRIMARY KEY,
    Full_Name VARCHAR(100),
    Phone VARCHAR(20),
    Age INT,
    Address VARCHAR(255)
);
DELIMITER //
CREATE PROCEDURE SeedPatients()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 500000 DO
        INSERT INTO Patients (Full_Name, Phone, Age, Address)
        VALUES (
            CONCAT('Patient ', i),
            CONCAT('090', LPAD(i, 7, '0')),
            FLOOR(RAND()*100),
            'Ho Chi Minh City'
        );
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

CALL SeedPatients();
