CLASS zbp_i_upload_data DEFINITION
  PUBLIC
  ABSTRACT
  FINAL FOR BEHAVIOR OF zi_upload_data.

ENDCLASS.

CLASS zbp_i_upload_data IMPLEMENTATION.

ENDCLASS.


CLASS lhc_uploaddata DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR uploaddata RESULT result.

    METHODS setuploadid FOR DETERMINE ON MODIFY
      IMPORTING keys FOR uploaddata~setuploadid.

    METHODS setstatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR uploaddata~setstatus.

    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR uploaddata~validatecustomer.

    METHODS validateamount FOR VALIDATE ON SAVE
      IMPORTING keys FOR uploaddata~validateamount.

    METHODS validatedocumentdate FOR VALIDATE ON SAVE
      IMPORTING keys FOR uploaddata~validatedocumentdate.

    METHODS uploadfromexcel FOR MODIFY
      IMPORTING keys FOR ACTION uploaddata~uploadfromexcel RESULT result.

ENDCLASS.

CLASS lhc_uploaddata IMPLEMENTATION.

  METHOD get_instance_authorizations.
    " Default authorization - allow all operations
    READ ENTITIES OF zi_upload_data IN LOCAL MODE
      ENTITY uploaddata
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(upload_data)
      FAILED failed.

    CHECK upload_data IS NOT INITIAL.

    result = VALUE #( FOR ls_data IN upload_data
                      ( %tky = ls_data-%tky
                        %update = if_abap_behv=>auth-allowed
                        %delete = if_abap_behv=>auth-allowed
                        %action-Edit = if_abap_behv=>auth-allowed ) ).
  ENDMETHOD.

  METHOD setuploadid.
    " Generate UUID for new records
    READ ENTITIES OF zi_upload_data IN LOCAL MODE
      ENTITY uploaddata
      FIELDS ( UploadId ) WITH CORRESPONDING #( keys )
      RESULT DATA(upload_data).

    DELETE upload_data WHERE UploadId IS NOT INITIAL.
    CHECK upload_data IS NOT INITIAL.

    MODIFY ENTITIES OF zi_upload_data IN LOCAL MODE
      ENTITY uploaddata
      UPDATE FIELDS ( UploadId )
      WITH VALUE #( FOR ls_data IN upload_data
                    ( %tky = ls_data-%tky
                      UploadId = cl_system_uuid=>create_uuid_x16_static( ) ) )
      REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD setstatus.
    " Set initial status for new records
    READ ENTITIES OF zi_upload_data IN LOCAL MODE
      ENTITY uploaddata
      FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(upload_data).

    DELETE upload_data WHERE Status IS NOT INITIAL.
    CHECK upload_data IS NOT INITIAL.

    MODIFY ENTITIES OF zi_upload_data IN LOCAL MODE
      ENTITY uploaddata
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR ls_data IN upload_data
                    ( %tky = ls_data-%tky
                      Status = 'P' ) )  " P = Pending
      REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD validatecustomer.
    " Validate customer ID exists
    READ ENTITIES OF zi_upload_data IN LOCAL MODE
      ENTITY uploaddata
      FIELDS ( CustomerId CustomerName ) WITH CORRESPONDING #( keys )
      RESULT DATA(upload_data).

    LOOP AT upload_data INTO DATA(ls_data).
      IF ls_data-CustomerId IS INITIAL.
        APPEND VALUE #( %tky = ls_data-%tky ) TO failed-uploaddata.
        APPEND VALUE #( %tky = ls_data-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text = 'Customer ID is mandatory' )
                        %element-customerid = if_abap_behv=>mk-on ) TO reported-uploaddata.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateamount.
    " Validate amount is positive
    READ ENTITIES OF zi_upload_data IN LOCAL MODE
      ENTITY uploaddata
      FIELDS ( Amount Currency ) WITH CORRESPONDING #( keys )
      RESULT DATA(upload_data).

    LOOP AT upload_data INTO DATA(ls_data).
      IF ls_data-Amount <= 0.
        APPEND VALUE #( %tky = ls_data-%tky ) TO failed-uploaddata.
        APPEND VALUE #( %tky = ls_data-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text = 'Amount must be greater than zero' )
                        %element-amount = if_abap_behv=>mk-on ) TO reported-uploaddata.
      ENDIF.

      IF ls_data-Currency IS INITIAL.
        APPEND VALUE #( %tky = ls_data-%tky ) TO failed-uploaddata.
        APPEND VALUE #( %tky = ls_data-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-warning
                                 text = 'Currency should be specified' )
                        %element-currency = if_abap_behv=>mk-on ) TO reported-uploaddata.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validatedocumentdate.
    " Validate document date is not in future
    READ ENTITIES OF zi_upload_data IN LOCAL MODE
      ENTITY uploaddata
      FIELDS ( DocumentDate ) WITH CORRESPONDING #( keys )
      RESULT DATA(upload_data).

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT upload_data INTO DATA(ls_data).
      IF ls_data-DocumentDate IS INITIAL.
        APPEND VALUE #( %tky = ls_data-%tky ) TO failed-uploaddata.
        APPEND VALUE #( %tky = ls_data-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text = 'Document date is mandatory' )
                        %element-documentdate = if_abap_behv=>mk-on ) TO reported-uploaddata.
      ELSEIF ls_data-DocumentDate > lv_today.
        APPEND VALUE #( %tky = ls_data-%tky ) TO failed-uploaddata.
        APPEND VALUE #( %tky = ls_data-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text = 'Document date cannot be in the future' )
                        %element-documentdate = if_abap_behv=>mk-on ) TO reported-uploaddata.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD uploadfromexcel.
    " Excel upload action implementation
    " This would integrate with the Excel utility class
    DATA lt_upload_data TYPE TABLE FOR CREATE zi_upload_data.

    " Read the parameter (Excel file content would be passed here)
    " For now, this is a placeholder for the actual Excel processing logic

    " Example: Call utility class to process Excel
    " DATA(lo_excel_util) = NEW zcl_excel_upload_util( ).
    " lo_excel_util->process_excel_file(
    "   EXPORTING
    "     iv_file_content = keys[ 1 ]-%param-file_content
    "   IMPORTING
    "     et_upload_data  = lt_upload_data ).

    " Create entities from uploaded data
    IF lt_upload_data IS NOT INITIAL.
      MODIFY ENTITIES OF zi_upload_data IN LOCAL MODE
        ENTITY uploaddata
        CREATE FIELDS ( DocumentNumber DocumentDate CustomerId
                        CustomerName Amount Currency )
        WITH lt_upload_data
        MAPPED DATA(ls_mapped)
        FAILED DATA(ls_failed)
        REPORTED DATA(ls_reported).

      result = VALUE #( FOR key IN keys
                        ( %tky = key-%tky
                          %param = CORRESPONDING #( ls_mapped-uploaddata ) ) ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_upload_data DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lsc_zi_upload_data IMPLEMENTATION.
  METHOD save_modified.
    " Additional save logic if needed
  ENDMETHOD.

  METHOD cleanup_finalize.
    " Cleanup logic if needed
  ENDMETHOD.
ENDCLASS.
