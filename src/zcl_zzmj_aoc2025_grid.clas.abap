CLASS zcl_zzmj_aoc2025_grid DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      cell TYPE c LENGTH 1.

    DATA:
      grid   TYPE string_table READ-ONLY,
      empty  TYPE cell READ-ONLY,
      width  TYPE i READ-ONLY,
      height TYPE i READ-ONLY.

    METHODS:
      constructor
        IMPORTING
          grid  TYPE string_table
          empty TYPE cell DEFAULT space,
      get
        IMPORTING
                  position TYPE REF TO zcl_zzmj_aoc2025_position
        RETURNING VALUE(r) TYPE cell,
      set
        IMPORTING
          position TYPE REF TO zcl_zzmj_aoc2025_position
          value    TYPE cell,
      sub_grid
        IMPORTING
                  position TYPE REF TO zcl_zzmj_aoc2025_position
                  width    TYPE i
                  height   TYPE i
        RETURNING VALUE(r) TYPE REF TO zcl_zzmj_aoc2025_grid,
      flood_fill
        IMPORTING
          find     TYPE cell
          fill     TYPE cell
          position TYPE REF TO zcl_zzmj_aoc2025_position,
      contains
        IMPORTING
                  find     TYPE cell
        RETURNING VALUE(r) TYPE abap_bool,
      replace_all
        IMPORTING
          find TYPE cell
          fill TYPE cell,
      print
        IMPORTING
          out TYPE REF TO if_oo_adt_classrun_out.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zzmj_aoc2025_grid IMPLEMENTATION.
  METHOD constructor.
    me->grid   = grid.
    me->empty  = empty.
    me->width  = strlen( grid[ 1 ] ).
    me->height = lines( grid ).
  ENDMETHOD.

  METHOD get.
    IF position->x < 0 OR position->x >= me->width OR position->y < 0 OR position->y >= me->height.
      RETURN space.
    ELSE.
      DATA(line) = me->grid[ position->y + 1 ].
      RETURN line+position->x(1).
    ENDIF.
  ENDMETHOD.

  METHOD set.
    IF position->x < 0 OR position->x >= me->width OR position->y < 0 OR position->y >= me->height.
      " Do nothing
    ELSE.
      DATA(line) = me->grid[ position->y + 1 ].
      DATA(trail_offset) = position->x + 1.
      me->grid[ position->y + 1 ] = |{ line(position->x) }{ value }{ line+trail_offset }|.
    ENDIF.
  ENDMETHOD.

  METHOD sub_grid.
    DATA(grid) = VALUE string_table( ).
    LOOP AT me->grid ASSIGNING FIELD-SYMBOL(<line>) FROM position->y + 1 TO position->y + height.
      DATA(offset) = position->x.
      APPEND <line>+offset(width) TO grid.
    ENDLOOP.
    RETURN NEW zcl_zzmj_aoc2025_grid( grid ).
  ENDMETHOD.

  METHOD flood_fill.
    CHECK me->get( position ) = find.
    me->set( position = position value = fill ).
    flood_fill( find = find fill = fill position = position->up( ) ).
    flood_fill( find = find fill = fill position = position->down( ) ).
    flood_fill( find = find fill = fill position = position->left( ) ).
    flood_fill( find = find fill = fill position = position->right( ) ).
  ENDMETHOD.

  METHOD contains.
    FIND FIRST OCCURRENCE OF find IN TABLE me->grid.
    r = COND #( WHEN sy-subrc = 0 THEN abap_true ELSE abap_false ).
  ENDMETHOD.

  METHOD replace_all.
    REPLACE ALL OCCURRENCES OF find IN TABLE me->grid WITH fill.
  ENDMETHOD.

  METHOD print.
    LOOP AT grid ASSIGNING FIELD-SYMBOL(<line>).
      out->write( <line> ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
