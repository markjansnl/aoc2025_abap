CLASS zcl_zzmj_aoc2025_day09 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_red_tile,
        x TYPE i,
        y TYPE i,
      END OF ty_red_tile,
      ty_red_tiles TYPE STANDARD TABLE OF ty_red_tile WITH DEFAULT KEY
                                                      WITH UNIQUE HASHED KEY k COMPONENTS x y,
      BEGIN OF ty_area,
        red_tile_a TYPE ty_red_tile,
        red_tile_b TYPE ty_red_tile,
        area       TYPE int8,
      END OF ty_area,
      ty_areas   TYPE STANDARD TABLE OF ty_area WITH DEFAULT KEY,
      ty_i_table TYPE SORTED TABLE OF i WITH UNIQUE DEFAULT KEY.

ENDCLASS.



CLASS zcl_zzmj_aoc2025_day09 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA:
      t1 TYPE timestampl,
      t2 TYPE timestampl.

    " Get the time stamp so we can measure execution time
    GET TIME STAMP FIELD t1.

    " Decide which input to use
*    FINAL(input) = lcl_input=>example.
    FINAL(input) = zcl_zzmj_aoc2025_inputs=>day09.

    " Parse input into table of red tiles
    DATA(red_tiles) = VALUE ty_red_tiles( ).
    LOOP AT input ASSIGNING FIELD-SYMBOL(<line>).
      SPLIT <line> AT ',' INTO DATA(x) DATA(y).
      APPEND VALUE #( x = x y = y ) TO red_tiles.
    ENDLOOP.

    " Calculate all areas
    DATA(areas) = VALUE ty_areas( ).
    LOOP AT red_tiles ASSIGNING FIELD-SYMBOL(<red_tile_a>).
      LOOP AT red_tiles ASSIGNING FIELD-SYMBOL(<red_tile_b>) FROM sy-tabix + 1.
        APPEND VALUE #(
          red_tile_a = <red_tile_a>
          red_tile_b = <red_tile_b>
          area       = ( abs( <red_tile_a>-x - <red_tile_b>-x ) + 1 ) * ( abs( <red_tile_a>-y - <red_tile_b>-y ) + 1 )
        ) TO areas.
      ENDLOOP.
    ENDLOOP.

    " Sort areas descending
    SORT areas BY area DESCENDING.
    DATA(part1) = areas[ 1 ]-area.

    " Compact the coordinates by putting all the x and y coordinates in a mapping
    DATA(x_coordinates) = VALUE ty_i_table( ).
    DATA(y_coordinates) = VALUE ty_i_table( ).
    LOOP AT red_tiles ASSIGNING FIELD-SYMBOL(<red_tile>).
      INSERT <red_tile>-x INTO TABLE x_coordinates.
      INSERT <red_tile>-y INTO TABLE y_coordinates.
    ENDLOOP.

    " Create the grid, with the border line
    DATA(prev) = NEW zcl_zzmj_aoc2025_position(
        x = line_index( x_coordinates[ table_line = red_tiles[ lines( red_tiles ) ]-x ] )
        y = line_index( y_coordinates[ table_line = red_tiles[ lines( red_tiles ) ]-y ] ) ).
    DATA(grid) = NEW zcl_zzmj_aoc2025_grid( VALUE #( FOR grid_y = 1 UNTIL grid_y > lines( y_coordinates ) + 2
                                                     ( repeat( val = '_' occ = lines( x_coordinates ) + 2 ) ) ) ).
    LOOP AT red_tiles ASSIGNING <red_tile>.
      DATA(next) = NEW zcl_zzmj_aoc2025_position(
        x = line_index( x_coordinates[ table_line = <red_tile>-x ] )
        y = line_index( y_coordinates[ table_line = <red_tile>-y ] ) ).

      WHILE prev->equals( next ) = abap_false.
        IF prev->x = next->x.
          IF prev->y > next->y.
            prev = prev->up( ).
          ELSE.
            prev = prev->down( ).
          ENDIF.
        ELSE.
          IF prev->x > next->x.
            prev = prev->left( ).
          ELSE.
            prev = prev->right( ).
          ENDIF.
        ENDIF.
        grid->set( position = prev value = 'X' ).
      ENDWHILE.

      grid->set( position = next value = '#' ).
    ENDLOOP.

    " Flood fill outside from top left
    grid->flood_fill(
      find     = '_'
      fill     = '.'
      position = NEW zcl_zzmj_aoc2025_position( x = 0 y = 0 ) ).

    " And replace inside
    grid->replace_all(
      find = '_'
      fill = 'X' ).

    " Print the grid to output
*    grid->print( out ).

    " Loop at the sorted areas
    LOOP AT areas ASSIGNING FIELD-SYMBOL(<area>).
      " Map the coordinates to the compacted grid
      DATA(a_x) = line_index( x_coordinates[ table_line = <area>-red_tile_a-x ] ).
      DATA(a_y) = line_index( y_coordinates[ table_line = <area>-red_tile_a-y ] ).
      DATA(b_x) = line_index( x_coordinates[ table_line = <area>-red_tile_b-x ] ).
      DATA(b_y) = line_index( y_coordinates[ table_line = <area>-red_tile_b-y ] ).

      " Take a sub grid
      DATA(sub_grid) = grid->sub_grid(
                         position = NEW zcl_zzmj_aoc2025_position(
                           x = nmin( val1 = a_x val2 = b_x )
                           y = nmin( val1 = a_y val2 = b_y ) )
                         width    = abs( a_x - b_x ) + 1
                         height   = abs( a_y - b_y ) + 1
                       ).
      IF sub_grid->contains( '.' ) = abap_false.
        " If the condensed sub grid does not contain a dot, the while sub grid is part of the inside
        " When we found it, this is the answer of part 2 and we can stop.
        DATA(part2) = <area>-area.
        EXIT.
      ENDIF.
    ENDLOOP.

    " Write result to output
    out->write( |Part 1: { part1 }| ).
    out->write( |Part 2: { part2 }| ).

    " Get the time stamp again and write execution time to output
    GET TIME STAMP FIELD t2.
    out->write( |Execution took { t2 - t1 } seconds| ).

  ENDMETHOD.
ENDCLASS.
