CLASS zcl_excel_upload_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_excel_data,
        document_number TYPE c LENGTH 10,
        document_date   TYPE d,
        customer_id     TYPE c LENGTH 10,
        customer_name   TYPE c LENGTH 80,
        amount          TYPE p LENGTH 8 DECIMALS 2,
        currency        TYPE c LENGTH 5,
      END OF ty_excel_data,
      tt_excel_data TYPE STANDARD TABLE OF ty_excel_data WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_upload_result,
        document_number TYPE c LENGTH 10,
        status          TYPE c LENGTH 1,
        message         TYPE c LENGTH 255,
      END OF ty_upload_result,
      tt_upload_result TYPE STANDARD TABLE OF ty_upload_result WITH DEFAULT KEY.

    METHODS process_excel_file
      IMPORTING
        !iv_file_content TYPE xstring
        !iv_file_name    TYPE string OPTIONAL
      EXPORTING
        !et_excel_data   TYPE tt_excel_data
        !et_results      TYPE tt_upload_result
      RAISING
        cx_root.

    METHODS validate_excel_data
      IMPORTING
        !it_excel_data TYPE tt_excel_data
      EXPORTING
        !et_valid_data TYPE tt_excel_data
        !et_results    TYPE tt_upload_result.

  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS parse_excel_content
      IMPORTING
        !iv_file_content TYPE xstring
      EXPORTING
        !et_excel_data   TYPE tt_excel_data
      RAISING
        cx_root.

    METHODS convert_date
      IMPORTING
        !iv_date_value   TYPE any
      RETURNING
        VALUE(rv_date)   TYPE d.

    METHODS convert_amount
      IMPORTING
        !iv_amount_value TYPE any
      RETURNING
        VALUE(rv_amount) TYPE p.

ENDCLASS.



CLASS zcl_excel_upload_util IMPLEMENTATION.


  METHOD process_excel_file.
    " Main method to process Excel file

    CLEAR: et_excel_data, et_results.

    TRY.
        " Parse Excel content
        parse_excel_content(
          EXPORTING
            iv_file_content = iv_file_content
          IMPORTING
            et_excel_data   = DATA(lt_parsed_data) ).

        " Validate parsed data
        validate_excel_data(
          EXPORTING
            it_excel_data = lt_parsed_data
          IMPORTING
            et_valid_data = et_excel_data
            et_results    = et_results ).

      CATCH cx_root INTO DATA(lx_error).
        " Handle parsing errors
        APPEND VALUE #(
          document_number = 'ERROR'
          status = 'E'
          message = lx_error->get_text( ) ) TO et_results.
    ENDTRY.

  ENDMETHOD.


  METHOD parse_excel_content.
    " Parse Excel file using SAP standard classes
    " This is a template - actual implementation would use cl_fdt_xl_spreadsheet
    " or similar Excel processing classes available in your SAP system

    DATA: lo_excel      TYPE REF TO object,
          lo_worksheet  TYPE REF TO object,
          lv_row        TYPE i,
          lv_max_rows   TYPE i VALUE 10000.

    CLEAR et_excel_data.

    " Example parsing logic (pseudo-code)
    " In real implementation, you would:
    " 1. Create Excel reader object
    " 2. Get the first worksheet
    " 3. Loop through rows and columns
    " 4. Map columns to structure fields

    " Sample data structure (for demonstration)
    " Replace with actual Excel parsing logic

