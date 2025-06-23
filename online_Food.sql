-- Customers Table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

Select * From customers;

-- Insert Customers
INSERT INTO customers (name, email, phone, address) VALUES
('Alice Sharma', 'alice@example.com', '9990011111', 'Delhi'),
('Bob Singh', 'bob@example.com', '9990022222', 'Mumbai');

-- Restaurants Table
CREATE TABLE restaurants (
    restaurant_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    phone VARCHAR(15),
    status VARCHAR(10) CHECK (status IN ('open', 'closed')) DEFAULT 'open'	
);
Select * From restaurants;

-- Insert Restaurants
INSERT INTO restaurants (name, address, phone) VALUES
('Pizza Palace', 'MG Road', '8888811111'),
('Burger House', 'Linking Road', '8888822222');

-- Menu Table
CREATE TABLE menu (
    menu_id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT
);
Select * From menu;

-- Insert Menus
INSERT INTO menu (restaurant_id, name, description) VALUES
(1, 'Main Menu', 'All available pizzas'),
(2, 'Burger Menu', 'All available burgers');

-- Menu Items Table
CREATE TABLE menu_items (
    item_id SERIAL PRIMARY KEY,
    menu_id INT REFERENCES menu(menu_id) ON DELETE CASCADE,
    name VARCHAR(100),
    description TEXT,
    price NUMERIC(10,2) NOT NULL
);

Select * From menu_items;
-- Insert Menu Items
INSERT INTO menu_items (menu_id, name, description, price) VALUES
(1, 'Margherita Pizza', 'Classic cheese', 299.00),
(1, 'Farmhouse Pizza', 'Loaded with veggies', 399.00),
(2, 'Chicken Burger', 'Grilled chicken patty', 199.00);
-- Orders Table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    restaurant_id INT REFERENCES restaurants(restaurant_id),
    status VARCHAR(20) CHECK (status IN ('placed', 'accepted', 'prepared', 'out_for_delivery', 'delivered', 'cancelled')) DEFAULT 'placed',
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
Select * From orders;
-- Insert Order
INSERT INTO orders (customer_id, restaurant_id, status) VALUES
(1, 1, 'placed');

-- Order_Items Table
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    item_id INT REFERENCES menu_items(item_id),
    quantity INT CHECK (quantity > 0)
);
Select * From order_items;

-- Insert Order Items
INSERT INTO order_items (order_id, item_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1);
-- Delivery Agents Table
CREATE TABLE delivery_agents (
    agent_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    phone VARCHAR(15),
    status VARCHAR(20) CHECK (status IN ('available', 'busy', 'inactive')) DEFAULT 'available'
);
Select * From delivery_agents ;

-- Insert Delivery Agents
INSERT INTO delivery_agents (name, phone) VALUES
('Ravi Kumar', '9876512345'),
('Neha Jain', '9876523456');

-- Order Assignment Table
CREATE TABLE order_assignments (
    assignment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    agent_id INT REFERENCES delivery_agents(agent_id),
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('assigned', 'picked_up', 'delivered')) DEFAULT 'assigned'
);

Select * From  order_assignments;
-- Assign Agent
INSERT INTO order_assignments (order_id, agent_id) VALUES
(1, 1);

-- Live Location Table
CREATE TABLE agent_locations (
    location_id SERIAL PRIMARY KEY,
    agent_id INT REFERENCES delivery_agents(agent_id),
    latitude NUMERIC(9,6),
    longitude NUMERIC(9,6),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
Select * From agent_locations;

-- Insert Location
INSERT INTO agent_locations (agent_id, latitude, longitude) VALUES
(1, 28.6139, 77.2090);


-- Get all customers
SELECT * FROM customers;

-- Update customer profile
UPDATE customers SET phone = '9990099999' WHERE customer_id = 1;

-- Add new restaurant
INSERT INTO restaurants (name, address, phone) VALUES ('Tandoori Hub', 'Sector 21', '8888833333');

-- Place a new order
INSERT INTO orders (customer_id, restaurant_id, status) VALUES (2, 2, 'placed');

-- Track order status
SELECT order_id, status FROM orders WHERE customer_id = 1;

-- Assign delivery agent
INSERT INTO order_assignments (order_id, agent_id) VALUES (2, 2);

-- Track delivery location
SELECT agent_id, latitude, longitude FROM agent_locations WHERE agent_id = 1;

-- Update location
UPDATE agent_locations SET latitude = 28.6140, longitude = 77.2100, updated_at = NOW() WHERE agent_id = 1;


-- Customer ratings for restaurants
CREATE TABLE restaurant_reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    restaurant_id INT REFERENCES restaurants(restaurant_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
Select * from restaurant_reviews;

-- Customer ratings for delivery agents
CREATE TABLE agent_reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    agent_id INT REFERENCES delivery_agents(agent_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

Select * from agent_reviews ;


-- Sample Review Data
INSERT INTO restaurant_reviews (customer_id, restaurant_id, rating, review)
VALUES (1, 1, 5, 'Excellent food!');

INSERT INTO agent_reviews (customer_id, agent_id, rating, review)
VALUES (1, 1, 4, 'Polite and fast delivery');

-- Promo Code Table
CREATE TABLE promo_codes (
    promo_id SERIAL PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    discount_percent INT CHECK (discount_percent BETWEEN 1 AND 100),
    valid_from DATE,
    valid_to DATE
);

-- Order Promo Mapping
ALTER TABLE orders ADD COLUMN promo_id INT REFERENCES promo_codes(promo_id);

-- Sample Promo Code
INSERT INTO promo_codes (code, discount_percent, valid_from, valid_to)
VALUES ('WELCOME50', 50, '2025-06-01', '2025-07-01');

-- Apply promo to order
UPDATE orders SET promo_id = 1 WHERE order_id = 1;

-- Payment Table
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    amount NUMERIC(10,2),
    method VARCHAR(20) CHECK (method IN ('cash', 'card', 'wallet')),
    payment_status VARCHAR(20) CHECK (payment_status IN ('pending', 'paid', 'failed')),
    payment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Payment
INSERT INTO payments (order_id, amount, method, payment_status)
VALUES (1, 897.00, 'card', 'paid');

- Restaurant Operating Hours
CREATE TABLE restaurant_hours (
    id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurants(restaurant_id),
    day_of_week VARCHAR(10), -- e.g., 'Monday'
    open_time TIME,
    close_time TIME
);

-- Scheduled Orders
ALTER TABLE orders ADD COLUMN scheduled_time TIMESTAMP;

-- Sample Operating Hours
INSERT INTO restaurant_hours (restaurant_id, day_of_week, open_time, close_time)
VALUES (1, 'Monday', '10:00', '22:00');

-- Scheduled Order
UPDATE orders SET scheduled_time = '2025-06-25 13:30:00' WHERE order_id = 1;