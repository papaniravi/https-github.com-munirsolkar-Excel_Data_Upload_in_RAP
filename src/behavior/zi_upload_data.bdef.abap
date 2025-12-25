managed implementation in class zbp_i_upload_data unique;
strict ( 2 );
with draft;

define behavior for ZI_UPLOAD_DATA alias UploadData
persistent table ztable_upload_data
draft table ztable_upload_d
lock master total etag LocalLastChangedAt
authorization master ( instance )
etag master LocalLastChangedAt
{
  // Administrative fields (read-only)
  field ( readonly ) CreatedBy, CreatedAt, LastChangedBy, LastChangedAt, LocalLastChangedAt;

  // Mandatory fields
  field ( mandatory ) DocumentNumber, DocumentDate, CustomerId;

  // Standard operations
  create;
  update;
  delete;

  // Draft operations
  draft action Edit;
  draft action Activate;
  draft action Discard;
  draft action Resume;
  draft determine action Prepare;

  // Determinations
  determination setUploadId on modify { create; }
  determination setStatus on modify { create; }

  // Validations
  validation validateCustomer on save { field CustomerId; }
  validation validateAmount on save { field Amount; }
  validation validateDocumentDate on save { field DocumentDate; }

  // Actions
  action uploadFromExcel parameter ZI_UPLOAD_EXCEL_PARAM result [1] $self;

  // Mapping
  mapping for ztable_upload_data
  {
    UploadId = upload_id;
    DocumentNumber = document_number;
    DocumentDate = document_date;
    CustomerId = customer_id;
    CustomerName = customer_name;
    Amount = amount;
    Currency = currency;
    Status = status;
    ErrorMessage = error_message;
    CreatedBy = created_by;
    CreatedAt = created_at;
    LastChangedBy = last_changed_by;
    LastChangedAt = last_changed_at;
    LocalLastChangedAt = local_last_changed_at;
  }
}
