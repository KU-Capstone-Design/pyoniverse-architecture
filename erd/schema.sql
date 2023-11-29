DROP TABLE IF EXISTS event_images;
DROP TABLE IF EXISTS event_image_types;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS product_bests;
DROP TABLE IF EXISTS product_brands;
DROP TABLE IF EXISTS product_events;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS brands;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories(
    id INTEGER NOT NULL UNIQUE PRIMARY KEY,
    slug VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(20) NOT NULL UNIQUE,
    description VARCHAR(50)
) engine=InnoDB;

CREATE TABLE products(
    id INTEGER NOT NULL UNIQUE PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    image VARCHAR(200),
    price REAL NOT NULL,
    good_count INTEGER NOT NULL,
    view_count INTEGER NOT NULL,
    CHECK (good_count >= 0 AND view_count >= 0 AND price >= 0.0),
    CONSTRAINT check_url_format CHECK ((image IS NULL) OR (image REGEXP '^(https?|ftp)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]$'))
) engine=InnoDB;

CREATE TABLE brands(
    id INTEGER NOT NULL UNIQUE PRIMARY KEY,
    slug VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL UNIQUE,
    image VARCHAR(200),
    CONSTRAINT check_url_format CHECK ((image IS NULL) OR (image REGEXP '^(https?|ftp)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]$'))
) engine=InnoDB;

CREATE TABLE product_events(
    id INTEGER NOT NULL UNIQUE PRIMARY KEY,
    slug VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(20) NOT NULL UNIQUE,
    description VARCHAR(100)
) engine=InnoDB;

CREATE TABLE product_bests(
    product_id INTEGER NOT NULL UNIQUE,
    brand_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    price REAL NOT NULL,
    PRIMARY KEY (product_id, brand_id, event_id),
    FOREIGN KEY (product_id) REFERENCES products (id),
    FOREIGN KEY (brand_id) REFERENCES brands (id),
    FOREIGN KEY (event_id) REFERENCES product_events (id),
    CHECK (price >= 0.0)
) engine=InnoDB;

CREATE TABLE product_brands(
    product_id INTEGER NOT NULL,
    brand_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    price REAL NOT NULL,
    event_price REAL,
    PRIMARY KEY (product_id, brand_id, event_id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (brand_id) REFERENCES brands(id),
    FOREIGN KEY (event_id) REFERENCES product_events(id),
    CHECK (price >= 0.0),
    CHECK (event_price IS NULL OR event_price >= 0.0)
) engine=InnoDB;

CREATE TABLE events(
    id INTEGER NOT NULL UNIQUE PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    start_at DATE NOT NULL,
    end_at DATE NOT NULL,
    good_count INTEGER NOT NULL,
    view_count INTEGER NOT NULL,
    CHECK (good_count >= 0 AND view_count >= 0)
) engine=InnoDB;

CREATE TABLE event_image_types(
    name VARCHAR(10) NOT NULL UNIQUE PRIMARY KEY
) engine=InnoDB;

CREATE TABLE event_images(
    event_id INTEGER NOT NULL,
    image_type VARCHAR(10) NOT NULL,
    url VARCHAR(200) NOT NULL UNIQUE,
    PRIMARY KEY (event_id, image_type, url),
    FOREIGN KEY (event_id) REFERENCES events(id),
    FOREIGN KEY (image_type) REFERENCES event_image_types(name),
    CONSTRAINT check_url_format CHECK (url REGEXP '^(https?|ftp)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]$')
) engine=InnoDB;