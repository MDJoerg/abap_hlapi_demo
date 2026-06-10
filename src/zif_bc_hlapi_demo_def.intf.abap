INTERFACE zif_bc_hlapi_demo_def
  PUBLIC.


  CONSTANTS con_default_rfcdest TYPE rfcdest VALUE 'EXT_ZBC_HLAPI_DEMO'.

  CONSTANTS: BEGIN OF con_api_path,
               set_led_color TYPE string VALUE `/becSetColorLED`,
               set_message TYPE string VALUE `/becSetMessage`,
               set_progress TYPE string VALUE `/v1/bcHLApiDemo/SetProgress`,
               get_weight    TYPE string VALUE `/becGetWeight`,
             END OF con_api_path.

  TYPES: BEGIN OF ty_hlapi_result,
           success TYPE abap_boolean,
           message TYPE string,
           value   TYPE string,
           code    TYPE i,
         END OF ty_HLAPI_RESULT.

  TYPES: BEGIN OF ty_led_color_payload,
           color TYPE string,
           text  TYPE string,
         END OF ty_led_color_payload.

  TYPES: BEGIN OF ty_progress_payload,
           progress TYPE i,
         END OF ty_progress_payload.

  TYPES: BEGIN OF ty_message_payload,
           author TYPE string,
           text  TYPE string,
         END OF ty_message_payload.


ENDINTERFACE.
