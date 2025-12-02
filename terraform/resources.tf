# Database
resource "snowflake_database" "main" {
  name         = var.database_name
  comment      = "Main database for ${var.environment} environment"
  
  data_retention_time_in_days = var.environment == "prod" ? 90 : 30
}

# Warehouse
resource "snowflake_warehouse" "main" {
  name           = var.warehouse_name
  warehouse_size = var.warehouse_size
  
  auto_suspend = 60
  auto_resume  = true
  
  comment = "Main warehouse for ${var.environment} environment"
  
  warehouse_type                = "STANDARD"
  max_cluster_count            = var.environment == "prod" ? 3 : 1
  min_cluster_count            = 1
  scaling_policy               = "STANDARD"
  resource_monitor             = var.environment == "prod" ? snowflake_resource_monitor.main[0].name : null
}

# Resource Monitor (for production only)
resource "snowflake_resource_monitor" "main" {
  count = var.environment == "prod" ? 1 : 0
  
  name           = "${var.warehouse_name}_MONITOR"
  credit_quota   = 1000
  frequency      = "MONTHLY"
  start_timestamp = "IMMEDIATELY"
  
  notify_triggers                = [80, 90]
  suspend_trigger               = 95
  suspend_immediate_trigger     = 100
  
  notify_users                  = []
}

# Schemas
resource "snowflake_schema" "schemas" {
  for_each = toset(var.schemas)
  
  database = snowflake_database.main.name
  name     = each.value
  comment  = "${each.value} schema for ${var.environment} environment"
  
  data_retention_time_in_days = var.environment == "prod" ? 90 : 30
}

# Roles
resource "snowflake_account_role" "app_role" {
  name    = "${upper(var.environment)}_APP_ROLE"
  comment = "Application role for ${var.environment} environment"
}

resource "snowflake_account_role" "read_role" {
  name    = "${upper(var.environment)}_READ_ROLE"
  comment = "Read-only role for ${var.environment} environment"
}

# Database privileges
resource "snowflake_grant_privileges_to_account_role" "app_role_database_usage" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.app_role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.main.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "read_role_database_usage" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.read_role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.main.name
  }
}

# Schema privileges
resource "snowflake_grant_privileges_to_account_role" "app_role_schema_all" {
  for_each = toset(var.schemas)
  
  privileges        = ["ALL"]
  account_role_name = snowflake_account_role.app_role.name
  on_schema {
    schema_name = "\"${snowflake_database.main.name}\".\"${snowflake_schema.schemas[each.value].name}\""
  }
}

resource "snowflake_grant_privileges_to_account_role" "read_role_schema_usage" {
  for_each = toset(var.schemas)
  
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.read_role.name
  on_schema {
    schema_name = "\"${snowflake_database.main.name}\".\"${snowflake_schema.schemas[each.value].name}\""
  }
}

# Warehouse privileges
resource "snowflake_grant_privileges_to_account_role" "app_role_warehouse_usage" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.app_role.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.main.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "read_role_warehouse_usage" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.read_role.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.main.name
  }
}

# Domain Modules - Tables and Functions

# Users module
module "users" {
  source = "./modules/users"
  
  database_name = snowflake_database.main.name
  schema_name   = snowflake_schema.schemas["PUBLIC"].name
  
  depends_on = [
    snowflake_database.main,
    snowflake_schema.schemas
  ]
}

# Products module  
module "products" {
  source = "./modules/products"
  
  database_name = snowflake_database.main.name
  schema_name   = snowflake_schema.schemas["PUBLIC"].name
  
  depends_on = [
    snowflake_database.main,
    snowflake_schema.schemas
  ]
}

# Orders module (depends on users)
module "orders" {
  source = "./modules/orders"
  
  database_name    = snowflake_database.main.name
  schema_name      = snowflake_schema.schemas["PUBLIC"].name
  users_table_name = module.users.users_table_name
  
  depends_on = [
    snowflake_database.main,
    snowflake_schema.schemas,
    module.users
  ]
}

# Views module (depends on all table modules)
module "views" {
  source = "./modules/views"
  
  database_name      = snowflake_database.main.name
  schema_name        = snowflake_schema.schemas["PUBLIC"].name
  users_table_name   = module.users.users_table_name
  orders_table_name  = module.orders.orders_table_name
  products_table_name = module.products.products_table_name
  
  depends_on = [
    snowflake_database.main,
    snowflake_schema.schemas,
    module.users,
    module.products,
    module.orders
  ]
}