CLASS zcl_zzmj_aoc2025_day03 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      run_part
        IMPORTING
                  input      TYPE string_table
                  len        TYPE i
        RETURNING VALUE(sum) TYPE int8.
ENDCLASS.



CLASS zcl_zzmj_aoc2025_day03 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    " Get the time stamp so we can measure execution time
    GET TIME STAMP FIELD DATA(t1).

    " Decide which input to use
    FINAL(input) = lcl_input=>example.
*    FINAL(input) = zcl_zzmj_aoc2025_inputs=>day03.


    " Run the parts and write to output
    out->write( |Part 1: { run_part( input = input len = 2 ) }| ).
    out->write( |Part 2: { run_part( input = input len = 12 ) }| ).

    " Get the time stamp again and write execution time to output
    GET TIME STAMP FIELD DATA(t2).
    out->write( |Execution took { t2 - t1 } seconds| ).

  ENDMETHOD.

  METHOD run_part.
    " Loop over the input
    LOOP AT input INTO DATA(bank).
      " Set the next cursor, which is the offset in the bank string to the next character
      DATA(next_cursor) = 1.

      " We are going to remove characters, so as long as we are larger than we need, we can continue
      WHILE strlen( bank ) > len.
        IF next_cursor = 0.
          " If the cursor is at the left edge, go one to the right
          next_cursor += 1.
          CONTINUE.
        ELSEIF next_cursor = strlen( bank ).
          " If the cursor is at the end, remove the trailing characters and we are done
          bank = bank(len).
          EXIT.
        ENDIF.

        " Get the characters previous and next of the cursor
        DATA(prev_cursor) = next_cursor - 1.
        DATA(prev) = bank+prev_cursor(1).
        DATA(next) = bank+next_cursor(1).

        IF prev < next.
          " If the next character is greater than the left character, remove the previous character
          bank = |{ bank(prev_cursor) }{ bank+next_cursor }|.
          " Also move the cursor one back, so it stays on the same place relative to the next character
          next_cursor -= 1.
        ELSE.
          " If the next character is equal or less than the left character, move the cursor to the right
          next_cursor += 1.
        ENDIF.
      ENDWHILE.

      " Add the joltage rating to the sum
      sum += bank.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
