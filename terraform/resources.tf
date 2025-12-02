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
resource "snowflake_role" "app_role" {
  name    = "${upper(var.environment)}_APP_ROLE"
  comment = "Application role for ${var.environment} environment"
}

resource "snowflake_role" "read_role" {
  name    = "${upper(var.environment)}_READ_ROLE"
  comment = "Read-only role for ${var.environment} environment"
}

# Database grants
resource "snowflake_database_grant" "app_role_usage" {
  database_name = snowflake_database.main.name
  privilege     = "USAGE"
  roles         = [snowflake_role.app_role.name]
}

resource "snowflake_database_grant" "read_role_usage" {
  database_name = snowflake_database.main.name
  privilege     = "USAGE"
  roles         = [snowflake_role.read_role.name]
}

# Schema grants
resource "snowflake_schema_grant" "app_role_all_privileges" {
  for_each = toset(var.schemas)
  
  database_name = snowflake_database.main.name
  schema_name   = snowflake_schema.schemas[each.value].name
  privilege     = "ALL"
  roles         = [snowflake_role.app_role.name]
}

resource "snowflake_schema_grant" "read_role_usage" {
  for_each = toset(var.schemas)
  
  database_name = snowflake_database.main.name
  schema_name   = snowflake_schema.schemas[each.value].name
  privilege     = "USAGE"
  roles         = [snowflake_role.read_role.name]
}

# Warehouse grants
resource "snowflake_warehouse_grant" "app_role_usage" {
  warehouse_name = snowflake_warehouse.main.name
  privilege      = "USAGE"
  roles          = [snowflake_role.app_role.name]
}

resource "snowflake_warehouse_grant" "read_role_usage" {
  warehouse_name = snowflake_warehouse.main.name
  privilege      = "USAGE"
  roles          = [snowflake_role.read_role.name]
}