# Demo Files

This directory contains demonstration materials for the Excel Data Upload RAP application.

## 📁 Directory Structure

```
demo/
├── README.md                          # This file
├── DEMO_GUIDE.md                      # Complete demo walkthrough
├── simulate_upload.py                 # Python simulation script
│
├── data/                              # Sample data files
│   ├── sample_upload_template.csv     # Valid sample data (10 records)
│   ├── sample_with_errors.csv         # Data with validation errors
│   ├── results_valid.json             # Processed results (valid data)
│   └── results_with_errors.json       # Processed results (with errors)
│
└── api-examples/                      # Mock OData responses
    ├── 01-service-metadata.xml        # OData service metadata
    ├── 02-get-all-records.json        # GET response example
    ├── 03-create-record-request.json  # POST request example
    ├── 04-create-record-response.json # POST response example
    └── 05-validation-error-response.json # Error response example
```

## 🚀 Quick Start

### Run the Simulation

```bash
# From the project root directory
python3 demo/simulate_upload.py
```

This will:
1. ✅ Process valid sample data (all 10 records pass)
2. ❌ Process data with errors (2 pass, 8 fail)
3. 💾 Generate JSON result files
4. 📊 Display validation results

### View Sample Data

```bash
# View valid sample template
cat demo/data/sample_upload_template.csv

# View sample with errors
cat demo/data/sample_with_errors.csv
```

### View API Examples

```bash
# View OData service metadata
cat demo/api-examples/01-service-metadata.xml

# View sample GET response
cat demo/api-examples/02-get-all-records.json

# View validation error response
cat demo/api-examples/05-validation-error-response.json
```

## 📊 What's Demonstrated

### ✅ Valid Data Processing
File: `data/sample_upload_template.csv`
- 10 records, all valid
- Various customers (CUST001-CUST007)
- Multiple currencies (USD, EUR, GBP, CHF)
- All validation rules pass

**Result:**
```
Total Records:    10
✅ Successful:    10
❌ Failed:         0
```

### ❌ Error Handling
File: `data/sample_with_errors.csv`
- 10 records with various validation errors
- Demonstrates all validation rules

**Errors Demonstrated:**
1. ❌ Future date (DOC0012: 2026-12-31)
2. ❌ Missing customer ID (DOC0013)
3. ❌ Negative amount (DOC0014: -100.00)
4. ❌ Zero amount (DOC0015: 0.00)
5. ❌ Missing date (DOC0016)
6. ❌ Missing document number (Row 8)
7. ❌ Missing currency (DOC0017)
8. ❌ Invalid date format (DOC0019: "invalid-date")

**Result:**
```
Total Records:    10
✅ Successful:     2
❌ Failed:         8
```

## 🔍 Validation Rules

The simulation implements these validation rules (same as ABAP code):

### Mandatory Fields
- ✓ Document Number (max 10 chars)
- ✓ Document Date (YYYY-MM-DD format)
- ✓ Customer ID (max 10 chars)
- ✓ Amount (must be numeric)
- ✓ Currency (3-5 chars)

### Business Rules
- ✓ Document date cannot be in the future
- ✓ Amount must be greater than zero
- ✓ Date must be valid calendar date
- ✓ All mandatory fields must be filled

## 📝 Sample OData Requests

### Get All Records
```bash
GET /sap/opu/odata4/.../UploadData
Accept: application/json
```

### Create Record
```bash
POST /sap/opu/odata4/.../UploadData
Content-Type: application/json

{
  "DocumentNumber": "DOC0020",
  "DocumentDate": "2024-02-10",
  "CustomerId": "CUST020",
  "CustomerName": "New Customer Inc",
  "Amount": "5000.00",
  "Currency": "USD"
}
```

### Filter Records
```bash
GET /sap/opu/odata4/.../UploadData?$filter=CustomerId eq 'CUST001'
GET /sap/opu/odata4/.../UploadData?$filter=Amount gt 1000
GET /sap/opu/odata4/.../UploadData?$filter=DocumentDate ge 2024-01-01
```

## 🎓 Understanding the Results

### Success Status (S)
```json
{
  "DocumentNumber": "DOC0011",
  "Status": "S",
  "ErrorMessage": ""
}
```
- Indicates record passed all validations
- Ready to be saved to database
- No error message

### Error Status (E)
```json
{
  "DocumentNumber": "DOC0012",
  "Status": "E",
  "ErrorMessage": "Document date cannot be in the future"
}
```
- Indicates validation failure
- Will not be saved
- Error message explains the issue

### Pending Status (P)
- Used for new records before final validation
- Shown in draft mode

## 🏗️ How This Relates to the Real Application

### In This Demo
```
CSV File → Python Script → Validation → JSON Results
```

### In Real SAP Deployment
```
Excel File → Fiori UI → OData Service → ABAP RAP → HANA Database
    ↓           ↓            ↓            ↓           ↓
  Upload    User clicks   REST API    Business    Persistent
   File      Upload       Endpoint     Logic       Storage
```

## 💻 Technical Details

### Simulation Script (simulate_upload.py)
- **Language**: Python 3
- **Purpose**: Demonstrates validation logic
- **Mimics**: ABAP behavior definition validations
- **Output**: JSON files with results

### Data Files
- **Format**: CSV (representing Excel)
- **Encoding**: UTF-8
- **Structure**: Header row + data rows

### API Examples
- **Format**: JSON and XML
- **Standard**: OData V4
- **Purpose**: Show service contract

## 🔧 Customization

### Add Your Own Test Data

1. Create a new CSV file in `data/` directory
2. Use the same column structure:
   ```
   Document Number,Document Date,Customer ID,Customer Name,Amount,Currency
   ```
3. Run simulation:
   ```bash
   python3 demo/simulate_upload.py
   ```

### Modify Validation Rules

Edit `simulate_upload.py` and update the `ValidationEngine` class methods:
- `validate_document_number()`
- `validate_document_date()`
- `validate_customer_id()`
- `validate_amount()`
- `validate_currency()`

## 📖 Learn More

- **Full Demo Guide**: See `DEMO_GUIDE.md`
- **Installation**: See `../INSTALLATION.md`
- **Architecture**: See `../ARCHITECTURE.md`
- **Excel Template**: See `../EXCEL_TEMPLATE.md`

## ⚠️ Important Notes

### This is NOT a Running Application
This demo **simulates** how the application works. It does not:
- ❌ Actually run ABAP code
- ❌ Connect to SAP database
- ❌ Process real Excel files (uses CSV)
- ❌ Provide a working UI
- ❌ Execute real OData calls

### To Get a Working Application
→ Deploy the ABAP code to a real SAP system
→ Follow the instructions in `INSTALLATION.md`

## 🎯 Demo Objectives

This demo helps you:
1. ✅ Understand how the application works
2. ✅ See validation rules in action
3. ✅ Test with sample data
4. ✅ View expected API responses
5. ✅ Learn the data structure

## 🤝 Contributing

To improve the demo:
1. Add more test cases in CSV files
2. Enhance the simulation script
3. Add more API examples
4. Create visualization diagrams

## 📞 Support

Questions about the demo?
- Review `DEMO_GUIDE.md` for detailed walkthrough
- Check main `README.md` for project overview
- See `INSTALLATION.md` for deployment steps

---

**Remember**: This is a demonstration. Deploy to SAP for full functionality!
