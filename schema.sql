CREATE TABLE invoice_frequency (
  id SERIAL PRIMARY KEY,
  frequency varchar(255) UNIQUE
);

CREATE TABLE employee (
  id SERIAL PRIMARY KEY,
  name varchar(255) UNIQUE
);

CREATE TABLE customer_and_account_no (
  id SERIAL PRIMARY KEY,
  company varchar(255) UNIQUE
);

CREATE TABLE product_name (
  id SERIAL PRIMARY KEY,
  product varchar(255) UNIQUE
);

CREATE TABLE sales_data(
  id SERIAL PRIMARY KEY,
  sale_date varchar(255),
  sale_amount varchar(255),
  units_sold varchar(255),
  invoice_no varchar(255),
  employee_id INT REFERENCES employee(id),
  customer_and_account_no_id INT REFERENCES customer_and_account_no(id),
  product_name_id INT REFERENCES product_name(id),
  invoice_frequency_id INT REFERENCES invoice_frequency(id)
);
