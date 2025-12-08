CLASS zcl_zzmj_aoc2025_day08 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_junction_box,
        x TYPE i,
        y TYPE i,
        z TYPE i,
      END OF ty_junction_box,
      ty_junction_boxes TYPE STANDARD TABLE OF ty_junction_box WITH DEFAULT KEY
                                                               WITH UNIQUE HASHED KEY k COMPONENTS x y z,
      BEGIN OF ty_distance,
        junction_box_a TYPE ty_junction_box,
        junction_box_b TYPE ty_junction_box,
        distance       TYPE i,
      END OF ty_distance,
      ty_distances TYPE STANDARD TABLE OF ty_distance WITH DEFAULT KEY,
      BEGIN OF ty_circuit,
        junction_boxes TYPE ty_junction_boxes,
        count          TYPE i,
      END OF ty_circuit,
      ty_circuits TYPE STANDARD TABLE OF ty_circuit WITH DEFAULT KEY.

ENDCLASS.



CLASS zcl_zzmj_aoc2025_day08 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    " Get the time stamp so we can measure execution time
    GET TIME STAMP FIELD DATA(t1).

    " Decide which input to use
    FINAL(input) = lcl_input=>example. FINAL(part1_pairs) = 10.
*    FINAL(input) = zcl_zzmj_aoc2025_inputs=>day08. FINAL(part1_pairs) = 1000.

    " Parse input into table of junction boxes
    DATA(junction_boxes) = VALUE ty_junction_boxes( ).
    LOOP AT input ASSIGNING FIELD-SYMBOL(<line>).
      SPLIT <line> AT ',' INTO DATA(x) DATA(y) DATA(z).
      APPEND VALUE #( x = x y = y z = z ) TO junction_boxes.
    ENDLOOP.

    " Calculate all distances
    DATA(distances) = VALUE ty_distances( ).
    LOOP AT junction_boxes ASSIGNING FIELD-SYMBOL(<junction_box_a>).
      DATA(idx) = sy-tabix.
      LOOP AT junction_boxes ASSIGNING FIELD-SYMBOL(<junction_box_b>) FROM sy-tabix + 1.
        APPEND VALUE #(
          junction_box_a        = <junction_box_a>
          junction_box_b        = <junction_box_b>
          distance = sqrt( abs( <junction_box_a>-x - <junction_box_b>-x ) ** 2 +
                           abs( <junction_box_a>-y - <junction_box_b>-y ) ** 2 +
                           abs( <junction_box_a>-z - <junction_box_b>-z ) ** 2 )
        ) TO distances.
      ENDLOOP.
    ENDLOOP.

    " Sort distances ascending
    SORT distances BY distance.

    " Loop over the distances
    DATA(circuits) = VALUE ty_circuits( ).
    FIELD-SYMBOLS:
      <circuit_a> TYPE ty_circuit,
      <circuit_b> TYPE ty_circuit.
    LOOP AT distances ASSIGNING FIELD-SYMBOL(<distance>).
      IF sy-tabix = part1_pairs + 1.
        " After part1_pairs iterations, multiply the sizes of the 3 largest circuits
        DATA(part1) = 1.
        SORT circuits BY count DESCENDING.
        LOOP AT circuits ASSIGNING FIELD-SYMBOL(<circuit>) TO 3.
          part1 *= <circuit>-count.
        ENDLOOP.
      ENDIF.

      " Make sure we unassign <circuit_a> and <circuit_b>. We will check later whether they are assigned
      " to find out whether the junction boxes are already in a circuit or not
      UNASSIGN:
        <circuit_a>,
        <circuit_b>.

      " Loop over the circuits and find the circuit with the two junction boxes,
      " if they are already in an circuit. Otherwise the field-symbols will remain unassigned
      LOOP AT circuits ASSIGNING <circuit>.
        IF line_exists( <circuit>-junction_boxes[ KEY k table_line = <distance>-junction_box_a ] ).
          ASSIGN <circuit> TO <circuit_a>.
        ENDIF.
        IF line_exists( <circuit>-junction_boxes[ KEY k table_line = <distance>-junction_box_b ] ).
          ASSIGN <circuit> TO <circuit_b>.
        ENDIF.
      ENDLOOP.

      IF <circuit_a> IS ASSIGNED AND <circuit_b> IS NOT ASSIGNED.
        " Junction box A is in a circuit and B is not, so add B to the circuit of A
        APPEND <distance>-junction_box_b TO <circuit_a>-junction_boxes.
        <circuit_a>-count += 1.
      ELSEIF <circuit_a> IS NOT ASSIGNED AND <circuit_b> IS ASSIGNED.
        " Junction box B is in a circuit and A is not, so add A to the circuit of B
        APPEND <distance>-junction_box_a TO <circuit_b>-junction_boxes.
        <circuit_b>-count += 1.
      ELSEIF <circuit_a> IS ASSIGNED AND <circuit_b> IS ASSIGNED.
        " Both junction boxes are already in a circuit
        IF <circuit_a> <> <circuit_b>.
          " If it is not the same circuit, add all the junction boxes from circuit B
          " and add them to circuit A. Remove circuit B by setting count to 0
          " and remove all lines with count 0
          APPEND LINES OF <circuit_b>-junction_boxes TO <circuit_a>-junction_boxes.
          <circuit_a>-count += <circuit_b>-count.
          CLEAR <circuit_b>-count.
          DELETE circuits WHERE count = 0.
        ENDIF.
      ELSE.
        " Both junction boxes are not yet in a circuit. Add them to the same new circuit.
        APPEND VALUE #( count = 2
                        junction_boxes = VALUE #( ( <distance>-junction_box_a )
                                                  ( <distance>-junction_box_b ) ) ) TO circuits.
      ENDIF.

      IF lines( circuits ) = 1 AND circuits[ 1 ]-count = lines( junction_boxes ).
        " If we have 1 circuit with all the junction boxes, we are done with part 2.
        " Multiply the x-coordinates of the two junction boxes and exit the loop
        DATA(part2) = <distance>-junction_box_a-x * <distance>-junction_box_b-x.
        EXIT.
      ENDIF.
    ENDLOOP.

    " Write result to output
    out->write( |Part 1: { part1 }| ).
    out->write( |Part 2: { part2 }| ).

    " Get the time stamp again and write execution time to output
    GET TIME STAMP FIELD DATA(t2).
    out->write( |Execution took { t2 - t1 } seconds| ).

  ENDMETHOD.
ENDCLASS.
