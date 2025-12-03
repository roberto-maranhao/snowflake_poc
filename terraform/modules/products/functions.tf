# Function to calculate order total with tax
resource "snowflake_function_sql" "calculate_order_total_with_tax" {
  database = var.database_name
  schema   = var.schema_name
  name     = "CALCULATE_ORDER_TOTAL_WITH_TAX"
  comment  = "Calculates order total including tax"

  arguments {
    arg_name      = "BASE_AMOUNT"
    arg_data_type = "DECIMAL(10,2)"
  }

  arguments {
    arg_name      = "TAX_RATE"
    arg_data_type = "DECIMAL(5,4)"
  }

  return_type = "DECIMAL(10,2)"

  function_definition = "BASE_AMOUNT * (1 + TAX_RATE)"
}

# Function with default parameter
resource "snowflake_function_sql" "calculate_order_total_with_default_tax" {
  database = var.database_name
  schema   = var.schema_name
  name     = "CALCULATE_ORDER_TOTAL_WITH_DEFAULT_TAX"
  comment  = "Calculates order total with default tax rate"

  arguments {
    arg_name      = "BASE_AMOUNT"
    arg_data_type = "DECIMAL(10,2)"
  }

  return_type = "DECIMAL(10,2)"

  function_definition = "BASE_AMOUNT * 1.0825" # 8.25% tax rate
}