* Example using cl_fdt_xl_spreadsheet (if available)
*    DATA(lo_excel_ref) = NEW cl_fdt_xl_spreadsheet(
*      document_name = iv_file_name
*      xdocument     = iv_file_content ).
*
*    lo_worksheet = lo_excel_ref->get_worksheet_by_index( 1 ).
*
*    " Skip header row, start from row 2
*    lv_row = 2.
*
*    WHILE lv_row <= lv_max_rows.
*      DATA(ls_excel_row) = VALUE ty_excel_data( ).
*
*      " Read cells (assuming columns A-F)
*      ls_excel_row-document_number = lo_worksheet->get_cell_value( row = lv_row column = 1 ).
*      ls_excel_row-document_date   = convert_date( lo_worksheet->get_cell_value( row = lv_row column = 2 ) ).
*      ls_excel_row-customer_id     = lo_worksheet->get_cell_value( row = lv_row column = 3 ).
*      ls_excel_row-customer_name   = lo_worksheet->get_cell_value( row = lv_row column = 4 ).
*      ls_excel_row-amount          = convert_amount( lo_worksheet->get_cell_value( row = lv_row column = 5 ) ).
*      ls_excel_row-currency        = lo_worksheet->get_cell_value( row = lv_row column = 6 ).
*
*      " Check if row is empty
*      IF ls_excel_row-document_number IS INITIAL.
*        EXIT. " End of data
*      ENDIF.
*
*      APPEND ls_excel_row TO et_excel_data.
*      lv_row = lv_row + 1.
*    ENDWHILE.

    " For demonstration purposes, create sample data
    " Remove this in production and use actual Excel parsing
    APPEND VALUE #(
      document_number = 'DOC001'
      document_date   = '20240101'
      customer_id     = 'CUST001'
      customer_name   = 'Sample Customer 1'
      amount          = '1000.00'
      currency        = 'USD' ) TO et_excel_data.

    APPEND VALUE #(
      document_number = 'DOC002'
      document_date   = '20240102'
      customer_id     = 'CUST002'
      customer_name   = 'Sample Customer 2'
      amount          = '2500.50'
      currency        = 'EUR' ) TO et_excel_data.

  ENDMETHOD.


  METHOD validate_excel_data.
    " Validate parsed Excel data

    CLEAR: et_valid_data, et_results.

    LOOP AT it_excel_data INTO DATA(ls_data).
      DATA(lv_is_valid) = abap_true.
      DATA(lv_message) = VALUE string( ).

      " Validation 1: Document number is mandatory
      IF ls_data-document_number IS INITIAL.
        lv_is_valid = abap_false.
        lv_message = |Document number is required|.
      ENDIF.

      " Validation 2: Document date is mandatory and valid
      IF ls_data-document_date IS INITIAL.
        lv_is_valid = abap_false.
        lv_message = |{ lv_message } Document date is required|.
      ELSEIF ls_data-document_date > sy-datum.
        lv_is_valid = abap_false.
        lv_message = |{ lv_message } Document date cannot be in future|.
      ENDIF.

      " Validation 3: Customer ID is mandatory
      IF ls_data-customer_id IS INITIAL.
        lv_is_valid = abap_false.
        lv_message = |{ lv_message } Customer ID is required|.
      ENDIF.

      " Validation 4: Amount must be positive
      IF ls_data-amount <= 0.
        lv_is_valid = abap_false.
        lv_message = |{ lv_message } Amount must be greater than zero|.
      ENDIF.

      " Validation 5: Currency is mandatory
      IF ls_data-currency IS INITIAL.
        lv_is_valid = abap_false.
        lv_message = |{ lv_message } Currency is required|.
      ENDIF.

      " Add to appropriate table
      IF lv_is_valid = abap_true.
        APPEND ls_data TO et_valid_data.
        APPEND VALUE #(
          document_number = ls_data-document_number
          status = 'S'
          message = 'Validation successful' ) TO et_results.
      ELSE.
        APPEND VALUE #(
          document_number = ls_data-document_number
          status = 'E'
          message = lv_message ) TO et_results.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD convert_date.
    " Convert various date formats to ABAP date format

    DATA: lv_date_string TYPE string,
          lv_year        TYPE c LENGTH 4,
          lv_month       TYPE c LENGTH 2,
          lv_day         TYPE c LENGTH 2.

    CLEAR rv_date.

    TRY.
        lv_date_string = |{ iv_date_value }|.
        CONDENSE lv_date_string NO-GAPS.

        " Handle different date formats
        " Format: YYYY-MM-DD or YYYYMMDD
        IF strlen( lv_date_string ) = 10 AND lv_date_string+4(1) = '-'.
          " Format: YYYY-MM-DD
          lv_year  = lv_date_string+0(4).
          lv_month = lv_date_string+5(2).
          lv_day   = lv_date_string+8(2).
        ELSEIF strlen( lv_date_string ) = 8.
          " Format: YYYYMMDD
          lv_year  = lv_date_string+0(4).
          lv_month = lv_date_string+4(2).
          lv_day   = lv_date_string+6(2).
        ENDIF.

        rv_date = |{ lv_year }{ lv_month }{ lv_day }|.

      CATCH cx_root.
        " Return initial date on conversion error
        CLEAR rv_date.
    ENDTRY.

  ENDMETHOD.


  METHOD convert_amount.
    " Convert various amount formats to ABAP amount format

    DATA: lv_amount_string TYPE string.

    CLEAR rv_amount.

    TRY.
        lv_amount_string = |{ iv_amount_value }|.
        CONDENSE lv_amount_string NO-GAPS.

        " Remove thousand separators if present
        REPLACE ALL OCCURRENCES OF ',' IN lv_amount_string WITH ''.

        " Convert to packed decimal
        rv_amount = lv_amount_string.

      CATCH cx_root.
        " Return 0 on conversion error
        CLEAR rv_amount.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
