-- Example schema setup
-- This file creates additional schemas for different environments

-- Analytics schema for data analysis
CREATE SCHEMA IF NOT EXISTS analytics;

-- Staging schema for ETL processes  
CREATE SCHEMA IF NOT EXISTS staging;

-- Testing schema (dev environment only)
CREATE SCHEMA IF NOT EXISTS testing;