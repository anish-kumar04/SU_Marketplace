-- create database SU_marketplace;
use SU_marketplace

GO

-- Down


-- Drop view if it exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'TopSellingItems')
    DROP VIEW TopSellingItems;

-- Drop user's history view if it exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'UserOrderHistory')
    DROP VIEW UserOrderHistory;

--Drop stored procedure for buying a product
IF OBJECT_ID('dbo.BuyProduct', 'P') IS NOT NULL
    DROP PROCEDURE dbo.BuyProduct;

--drop fk constraints
IF EXISTS(SELECT*FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_products_product_category_id')
    ALTER TABLE products DROP CONSTRAINT fk_products_product_category_id;

IF EXISTS(SELECT*FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_products_product_user_suid')
    ALTER TABLE products DROP CONSTRAINT fk_products_product_user_suid;

IF EXISTS(SELECT*FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_reviews_review_for_user_id')
    ALTER TABLE reviews DROP CONSTRAINT fk_reviews_review_for_user_id;

IF EXISTS(SELECT*FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_reviews_review_by_user_id')
    ALTER TABLE reviews DROP CONSTRAINT fk_reviews_review_by_user_id;

IF EXISTS(SELECT*FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_orders_order_user_suid')
    ALTER TABLE orders DROP CONSTRAINT fk_orders_order_user_suid;


--drop tables

DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS users;



-- UP metadata

-- Users Table Create SQL
-- Table Creation SQL - Users

--UP mata data
CREATE TABLE users
(
    "user_id"                int            NOT NULL    IDENTITY,
    "user_suid"              varchar(10)    NOT NULL, 
    "user_firstname"         varchar(50)    NOT NULL, 
    "user_lastname"          varchar(50)    NOT NULL, 
    "user_email"             varchar(50)    NOT NULL,
    "user_password"          varchar(20)    NOT NULL, 
    "user_primary_street"    varchar(50), 
    "user_secondary_street"  varchar(50), 
    "user_city"              varchar(20), 
    "user_state"             varchar(2), 
    "user_postal_code"       varchar(10), 
    "user_country"           varchar(50), 
    "user_degree"            varchar(50), 
    "user_major"             varchar(50), 
    "user_balance"           money            NOT NULL, 
     CONSTRAINT pk_users_user_id PRIMARY KEY (user_id),
     CONSTRAINT u_users_user_suid  UNIQUE (user_suid),
     CONSTRAINT u_users_user_email UNIQUE(user_email),
     CONSTRAINT u_users_user_password UNIQUE (user_password)
);

GO


-- Categories Table Create SQL
-- Table Creation SQL - Categories
-- didnt put unique constraint in category name yet 
CREATE TABLE categories
(
    "category_id"    int            NOT NULL    IDENTITY, 
    "category_name"  varchar(50)    NOT NULL, 
     CONSTRAINT pk_categories_category_id PRIMARY KEY (category_id),
     CONSTRAINT u_categories_category_name UNIQUE (category_name)
);
GO


-- Products Table Create SQL
-- Table Creation SQL - Products
CREATE TABLE products
(
    "product_id"           int             NOT NULL    IDENTITY, 
    "product_name"         varchar(50)     NOT NULL, 
    "product_description"  varchar(500), 
    "product_price"        money           NOT NULL,
    "product_update_date"  date            NOT NULL,
    "product_category_id"  int             NOT NULL, 
    "product_user_id"      int             NOT NULL, 
     CONSTRAINT pk_products_product_id PRIMARY KEY (product_id)
);
ALTER TABLE products
    ADD CONSTRAINT fk_products_product_category_id FOREIGN KEY (product_category_id)
        REFERENCES categories(category_id);

ALTER TABLE products
    ADD CONSTRAINT fk_products_product_user_id FOREIGN KEY (product_user_id)
        REFERENCES users(user_id);

GO

-- Reviews Table Create SQL
-- Table Creation SQL - Reviews
CREATE TABLE reviews
(
    "review_id"         int            NOT NULL    IDENTITY, 
    "review_rating"     int, 
    "review_text"       varchar(250), 
    "review_for_user_id"    int            NOT NULL,
    "review_by_user_id"     int            NOT NULL,
     CONSTRAINT pk_reviews_review_id PRIMARY KEY (review_id),
     CONSTRAINT ck_review_rating check (review_rating <6)
);
ALTER TABLE reviews
    ADD CONSTRAINT fk_reviews_review_for_user_id FOREIGN KEY (review_for_user_id)
        REFERENCES users(user_id);

ALTER TABLE reviews
    ADD CONSTRAINT fk_reviews_review_by_user_id FOREIGN KEY (review_by_user_id)
        REFERENCES users(user_id);

GO

-- Orders Table Create SQL
-- Table Creation SQL - Orders
CREATE TABLE orders
(
    "order_id"         int            NOT NULL    IDENTITY, 
    "order_date"       date           NOT NULL, 
    "order_price"      money          NOT NULL, 
    "order_type"       varchar(50)    NOT NULL, 
    "order_user_id"    int            NOT NULL, 
     CONSTRAINT pk_orders_order_id PRIMARY KEY (order_id)
);
ALTER TABLE orders
    ADD CONSTRAINT fk_orders_order_user_suid FOREIGN KEY (order_user_id)
        REFERENCES users(user_id);
GO




-- Up Data

--users data

insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '0003327880', 'Ninnette', 'Gethins', 'ngethins0@wikispaces.com', 'abc', '2 Beilfuss Pass', 'Apt 1987', 'Syracuse', 'NY', 13207, 'United States', 'Graduate Student', 'Engineering', 3028.99);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '7003032590', 'Edmon', 'O''Halloran', 'eohalloran1@timesonline.co.uk', 'shgc', '24 Summerview Hill', '20th Floor', 'Syracuse', 'NY', 13208, 'United States', 'Senior', 'History', 2956.78);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '4524469239', 'Mariette', 'Hrinishin', 'mhrinishin2@amazon.com', 'yfvgbsa', '15 Northport Circle', null, 'Syracuse', 'NY', 13201, 'United States', 'Faculty', 'Chemistry', 876.83);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '8914229192', 'Winn', 'Bidgod', 'wbidgod3@vimeo.com', 'uyegfasadfqw', '784 Surrey Road', 'Room 1307', 'Syracuse', 'NY', 13203, 'United States', 'Freshman', 'Engineering', 475.24);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '8322469503', 'Alistair', 'Barmby', 'abarmby4@engadget.com', 'ygasbwya', '9 Starling Place', 'PO Box 64662', 'Syracuse', 'NY', 13201, 'United States', 'Graduate Student', 'History', 3935.67);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '9787148872', 'Linn', 'Normanvell', 'lnormanvell5@cbc.ca', 'ygashdgvi','731 Anniversary Way', 'Room 878', 'Syracuse', 'NY', 13201, 'United States', 'Sophomore', 'Biology', 3295.61);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '3189362083', 'Jeff', 'Slator', 'jslator6@google.com.au', 'vadjsadh', '8725 David Drive', 'Suite 64', 'Syracuse', 'NY', 13205, 'United States', 'Graduate Student', 'English Literature', 4172.5);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '8203878395', 'Loralie', 'Slaten', 'lslaten7@bandcamp.com', 'asdkwia','14 Fisk Place', null, 'Syracuse', 'NY', 13210, 'United States', 'Junior', 'Sociology', 3547.24);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '4614859724', 'Nina', 'Sillis', 'nsillis8@columbia.edu', 'lijhbasv', '054 Superior Terrace', 'PO Box 72810', 'Syracuse', 'NY', 13209, 'United States', 'Freshman', 'Computer Science', 1760.09);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '2749470042', 'Wyatt', 'Plues', 'wplues9@imdb.com', 'oklsahw', '15888 Sheridan Court', null, 'Syracuse', 'NY', 13203, 'United States', 'Graduate Student', 'Chemistry', 1049.43);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '3021488879', 'Wilmette', 'Cargo', 'wcargoa@freewebs.com', 'ajshcuwjyas', '3661 Onsgard Hill', 'Room 29', 'Syracuse', 'NY', 13209, 'United States', 'Graduate Student', 'Psychology', 801.79);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '5080829114', 'Hetti', 'Letessier', 'hletessierb@vk.com', 'laksawhsbdc', '82990 Evergreen Hill', 'Apt 117', 'Syracuse', 'NY', 13203, 'United States', 'Junior', 'History', 3650.76);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '1041387075', 'Alonso', 'Scamadin', 'ascamadinc@stumbleupon.com', 'uhashcg', '52865 Randy Avenue', null, 'Syracuse', 'NY', 13206, 'United States', 'Sophomore', 'Computer Science', 220.0);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '3890363871', 'Trixy', 'Tomasek', 'ttomasekd@qq.com', 'nbxzgf', '27374 Packers Terrace', 'PO Box 80210', 'Syracuse', 'NY', 13210, 'United States', 'Junior', 'Mathematics', 2101.4);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '1278762630', 'Marquita', 'Marskell', 'mmarskelle@51.la', 'reagsdn', '62212 Evergreen Avenue', null, 'Syracuse', 'NY', 13204, 'United States', 'Freshman', 'Biology', 245.08);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '5299458577', 'Lindy', 'Pardon', 'lpardonf@netscape.com', 'nhsatyw', '98270 Algoma Park', null, 'Syracuse', 'NY', 13207, 'United States', 'Freshman', 'History', 1722.16);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '1961037928', 'Archer', 'Fawdrie', 'afawdrieg@sfgate.com', 'jscbjywshb', '440 Quincy Drive', '15th Floor', 'Syracuse', 'NY', 13201, 'United States', 'Junior', 'Chemistry', 3566.01);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '5776119421', 'Bartolomeo', 'MacGahy', 'bmacgahyh@weather.com', 'ukjasbc', '91176 West Court', null, 'Syracuse', 'NY', 13207, 'United States', 'Faculty', 'History', 3795.82);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '4374684572', 'Merv', 'Tims', 'mtimsi@lulu.com', 'kjsacbbw', '82035 Columbus Avenue', null, 'Syracuse', 'NY', 13205, 'United States', 'Junior', 'Business Administration', 3485.68);
insert into users ( user_suid, user_firstname, user_lastname, user_email, user_password, user_primary_street, user_secondary_street, user_city, user_state, user_postal_code, user_country, user_degree, user_major, user_balance) values ( '0395722917', 'Drud', 'Lindeboom', 'dlindeboomj@uol.com.br', 'iuskcjhas', '30398 Lillian Road', '9th Floor', 'Syracuse', 'NY', 13208, 'United States', 'Senior', 'Business Administration', 2766.12);

