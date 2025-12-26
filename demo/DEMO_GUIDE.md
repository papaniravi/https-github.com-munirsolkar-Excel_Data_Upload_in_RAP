# Excel Data Upload RAP - Demo Guide

This demo simulates how the SAP RAP application works in a real SAP environment.

## 🎯 What This Demo Shows

Since this is an SAP ABAP application that requires a SAP system to run, this demo provides:
- Sample data files (CSV format representing Excel)
- Mock API responses showing OData service behavior
- Simulated workflow demonstration
- Validation examples

## 📋 Prerequisites for Real Deployment

To actually run this application, you need:
- **SAP System**: SAP BTP ABAP Environment OR SAP S/4HANA 2020+
- **Development Tools**: ABAP Development Tools (ADT) in Eclipse
- **Access**: Developer authorization in SAP system

## 🔄 Application Workflow

### 1. User Access the Fiori App

```
┌─────────────────────────────────────────┐
│     SAP Fiori Launchpad                 │
│                                         │
│  ┌───────────────────────────────┐     │
│  │  📊 Excel Upload App          │     │
│  │  Upload and manage data       │     │
│  └───────────────────────────────┘     │
└─────────────────────────────────────────┘
```

### 2. View Existing Records

**Request:**
```http
GET /sap/opu/odata4/sap/zsd_upload_data/srvd/sap/zsb_upload_data/0001/UploadData
```

**Response:** See `demo/api-examples/02-get-all-records.json`

**UI Display:**
```
╔═══════════════════════════════════════════════════════════════════════════╗
║ Upload Data                                         🔍 Search   ➕ Create  ║
╠═══════════════════════════════════════════════════════════════════════════╣
║ Document #  │ Date       │ Customer ID │ Customer Name        │ Amount    ║
╟─────────────┼────────────┼─────────────┼─────────────────────┼───────────╢
║ DOC0001     │ 2024-01-15 │ CUST001     │ Acme Corporation    │ 1,500.00  ║
║ DOC0002     │ 2024-01-16 │ CUST002     │ Tech Solutions Inc  │ 2,750.50  ║
║ DOC0003     │ 2024-01-17 │ CUST003     │ Global Industries   │ 3,200.75  ║
║ DOC0004     │ 2024-01-18 │ CUST001     │ Acme Corporation    │   890.25  ║
║ DOC0005     │ 2024-01-19 │ CUST004     │ Digital Services    │ 4,500.00  ║
╚═══════════════════════════════════════════════════════════════════════════╝
```

### 3. Create New Record Manually

**Click "Create" button → Draft is created**

**UI Form:**
```
╔═══════════════════════════════════════════════════════╗
║ Create Upload Data                    [Save] [Cancel] ║
╠═══════════════════════════════════════════════════════╣
║                                                       ║
║ Document Details                                      ║
║ ┌─────────────────────────────────────────────────┐  ║
║ │ Document Number: [DOC0020________________]  *   │  ║
║ │ Document Date:   [2024-02-10____________]  *   │  ║
║ │ Status:          [P - Pending___________]      │  ║
║ └─────────────────────────────────────────────────┘  ║
║                                                       ║
║ Customer Information                                  ║
║ ┌─────────────────────────────────────────────────┐  ║
║ │ Customer ID:     [CUST020_______________]  *   │  ║
║ │ Customer Name:   [New Customer Inc______]      │  ║
║ └─────────────────────────────────────────────────┘  ║
║                                                       ║
║ Amount Details                                        ║
║ ┌─────────────────────────────────────────────────┐  ║
║ │ Amount:          [5000.00_______________]  *   │  ║
║ │ Currency:        [USD___________________]  *   │  ║
║ └─────────────────────────────────────────────────┘  ║
╚═══════════════════════════════════════════════════════╝
```

**On Save, validation runs:**
- ✅ Document number provided
- ✅ Document date is valid and not in future
- ✅ Customer ID provided
- ✅ Amount > 0
- ✅ Currency provided

**Result:** Record saved successfully!

### 4. Upload from Excel File

**Sample File:** `demo/data/sample_upload_template.csv`

**Process:**
1. User clicks "Upload" action
2. Selects Excel/CSV file
3. System processes file:
   ```
   Reading file... ✓
   Parsing rows... ✓
   Validating data... ✓
   Creating records... ✓
   ```
4. Results displayed:
   ```
   ╔══════════════════════════════════════════════╗
   ║ Upload Results                               ║
   ╠══════════════════════════════════════════════╣
   ║ Total Records:      10                       ║
   ║ Successful:         10  ✓                    ║
   ║ Failed:              0  ✗                    ║
   ╚══════════════════════════════════════════════╝
   ```

### 5. Validation Errors Example

**Sample File with Errors:** `demo/data/sample_with_errors.csv`

**Validation Results:**

```
╔══════════════════════════════════════════════════════════════════════╗
║ Upload Results - Errors Detected                                     ║
╠══════════════════════════════════════════════════════════════════════╣
║ Row │ Document #  │ Status │ Error Message                          ║
╟─────┼─────────────┼────────┼────────────────────────────────────────╢
║  2  │ DOC0011     │   ✓    │ Success                                ║
║  3  │ DOC0012     │   ✗    │ Document date cannot be in the future  ║
║  4  │ DOC0013     │   ✗    │ Customer ID is mandatory               ║
║  5  │ DOC0014     │   ✗    │ Amount must be greater than zero       ║
║  6  │ DOC0015     │   ✗    │ Amount must be greater than zero       ║
║  7  │ DOC0016     │   ✗    │ Document date is mandatory             ║
║  8  │ (missing)   │   ✗    │ Document number is required            ║
║  9  │ DOC0017     │   ✗    │ Currency should be specified           ║
║ 10  │ DOC0018     │   ✓    │ Success                                ║
║ 11  │ DOC0019     │   ✗    │ Invalid date format                    ║
╠═════════════════════════════════════════════════════════════════════╣
║ Summary                                                              ║
║ Total Records:       10                                              ║
║ Successful:           2  ✓                                           ║
║ Failed:               8  ✗                                           ║
╚══════════════════════════════════════════════════════════════════════╝
```

