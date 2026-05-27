CLASS zcl_bc_hlapi_demo_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    class-methods:
      create_http_connector imPORTING iv_rfcdest type rfcdest opTIONAL
        RETURNING
          VALUE(ro_instance) TYPE REF TO zcl_bc_hlapi_demo_connector.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bc_hlapi_demo_factory IMPLEMENTATION.
  METHOD create_http_connector.
    ro_instance = NEW zcl_bc_hlapi_demo_connector( iv_rfcdest ).
  ENDMETHOD.

ENDCLASS.
