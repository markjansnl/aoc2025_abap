CLASS zcl_zzmj_aoc2025_day02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zzmj_aoc2025_day02 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA:
      invalid_ids_part1 TYPE HASHED TABLE OF int8 WITH UNIQUE KEY table_line,
      invalid_ids_part2 TYPE HASHED TABLE OF int8 WITH UNIQUE KEY table_line.

    GET TIME STAMP FIELD DATA(t1).

    " Decide which input to use
    FINAL(input) = lcl_input=>example.
*    FINAL(input) = zcl_zzmj_aoc2025_inputs=>day02.

    " Split input into ranges
    SPLIT input AT ',' INTO TABLE DATA(ranges).

    " Loop over the ranges
    LOOP AT ranges ASSIGNING FIELD-SYMBOL(<range>).
      " Split into from and to
      SPLIT <range> AT '-' INTO DATA(from_s) DATA(to_s).

      " Prefix string with leading zeroes if the length of to is greater than the length of from
      WHILE strlen( to_s ) > strlen( from_s ).
        from_s = |0{ from_s }|.
      ENDWHILE.

      " Convert to numbers
      DATA(from) = CONV int8( from_s ).
      DATA(to) = CONV int8( to_s ).

      " Find all the invalid ids by starting at length 1, until half length of to
      " Try repeat 2 times, 3 times, until we are out of bounds
      " Try next number, until it doesn't match the prefix anymore
      DATA(l) = 1.
      WHILE l <= strlen( to_s ) / 2.
        DATA(number) = CONV int8( from_s(l) ).
        WHILE strlen( |{ number }| ) <= l.
          IF number > 0.
            DATA(times) = 2.
            DO.
              " Repeat the number
              DATA(repeated) = CONV int8( repeat( val = |{ number }|
                                                  occ = times ) ).

              IF repeated > to.
                " If we are out of boundaries after the range, we are done
                EXIT.
              ELSEIF repeated >= from.
                " Only if we are in the range (not before), count as invalid, so add to the sum
                IF times = 2.
                  INSERT repeated INTO TABLE invalid_ids_part1.
                ENDIF.
                INSERT repeated INTO TABLE invalid_ids_part2.
              ENDIF.

              " Repeat more...
              times += 1.
            ENDDO.
          ENDIF.

          " Next number...
          number += 1.
        ENDWHILE.

        " One more longer...
        l += 1.
      ENDWHILE.

    ENDLOOP.

    GET TIME STAMP FIELD DATA(t2).
    out->write( |Execution took { t2 - t1 } seconds| ).

    " Write the result
    out->write( |Part 1: { REDUCE int8( INIT sum = CONV int8( 0 )
                                         FOR <invalid_id_part1> IN invalid_ids_part1
                                        NEXT sum += <invalid_id_part1> ) }| ).
    out->write( |Part 2: { REDUCE int8( INIT sum = CONV int8( 0 )
                                         FOR <invalid_id_part2> IN invalid_ids_part2
                                        NEXT sum += <invalid_id_part2> ) }| ).

  ENDMETHOD.
ENDCLASS.
