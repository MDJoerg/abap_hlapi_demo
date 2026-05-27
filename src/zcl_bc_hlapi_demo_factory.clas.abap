CLASS zcl_bc_hlapi_demo_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    class-methods
      create_http_connector imPORTING iv_rfcdest type rfcdest opTIONAL
        RETURNING
          VALUE(ro_instance) TYPE REF TO zcl_bc_hlapi_demo_connector.

    class-methods
      create_api
        RETURNING
          VALUE(ro_instance) TYPE REF TO zcl_bc_hlapi_demo_api.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bc_hlapi_demo_factory IMPLEMENTATION.
  METHOD create_http_connector.
    ro_instance = NEW zcl_bc_hlapi_demo_connector( iv_rfcdest ).
  ENDMETHOD.

  METHOD create_api.
    ro_instance = NEW zcl_bc_hlapi_demo_api( ).
  ENDMETHOD.

ENDCLASS.
