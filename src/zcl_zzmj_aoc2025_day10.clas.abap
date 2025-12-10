CLASS zcl_zzmj_aoc2025_day10 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      ty_bits     TYPE x LENGTH 2, " 32 bit, so we have enough space for logarithm calculations
      ty_bits_tab TYPE STANDARD TABLE OF ty_bits WITH DEFAULT KEY,
      BEGIN OF ty_input,
        indicator_lights     TYPE ty_bits,
        buttons              TYPE ty_bits_tab,
        " Todo for part 2: joltage requirements
      END OF ty_input,
      ty_input_tab TYPE STANDARD TABLE OF ty_input WITH DEFAULT KEY,
      BEGIN OF ty_button_mask,
        mask     TYPE ty_bits,
        length   TYPE i,
        on_count TYPE i,
      END OF ty_button_mask,
      ty_button_masks TYPE STANDARD TABLE OF ty_button_mask WITH DEFAULT KEY.

    CLASS-METHODS:
      parse_ind_lights
        IMPORTING
                  s        TYPE string
        RETURNING VALUE(r) TYPE ty_bits,
      parse_buttons
        IMPORTING
                  s        TYPE string
        RETURNING VALUE(r) TYPE ty_bits_tab,
      count_on_bits
        IMPORTING
                  bits     TYPE ty_bits
        RETURNING VALUE(r) TYPE i.


ENDCLASS.



CLASS zcl_zzmj_aoc2025_day10 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA:
      t1 TYPE timestampl,
      t2 TYPE timestampl.

    " Get the time stamp so we can measure execution time
    GET TIME STAMP FIELD t1.

    " Decide which input to use
    FINAL(input) = lcl_input=>example.
*    FINAL(input) = zcl_zzmj_aoc2025_inputs=>day10.

    " Parse input
    DATA(parsed_input) = VALUE ty_input_tab( ).
    LOOP AT input ASSIGNING FIELD-SYMBOL(<line>).
      SPLIT <line> AT '] (' INTO DATA(ind_lights) DATA(buttons_and_joltage_req).
      SPLIT buttons_and_joltage_req AT ') {' INTO DATA(buttons) DATA(joltage_req).
      APPEND VALUE #(
        indicator_lights     = parse_ind_lights( |{ ind_lights+1 }| )
        buttons              = parse_buttons( buttons )
      ) TO parsed_input.
    ENDLOOP.

    " What is the max number of buttons?
    DATA(max_buttons) = REDUCE #( INIT mb = 0
                                  FOR <l> IN parsed_input
                                  NEXT mb = nmax( val1 = mb val2 = lines( <l>-buttons ) ) ).

    " Prepare button masks, and sort them
    DATA(button_masks) = VALUE ty_button_masks( ).
    DO 2 ** max_buttons TIMES.
      DATA(mask) = CONV ty_bits( sy-index - 1 ).
      APPEND VALUE #(
        mask     = mask
        length   = ceil( log( mask + 1 ) / log( 2 ) )
        on_count = count_on_bits( mask )
      ) TO button_masks.
    ENDDO.
    SORT button_masks BY on_count length mask.

    " For each line, try every button mask until we found the right one
    DATA(part1) = 0.
    LOOP AT parsed_input ASSIGNING FIELD-SYMBOL(<input_line>).
      LOOP AT button_masks ASSIGNING FIELD-SYMBOL(<button_mask>) WHERE length <= lines( <input_line>-buttons ).
        DATA(lights) = CONV ty_bits( 0 ).

        LOOP AT <input_line>-buttons ASSIGNING FIELD-SYMBOL(<button>).
          DATA(index_mask) = CONV ty_bits( 2 ** ( sy-tabix - 1 ) ).
          IF <button_mask>-mask BIT-AND index_mask > CONV ty_bits( 0 ).
            lights = lights BIT-XOR <button>.
          ENDIF.
        ENDLOOP.

        IF lights = <input_line>-indicator_lights.
          part1 += <button_mask>-on_count.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    " Write result to output
    out->write( |Part 1: { part1 }| ).
    out->write( |Part 2: { 0 }| ).

    " Get the time stamp again and write execution time to output
    GET TIME STAMP FIELD t2.
    out->write( |Execution took { t2 - t1 } seconds| ).

  ENDMETHOD.

  METHOD parse_ind_lights.
    " Store reversed, so that the most left character will be the most right (least significant) bit.
    DO strlen( s ) TIMES.
      DATA(offset) = sy-index - 1.
      IF s+offset(1) = '#'.
        r += 2 ** offset.
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD parse_buttons.
    SPLIT s AT ') (' INTO TABLE FINAL(buttons).
    LOOP AT buttons ASSIGNING FIELD-SYMBOL(<button>).
      APPEND INITIAL LINE TO r ASSIGNING FIELD-SYMBOL(<mask>).
      SPLIT <button> AT ',' INTO TABLE DATA(offsets).
      LOOP AT offsets ASSIGNING FIELD-SYMBOL(<offset>).
        <mask> += 2 ** <offset>.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD count_on_bits.
    DATA(b) = bits.
    WHILE b > 0.
      DATA(lsb) = b MOD 2.
      IF lsb = 1.
        r += 1.
      ENDIF.
      b = ( b - lsb ) / 2.
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.
