# Architecture Documentation

This document describes the technical architecture of the Excel Data Upload RAP application.

## System Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        Fiori UI Layer                        │
│                     (SAP Fiori Elements)                     │
└────────────────────┬────────────────────────────────────────┘
                     │ OData V4
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    Service Binding Layer                     │
│                   ZSB_UPLOAD_DATA (OData V4)                │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                   Service Definition Layer                   │
│                      ZSD_UPLOAD_DATA                        │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                  Consumption/Projection Layer                │
│             ZC_UPLOAD_DATA (Projection View)                │
│           + Metadata Extension (UI Annotations)              │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                   Business Object Layer                      │
│            ZI_UPLOAD_DATA (Interface View)                  │
│         + Behavior Definition + Implementation               │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    Persistence Layer                         │
│              ZTABLE_UPLOAD_DATA (Active Table)              │
│               ZTABLE_UPLOAD_D (Draft Table)                 │
└─────────────────────────────────────────────────────────────┘
```

## RAP Layer Architecture

### 1. Database Layer

#### Active Table: ZTABLE_UPLOAD_DATA
- Stores final, activated upload records
- Fields: Upload ID, Document details, Customer info, Amount, Admin data
- Key: Client + Upload ID (UUID)

#### Draft Table: ZTABLE_UPLOAD_D
- Stores draft records during edit operations
- Includes RAP draft administrative fields
- Synchronized with active table structure

### 2. Business Object Layer (Interface)

#### CDS View: ZI_UPLOAD_DATA
```
Purpose: Data model definition
Type: Root entity
Features:
  - Semantic annotations (@Semantics)
  - Field mappings from database
  - Currency/Amount associations
  - Timestamp fields
```

#### Behavior Definition: ZI_UPLOAD_DATA.bdef
```
Implementation: Managed
Features:
  - CRUD operations
  - Draft handling (Edit, Activate, Discard)
  - Determinations (auto-fill fields)
  - Validations (business rules)
  - Actions (Excel upload)
  - Field characteristics (readonly, mandatory)
```

#### Behavior Implementation: ZBP_I_UPLOAD_DATA
```
Methods:
  - setuploadid: Generate UUID for new records
  - setstatus: Set initial status
  - validatecustomer: Customer existence check
  - validateamount: Positive amount check
  - validatedocumentdate: Date range validation
  - uploadfromexcel: Excel file processing
```

### 3. Projection Layer (Consumption)

#### CDS View: ZC_UPLOAD_DATA
```
Purpose: Expose business object for consumption
Type: Projection on ZI_UPLOAD_DATA
Features:
  - Search annotations
  - Field subset selection
  - Provider contract: transactional_query
```

#### Metadata Extension: ZC_UPLOAD_DATA.ddlx
```
Purpose: UI annotations
Contains:
  - Header information
  - Facet definitions (tabs/sections)
  - Line item definitions (list view)
  - Field groups (object page)
  - Selection fields (filter bar)
  - Criticality definitions
```

#### Projection Behavior: ZC_UPLOAD_DATA.bdef
```
Purpose: Expose behavior for UI
Exposes:
  - Standard operations (create, update, delete)
  - Draft actions
  - Custom actions
```

### 4. Service Layer

#### Service Definition: ZSD_UPLOAD_DATA
```
Purpose: Define OData service entities
Exposes: ZC_UPLOAD_DATA as UploadData
```

#### Service Binding: ZSB_UPLOAD_DATA
```
Type: OData V4 UI
Purpose: Bind service to HTTP endpoint
Status: Published (after activation)
```

### 5. Utility Layer

#### Class: ZCL_EXCEL_UPLOAD_UTIL
```
Purpose: Excel file processing utilities
Methods:
  - process_excel_file: Main processing method
  - parse_excel_content: Extract data from Excel
  - validate_excel_data: Business validation
  - convert_date: Date format conversion
  - convert_amount: Number format conversion
```

## Data Flow

### Read Operation (GET)

```
User Action → Fiori UI
    ↓
OData GET Request → Service Binding
    ↓
Service Definition → Projection View
    ↓
Projection View → Interface View
    ↓
Interface View → Database Table
    ↓
Data ← Returned through layers
    ↓
UI Rendering
```

### Create/Update Operation (POST/PATCH)

```
User Input → Fiori UI
    ↓
OData POST/PATCH → Service Binding
    ↓
Draft Created → Draft Table
    ↓
User Edits → Draft Updated
    ↓
Determinations Executed:
    - Generate UUID
    - Set Status
    ↓
Validations Executed:
    - Customer validation
    - Amount validation
    - Date validation
    ↓
Activate Draft → Active Table
    ↓
Success Response → UI
```

### Excel Upload Operation

```
User Selects File → Fiori UI
    ↓
Upload Action Triggered → Service Binding
    ↓
uploadfromexcel Method → Behavior Implementation
    ↓
Call Utility Class → ZCL_EXCEL_UPLOAD_UTIL
    ↓
Parse Excel File:
    - Read Excel content
    - Extract rows/columns
    - Map to structure
    ↓
Validate Data:
    - Check mandatory fields
    - Validate data types
    - Apply business rules
    ↓
Create Entities:
    - Generate for each valid row
    - Trigger determinations
    - Run validations
    ↓
