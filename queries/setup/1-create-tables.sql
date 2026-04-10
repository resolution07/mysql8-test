-- Удалим таблицы, если они уже есть (для чистоты эксперимента)
DROP TABLE IF EXISTS booking_history;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS properties;
DROP TABLE IF EXISTS users;

-- Пользователи
CREATE TABLE users
(
    id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100)                    NOT NULL,
    email      VARCHAR(150)                    NOT NULL UNIQUE,
    role       ENUM ('admin', 'host', 'guest') NOT NULL DEFAULT 'guest',
    created_at DATETIME                        NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Объекты размещения
CREATE TABLE properties
(
    id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    host_id    INT UNSIGNED     NOT NULL,
    title      VARCHAR(200)     NOT NULL,
    city       VARCHAR(100)     NOT NULL,
    price      DECIMAL(10, 2)   NOT NULL CHECK (price >= 0),
    bedrooms   TINYINT UNSIGNED NOT NULL CHECK (bedrooms >= 0),
    details    JSON,
    created_at DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES users (id) ON DELETE CASCADE,
    INDEX idx_city_price (city, price) -- индекс. Не стал далеть отдельным файлом-задачей
) ENGINE = InnoDB;

-- Бронирования
CREATE TABLE bookings
(
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    property_id INT UNSIGNED                                            NOT NULL,
    guest_id    INT UNSIGNED                                            NOT NULL,
    status      ENUM ('pending', 'confirmed', 'cancelled', 'completed') NOT NULL DEFAULT 'pending',
    start_date  DATE                                                    NOT NULL,
    end_date    DATE                                                    NOT NULL,
    created_at  DATETIME                                                NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties (id) ON DELETE CASCADE,
    FOREIGN KEY (guest_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT chk_dates CHECK (end_date >= start_date)
) ENGINE = InnoDB;

-- Платежи
CREATE TABLE payments
(
    id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    booking_id INT UNSIGNED   NOT NULL,
    amount     DECIMAL(10, 2) NOT NULL CHECK (amount >= 0),
    paid_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings (id) ON DELETE CASCADE,
    UNIQUE KEY uk_booking_id (booking_id) -- одно бронирование — один платёж
) ENGINE = InnoDB;

-- Отзывы
CREATE TABLE reviews
(
    id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    booking_id INT UNSIGNED     NOT NULL,
    rating     TINYINT UNSIGNED NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment    TEXT,
    created_at DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings (id) ON DELETE CASCADE,
    UNIQUE KEY uk_booking_id (booking_id) -- на одно бронирование один отзыв
) ENGINE = InnoDB;

-- История изменений статусов бронирований
CREATE TABLE booking_history
(
    id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    booking_id INT UNSIGNED                                            NOT NULL,
    old_status ENUM ('pending', 'confirmed', 'cancelled', 'completed'),
    new_status ENUM ('pending', 'confirmed', 'cancelled', 'completed') NOT NULL,
    changed_at DATETIME                                                NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings (id) ON DELETE CASCADE
) ENGINE = InnoDB;