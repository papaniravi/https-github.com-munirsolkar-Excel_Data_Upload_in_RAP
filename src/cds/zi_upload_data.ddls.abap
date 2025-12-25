@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Upload Data Interface View'
define root view entity ZI_UPLOAD_DATA
  as select from ztable_upload_data
{
  key upload_id              as UploadId,
      document_number        as DocumentNumber,
      document_date          as DocumentDate,
      customer_id            as CustomerId,
      customer_name          as CustomerName,
      @Semantics.amount.currencyCode: 'Currency'
      amount                 as Amount,
      @Semantics.currencyCode: true
      currency               as Currency,
      status                 as Status,
      error_message          as ErrorMessage,
      @Semantics.user.createdBy: true
      created_by             as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at             as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by        as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at        as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at  as LocalLastChangedAt
}
