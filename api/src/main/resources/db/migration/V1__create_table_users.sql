CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    logon VARCHAR(60) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;