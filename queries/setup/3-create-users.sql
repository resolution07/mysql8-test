-- Администратор
INSERT INTO users (name, email, role)
VALUES ('Admin User', 'admin@example.com', 'admin');

-- Хосты
INSERT INTO users (name, email, role)
VALUES ('Alice Host', 'alice@example.com', 'host'),
       ('Bob Host', 'bob@example.com', 'host'),
       ('Carol Host', 'carol@example.com', 'host');

-- Гости
INSERT INTO users (name, email, role)
VALUES ('Dave Guest', 'dave@example.com', 'guest'),
       ('Eve Guest', 'eve@example.com', 'guest'),
       ('Frank Guest', 'frank@example.com', 'guest'),
       ('Grace Guest', 'grace@example.com', 'guest'),
       ('Henry Guest', 'henry@example.com', 'guest');