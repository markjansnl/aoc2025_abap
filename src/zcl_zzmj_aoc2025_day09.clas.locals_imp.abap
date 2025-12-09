*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_input DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA:
      example TYPE string_table READ-ONLY.
    CLASS-METHODS:
      class_constructor.
ENDCLASS.


CLASS lcl_input IMPLEMENTATION.
  METHOD class_constructor.
    APPEND LINES OF VALUE string_table(
      ( `7,1` )
      ( `11,1` )
      ( `11,7` )
      ( `9,7` )
      ( `9,5` )
      ( `2,5` )
      ( `2,3` )
      ( `7,3` )
    ) TO example.
  ENDMETHOD.
ENDCLASS.
