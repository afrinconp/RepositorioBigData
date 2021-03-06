# Capitulo 5

#Alterar Tablas

# El codigo para crear una ALTER TABLE es simple:

# Se crea una alter table que se llama

ALTER TABLE bird_families
ADD COLUMN order_id INT;

CREATE TABLE test.birds_new LIKE birds;

# El codigo LIKE crea uan copia de una tabla, que en el caso anterior es una copia de la tabla birds

DESCRIBE test.birds_new;

DESCRIBE birds;

USE test;

DESCRIBE birds_new;

INSERT INTO birds_new
SELECT * FROM rookery.birds;

#En el codigo anterior se inserto la tabla birds que esta en el dataset de rookery

SELECT * FROM birds_new;

CREATE TABLE birds_new_alternative
SELECT * FROM rookery.birds;

SELECT * FROM birds_new_alternative;

DROP TABLE birds_new_alternative;

# La siguiente linea agrega una columna a la tabla birds_new

ALTER TABLE birds_new
ADD COLUMN wing_id CHAR(2);

DESCRIBE birds_new;

ALTER TABLE birds_new
DROP COLUMN wing_id;

DESCRIBE birds_new;

#Se agrega la tabla birds_new de nuevo despues de family_id

ALTER TABLE birds_new
ADD COLUMN wing_id CHAR(2) AFTER family_id;

DESCRIBE birds_new;

ALTER TABLE birds_new
ADD COLUMN body_id CHAR(2) AFTER wing_id,
ADD COLUMN bill_id CHAR(2) AFTER body_id,
ADD COLUMN endangered BIT DEFAULT b'1' AFTER bill_id,
CHANGE COLUMN common_name common_name VARCHAR(255);

#BIT. Esto almacena un bit, que toma valores de cualquier conjunto o desarmado: básicamente, 1 o 0. Usaremos esto para indicar si una especie 
#está en peligro o no. Observe que especificamos un valor predeterminado para esta columna con la palabra clave DEFAULT seguido del valor predeterminado.

#CHANGE COLUMN cambia las caracgteristicas como de VARCHAR.

DESCRIBE birds_new;

UPDATE birds_new SET endangered = 0
WHERE bird_id IN(1,2,4,5);

SELECT * FROM birds_new;

SELECT * FROM birds_new
WHERE NOT endangered;

ALTER TABLE birds_new
MODIFY COLUMN endangered
ENUM('Extinct',
'Extinct in Wild',
'Threatened - Critically Endangered',
'Threatened - Endangered',
'Threatened - Vulnerable',
'Lower Risk - Conservation Dependent',
'Lower Risk - Near Threatened',
'Lower Risk - Least Concern')
AFTER family_id;

UPDATE birds_new
SET endangered = 7;

#Columnas dinamicas 

USE birdwatchers;

CREATE TABLE surveys
(survey_id INT AUTO_INCREMENT KEY,
survey_name VARCHAR(255));

CREATE TABLE survey_questions
(question_id INT AUTO_INCREMENT KEY,
survey_id INT,
question VARCHAR(255),
choices BLOB);

#BLOB se utiliza para una columna dinamica

CREATE TABLE survey_answers
(answer_id INT AUTO_INCREMENT KEY,
human_id INT,
question_id INT,
date_answered DATETIME,
answer VARCHAR(255));

INSERT INTO surveys (survey_name)
VALUES("Favorite Birding Location");

INSERT INTO survey_questions
(survey_id, question, choices)
VALUES(LAST_INSERT_ID(),
"What's your favorite setting for bird-watching?",
COLUMN_CREATE('1', 'forest', '2', 'shore', '3', 'backyard') );

INSERT INTO surveys (survey_name)
VALUES("Preferred Birds");

INSERT INTO survey_questions
(survey_id, question, choices)
VALUES(LAST_INSERT_ID(),
"Which type of birds do you like best?",
COLUMN_CREATE('1', 'perching', '2', 'shore', '3', 'fowl', '4', 'rapture') );

