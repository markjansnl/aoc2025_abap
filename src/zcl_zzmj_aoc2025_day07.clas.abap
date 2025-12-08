CLASS zcl_zzmj_aoc2025_day07 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zzmj_aoc2025_day07 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA:
      t1 TYPE timestampl,
      t2 TYPE timestampl.

    " Get the time stamp so we can measure execution time
    GET TIME STAMP FIELD t1.

    " Decide which input to use
    FINAL(input) = lcl_input=>example.
*    FINAL(input) = zcl_zzmj_aoc2025_inputs=>day07.

    DATA(grid) = NEW zcl_zzmj_aoc2025_grid( input ).

    DO grid->height TIMES.
      DATA(y) = sy-index - 1.
      DO grid->width TIMES.
        DATA(x) = sy-index - 1.
        DATA(position) = NEW zcl_zzmj_aoc2025_position( x = x y = y ).

        IF ( grid->get( position ) <> '^' AND ( grid->get( position->up( ) ) = 'S' OR grid->get( position->up( ) ) = '|' ) ) OR
           ( grid->get( position->left( ) ) = '^' AND grid->get( position->left( )->up( ) ) = '|' ) OR
           ( grid->get( position->right( ) ) = '^' AND grid->get( position->right( )->up( ) ) = '|' ).
          grid->set( position = position value = '|' ).
        ENDIF.
      ENDDO.
    ENDDO.

    grid->print( out ).

    DATA(part1) = 0.
    DO grid->height TIMES.
      y = sy-index - 1.
      DO grid->width TIMES.
        x = sy-index - 1.
        position = NEW zcl_zzmj_aoc2025_position( x = x y = y ).
        IF grid->get( position ) = '^' AND grid->get( position->up( ) ) = '|'.
          part1 += 1.
        ENDIF.
      ENDDO.
    ENDDO.

    DATA(part2) = 0.
    DO grid->height TIMES.
      y = sy-index - 1.
      check y mod 2 = 0.
      DO grid->width TIMES.
        x = sy-index - 1.
        position = NEW zcl_zzmj_aoc2025_position( x = x y = y ).
        IF grid->get( position ) = '|'.
          part2 += 1.
        ENDIF.
      ENDDO.
    ENDDO.

    " Write result to output
    out->write( |Part 1: { part1 }| ).
    out->write( |Part 2: { part2 }| ).

    " Part2: 3158 is too low

    " Get the time stamp again and write execution time to output
    GET TIME STAMP FIELD t2.
    out->write( |Execution took { t2 - t1 } seconds| ).

  ENDMETHOD.
ENDCLASS.
