CLASS zcl_bc_hlapi_demo_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    METHODS get_led_colors RETURNING VALUE(r_colors) TYPE string_table.

    METHODS get_random_integer
      IMPORTING i_min            TYPE i DEFAULT 1
                i_max            TYPE i
      RETURNING VALUE(r_integer) TYPE i.

    METHODS get_random_string
      IMPORTING i_strings       TYPE string_table
      RETURNING VALUE(r_string) TYPE string.

    METHODS get_connector RETURNING VALUE(r_connector) TYPE REF TO zcl_bc_hlapi_demo_connector.

    METHODS get_user_context RETURNING VALUE(r_context) TYPE string.


    METHODS to_json IMPORTING i_data        TYPE data
                    RETURNING VALUE(r_json) TYPE string.

    METHODS set_led_color
      IMPORTING i_color          TYPE string
                i_text           TYPE string OPTIONAL
      RETURNING VALUE(r_success) TYPE abap_boolean.



  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bc_hlapi_demo_api IMPLEMENTATION.

  METHOD get_connector.
    r_connector = zcl_bc_hlapi_demo_factory=>create_http_connector( zif_bc_hlapi_demo_def=>con_default_rfcdest ).
  ENDMETHOD.

  METHOD get_led_colors.
    r_colors = VALUE #( ( `grey` )
                        ( `red` )
                        ( `green` )
                        ( `yellow` ) ).
  ENDMETHOD.

  METHOD get_random_integer.
    r_integer = cl_abap_random=>create( cl_abap_random=>seed( ) )->intinrange( low  = i_min
                                                                                high = i_max ).
  ENDMETHOD.

  METHOD get_random_string.
    DATA(count) = lines( i_strings ).
    IF count > 0.
      r_string = i_strings[ get_random_integer( count ) ].
    ENDIF.
  ENDMETHOD.

  METHOD set_led_color.
    DATA(connector) = get_connector( ).
    DATA(content) = VALUE zif_bc_hlapi_demo_def=>ty_led_color_message(
        color = i_color
        text  = COND #( WHEN i_text IS NOT INITIAL
                        THEN i_text
                        ELSE get_user_context( ) )
    ).


    r_success = connector->http_post( i_content_text = to_json( content )
                                      i_content_type = connector->con_content_type-json
                                      i_path         = zif_bc_hlapi_demo_def=>con_api_path-set_led_color ).
  ENDMETHOD.

  METHOD to_json.
    r_json = /ui2/cl_json=>serialize( i_data ).
  ENDMETHOD.

METHOD get_user_context.
  DATA(date) = cl_abap_context_info=>get_system_date( ).
  DATA(time) = cl_abap_context_info=>get_system_time( ).
  DATA(user) = sy-uname.
  DATA(tenant) = |{ sy-sysid }/{ sy-mandt }|.

  r_context = |{ user } - { tenant } - { date } - { time }|.
ENDMETHOD.

METHOD if_oo_adt_classrun~main.
  " LED DEMO
  DATA(color) = get_random_string( get_led_colors( ) ).
  IF set_led_color( color ) = abap_true.
    out->write( |LED color { color } set| ).
  ELSE.
    out->write( |Error while setting LED color { color }| ).
  ENDIF.
ENDMETHOD.
ENDCLASS.
