CLASS zcl_zzmj_aoc2025_day01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zzmj_aoc2025_day01 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    " Decide which input to use
    FINAL(input) = lcl_input=>example.
*    FINAL(input) = zcl_zzmj_aoc2025_inputs=>day01.

    " Initiate dial and the counter for part 1
    DATA(dial) = NEW lcl_dial( ).
    DATA(part1) = 0.

    " Loop over all the input lines
    LOOP AT input ASSIGNING FIELD-SYMBOL(<line>).
      " Rotate the dial
      dial->rotate( <line> ).

      " For part 1, if we point to 0, add one to the counter
      IF dial->value = 0.
        part1 += 1.
      ENDIF.
    ENDLOOP.

    " Ask the dial how many times it has hit 0
    DATA(part2) = dial->point_0_count.

    " Write the output to the console
    out->write( |Part 1: { part1 }| ).
    out->write( |Part 2: { part2 }| ).

  ENDMETHOD.
ENDCLASS.