--categories

insert into categories (category_name) values ('Electronics');
insert into categories (category_name) values ('Clothing');
insert into categories (category_name) values ('Home & Kitchen');
insert into categories (category_name) values ('Books');
insert into categories (category_name) values ('Sports & Outdoors');
insert into categories (category_name) values ('Beauty');
insert into categories (category_name) values ('Toys & Games');
insert into categories (category_name) values ('Automotive');

-- products

insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ('QuantumPro Wireless Earbuds', 'Affordable and durable', 673.06, '9/7/2023', 1, 1);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'UrbanTrend Reversible Jacket', 'Limited edition item', 208.46, '9/19/2023', 2, 2);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'ChefMaster Digital Air Fryer', 'Versatile and functional', 3.77, '11/3/2023', 3, 3);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'Whispers of the Past by Emma Richardson', 'High-quality product', 964.44, '10/26/2023', 4, 4);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'TrailMaster Hiking Backpack', 'Versatile and functional', 494.28, '11/22/2023', 5, 5);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'GlowRadiance Skin Serum', 'Limited edition item', 6.28, '10/12/2023', 6, 6);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'SkyCastle Puzzle Set', 'Limited edition item', 452.05, '11/26/2023', 7, 7);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'UltraShine Car Wax', 'Trendy and stylish', 529.7, '10/31/2023', 8, 8);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'SkyView HD Drone', 'Versatile and functional', 167.14, '10/19/2023', 1, 9);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'FlexFit Yoga Pants', 'Versatile and functional', 1.49, '10/2/2023', 2, 10);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'AquaPure Water Filter Pitcher', 'Versatile and functional', 802.18, '11/20/2023', 3, 11);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'Journey Through Stars by Liam Clarke', 'Affordable and durable', 598.95, '9/28/2023', 4, 12);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'FlexGrip Yoga Mat', 'Affordable and durable', 475.54, '11/24/2023', 5, 13);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'MysticEyes Mascara', 'High-quality product', 762.52, '9/28/2023', 6, 14);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'CyberTech Gaming Console', 'Trendy and stylish', 430.53, '10/19/2023', 7, 15);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'PowerBoost Engine Cleaner', 'Limited edition item', 683.3, '11/18/2023', 8, 16);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'FlexiCharge Solar Power Bank', 'High-quality product', 280.72, '9/11/2023', 1, 17);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'BreezeComfort Summer Dress', 'Limited edition item', 469.86, '9/28/2023', 2, 18);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'CozyNest Memory Foam Pillow', 'Trendy and stylish', 104.54, '11/21/2023', 3, 19);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'The Art of Mindfulness by Sophia Lee', 'Versatile and functional', 621.51, '10/22/2023', 4, 20);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'SwiftRide Mountain Bike', 'Trendy and stylish', 929.76, '10/17/2023', 5, 1);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'SilkTouch Hair Treatment', 'Versatile and functional', 906.26, '9/1/2023', 6, 2);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'MagicWizard Board Game', 'Affordable and durable', 663.91, '10/17/2023', 7, 3);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'NightVision Dash Cam', 'Versatile and functional', 939.38, '11/17/2023', 8, 4);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'QuantumPro Wireless Earbuds', 'Trendy and stylish', 807.91, '11/23/2023', 1, 5);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'UrbanTrend Reversible Jacket', 'Limited edition item', 578.82, '9/8/2023', 2, 6);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'ChefMaster Digital Air Fryer', 'Affordable and durable', 217.19, '10/1/2023', 3, 7);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'Whispers of the Past by Emma Richardson', 'Versatile and functional', 230.85, '11/8/2023', 4, 8);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'TrailMaster Hiking Backpack', 'High-quality product', 994.56, '10/9/2023', 5, 9);
insert into products ( product_name, product_description, product_price, product_update_date, product_category_id, product_user_id) values ( 'GlowRadiance Skin Serum', 'Versatile and functional', 214.28, '9/18/2023', 6, 10);

