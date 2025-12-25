@EndUserText.label: 'Excel Upload Parameter'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define abstract entity ZI_UPLOAD_EXCEL_PARAM
{
  @EndUserText.label: 'File Name'
  file_name    : abap.char(255);

  @EndUserText.label: 'File Content'
  file_content : abap.rawstring(0);

  @EndUserText.label: 'File Size'
  file_size    : abap.int4;
}
