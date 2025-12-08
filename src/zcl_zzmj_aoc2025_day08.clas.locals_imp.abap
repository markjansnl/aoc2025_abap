*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_input DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA:
      example TYPE string_table READ-ONLY.
    CLASS-METHODS:
      class_constructor.
ENDCLASS.


CLASS lcl_input IMPLEMENTATION.
  METHOD class_constructor.
    APPEND LINES OF VALUE string_table(
      ( `162,817,812` )
      ( `57,618,57` )
      ( `906,360,560` )
      ( `592,479,940` )
      ( `352,342,300` )
      ( `466,668,158` )
      ( `542,29,236` )
      ( `431,825,988` )
      ( `739,650,466` )
      ( `52,470,668` )
      ( `216,146,977` )
      ( `819,987,18` )
      ( `117,168,530` )
      ( `805,96,715` )
      ( `346,949,466` )
      ( `970,615,88` )
      ( `941,993,340` )
      ( `862,61,35` )
      ( `984,92,344` )
      ( `425,690,689` )
    ) TO example.
  ENDMETHOD.
ENDCLASS.
