CLASS zcl_zzmj_aoc2025_day04 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      positions TYPE STANDARD TABLE OF REF TO zcl_zzmj_aoc2025_position WITH DEFAULT KEY.

    METHODS:
      get_accessible
        IMPORTING
                  grid     TYPE REF TO zcl_zzmj_aoc2025_grid
        RETURNING VALUE(r) TYPE positions.
ENDCLASS.



CLASS zcl_zzmj_aoc2025_day04 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    data:
      t1 type timestampl,
      t2 type timestampl.

    " Get the time stamp so we can measure execution time
    GET TIME STAMP FIELD t1.

    " Decide which input to use
    FINAL(input) = lcl_input=>example.
*    FINAL(input) = zcl_zzmj_aoc2025_inputs=>day04.

    " Create the grid
    DATA(grid) = NEW zcl_zzmj_aoc2025_grid( input ).

    " Get the accessible rolls of paper
    DATA(accessible) = get_accessible( grid ).

    " For part 1, just count them. For part 2, this is the start
    DATA(part1) = lines( accessible ).
    DATA(part2) = part1.

    " While we still have accessible rolls, continue
    WHILE lines( accessible ) > 0.
      " Mark all he accessible rolls as remove
      LOOP AT accessible ASSIGNING FIELD-SYMBOL(<position>).
        grid->set( position = <position> value = 'x' ).
      ENDLOOP.

      " Get the following round of accessible rolls and add them to the result of part 2
      accessible = get_accessible( grid ).
      part2 += lines( accessible ).
    ENDWHILE.

    " Write the result to the output
    out->write( |Part 1: { part1 }| ).
    out->write( |Part 2: { part2 }| ).

    " Get the time stamp again and write execution time to output
    GET TIME STAMP FIELD t2.
    out->write( |Execution took { t2 - t1 } seconds| ).

  ENDMETHOD.

  METHOD get_accessible.
    DO grid->height TIMES.
      DATA(y) = sy-index - 1.
      DO grid->width TIMES.
        DATA(x) = sy-index - 1.
        DATA(position) = NEW zcl_zzmj_aoc2025_position( x = x y = y ).

        IF grid->get( position ) = '@'.
          DATA(count_adjecent) = 0.

          DO 3 TIMES.
            DATA(delta_x) = sy-index - 2.
            DO 3 TIMES.
              DATA(delta_y) = sy-index - 2.
              CHECK NOT ( delta_x = 0 AND delta_y = 0 ).

              IF grid->get( NEW zcl_zzmj_aoc2025_position( x = x + delta_x y = y + delta_y ) ) = '@'.
                count_adjecent += 1.
              ENDIF.
            ENDDO.
          ENDDO.

          IF count_adjecent < 4.
            APPEND position TO r.
          ENDIF.
        ENDIF.
      ENDDO.
    ENDDO.
  ENDMETHOD.
ENDCLASS.
