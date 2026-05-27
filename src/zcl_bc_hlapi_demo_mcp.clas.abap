CLASS zcl_bc_hlapi_demo_mcp DEFINITION
  PUBLIC
  INHERITING FROM zcl_mcp_server_base
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS: BEGIN OF co_general,
                 server_class TYPE string VALUE `ZCL_BC_HLAPI_DEMO_MCP` ##NO_TEXT,
                 description  TYPE string VALUE `Demo MCP Server for central dashboard control` ##NO_TEXT,
                 version      TYPE string VALUE `1.0.0` ##NO_TEXT,
                 mcp_area     TYPE string VALUE 'demo' ##NO_TEXT,
                 mcp_server   TYPE string VALUE 'zbc_hlapi_demo' ##NO_TEXT,
               END OF co_general.

    CONSTANTS: BEGIN OF co_tool,
                 set_dashboard_led_color TYPE string VALUE `set_shopfloor_led_color` ##NO_TEXT,
                 set_dashboard_message   TYPE string VALUE `set_shopfloor_message` ##NO_TEXT,
                 simulate_process        TYPE string VALUE `simulate_process` ##NO_TEXT,
                 get_weight              TYPE string VALUE `get_weight` ##NO_TEXT,
               END OF co_tool.

    INTERFACES if_oo_adt_classrun.


  PROTECTED SECTION.
    METHODS handle_initialize     REDEFINITION.
    METHODS handle_list_tools     REDEFINITION.
    METHODS handle_call_tool      REDEFINITION.
    METHODS get_session_mode      REDEFINITION.


  PRIVATE SECTION.
    methods get_api returNING VALUE(api) type ref to zcl_bc_hlapi_demo_api.


    METHODS process_headless_result
      IMPORTING result   type zif_bc_hlapi_demo_def=>ty_hlapi_result
      changing response TYPE zif_mcp_server=>call_tool_response.



    METHODS set_dashboard_led_color
      IMPORTING !request  TYPE REF TO zcl_mcp_req_call_tool
      CHANGING  !response TYPE zif_mcp_server=>call_tool_response
      RAISING   zcx_mcp_ajson_error.

    METHODS set_dashboard_message
      IMPORTING !request  TYPE REF TO zcl_mcp_req_call_tool
      CHANGING  !response TYPE zif_mcp_server=>call_tool_response
      RAISING   zcx_mcp_ajson_error.

    METHODS simulate_process
      IMPORTING !request  TYPE REF TO zcl_mcp_req_call_tool
      CHANGING  !response TYPE zif_mcp_server=>call_tool_response
      RAISING   zcx_mcp_ajson_error.

    METHODS get_weight
      IMPORTING !request  TYPE REF TO zcl_mcp_req_call_tool
      CHANGING  !response TYPE zif_mcp_server=>call_tool_response
      RAISING   zcx_mcp_ajson_error.
ENDCLASS.



