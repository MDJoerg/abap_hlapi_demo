CLASS zcl_bc_hlapi_demo_connector DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS: BEGIN OF con_content_type,
                 json TYPE string VALUE `application/json`,
               END OF con_content_type.

    METHODS constructor IMPORTING i_rfcdest TYPE rfcdest DEFAULT zif_bc_hlapi_demo_def=>con_default_rfcdest.

    METHODS http_post IMPORTING i_content_text   TYPE string  OPTIONAL
                                i_content_binary TYPE xstring OPTIONAL
                                i_content_type   TYPE string  DEFAULT 'application/json'
                                i_destination    TYPE rfcdest OPTIONAL
                                i_path           TYPE string  OPTIONAL
                      RETURNING VALUE(r_success) TYPE abap_boolean.

    METHODS http_get IMPORTING i_path           TYPE string  OPTIONAL
                               i_destination    TYPE rfcdest OPTIONAL
                     RETURNING VALUE(r_success) TYPE abap_boolean.

    METHODS get_http_status         RETURNING VALUE(r_status)       TYPE if_web_http_response=>http_status.
    METHODS get_http_content        RETURNING VALUE(r_content)      TYPE string.
    METHODS get_http_content_type   RETURNING VALUE(r_content_type) TYPE string.
    METHODS get_http_content_binary RETURNING VALUE(r_xcontent)     TYPE xstring.

  PROTECTED SECTION.
    DATA m_rfcdest        TYPE rfcdest.
    DATA m_last_exception TYPE REF TO cx_root.
    DATA m_status         TYPE if_web_http_response=>http_status.
    DATA m_client         TYPE REF TO if_web_http_client.
    DATA m_content        TYPE string.
    DATA m_content_type   TYPE string.
    DATA m_content_bin    TYPE xstring.

    METHODS reset_http.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bc_hlapi_demo_connector IMPLEMENTATION.
  METHOD constructor.
    m_rfcdest = i_rfcdest.
  ENDMETHOD.

  METHOD reset_http.
    CLEAR: m_last_exception,
           m_content,
           m_content_bin,
           m_content,
           m_status,
           m_client.
  ENDMETHOD.

  METHOD get_http_content.
    r_content = m_content.
  ENDMETHOD.

  METHOD get_http_content_binary.
    r_xcontent = m_content_bin.
  ENDMETHOD.

  METHOD get_http_content_type.
    r_content_type = m_content_type.
  ENDMETHOD.

  METHOD get_http_status.
    r_status = m_status.
  ENDMETHOD.

  METHOD http_post.
    TRY.
        reset_http( ).

        DATA(lo_dest) = cl_outbound_provider_http=>create_by_destination(
                            COND #( WHEN i_destination IS NOT INITIAL THEN i_destination ELSE m_rfcdest ) ).
        IF lo_dest IS INITIAL.
          RETURN.
        ENDIF.

        m_client = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).
        IF m_client IS INITIAL.
          RETURN.
        ENDIF.

        IF i_path IS NOT INITIAL.
          m_client->get_http_request( )->set_uri_path( i_path ).
        ENDIF.

        IF i_content_type IS NOT INITIAL.
          m_client->get_http_request( )->set_content_type( i_content_type ).
        ENDIF.

        IF i_content_binary IS NOT INITIAL.
          m_client->get_http_request( )->set_binary( i_content_binary ).
        ELSEIF i_content_text IS NOT INITIAL.
          m_client->get_http_request( )->set_text( i_content_text ).
        ENDIF.

        DATA(lo_response) = m_client->execute( i_method = if_web_http_client=>post ).
        IF lo_response IS INITIAL.
          RETURN.
        ENDIF.

        m_status = lo_response->get_status( ).
        m_content_type = lo_response->get_content_type( ).
        m_content = lo_response->get_text( ).
        m_content_bin = lo_response->get_binary( ).

        r_success = xsdbool( m_status-code >= 200 AND m_status-code < 300 ).
      CATCH cx_root INTO m_last_exception.
    ENDTRY.
  ENDMETHOD.

  METHOD http_get.
    TRY.
        reset_http( ).

        DATA(lo_dest) = cl_outbound_provider_http=>create_by_destination(
                            COND #( WHEN i_destination IS NOT INITIAL THEN i_destination ELSE m_rfcdest ) ).
        IF lo_dest IS INITIAL.
          RETURN.
        ENDIF.

        m_client = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).
        IF m_client IS INITIAL.
          RETURN.
        ENDIF.

        IF i_path IS NOT INITIAL.
          m_client->get_http_request( )->set_uri_path( i_path ).
        ENDIF.

        DATA(lo_response) = m_client->execute( i_method = if_web_http_client=>get ).
        IF lo_response IS INITIAL.
          RETURN.
        ENDIF.

        m_status = lo_response->get_status( ).
        m_content_type = lo_response->get_content_type( ).
        m_content = lo_response->get_text( ).
        m_content_bin = lo_response->get_binary( ).

        r_success = xsdbool( m_status-code >= 200 AND m_status-code < 300 ).
      CATCH cx_root INTO m_last_exception.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