#Se usa COLUMN_CREATE( ) para crear listas enumeradas de opciones. Cada opcion tiene un key y un valor. Entonces en 

SELECT COLUMN_GET(choices, 3 AS CHAR)
AS 'Location'
FROM survey_questions
WHERE survey_id = 1;

INSERT INTO survey_answers
(human_id, question_id, date_answered, answer)
VALUES
(29, 1, NOW(), 2),
(29, 2, NOW(), 2),
(35, 1, NOW(), 1),
(35, 2, NOW(), 1),
(26, 1, NOW(), 2),
(26, 2, NOW(), 1),
(27, 1, NOW(), 2),
(27, 2, NOW(), 4),
(16, 1, NOW(), 3),
(3, 1, NOW(), 1),
(3, 2, NOW(), 1);

SELECT IFNULL(COLUMN_GET(choices, answer AS CHAR), 'total')
AS 'Birding Site', COUNT(*) AS 'Votes'
FROM survey_answers
JOIN survey_questions USING(question_id)
WHERE survey_id = 1
AND question_id = 1
GROUP BY answer WITH ROLLUP;

# Optional Changes

# Establecer el valor predeterminado de una columna

CREATE TABLE rookery.conservation_status
(status_id INT AUTO_INCREMENT PRIMARY KEY,
conservation_category CHAR(10),
conservation_state CHAR(25) );

INSERT INTO rookery.conservation_status
(conservation_category, conservation_state)
VALUES('Extinct','Extinct'),
('Extinct','Extinct in Wild'),
('Threatened','Critically Endangered'),
('Threatened','Endangered'),
('Threatened','Vulnerable'),
('Lower Risk','Conservation Dependent'),
('Lower Risk','Near Threatened'),
('Lower Risk','Least Concern');

SELECT * FROM rookery.conservation_status;

ALTER TABLE birds_new
CHANGE COLUMN endangered conservation_status_id INT DEFAULT 8;

SELECT * FROM birds_new;

SHOW COLUMNS FROM birds_new LIKE 'conservation_status_id';

ALTER TABLE birds_new
ALTER conservation_status_id DROP DEFAULT;

# Establecer el valor predeterminado de una columna

SELECT auto_increment
FROM information_schema.tables
WHERE table_name = 'birds';

USE rookery;

ALTER TABLE birds
AUTO_INCREMENT = 10;

#Otros metodos de alterar y crear tablas

CREATE TABLE birds_new LIKE birds;

DESCRIBE birds;

DESCRIBE birds_new;

SELECT * FROM birds_new;

SHOW CREATE TABLE birds;

ALTER TABLE birds_new
AUTO_INCREMENT = 6;

CREATE TABLE birds_details
SELECT bird_id, description
FROM birds;

DESCRIBE birds_details;

ALTER TABLE birds
DROP COLUMN description;

# Renombrando Tablas

RENAME TABLE rookery.birds TO rookery.birds_old,
test.birds_new TO rookery.birds;

SHOW TABLES IN rookery LIKE 'birds%';

DROP TABLE birds_old;

SELECT * FROM country_codes
LIMIT 5;

ALTER TABLE country_codes
ORDER BY country_code;

SELECT * FROM
country_codes LIMIT 5;

SELECT * FROM country_codes
ORDER BY country_name
LIMIT 5;

#Indexes

ALTER TABLE conservation_status
CHANGE status_id conservation_status_id INT AUTO_INCREMENT PRIMARY KEY;

SHOW INDEX FROM birdwatchers.humans;

EXPLAIN SELECT * FROM birdwatchers.humans
WHERE name_last = 'Hollar';

ALTER TABLE birdwatchers.humans
ADD INDEX human_names (name_last, name_first);

SHOW CREATE TABLE birdwatchers.humans;

SHOW INDEX FROM birdwatchers.humans
WHERE Key_name = 'human_names';

EXPLAIN SELECT * FROM birdwatchers.humans
WHERE name_last = 'Hollar';

ALTER TABLE conservation_status
DROP PRIMARY KEY,
CHANGE status_id conservation_status_id INT PRIMARY KEY AUTO_INCREMENT;