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
          value    TYPE cell.

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

ENDCLASS.
