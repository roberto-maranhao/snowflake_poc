# Function to calculate order total with tax
resource "snowflake_function" "calculate_order_total_with_tax" {
  database = var.database_name
  schema   = var.schema_name
  name     = "CALCULATE_ORDER_TOTAL_WITH_TAX"
  comment  = "Calculates order total including tax"

  language = "SQL"

  arguments {
    name = "BASE_AMOUNT"
    type = "DECIMAL(10,2)"
  }

  arguments {
    name = "TAX_RATE"
    type = "DECIMAL(5,4)"
  }

  return_type = "DECIMAL(10,2)"

  statement = "BASE_AMOUNT * (1 + TAX_RATE)"
}

# Function with default parameter
resource "snowflake_function" "calculate_order_total_with_default_tax" {
  database = var.database_name
  schema   = var.schema_name
  name     = "CALCULATE_ORDER_TOTAL_WITH_DEFAULT_TAX"
  comment  = "Calculates order total with default tax rate"

  language = "SQL"

  arguments {
    name = "BASE_AMOUNT"
    type = "DECIMAL(10,2)"
  }

  return_type = "DECIMAL(10,2)"

  statement = "BASE_AMOUNT * 1.0825" # 8.25% tax rate
}