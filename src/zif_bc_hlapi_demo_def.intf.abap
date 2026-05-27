INTERFACE zif_bc_hlapi_demo_def
  PUBLIC.


  CONSTANTS con_default_rfcdest TYPE rfcdest VALUE 'EXT_ZBC_HLAPI_DEMO'.

  CONSTANTS: BEGIN OF con_api_path,
               set_led_color TYPE string VALUE `/becSetColorLED`,
             END OF con_api_path.

  TYPES: BEGIN OF ty_led_color_message,
           color TYPE string,
           text  TYPE string,
         END OF ty_led_color_message.

ENDINTERFACE.
