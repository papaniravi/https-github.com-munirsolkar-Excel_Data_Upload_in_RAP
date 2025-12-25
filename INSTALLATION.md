# Installation Guide

This guide will help you install and configure the Excel Data Upload RAP application in your SAP system.

## Prerequisites

Before installing this application, ensure you have:

- SAP BTP ABAP Environment or SAP S/4HANA 2020 or higher
- ABAP Development Tools (ADT) in Eclipse installed
- Developer authorization in the SAP system
- Basic knowledge of RAP and ABAP development

## Step-by-Step Installation

### 1. Import ABAP Objects

#### Using ADT (ABAP Development Tools)

1. **Create Package**
   - Open ADT in Eclipse
   - Right-click on your project → New → ABAP Package
   - Name: `ZEXCEL_UPLOAD` (or your preferred name)
   - Description: "Excel Data Upload Application"
   - Package Type: Development

2. **Import Database Tables**
   - Copy content from `src/data/ztable_upload_data.tabl.abap`
   - Create new Database Table in ADT
   - Paste content and activate
   - Repeat for `src/data/ztable_upload_d.tabl.abap` (draft table)

3. **Import CDS Views**
   - Create the following CDS views in order:
     1. `zi_upload_excel_param.ddls.abap` (Parameter structure)
     2. `zi_upload_data.ddls.abap` (Interface view)
     3. `zc_upload_data.ddls.abap` (Consumption view)
     4. `zc_upload_data.ddlx.abap` (Metadata extension)

4. **Import Behavior Definitions**
   - Create `zi_upload_data.bdef.abap` (Interface behavior)
   - Create `zc_upload_data.bdef.abap` (Projection behavior)
   - Activate both

5. **Import Implementation Class**
   - Create class `zbp_i_upload_data`
   - Copy content from `src/behavior/zbp_i_upload_data.clas.abap`
   - Activate

6. **Import Utility Class**
   - Create class `zcl_excel_upload_util`
   - Copy content from `src/utils/zcl_excel_upload_util.clas.abap`
   - Activate

7. **Create Service Definition**
   - Create service definition `zsd_upload_data`
   - Copy content from `src/service/zsd_upload_data.srvd.abap`
   - Activate

8. **Create Service Binding**
   - Create service binding `zsb_upload_data`
   - Copy content from `src/service/zsb_upload_data.srvb.abap`
   - Activate

### 2. Activate All Objects

1. Select your package in Project Explorer
2. Right-click → Activate (Ctrl+F3)
3. Ensure all objects are activated without errors

### 3. Publish Service

1. Open service binding `ZSB_UPLOAD_DATA`
2. Click "Publish" button
3. Wait for service to be published
4. Note the service URL

### 4. Test the Service

1. In service binding, click "Preview" button
2. Select entity "UploadData"
3. This opens Fiori Elements preview
4. Test CRUD operations

## Configuration

### Setting Up Excel Upload

The Excel upload functionality requires additional configuration:

1. **Update Excel Parser**
   - Open class `zcl_excel_upload_util`
   - Locate method `parse_excel_content`
   - Uncomment and adapt the Excel parsing logic for your SAP system
   - Use appropriate Excel processing class (e.g., `cl_fdt_xl_spreadsheet`)

2. **Configure File Upload in Fiori**
   - The file upload will be available as an action in the UI
   - Ensure your Fiori launchpad has the necessary file upload component

### Optional: Create Fiori App

1. **Using SAP Business Application Studio**
   - Create new Fiori Elements application
   - Template: List Report Object Page
   - Data source: Use the published OData service
   - Main entity: UploadData

2. **Deploy to SAP BTP or On-Premise**
   - Follow standard Fiori deployment procedures
   - Configure launchpad tile

## Verification

After installation, verify the setup:

### Check Database Tables
```sql
SELECT * FROM ztable_upload_data UP TO 1 ROWS
```

### Check Service
1. Open service binding in ADT
2. Status should show "Published"
3. Preview should work without errors

### Check Authorizations
Ensure users have:
- Read/Write authorization for the tables
- Execute authorization for the service
- UI authorization for Fiori app (if created)

## Troubleshooting

### Common Issues

#### Activation Errors
- **Issue**: "Cannot find referenced object"
- **Solution**: Ensure objects are created in correct order (tables → views → behaviors)

#### Service Not Publishing
- **Issue**: Service binding won't publish
- **Solution**:
  - Check all referenced objects are active
  - Verify behavior implementation is error-free
  - Check system logs in transaction SLG1

#### Excel Upload Not Working
- **Issue**: Excel file upload fails
- **Solution**:
  - Verify Excel parsing class is available in your system
  - Check file size limits
  - Review error logs in behavior implementation

#### Draft Not Working
- **Issue**: Draft functionality errors
- **Solution**:
  - Verify draft table `ztable_upload_d` is created and activated
  - Check draft determination actions in behavior definition

### Getting Help

If you encounter issues:

1. Check SAP Community for RAP-related questions
2. Review SAP RAP documentation
3. Check system logs (transaction SLG1)
4. Verify ADT and system versions are compatible

## Next Steps

After successful installation:

1. Customize UI annotations in metadata extension
2. Add custom validations as needed
3. Extend data model for your requirements
4. Configure authorization objects
5. Create user documentation

## System Requirements

### Minimum Versions
- SAP BTP ABAP Environment: Any version
- SAP S/4HANA: 2020 or higher
- ABAP Development Tools: Latest version recommended

### Required Components
- SAP Fiori Frontend (for UI)
- SAP Gateway (for On-Premise systems)
- Excel processing classes (check availability in your system)

## License

This project is provided as-is for educational and development purposes.
