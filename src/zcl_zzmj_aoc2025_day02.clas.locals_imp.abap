*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CLASS lcl_input DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA:
      example TYPE string READ-ONLY.
    CLASS-METHODS:
      class_constructor.
ENDCLASS.

CLASS lcl_input IMPLEMENTATION.
  METHOD class_constructor.
    example = '11-22,95-115,998-1012,1188511880-1188511890,222220-222224,' &&
      '1698522-1698528,446443-446449,38593856-38593862,565653-565659,' &&
      '824824821-824824827,2121212118-2121212124'.
  ENDMETHOD.
ENDCLASS.