Return Results:
    - Success count
    - Error list
    ↓
Display to User
```

## Key Design Patterns

### 1. Managed Scenario
- Framework handles CRUD operations
- Automatic draft handling
- Built-in transaction management

### 2. Separation of Concerns
- **Interface Layer**: Business logic and data model
- **Projection Layer**: UI-specific concerns
- **Service Layer**: Protocol binding (OData)

### 3. Virtual Element Pattern
Used for:
- Calculated fields
- Transient data
- Action parameters

### 4. Determination Pattern
Auto-calculate or derive field values:
- UUID generation
- Default values
- Status computation

### 5. Validation Pattern
Business rule enforcement:
- At save time
- Field-level or entity-level
- With user-friendly messages

## Component Interactions

### Behavior Implementation Components

```
┌──────────────────────────────────────────────┐
│        Behavior Handler Class                │
│         (Local Handler Class)                │
├──────────────────────────────────────────────┤
│  - Authorization Handler                     │
│  - Determination Handler                     │
│  - Validation Handler                        │
│  - Action Handler                            │
└──────────────────────────────────────────────┘
         ↓              ↓              ↓
    ┌────────┐    ┌─────────┐    ┌─────────┐
    │ Read   │    │ Modify  │    │ Delete  │
    │ Entity │    │ Entity  │    │ Entity  │
    └────────┘    └─────────┘    └─────────┘
         ↓              ↓              ↓
    ┌──────────────────────────────────────┐
    │      Database Operations             │
    │   (Framework Managed)                │
    └──────────────────────────────────────┘
```

### Draft Handling Flow

```
┌─────────────┐
│   Create    │
└──────┬──────┘
       ↓
┌─────────────┐     ┌──────────────┐
│    Edit     │────→│ Create Draft │
└──────┬──────┘     └──────┬───────┘
       ↓                   ↓
┌─────────────┐     ┌──────────────┐
│   Modify    │────→│ Update Draft │
└──────┬──────┘     └──────┬───────┘
       ↓                   ↓
┌─────────────┐     ┌──────────────┐
│  Activate   │────→│ Move to      │
│             │     │ Active Table │
└─────────────┘     └──────────────┘
       or
┌─────────────┐     ┌──────────────┐
│   Discard   │────→│ Delete Draft │
└─────────────┘     └──────────────┘
```

## Technology Stack

### Backend
- **Language**: ABAP (7.50+)
- **Framework**: RAP (ABAP RESTful Application Programming)
- **Protocol**: OData V4
- **Database**: SAP HANA

### Frontend
- **Framework**: SAP Fiori Elements
- **UI Technology**: SAPUI5
- **Design**: SAP Fiori Design Guidelines

### Development Tools
- **IDE**: ABAP Development Tools (ADT) in Eclipse
- **Version Control**: Git
- **Service**: OData V4

## Security Considerations

### Authorization
- Instance-level authorization in behavior
- Field-level authorization possible
- CDS access control (when enabled)

### Data Validation
- Input validation at multiple layers
- SQL injection prevention (parameterized queries)
- XSS prevention (framework-handled)

### Audit Trail
- Created By/At fields
- Last Changed By/At fields
- Local last changed timestamp

## Performance Optimization

### Database Level
- UUID as primary key (efficient indexing)
- Selective field loading
- Bulk operations where possible

### CDS Level
- Associations instead of joins where appropriate
- Filtered projections
- Efficient field selection

### UI Level
- Lazy loading of data
- Pagination support
- Optimistic UI updates (draft)

## Extensibility Points

### Where to Extend

1. **Add New Fields**
   - Modify database table
   - Update CDS views
   - Add to behavior definition
   - Update metadata extension

2. **Add New Validations**
   - Add validation method in behavior implementation
   - Reference in behavior definition
   - Define trigger fields

3. **Add New Actions**
   - Define in behavior definition
   - Implement in behavior class
   - Add UI button in metadata extension

4. **Customize UI**
   - Modify metadata extension
   - Adjust facet structure
   - Change field importance
   - Add criticality

## Deployment Architecture

```
┌─────────────────────────────────────────┐
│        SAP BTP ABAP Environment         │
│              or S/4HANA                  │
├─────────────────────────────────────────┤
│  ABAP Stack                             │
│   ├── Database (HANA)                   │
│   ├── Application Server                │
│   └── OData Service                     │
└──────────────┬──────────────────────────┘
               │ HTTPS
               ▼
┌─────────────────────────────────────────┐
│      SAP Fiori Launchpad                │
│        (Browser-based)                   │
└─────────────────────────────────────────┘
```

## Best Practices Applied

1. **Clean Code**: Single responsibility, clear naming
2. **RAP Managed Scenario**: Leverage framework capabilities
3. **Separation of Concerns**: Clear layer boundaries
4. **Error Handling**: Comprehensive error management
5. **Documentation**: Inline and external docs
6. **Testability**: Designed for unit testing
7. **Performance**: Optimized queries and operations

## Future Architecture Considerations

1. **Microservices**: Potential to expose as external service
2. **Integration**: REST APIs for external systems
3. **Scalability**: Cloud-native deployment options
4. **Analytics**: Integration with SAP Analytics Cloud
5. **ML Integration**: Potential for data quality predictions

---

Last Updated: 2024-12-25