**API Response:** See `demo/api-examples/05-validation-error-response.json`

## 🔍 OData API Examples

### Get All Records
```bash
curl -X GET \
  'https://your-sap-system/sap/opu/odata4/sap/zsd_upload_data/srvd/sap/zsb_upload_data/0001/UploadData' \
  -H 'Accept: application/json'
```

### Get Single Record
```bash
curl -X GET \
  'https://your-sap-system/.../UploadData(550e8400-e29b-41d4-a716-446655440001)' \
  -H 'Accept: application/json'
```

### Create Record
```bash
curl -X POST \
  'https://your-sap-system/.../UploadData' \
  -H 'Content-Type: application/json' \
  -d @demo/api-examples/03-create-record-request.json
```

### Update Record
```bash
curl -X PATCH \
  'https://your-sap-system/.../UploadData(550e8400-e29b-41d4-a716-446655440001)' \
  -H 'Content-Type: application/json' \
  -d '{"Amount": "1600.00"}'
```

### Delete Record
```bash
curl -X DELETE \
  'https://your-sap-system/.../UploadData(550e8400-e29b-41d4-a716-446655440001)'
```

### Filter Records
```bash
# By Customer ID
curl -X GET \
  'https://your-sap-system/.../UploadData?$filter=CustomerId eq ''CUST001'''

# By Date Range
curl -X GET \
  'https://your-sap-system/.../UploadData?$filter=DocumentDate ge 2024-01-01 and DocumentDate le 2024-01-31'

# By Amount
curl -X GET \
  'https://your-sap-system/.../UploadData?$filter=Amount gt 1000'
```

## 📊 Sample Data Overview

### Valid Sample Data
File: `demo/data/sample_upload_template.csv`
- 10 records
- All validations pass
- Various customers and currencies
- Date range: Jan 15-24, 2024

### Sample with Validation Errors
File: `demo/data/sample_with_errors.csv`
- 10 records
- 8 validation errors
- 2 successful records
- Demonstrates all validation rules

## 🎨 UI Features

### List View (List Report)
- **Columns**: Document #, Date, Customer, Amount, Status
- **Search**: Across all searchable fields
- **Filter**: By status, date range, customer
- **Sort**: By any column
- **Actions**: Create, Delete, Upload

### Object Page (Detail View)
- **Header**: Document number and key info
- **Tabs**:
  - General Information
  - Document Details
  - Customer Information
  - Amount Details
  - Administrative Data

### Draft Handling
- **Edit Mode**: Creates draft
- **Save**: Activates draft → moves to active table
- **Cancel**: Discards draft
- **Auto-save**: Drafts saved automatically

## 🔐 Validations Demonstrated

### 1. Mandatory Field Validations
- Document Number (required)
- Document Date (required)
- Customer ID (required)
- Amount (required)
- Currency (required)

### 2. Business Logic Validations
- Document date cannot be in future
- Amount must be > 0
- Valid date format required
- Customer name optional but recommended

### 3. Data Type Validations
- Date must be valid calendar date
- Amount must be numeric
- Currency must be valid code (3-5 chars)

## 📈 Performance

### Estimated Processing Times
- **Single Record Create**: < 1 second
- **Small Upload (10 rows)**: 1-2 seconds
- **Medium Upload (100 rows)**: 5-10 seconds
- **Large Upload (1000 rows)**: 30-60 seconds

### Optimization Tips
- Process in batches for large files
- Validate client-side before upload
- Use bulk operations where possible

## 🚀 How to Actually Deploy

1. **Setup SAP Environment**
   - Access SAP BTP or S/4HANA system
   - Install ABAP Development Tools (ADT)

2. **Import Code**
   - Follow `INSTALLATION.md`
   - Import all ABAP objects
   - Activate all components

3. **Publish Service**
   - Open service binding in ADT
   - Click "Publish"
   - Note the service URL

4. **Create Fiori App** (Optional)
   - Use SAP Business Application Studio
   - Create Fiori Elements app
   - Point to published service
   - Deploy to launchpad

5. **Test**
   - Open app in browser
   - Try manual create
   - Test Excel upload
   - Verify validations

## 📝 Notes

### This Demo Provides:
✅ Sample data files
✅ Mock API responses
✅ Validation examples
✅ Workflow visualization
✅ OData query examples

### This Demo Does NOT:
❌ Actually run the ABAP code
❌ Connect to SAP database
❌ Process real Excel files
❌ Provide working UI
❌ Execute OData calls

### To Get Full Functionality:
→ Deploy to a real SAP system following INSTALLATION.md

## 🎓 Learning Resources

- **SAP RAP**: https://developers.sap.com/mission.sap-fiori-abap-rap100.html
- **OData V4**: https://www.odata.org/
- **Fiori Elements**: https://sapui5.hana.ondemand.com/
- **ABAP Development**: https://community.sap.com/

## 💡 Next Steps

1. Review the code in `src/` directory
2. Understand RAP architecture (see ARCHITECTURE.md)
3. Set up SAP development environment
4. Import and test in your SAP system
5. Customize for your needs

---

**Remember**: This is a **template/framework** ready for deployment in SAP systems!