-- orders
insert into orders (order_date, order_price, order_type, order_user_id) values ('10/6/2023', 673.06, 'Sell', 1);
insert into orders (order_date, order_price, order_type, order_user_id) values ('11/12/2023', 208.46, 'Sell', 2);
insert into orders (order_date, order_price, order_type, order_user_id) values ('10/29/2023', 3.77, 'Sell', 3);
insert into orders (order_date, order_price, order_type, order_user_id) values ('9/23/2023', 964.44, 'Sell', 4);
insert into orders (order_date, order_price, order_type, order_user_id) values ('10/30/2023', 494.28, 'Sell', 5);
insert into orders (order_date, order_price, order_type, order_user_id) values ('11/26/2023', 6.28, 'Sell', 6);
insert into orders (order_date, order_price, order_type, order_user_id) values ('10/13/2023', 452.05, 'Sell', 7);
insert into orders (order_date, order_price, order_type, order_user_id) values ('9/11/2023', 529.7, 'Sell', 8);
insert into orders (order_date, order_price, order_type, order_user_id) values ('9/30/2023', 167.14, 'Sell', 9);
insert into orders (order_date, order_price, order_type, order_user_id) values ('11/13/2023', 1.49, 'Sell', 10);
insert into orders (order_date, order_price, order_type, order_user_id) values ('10/14/2023', 802.18, 'Sell', 11);
insert into orders (order_date, order_price, order_type, order_user_id) values ('11/23/2023', 598.95, 'Sell', 12);
insert into orders (order_date, order_price, order_type, order_user_id) values ('11/29/2023', 475.54, 'Sell', 13);
insert into orders (order_date, order_price, order_type, order_user_id) values ('9/30/2023', 762.52, 'Sell', 14);
insert into orders (order_date, order_price, order_type, order_user_id) values ('10/28/2023', 430.53, 'Sell', 15);
insert into orders (order_date, order_price, order_type, order_user_id) values ('11/22/2023', 683.3, 'Sell', 16);
insert into orders (order_date, order_price, order_type, order_user_id) values ('9/6/2023', 280.72, 'Sell', 17);
insert into orders (order_date, order_price, order_type, order_user_id) values ('10/19/2023', 469.86, 'Sell', 18);
insert into orders (order_date, order_price, order_type, order_user_id) values ('10/16/2023', 104.54, 'Sell', 19);
insert into orders (order_date, order_price, order_type, order_user_id) values ('10/29/2023', 621.51, 'Sell', 20);
insert into orders (order_date, order_price, order_type, order_user_id) values ('11/12/2023', 929.76, 'Sell', 1);
insert into orders (order_date, order_price, order_type, order_user_id) values ('11/14/2023', 906.26, 'Sell', 2);
insert into orders (order_date, order_price, order_type, order_user_id) values ('9/6/2023', 663.91, 'Sell', 3);
insert into orders (order_date, order_price, order_type, order_user_id) values ('10/28/2023', 939.38, 'Sell', 4);
insert into orders (order_date, order_price, order_type, order_user_id) values ('11/21/2023', 807.91, 'Sell', 5);
insert into orders (order_date, order_price, order_type, order_user_id) values ('11/2/2023', 578.82, 'Sell', 6);
insert into orders (order_date, order_price, order_type, order_user_id) values ('9/1/2023', 217.19, 'Sell', 7);
insert into orders (order_date, order_price, order_type, order_user_id) values ('9/4/2023', 230.85, 'Sell', 8);
insert into orders (order_date, order_price, order_type, order_user_id) values ('10/26/2023', 994.56, 'Sell', 9);
insert into orders (order_date, order_price, order_type, order_user_id) values ('11/26/2023', 214.28, 'Sell', 10);


