@EndUserText.label: 'Upload Data Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_UPLOAD_DATA
  provider contract transactional_query
  as projection on ZI_UPLOAD_DATA
{
  key UploadId,
      @Search.defaultSearchElement: true
      DocumentNumber,
      DocumentDate,
      @Search.defaultSearchElement: true
      CustomerId,
      @Search.defaultSearchElement: true
      CustomerName,
      Amount,
      Currency,
      Status,
      ErrorMessage,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
