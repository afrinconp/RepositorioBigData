# Capítulo 4

# Creating Databases and Tables

# Creating DataBase

CREATE DATABASE rookery;

# Eliminar la DATABASE rookery

DROP DATABASE rookery;

CREATE DATABASE rookery
CHARACTER SET latin1
COLLATE latin1_bin;


#La linea CHARACTER le dice a MySQl que los caracteres predeterminados que se usarán en las tablas de la base de datos son letras latinas y otros caracteres.
#La tercera línea le dice a MySql que el método predeterminado para obtener datos en tablas se basa en caracteres latinos binarios

SHOW DATABASES;

#Usar la database rookery

USE rookery;

# Creating Tables

CREATE TABLE birds(
bird_id INT AUTO_INCREMENT PRIMARY KEY,
scientific_name VARCHAR(255) UNIQUE,
common_name VARCHAR(50),
family_id INT,
description TEXT);

#La tabla tiene 5 columnas:
#En la primera está la columna bird_id, que el la columna primary key en donde la data será indexada.
#La opción AUTO_INCREMENT le dice a MySQL que incremente automaticamente el valor de este campo comenzará con el número 1, a menos que especifiquemos un número diferente.
#La siguiente columna contiene el nombre de cada pajaro, este podria pensarse como el primary key, pero el nombre cientifico de los pajaros puede 
#ser muy largo y a veces una mezcla de palabras latinas y griegas y no todas las personas están comodas usando palabras en estos lenguajes.
#En el VARCHAR(255), el 255 especifica el número maximo se caracteres.
#La ultima columna es lka descripción de cada ave, el TEXT significa que es una columna de ancho variable.

DESCRIBE birds;

INSERT INTO birds (scientific_name, common_name)
VALUES ('Charadrius vociferus','Killdeer'),
('Gavia immer', 'Great Northern Loon'),
('Aix sponsa', 'Wood Duck'),
('Chordeiles minor', 'Common Nighthawk'),
('Sitta carolinensis', ' White-breasted Nuthatch'),
('Apteryx mantelli', 'North Island Brown Kiwi');

SELECT * FROM birds;

CREATE DATABASE birdwatchers;

CREATE TABLE birdwatchers.humans
(human_id INT AUTO_INCREMENT PRIMARY KEY,
formal_title VARCHAR(25),
name_first VARCHAR(25),
name_last VARCHAR(25),
email_address VARCHAR(255));

INSERT INTO birdwatchers.humans
(name_first,name_last,email_address)
VALUES
('Mr.', 'Russell', 'Dyer', 'russell@mysqlresources.com'),
('Mr.', 'Richard', 'Stringer', 'richard@mysqlresources.com'),
('Ms.', 'Rusty', 'Osborne', 'rusty@mysqlresources.com'),
('Ms.', 'Lexi', 'Hollar', 'alexandra@mysqlresources.com');

CREATE TABLE bird_families (
family_id INT AUTO_INCREMENT PRIMARY KEY,
scientific_name VARCHAR(255) UNIQUE,
brief_description VARCHAR(255) );

DESCRIBE bird_families;

CREATE TABLE bird_orders (
order_id INT AUTO_INCREMENT PRIMARY KEY,
scientific_name VARCHAR(255) UNIQUE,
brief_description VARCHAR(255),
order_image BLOB
) DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

# Estamos usando UTF-8 (es decir, formato de transformación UCS, 8 bits), porque algunos de los nombres pueden incluir caracteres que no 
#forman parte del conjunto de caracteres latin1 predeterminado. Por ejemplo, si nuestro sitio ficticio de observadores de aves incluye palabras 
#en alemán, la columna breve_descripción podría aceptar las letras con diéresis sobre ellas (es decir, ä). El juego de caracteres utf8 permite 
#este tipo de letras.










