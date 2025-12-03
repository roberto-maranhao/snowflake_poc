# Stored procedure to create a new user
resource "snowflake_procedure_sql" "create_user" {
  database = var.database_name
  schema   = var.schema_name
  name     = "CREATE_USER"
  comment  = "Creates a new user with email validation"

  arguments {
    arg_name      = "EMAIL_PARAM"
    arg_data_type = "VARCHAR(255)"
  }

  arguments {
    arg_name      = "FIRST_NAME_PARAM"
    arg_data_type = "VARCHAR(100)"
  }

  arguments {
    arg_name      = "LAST_NAME_PARAM"
    arg_data_type = "VARCHAR(100)"
  }

  return_type = "NUMBER(38,0)"

  procedure_definition = <<-SQL
    BEGIN
        -- Validate email format (basic check)
        IF (EMAIL_PARAM NOT LIKE '%@%.%') THEN
            RETURN -1;  -- Invalid email format
        END IF;
        
        -- Insert new user
        INSERT INTO ${var.database_name}.${var.schema_name}.${snowflake_table.users.name} (EMAIL, FIRST_NAME, LAST_NAME)
        VALUES (EMAIL_PARAM, FIRST_NAME_PARAM, LAST_NAME_PARAM);
        
        -- Return the new user ID
        RETURN LAST_INSERT_ID();
    EXCEPTION
        WHEN DUPLICATE_KEY_VALUE THEN
            RETURN -2;  -- Email already exists
        WHEN OTHER THEN
            RETURN -3;  -- Other error
    END;
  SQL

  depends_on = [snowflake_table.users]
}