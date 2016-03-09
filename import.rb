require 'CSV'
require "pg"
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end

korning_data = []
CSV.foreach('sales.csv', headers: true) do |row|
  korning_data << row.to_hash
end

korning_data.each do |info|
  db_connection do |conn|
    conn.exec("INSERT INTO employee (name) VALUES ('#{info["employee"]}') ON CONFLICT DO NOTHING;")
    employee = conn.exec("SELECT id FROM employee WHERE employee.name = '#{info["employee"]}'").first
    employee_id = employee["id"]

    conn.exec("INSERT INTO customer_and_account_no (company) VALUES ('#{info["customer_and_account_no"]}') ON CONFLICT DO NOTHING;")
    cust = conn.exec("SELECT id FROM customer_and_account_no WHERE customer_and_account_no.company = '#{info["customer_and_account_no"]}'").first
    cust_id = cust["id"]

    conn.exec("INSERT INTO product_name (product) VALUES ('#{info["product_name"]}') ON CONFLICT DO NOTHING;")
    prod = conn.exec("SELECT id FROM product_name WHERE product_name.product = '#{info["product_name"]}'").first
    product_id = prod["id"]

    conn.exec("INSERT INTO invoice_frequency (frequency) VALUES ('#{info["invoice_frequency"]}') ON CONFLICT DO NOTHING;")
    inv = conn.exec("SELECT id FROM invoice_frequency WHERE invoice_frequency.frequency = '#{info["invoice_frequency"]}'").first
    invoice_id = inv["id"]

    conn.exec_params("INSERT INTO sales_data (sale_date, sale_amount, units_sold, invoice_no, employee_id, customer_and_account_no_id, product_name_id, invoice_frequency_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)", [info["sale_date"], info["sale_amount"], info["units_sold"], info["invoice_no"], employee_id, cust_id, product_id, invoice_id])
  end
end
