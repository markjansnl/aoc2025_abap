CLASS zcl_zzmj_aoc2025_position DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      direction TYPE c LENGTH 1.

    CONSTANTS:
      direction_up    TYPE direction VALUE 'U',
      direction_down  TYPE direction VALUE 'D',
      direction_left  TYPE direction VALUE 'L',
      direction_right TYPE direction VALUE 'R'.

    DATA:
      x TYPE i READ-ONLY,
      y TYPE i READ-ONLY.

    METHODS:
      constructor
        IMPORTING
          x TYPE i OPTIONAL
          y TYPE i OPTIONAL,
      move
        IMPORTING
                  direction TYPE direction
        RETURNING VALUE(r)  TYPE REF TO zcl_zzmj_aoc2025_position,
      up
        RETURNING VALUE(r) TYPE REF TO zcl_zzmj_aoc2025_position,
      down
        RETURNING VALUE(r) TYPE REF TO zcl_zzmj_aoc2025_position,
      left
        RETURNING VALUE(r) TYPE REF TO zcl_zzmj_aoc2025_position,
      right
        RETURNING VALUE(r) TYPE REF TO zcl_zzmj_aoc2025_position.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zzmj_aoc2025_position IMPLEMENTATION.
  METHOD constructor.
    me->x = x.
    me->y = y.
  ENDMETHOD.

  METHOD move.
    CASE direction.
      WHEN direction_up.
        RETURN NEW #( x = me->x y = me->y - 1 ).
      WHEN direction_down.
        RETURN NEW #( x = me->x y = me->y + 1 ).
      WHEN direction_left.
        RETURN NEW #( x = me->x - 1 y = me->y ).
      WHEN direction_right.
        RETURN NEW #( x = me->x + 1 y = me->y ).
    ENDCASE.
  ENDMETHOD.

  METHOD up.
    RETURN move( direction_up ).
  ENDMETHOD.

  METHOD down.
    RETURN move( direction_down ).
  ENDMETHOD.

  METHOD left.
    RETURN move( direction_left ).
  ENDMETHOD.

  METHOD right.
    RETURN move( direction_right ).
  ENDMETHOD.

ENDCLASS.
