@EndUserText.label : 'Draft Table for Upload Data'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table ztable_upload_d {

  key mandt             : mandt not null;
  key upload_id         : sysuuid_x16 not null;
  document_number       : abap.char(10);
  document_date         : abap.dats;
  customer_id           : abap.char(10);
  customer_name         : abap.char(80);
  amount                : abap.curr(15,2);
  currency              : abap.cuky;
  status                : abap.char(1);
  error_message         : abap.char(255);
  created_by            : abp_creation_user;
  created_at            : abp_creation_tstmpl;
  last_changed_by       : abp_lastchange_user;
  last_changed_at       : abp_lastchange_tstmpl;
  local_last_changed_at : abp_locinst_lastchange_tstmpl;
  "%admin"              : include sych_bdl_draft_admin_inc;

}
