# Excel Template Guide

This document describes the Excel file format required for uploading data to the SAP RAP application.

## Template Structure

### Required Columns

Your Excel file must contain the following columns in this exact order:

| Column | Name            | Type    | Format      | Required | Description                    |
|--------|-----------------|---------|-------------|----------|--------------------------------|
| A      | Document Number | Text    | Max 10 char | Yes      | Unique document identifier     |
| B      | Document Date   | Date    | YYYY-MM-DD  | Yes      | Date of the document           |
| C      | Customer ID     | Text    | Max 10 char | Yes      | Customer identifier            |
| D      | Customer Name   | Text    | Max 80 char | No       | Full customer name             |
| E      | Amount          | Number  | Decimal     | Yes      | Transaction amount             |
| F      | Currency        | Text    | 3 char      | Yes      | Currency code (USD, EUR, etc.) |

### Header Row

The first row of your Excel file should contain column headers:

```
Document Number | Document Date | Customer ID | Customer Name | Amount | Currency
```

### Data Rows

Starting from row 2, each row represents one record to be uploaded.

## Sample Data

### Example Excel Content

```
Document Number | Document Date | Customer ID | Customer Name      | Amount   | Currency
----------------|---------------|-------------|-------------------|----------|----------
DOC0001         | 2024-01-15   | CUST001     | Acme Corporation  | 1500.00  | USD
DOC0002         | 2024-01-16   | CUST002     | Tech Solutions    | 2750.50  | EUR
DOC0003         | 2024-01-17   | CUST003     | Global Industries | 3200.75  | GBP
DOC0004         | 2024-01-18   | CUST001     | Acme Corporation  | 890.25   | USD
DOC0005         | 2024-01-19   | CUST004     | Digital Services  | 4500.00  | USD
```

## Field Specifications

### Document Number
- **Type**: Alphanumeric
- **Length**: Maximum 10 characters
- **Required**: Yes
- **Validation**: Must be unique
- **Example**: DOC0001, INV-2024-001, PO123456

### Document Date
- **Type**: Date
- **Format**: YYYY-MM-DD (ISO 8601)
- **Required**: Yes
- **Validation**:
  - Cannot be in the future
  - Must be a valid date
- **Examples**:
  - ✓ 2024-01-15
  - ✓ 2024-12-31
  - ✗ 2024-13-01 (invalid month)
  - ✗ 2025-12-31 (future date, if today is 2024)

### Customer ID
- **Type**: Alphanumeric
- **Length**: Maximum 10 characters
- **Required**: Yes
- **Validation**: Must not be empty
- **Example**: CUST001, C12345, CUSTOMER-A

### Customer Name
- **Type**: Text
- **Length**: Maximum 80 characters
- **Required**: No (optional)
- **Example**: Acme Corporation, John Doe, Tech Solutions Ltd.

### Amount
- **Type**: Decimal number
- **Format**: Up to 13 digits before decimal, 2 digits after
- **Required**: Yes
- **Validation**:
  - Must be greater than 0
  - Maximum: 9,999,999,999,999.99
- **Examples**:
  - ✓ 1500.00
  - ✓ 1500 (will be interpreted as 1500.00)
  - ✓ 1,500.50 (commas are stripped)
  - ✗ -100 (negative not allowed)
  - ✗ 0 (must be greater than zero)

### Currency
- **Type**: Text
- **Length**: 3-5 characters
- **Required**: Yes
- **Format**: ISO 4217 currency code
- **Common Values**: USD, EUR, GBP, JPY, CHF, CAD, AUD
- **Examples**:
  - ✓ USD
  - ✓ EUR
  - ✗ Dollar (must use code)
  - ✗ $ (must use code)

## Validation Rules

### During Upload

The system performs the following validations:

1. **Mandatory Field Check**
   - Document Number, Document Date, Customer ID, Amount, and Currency must be provided
   - Missing mandatory fields will cause the row to be rejected

2. **Data Type Validation**
   - Dates must be valid and in correct format
   - Amounts must be numeric
   - All fields must not exceed maximum length

3. **Business Logic Validation**
   - Document Date cannot be in the future
   - Amount must be greater than zero
   - Currency code should be valid (system dependent)

4. **Duplicate Check**
   - System may check for duplicate document numbers
   - Depending on configuration, duplicates may be rejected or updated

## Error Handling

### Common Errors

| Error Message                          | Cause                           | Solution                              |
|----------------------------------------|---------------------------------|---------------------------------------|
| "Document number is required"          | Column A is empty               | Fill in document number               |
| "Document date is mandatory"           | Column B is empty               | Provide a valid date                  |
| "Document date cannot be in future"    | Date is beyond today            | Use a past or current date            |
| "Customer ID is required"              | Column C is empty               | Fill in customer ID                   |
| "Amount must be greater than zero"     | Amount is 0 or negative         | Enter a positive amount               |
| "Currency is required"                 | Column F is empty               | Provide currency code                 |
| "Invalid date format"                  | Date not in YYYY-MM-DD format   | Correct date format                   |
| "Amount exceeds maximum value"         | Amount too large                | Reduce amount value                   |

### Error Reporting

After upload, the system will provide:
- **Success Count**: Number of successfully processed records
- **Error Count**: Number of rejected records
- **Error Details**: List of errors with row numbers and messages

## Best Practices

### Preparing Your Excel File

1. **Use the Template**
   - Start with a clean template
   - Don't add extra columns before the required ones
   - Keep column headers in row 1

2. **Data Entry**
   - Use consistent date format (YYYY-MM-DD)
   - Don't use special formatting (colors, formulas)
   - Avoid merged cells
   - Use plain text format for number columns

3. **Data Validation**
   - Check for duplicates before upload
   - Verify customer IDs exist in your system
   - Ensure currency codes are standard
   - Validate date formats

4. **File Format**
   - Save as .xlsx (Excel 2007 or later)
   - Avoid .xls (old Excel format)
   - Maximum recommended rows: 10,000 per file
   - Keep file size under 10 MB

5. **Testing**
   - Test with a small sample first
   - Verify upload results
   - Check error messages
   - Validate data in the system

### Performance Tips

- **Batch Processing**: For large datasets, split into multiple files
- **Clean Data**: Remove empty rows and columns
- **File Size**: Keep files under 10 MB for best performance
- **Network**: Use stable network connection for upload

## Example Files

### Minimal Valid Example

```
Document Number | Document Date | Customer ID | Customer Name | Amount | Currency
DOC001          | 2024-01-15   | CUST001     | Test Customer | 100.00 | USD
```

### Complete Example with Multiple Records

```
Document Number | Document Date | Customer ID | Customer Name          | Amount    | Currency
DOC001          | 2024-01-15   | CUST001     | Acme Corporation       | 1500.00   | USD
DOC002          | 2024-01-15   | CUST002     | Tech Solutions Inc     | 2750.50   | EUR
DOC003          | 2024-01-16   | CUST003     | Global Industries Ltd  | 3200.75   | GBP
DOC004          | 2024-01-16   | CUST001     | Acme Corporation       | 890.25    | USD
DOC005          | 2024-01-17   | CUST004     | Digital Services       | 4500.00   | CHF
```

## Download Template

A blank Excel template with proper formatting is available:
- Template file: `Excel_Upload_Template.xlsx` (if provided)
- Location: Project documentation folder

## Support

If you encounter issues with the Excel template:
1. Verify your file matches the template structure
2. Check validation rules above
3. Review error messages from the upload
4. Contact your system administrator for help

## Version History

- v1.0 (2024) - Initial template specification
