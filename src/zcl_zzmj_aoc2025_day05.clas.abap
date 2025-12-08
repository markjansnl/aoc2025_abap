CLASS zcl_zzmj_aoc2025_day05 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zzmj_aoc2025_day05 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    TYPES:
      BEGIN OF ty_range,
        from TYPE int8,
        to   TYPE int8,
      END OF ty_range,
      ty_ranges TYPE STANDARD TABLE OF ty_range WITH DEFAULT KEY.

    DATA:
      t1 TYPE timestampl,
      t2 TYPE timestampl,
      empty_line_found TYPE abap_bool,
      ranges           TYPE ty_ranges,
      part1            TYPE i.

    " Get the time stamp so we can measure execution time
    GET TIME STAMP FIELD t1.

    " Decide which input to use
    FINAL(input) = lcl_input=>example.
*    FINAL(input) = zcl_zzmj_aoc2025_inputs=>day05.

    " Put input into ranges and ingredients tables
    LOOP AT input ASSIGNING FIELD-SYMBOL(<line>).
      IF empty_line_found = abap_false.
        " Parse the ranges into ranges table
        IF <line> = ''.
          empty_line_found = abap_true.
        ELSE.
          SPLIT <line> AT '-' INTO DATA(from) DATA(to).
          APPEND VALUE #( from = from to = to ) TO ranges.
        ENDIF.
      ELSE.
        " Find the fresh ingredients for part 1
        DATA(ingredient) = CONV int8( <line> ).
        LOOP AT ranges TRANSPORTING NO FIELDS WHERE from <= ingredient AND to >= ingredient.
          part1 += 1.
          EXIT.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

    " For part 2 go through the ranges and remove all the overlaps
    SORT ranges BY from to.
    LOOP AT ranges ASSIGNING FIELD-SYMBOL(<range1>).
      DATA(tabix1) = sy-tabix.
      LOOP AT ranges ASSIGNING FIELD-SYMBOL(<range2>) FROM tabix1 + 1.
        DATA(tabix2) = sy-tabix.

        IF <range2>-from <= <range1>-to.
          " These ranges overlap. Extend range 1 if needed, and remove range 2
          <range1>-to = nmax( val1 = <range1>-to val2 = <range2>-to ).
          DELETE ranges INDEX tabix2.
        ELSE.
          " The next range doesn't overlap, so break inner loop
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    " Write result to output
    out->write( |Part 1: { part1 }| ).
    out->write( |Part 2: { REDUCE int8( INIT sum = CONV int8( 0 )
                                         FOR <range> IN ranges
                                        NEXT sum += <range>-to - <range>-from + 1 ) }| ).

    " Get the time stamp again and write execution time to output
    GET TIME STAMP FIELD t2.
    out->write( |Execution took { t2 - t1 } seconds| ).

  ENDMETHOD.
ENDCLASS.
