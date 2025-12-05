*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_dial DEFINITION.
  PUBLIC SECTION.
    DATA:
      value         TYPE i VALUE 50 READ-ONLY,
      point_0_count TYPE i READ-ONLY.

    METHODS:
      rotate
        IMPORTING
          input_line TYPE string.
ENDCLASS.

CLASS lcl_dial IMPLEMENTATION.
  METHOD rotate.

    " Parse input line
    DATA(direction) = input_line(1).
    DATA(clicks)    = CONV i( input_line+1 ).

    " Do all the requested clicks
    DO clicks TIMES.

      " Rotate 1 click in the right direction
      CASE direction.
        WHEN 'L'.
          value -= 1.
        WHEN 'R'.
          value += 1.
      ENDCASE.

      " If we go under 0 or above 99, reset the value
      value = value MOD 100.

      " If we are at point 0, add one to the counter
      IF value = 0.
        point_0_count += 1.
      ENDIF.
    ENDDO.
  ENDMETHOD.
ENDCLASS.


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
      ( `L68` )
      ( `L30` )
      ( `R48` )
      ( `L5` )
      ( `R60` )
      ( `L55` )
      ( `L1` )
      ( `L99` )
      ( `R14` )
      ( `L82` )
    ) TO example.
  ENDMETHOD.
ENDCLASS.
