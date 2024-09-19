# Project Documentation: Data Cleaning and Transformation

Advanced SQL Techniques: Data Retrieval, Aggregation, and Cleaning

## 1. Project Overview
This project demonstrates the process of data cleaning and transformation using SQL queries. It covers basic and intermediate SQL operations, including data retrieval, aggregation, joins, and data standardization.

## 2. Tools Used
Database Management System: MySQL
Tools: SQL queries for data manipulation and transformation
## 3. Database Schema
Tables:

#### employee_demographics: Contains employee demographic information.
#### employee_salary: Contains employee salary data.
#### parks_departments: Contains department information.
#### layoffs: Contains raw data on layoffs.
#### layoffs_staging: Temporary table for staging data during the cleaning process.
#### layoffs_staging2: Final staging table with cleaned data.
## Relationships:

employee_demographics and employee_salary are joined on employee_id.
employee_salary and parks_departments are joined on dept_id.
layoffs data is cleaned and transformed without explicit relational constraints.