--Verify
select * from users;
select*from categories;
select*from products;
select*from orders;

GO
-- Create stored procedure for buying a product with error handling
CREATE PROCEDURE BuyProduct(
    @buyer_suid varchar(10),
    @product_id int
    )
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION; -- Start a transaction

        DECLARE @buyer_balance money;
        DECLARE @product_price money;
        DECLARE @seller_id int;
        DECLARE @seller_balance money;

        -- Get buyer's balance
        SELECT @buyer_balance = user_balance
        FROM users
        WHERE user_suid = @buyer_suid;

        -- Get product price and seller info
        SELECT @product_price = product_price,
               @seller_id = product_user_id
        FROM products
        WHERE product_id = @product_id;

        -- Check if buyer has sufficient balance
        IF @buyer_balance >= @product_price
        BEGIN
            -- Update buyer's balance (deduct product price)
            UPDATE users
            SET user_balance = @buyer_balance - @product_price
            WHERE user_suid = @buyer_suid;

            -- Update seller's balance (add product price)
            UPDATE users
            SET user_balance = user_balance + @product_price
            WHERE user_id = @seller_id;

            -- Remove the product from the products table
            DELETE FROM products
            WHERE product_id = @product_id;

            -- Perform the actual purchase (you can add more details or logs here if needed)
            INSERT INTO orders (order_date, order_price, order_type, order_user_suid)
            VALUES (GETDATE(), @product_price, 'Buy', @buyer_suid);

            COMMIT; -- Commit the transaction

            PRINT 'Purchase successful!';
        END
        ELSE
        BEGIN
            -- Rollback the transaction if there's insufficient balance
            ROLLBACK;
            PRINT 'Insufficient Balance';
        END
    END TRY
    BEGIN CATCH
        -- Rollback the transaction on error and print the error message
        ROLLBACK;
        PRINT 'An error occurred: ' + ERROR_MESSAGE();
    END CATCH
END;

GO


-- Create a view for the top 5 highest-priced items
CREATE VIEW TopSellingItems AS
    SELECT TOP 5 product_id, product_name, product_price
    FROM products
    ORDER BY product_price DESC;


GO

-- Select from the view
SELECT * FROM TopSellingItems;

GO

-- Create view for user order history
CREATE VIEW UserOrderHistory AS
SELECT order_id, order_date, order_price, order_type, order_user_id
FROM orders;

GO