CLASS zcl_bc_hlapi_demo_mcp IMPLEMENTATION.

  METHOD get_session_mode.
    result = zcl_mcp_session=>session_mode_stateless.
  ENDMETHOD.

  METHOD handle_initialize.
    response-result->set_capabilities( VALUE #( prompts   = abap_true
                                                resources = abap_false
                                                tools     = abap_false ) ).
    response-result->set_implementation( VALUE #( name    = co_general-description
                                                  version = co_general-version ) ).
    " TODO: check spelling: explicitely (typo) -> explicitly (ABAP cleaner)
    response-result->set_instructions(
        `This is a remote control server for central dashboard scenario. Use the features provided by this MCP server only if explicitely requested. If not sure ask the user!` ) ##NO_TEXT.
  ENDMETHOD.

  METHOD handle_list_tools.
    DATA tools TYPE zcl_mcp_resp_list_tools=>tools.

    " Demo Tool without any input parameter
    TRY.
        " register set color
        DATA(input_schema_color) = NEW zcl_mcp_schema_builder( ).
        input_schema_color->add_string( name        = `color`
                                        description = `color code as text`
                                        required    = abap_true ) ##NO_TEXT.

        APPEND VALUE #(
            name         = co_tool-set_dashboard_led_color
            title        = `Set the LED Color at the central dashboard`
            description  = `Set the color of the LED o the specified color. Supported colors are gray, red, green and yellow.`
            input_schema = input_schema_color->to_json( )  ) TO tools ##NO_TEXT.

        " register set message
        DATA(input_schema_message) = NEW zcl_mcp_schema_builder( ).
        input_schema_message->add_string( name        = `message`
                                          " TODO: check spelling: diplay (typo) -> display (ABAP cleaner)
                                          description = `Text message to diplay at shopfloor`
                                          required    = abap_true ) ##NO_TEXT.

        input_schema_message->add_string( name        = `author`
                                          description = `Author reference for a message`
                                          required    = abap_false ) ##NO_TEXT.

        APPEND VALUE #( name         = co_tool-set_dashboard_message
                        title        = `Set a mesaage at a dashboard`
                        description  = `Set the message text at a central dashboard. The authors name is optional`
                        input_schema = input_schema_message->to_json( )  ) TO tools ##NO_TEXT.

        " register process simulation
        DATA(input_schema_wait) = NEW zcl_mcp_schema_builder( ).
        input_schema_wait->add_integer(
            name        = `seconds`
            description = `simulate a process with given seconds of worktime. default is 1 second.`
            required    = abap_false
            minimum     = 1
            maximum     = 5 )
                                              ##NO_TEXT.

        APPEND VALUE #( name         = co_tool-simulate_process
                        title        = `Simulate a process and Wait for given seconds`
                        description  = `Simulates a shopfloor process`
                        input_schema = input_schema_wait->to_json( )  ) TO tools ##NO_TEXT.

        " register get weight
        APPEND VALUE #( name        = co_tool-get_weight
                        title       = `Get weight from scale`
                        description = `Simulates a shopfloor scale and returns a weight in unit KG` )
               TO tools ##NO_TEXT.

      CATCH zcx_mcp_ajson_error INTO DATA(schema_error).
        response-error-code    = zcl_mcp_jsonrpc=>error_codes-internal_error.
        response-error-message = schema_error->get_text( ).
        RETURN.
    ENDTRY.

    response-result->set_tools( tools ).
  ENDMETHOD.

  METHOD handle_call_tool.
    TRY.
        CASE request->get_name( ).
          WHEN co_tool-set_dashboard_led_color.
            set_dashboard_led_color( EXPORTING request  = request
                                     CHANGING  response = response ).
          WHEN co_tool-set_dashboard_message.
            set_dashboard_message( EXPORTING request  = request
                                   CHANGING  response = response ).

          WHEN co_tool-simulate_process.
            simulate_process( EXPORTING request  = request
                              CHANGING  response = response ).
          WHEN co_tool-get_weight.
            get_weight( EXPORTING request  = request
                        CHANGING  response = response ).

          WHEN OTHERS.
            response-error-code    = zcl_mcp_jsonrpc=>error_codes-invalid_params.
            response-error-message = |Tool { request->get_name( ) } not found.| ##NO_TEXT.
        ENDCASE.
      CATCH zcx_mcp_ajson_error INTO DATA(error).
        response-error-code    = zcl_mcp_jsonrpc=>error_codes-internal_error.
        response-error-message = error->get_text( ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_api.
    api = zcl_bc_hlapi_demo_factory=>create_api( ).
  ENDMETHOD.

  METHOD process_headless_result.
    IF result-success = abap_true.
      IF result-message IS NOT INITIAL.
        response-result->add_text_content( result-message ).
      ELSE.
        response-result->add_text_content( `Success.` ) ##NO_TEXT.
      ENDIF.
    ELSE.
      IF result-code IS INITIAL.
        response-error-code = zcl_mcp_jsonrpc=>error_codes-invalid_request.
      ELSE.
        response-error-code = result-code.
      ENDIF.
      IF result-message IS NOT INITIAL.
        response-error-message = result-message.
      ELSE.
        response-error-message = `Error!` ##NO_TEXT.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD set_dashboard_led_color.
    DATA(color) = to_lower( request->get_arguments( )->get_string( `color` ) ).
    DATA(result) = get_api( )->set_led_color( color ).
    process_headless_result( EXPORTING result   = result
                             CHANGING  response = response ).
  ENDMETHOD.

  METHOD set_dashboard_message.
    " check parameters
    DATA(message) = request->get_arguments( )->get_string( iv_path = 'message' ).
    DATA(author) = request->get_arguments( )->get_string( iv_path = 'author' ).
    DATA(result) = get_api( )->set_message( i_text   = message
                                            i_author = author ).
    process_headless_result( EXPORTING result   = result
                             CHANGING  response = response ).
  ENDMETHOD.

  METHOD get_weight.
    DATA(result) = get_api( )->get_weight( ).
    process_headless_result( EXPORTING result   = result
                             CHANGING  response = response ).
  ENDMETHOD.


  METHOD simulate_process.
    " check parameters
    DATA(seconds) = request->get_arguments( )->get_integer( 'seconds' ).
    IF seconds <= 0.
      seconds = 1.
    ELSEIF seconds > 5.
      response-result->add_text_content( |Error! Used { seconds } is higher as allowed 5 sec.|  ) ##NO_TEXT.
    ENDIF.

    " wait now
    WAIT UP TO seconds SECONDS.
    response-result->add_text_content( |Shopfloor process simulated - { seconds } sec used.|  ) ##NO_TEXT.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    DATA(config) = VALUE zmcp_servers( area   = co_general-mcp_area
                                       server = co_general-mcp_server
                                       class  = co_general-server_class ) ##NO_TEXT.
    MODIFY zmcp_servers FROM config.

    IF sy-subrc = 0.
      out->write(
          |MCP Server installed: http://YOUR_HOST:YOUR_PORT/zmcp/{ config-area }/{ config-server }?sap-client={ sy-mandt }| ) ##NO_TEXT.
    ELSE.
      out->write( `MCP Server not installed` ) ##NO_TEXT.
    ENDIF.
  ENDMETHOD.



ENDCLASS.
