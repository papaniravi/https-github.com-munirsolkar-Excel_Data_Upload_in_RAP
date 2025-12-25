# Excel Data Upload in SAP RAP

A complete SAP ABAP RESTful Application Programming (RAP) project for uploading and managing Excel data.

## Overview

This project demonstrates how to build a Fiori application using SAP RAP that allows users to upload Excel files and process the data into SAP tables. It includes a full CRUD interface with Excel import functionality.

## Features

- **Excel File Upload**: Upload .xlsx files directly through the Fiori UI
- **Data Validation**: Validate uploaded data before saving
- **CRUD Operations**: Create, Read, Update, Delete operations on uploaded data
- **Error Handling**: Comprehensive error messages and validation
- **Fiori Elements UI**: Modern UI built with SAP Fiori Elements

## Project Structure

```
src/
├── data/
│   └── ztable_upload_data.tabl.abap          # Database table
├── cds/
│   ├── zi_upload_data.ddls.abap              # Interface CDS View
│   ├── zc_upload_data.ddls.abap              # Consumption CDS View
│   └── zc_upload_data.ddlx.abap              # Metadata Extension
├── service/
│   ├── zsd_upload_data.srvd.abap             # Service Definition
│   └── zsb_upload_data.srvb.abap             # Service Binding
├── behavior/
│   ├── zbp_i_upload_data.clas.abap           # Behavior Implementation
│   └── zi_upload_data.bdef.abap              # Behavior Definition
└── utils/
    └── zcl_excel_upload_util.clas.abap       # Excel Upload Utility

```

## Architecture

This project follows the SAP RAP architecture pattern:

1. **Persistence Layer**: Database table (`ZTABLE_UPLOAD_DATA`)
2. **Business Object Layer**: CDS Interface View (`ZI_UPLOAD_DATA`)
3. **Consumption Layer**: CDS Consumption View (`ZC_UPLOAD_DATA`)
4. **Service Layer**: Service Definition and Binding
5. **Behavior Layer**: Business logic and validations

## Data Model

The upload data table includes:
- Client
- Upload ID (Key)
- Document Number
- Document Date
- Customer ID
- Customer Name
- Amount
- Currency
- Status
- Error Message
- Created By/At
- Last Changed By/At

## Prerequisites

- SAP BTP ABAP Environment or SAP S/4HANA 2020 or higher
- ABAP Development Tools (ADT) in Eclipse
- Authorization for RAP development

## Installation

1. Clone this repository
2. Import all ABAP objects into your SAP system using ADT
3. Activate all objects
4. Publish the service binding
5. Create a Fiori Elements app using the published service

## Usage

### Uploading Excel Data

1. Open the Fiori application
2. Click "Upload" button
3. Select your Excel file (.xlsx format)
4. Review the uploaded data
5. Save to persist the data

### Excel Format

Your Excel file should have the following columns:
- Document Number
- Document Date (YYYY-MM-DD)
- Customer ID
- Customer Name
- Amount
- Currency

## Technical Details

### RAP Features Used

- **Managed Scenario**: Framework handles CRUD operations
- **Draft Enabled**: Support for draft handling
- **Determinations**: Auto-generate IDs and timestamps
- **Validations**: Validate data before save
- **Actions**: Custom Excel upload action

### Excel Processing

The project uses `cl_fdt_xl_spreadsheet` or similar classes to:
1. Parse Excel files
2. Extract data from cells
3. Map to internal table structure
4. Validate and process records

## Development

To extend this project:

1. **Add Fields**: Modify the database table and regenerate CDS views
2. **Custom Validations**: Add validation methods in behavior implementation
3. **Additional Actions**: Define new actions in behavior definition
4. **UI Customization**: Modify metadata extensions for UI changes

## License

This project is provided as-is for educational and development purposes.

## Author

SAP RAP Developer

## Version History

- 1.0.0 - Initial release with basic Excel upload functionality
