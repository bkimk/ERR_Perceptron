.section .text
.globl _start
    # Refer to the RISC-V ISA Spec for the functionality of
    # the instructions in this test program.
_start:
    # Note that the comments in this file should not be taken as
    # an example of good commenting style!!  They are merely provided
    # in an effort to help you understand the assembly style.

ADDI x0, x0, 0
ADDI x1, x0, 0
ADDI x2, x0, 0
ADDI x3, x0, 0
ADDI x4, x0, 0
ADDI x5, x0, 0
ADDI x6, x0, 0
ADDI x7, x0, 0
ADDI x8, x0, 0
ADDI x9, x0, 0
ADDI x10, x0, 0
ADDI x11, x0, 0
ADDI x12, x0, 0
ADDI x13, x0, 0
ADDI x14, x0, 0
ADDI x15, x0, 0
ADDI x16, x0, 0
ADDI x17, x0, 0
ADDI x18, x0, 0
ADDI x19, x0, 0
ADDI x20, x0, 0
ADDI x21, x0, 0
ADDI x22, x0, 0
ADDI x23, x0, 0
ADDI x24, x0, 0
ADDI x25, x0, 0
ADDI x26, x0, 0
ADDI x27, x0, 0
ADDI x28, x0, 0
ADDI x29, x0, 0
ADDI x30, x0, 0
ADDI x31, x0, 0

ORI x6, x1, 83

LUI x16, 24

SLTU x17, x3, x25

ANDI x5, x22, -1

SLLI x27, x17, 2

SRL x17, x30, x19

XOR x1, x11, x11

AUIPC x13, 1

SUB x5, x28, x7

AUIPC x4, 3

SUB x19, x30, x27

SLTI x1, x3, -15

OR x13, x20, x30

SRL x18, x29, x19

OR x21, x11, x20

SLTIU x24, x6, 50

ORI x26, x17, -68

SRA x15, x5, x23

ORI x26, x5, -5

SLT x21, x19, x18

SLLI x9, x16, 1

ADDI x21, x2, 0

SUB x3, x2, x12

SLTIU x29, x1, -54

LUI x20, 13

SLTI x23, x9, -28

SLT x25, x8, x11

OR x25, x9, x15

XOR x2, x9, x28

XORI x27, x18, -92

SLT x10, x10, x16

SUB x4, x25, x11

SRAI x27, x12, 10

SLL x23, x17, x8

SLT x18, x31, x24

LUI x5, 11

ORI x17, x11, -50

OR x30, x14, x10

ORI x17, x3, 82

XORI x18, x25, 15

SLTI x2, x18, -21

LUI x20, 16

SLTU x12, x10, x5

AUIPC x20, 1

ORI x27, x4, -24

SLTI x26, x26, 22

SLT x7, x30, x26

LUI x31, 5

LUI x5, 0

XORI x25, x30, -21

SLTI x28, x24, 46

AUIPC x27, 1

SLT x29, x6, x6

SUB x1, x10, x21

SLTIU x22, x15, 49

SLL x15, x3, x12

AUIPC x7, 9

OR x22, x27, x25

XORI x26, x12, 57

SLLI x26, x3, 8

SLLI x17, x12, 14

SLL x16, x18, x20

AND x31, x31, x25

SLL x15, x10, x27

ADD x17, x3, x23

AND x18, x8, x24

SRA x14, x25, x26

AUIPC x18, 13

OR x14, x23, x12

SLTIU x24, x20, -79

SLTIU x15, x25, 26

SLTIU x14, x30, -17

SRAI x30, x22, 23

XORI x30, x7, -76

AUIPC x19, 8

SLLI x25, x3, 11

SRLI x18, x15, 18

SRA x8, x4, x29

ADDI x18, x28, 92

AUIPC x21, 16

LUI x12, 24

OR x6, x30, x14

SRL x26, x22, x13

LUI x4, 13

ANDI x26, x31, 10

SLL x10, x17, x20

SUB x29, x21, x10

SRAI x17, x2, 5

SUB x9, x31, x17

ADD x14, x30, x30

ADDI x22, x29, -73

SLT x31, x16, x27

SLTIU x6, x3, -3

ORI x7, x6, 2

AND x2, x2, x27

LUI x28, 19

AND x30, x25, x3

LUI x29, 3

SLTU x30, x6, x11

XOR x20, x28, x2

SLT x2, x23, x2

SLT x5, x2, x8

SLTU x28, x13, x11

SLTU x1, x31, x14

SLTI x6, x27, 60

ADDI x15, x3, -97

SRLI x22, x23, 1

AND x27, x15, x20

SLT x21, x15, x8

SRA x1, x7, x19

SLLI x12, x19, 21

ADDI x26, x31, -92

SRA x30, x11, x14

SRL x4, x8, x24

AND x8, x28, x4

ADDI x15, x8, 43

ADDI x12, x5, 80

SLTI x23, x2, -32

ORI x6, x20, -54

OR x3, x8, x29

ORI x12, x11, -96

ORI x22, x10, 30

SRA x24, x2, x28

AUIPC x2, 3

ADDI x28, x8, 17

SRA x9, x29, x9

XORI x7, x10, -89

ADD x4, x29, x24

AUIPC x3, 21

SRLI x5, x29, 0

ADDI x4, x11, 3

XOR x22, x16, x19

SRAI x2, x7, 14

AND x15, x3, x13

ADD x6, x4, x18

SRL x2, x4, x16

LUI x4, 17

ANDI x5, x23, -53

SRL x16, x21, x15

XOR x23, x8, x31

ANDI x17, x28, -34

SLTIU x27, x19, 58

SLT x7, x28, x5

SLT x26, x12, x3

SLL x19, x3, x1

SLTI x26, x17, -94

LUI x5, 22

SLTI x28, x7, 86

AUIPC x3, 16

XORI x8, x23, 53

ORI x29, x26, -46

SLL x7, x29, x15

ANDI x24, x7, 18

SUB x26, x18, x4

LUI x23, 3

SLTI x16, x11, 19

SUB x15, x11, x10

XOR x10, x25, x27

AUIPC x15, 1

SRA x29, x10, x5

ANDI x22, x9, 41

XOR x16, x25, x18

SRA x14, x25, x12

SLLI x15, x1, 17

AND x19, x18, x30

SLL x3, x8, x25

LUI x10, 6

SLL x8, x17, x25

XORI x8, x11, -65

XOR x14, x27, x29

SRL x31, x6, x27

XOR x18, x8, x26

SRA x6, x8, x20

SRA x21, x8, x3

SRA x12, x8, x27

LUI x6, 24

SLTI x17, x13, 75

ORI x29, x4, -14

LUI x18, 20

SLT x11, x10, x12

AUIPC x14, 14

OR x23, x7, x9

LUI x19, 5

AUIPC x18, 1

SRLI x7, x15, 18

SLTI x29, x31, 68

LUI x23, 21

XORI x24, x31, 39

SLTIU x29, x19, 61

OR x10, x31, x18

SRL x1, x20, x31

SLTI x15, x3, -25

SLTIU x2, x19, -67

ADDI x8, x25, -82

ORI x13, x4, -14

SLTIU x2, x23, 76

SRLI x5, x10, 7

SLT x2, x17, x8

XORI x31, x5, -41

OR x17, x23, x7

ADDI x31, x20, -87

SUB x29, x23, x16

XORI x19, x7, 83

ADD x9, x1, x20

ORI x23, x17, -77

OR x15, x31, x30

LUI x1, 10

AUIPC x9, 10

AUIPC x14, 15

ANDI x26, x30, 74

ANDI x28, x17, -43

XOR x26, x31, x20

SLTI x14, x29, 72

SLLI x28, x14, 21

SLLI x3, x7, 7

SLTIU x10, x23, 40

ADDI x9, x5, 53

SLTIU x28, x16, -61

SLT x24, x16, x25

SRA x3, x7, x30

AND x5, x12, x22

SLT x25, x4, x7

SUB x7, x1, x15

LUI x30, 9

SLL x16, x28, x9

ADDI x28, x8, 52

SLT x31, x28, x23

SRL x16, x9, x11

SLL x12, x10, x13

SLTI x28, x27, 10

AND x14, x7, x5

SLTU x20, x5, x29

OR x14, x17, x26

XOR x17, x5, x31

SUB x29, x31, x24

SLTU x26, x3, x16

SLL x8, x18, x4

SUB x5, x5, x29

SRLI x23, x3, 3

AND x25, x7, x26

LUI x21, 13

ORI x30, x22, -40

AUIPC x23, 9

OR x15, x7, x17

SLTI x19, x9, -42

SLLI x3, x4, 0

SLTI x10, x10, 15

ADDI x25, x25, 82

OR x12, x16, x17

XORI x18, x26, -51

SLTI x20, x23, 70

SRA x29, x14, x6

SUB x12, x26, x30

ANDI x25, x13, -73

ADDI x29, x18, -79

OR x24, x1, x8

SRA x10, x19, x17

SLLI x19, x4, 16

ORI x20, x26, -53

AND x13, x17, x30

XOR x14, x2, x12

SRLI x1, x11, 22

LUI x11, 22

ADDI x10, x17, -8

SLTI x17, x3, 68

SLT x28, x8, x11

XORI x5, x15, -16

SRAI x8, x21, 6

SUB x31, x13, x20

SRL x12, x18, x14

SRLI x2, x31, 9

SLT x30, x22, x30

SRAI x23, x26, 13

OR x5, x11, x11

ANDI x1, x10, -31

OR x25, x3, x14

ORI x25, x16, -64

SLLI x29, x23, 5

SRL x6, x10, x23

OR x20, x22, x14

SRLI x26, x13, 7

XORI x30, x20, 13

SRA x19, x2, x27

LUI x23, 13

SLLI x13, x24, 22

AUIPC x29, 20

ORI x30, x13, 38

SLL x15, x20, x10

SRLI x17, x14, 2

SLL x2, x31, x29

OR x7, x18, x14

ADDI x4, x1, 30

XOR x22, x9, x30

SLTU x16, x31, x15

ADD x18, x19, x20

SLTIU x4, x14, -20

ANDI x24, x19, 90

SLTI x23, x2, -44

OR x14, x4, x9

SLTU x5, x16, x15

SLLI x7, x5, 12

ADD x29, x1, x12

SRAI x31, x28, 4

ORI x7, x20, 48

SLTI x20, x20, -29

ADD x1, x3, x20

SLTU x9, x25, x3

OR x15, x21, x1

ADD x21, x4, x16

SRAI x16, x21, 22

SUB x1, x12, x20

SLTIU x11, x27, 80

SRLI x31, x12, 15

SRAI x19, x3, 16

ADDI x31, x26, -1

SRA x23, x11, x13

SLTIU x2, x22, -47

AUIPC x23, 1

SLT x12, x13, x29

SLTU x16, x21, x24

SRAI x26, x2, 13

SRLI x5, x12, 21

ADD x16, x14, x27

XOR x24, x18, x9

ADDI x21, x10, 74

SLTI x9, x23, 16

SLTIU x2, x12, 46

SUB x1, x10, x4

SRLI x14, x29, 12

SLT x25, x21, x7

SRA x2, x14, x16

SLT x24, x31, x27

SRAI x22, x30, 20

XOR x24, x20, x12

OR x28, x24, x4

SLTI x8, x2, 85

SLTU x29, x9, x15

SLLI x25, x4, 1

LUI x19, 7

SLTI x9, x11, 56

XOR x4, x18, x21

OR x3, x31, x29

SRAI x12, x21, 20

SRLI x25, x8, 9

XOR x13, x13, x23

SLL x29, x4, x27

ANDI x20, x21, -64

SRAI x27, x27, 13

AUIPC x19, 22

SLT x31, x17, x10

SLTIU x6, x23, 59

SLTU x2, x20, x1

SRLI x3, x6, 7

ADD x4, x19, x4

AUIPC x3, 23

ORI x16, x19, -77

OR x1, x4, x28

XORI x7, x13, 42

SLTIU x16, x31, 74

ORI x29, x27, -44

ADDI x26, x2, -15

AUIPC x23, 23

SRLI x5, x18, 20

AND x29, x6, x29

SLTI x20, x9, 80

SRA x31, x4, x29

SLTU x10, x26, x25

ANDI x19, x6, 88

SRLI x30, x19, 21

SRL x13, x15, x24

SLT x22, x7, x20

SRA x20, x12, x1

SRL x23, x30, x14

SLT x5, x25, x17

SUB x10, x25, x6

SLTI x6, x23, 88

OR x29, x17, x13

ORI x19, x19, 82

XOR x8, x29, x3

SLTU x18, x8, x11

SRLI x20, x30, 8

SLLI x23, x18, 10

SRA x9, x22, x12

SLT x13, x29, x15

XORI x15, x14, 98

ADD x1, x4, x31

AND x7, x3, x7

AND x28, x8, x8

SRL x15, x31, x17

SRLI x16, x21, 2

AND x20, x23, x7

SLT x9, x3, x20

ANDI x31, x25, 49

SRL x23, x12, x25

SLTU x15, x25, x30

AUIPC x28, 1

SLT x28, x19, x5

SLTIU x3, x1, 0

SLL x20, x2, x28

ADDI x3, x3, -63

AND x30, x21, x24

ADDI x14, x17, -73

SLTIU x26, x13, -56

SLL x29, x30, x31

SRA x13, x3, x4

SLL x28, x21, x13

SRAI x30, x19, 11

AND x5, x30, x22

LUI x4, 13

ANDI x30, x3, -36

ADDI x4, x6, 1

SLTI x21, x22, -67

OR x24, x26, x3

AUIPC x21, 19

SUB x28, x14, x7

SLTI x15, x20, -72

SRA x31, x21, x16

SRLI x13, x1, 16

ANDI x25, x8, -59

SLLI x18, x4, 21

ADD x11, x18, x10

SLTIU x30, x4, -29

XOR x24, x16, x16

LUI x31, 9

SLTI x9, x21, -89

ANDI x16, x9, -64

ORI x14, x23, 49

SLT x24, x11, x14

SLTIU x23, x28, 59

SLLI x29, x15, 11

XORI x21, x12, -46

SRAI x30, x29, 3

SLTU x11, x10, x10

SLTIU x25, x29, 14

SLTI x10, x25, 57

OR x9, x17, x27

ORI x14, x26, 88

SRL x6, x2, x2

XOR x1, x5, x18

LUI x21, 2

SUB x30, x2, x29

OR x16, x12, x27

SRL x31, x15, x5

XORI x17, x1, -18

SLTU x4, x13, x29

SLT x18, x9, x12

SLTIU x28, x19, 85

AUIPC x6, 22

SLTIU x29, x10, 30

LUI x27, 19

SRA x20, x17, x21

SUB x20, x6, x6

SRA x31, x4, x22

XORI x29, x27, 0

ORI x30, x10, 77

XORI x2, x8, 1

SLT x12, x26, x3

SLTIU x4, x8, -37

AND x1, x28, x9

XOR x26, x21, x28

SLTI x13, x29, 42

SLL x17, x14, x1

AUIPC x6, 17

SRL x31, x28, x21

SLL x3, x23, x7

SRAI x1, x10, 1

AUIPC x23, 10

SRLI x31, x23, 18

SUB x13, x1, x6

SRL x6, x7, x25

SRAI x22, x25, 2

XORI x7, x16, -60

AUIPC x30, 14

SRA x28, x22, x7

SLLI x7, x11, 11

XOR x18, x19, x26

SLT x16, x30, x29

XOR x1, x14, x3

SLTU x1, x26, x11

ADDI x13, x26, -42

XOR x29, x13, x2

SLTU x11, x28, x18

ADDI x21, x9, -54

SLT x1, x8, x4

SLL x8, x30, x15

OR x24, x10, x6

OR x31, x20, x17

ADD x27, x20, x8

OR x12, x23, x24

SRLI x6, x20, 0

AUIPC x15, 1

SRL x28, x10, x17

ANDI x28, x12, 29

ADDI x18, x5, -20

SLTIU x22, x11, -30

ORI x31, x6, 70

AUIPC x17, 6

LUI x31, 9

AND x21, x10, x16

AND x1, x16, x12

AUIPC x3, 14

SRL x22, x28, x2

LUI x8, 3

SLL x13, x9, x9

LUI x20, 8

SLT x31, x27, x4

SRA x3, x30, x3

ANDI x8, x12, 88

SRL x25, x15, x6

SLTI x24, x8, 42

SRL x3, x27, x3

SUB x27, x21, x27

SLTIU x12, x10, 73

XOR x16, x29, x18

SLTU x6, x8, x1

SLTI x14, x8, -86

SRL x9, x4, x1

XORI x20, x5, -84

SLTU x27, x15, x22

SLT x4, x8, x30

ADDI x2, x15, 66

XOR x18, x2, x16

SRAI x9, x1, 21

SRL x24, x11, x23

SLL x21, x30, x11

SLTU x12, x24, x4

OR x26, x13, x26

SLLI x24, x30, 24

XORI x1, x23, -44

ADD x27, x1, x25

SRAI x29, x9, 4

AUIPC x25, 6

SRAI x21, x21, 18

SLTU x23, x3, x26

SLTIU x2, x17, -45

ADD x7, x6, x19

ANDI x12, x18, 61

SLT x2, x11, x23

SLTU x4, x11, x2

SLTU x16, x10, x29

SRLI x3, x30, 16

AUIPC x16, 20

XOR x27, x21, x9

XOR x4, x25, x4

SLTU x29, x12, x14

XORI x10, x24, -29

SLL x27, x4, x10

SUB x12, x13, x23

SRAI x5, x14, 20

ADD x29, x5, x10

ANDI x29, x30, -62

ADD x4, x22, x30

SLTIU x5, x12, -17

SLTI x26, x10, -31

SUB x14, x5, x13

OR x29, x20, x31

ADD x6, x15, x6

SUB x19, x5, x29

XORI x23, x20, -63

AUIPC x21, 3

XOR x25, x2, x20

XORI x3, x30, -63

SLTU x14, x28, x13

SRLI x21, x13, 1

ANDI x18, x8, -94

SRAI x12, x21, 19

SLL x9, x16, x2

XOR x3, x31, x30

SRAI x31, x10, 2

ORI x15, x27, 16

XOR x8, x30, x21

LUI x1, 6

AND x5, x25, x16

OR x29, x16, x30

SRA x6, x23, x15

SRL x27, x2, x6

ADDI x24, x20, 28

SRL x24, x1, x2

ANDI x16, x7, 74

ANDI x28, x7, -38

SRLI x22, x26, 22

ORI x20, x18, 82

XORI x5, x11, 46

AUIPC x16, 9

XOR x16, x1, x20

SLT x21, x3, x28

ORI x8, x14, 65

SRA x9, x1, x6

ADD x13, x12, x21

ORI x11, x17, 40

ORI x25, x19, -89

SRA x30, x31, x28

SLTU x24, x31, x24

ADDI x25, x26, -87

SLL x5, x14, x23

SLLI x30, x25, 8

AUIPC x20, 20

SLTIU x31, x23, -5

SUB x28, x11, x19

OR x2, x8, x9

SRLI x29, x17, 10

OR x5, x29, x1

SUB x12, x3, x6

LUI x18, 10

SLTU x31, x3, x13

SRL x15, x19, x3

SRLI x31, x3, 22

ADDI x9, x27, 20

SLTI x10, x6, -34

ADDI x13, x7, 29

ANDI x30, x16, -49

SUB x8, x7, x14

SUB x31, x30, x29

OR x2, x14, x12

SRAI x7, x14, 9

SUB x20, x28, x25

ANDI x4, x11, -36

SLTI x4, x22, 81

AUIPC x6, 15

SRA x19, x3, x10

SLTIU x29, x9, 98

SLTIU x27, x30, -27

SRAI x27, x15, 16

SRLI x25, x29, 13

OR x30, x16, x10

AND x22, x17, x26

SRLI x13, x18, 0

SLL x16, x16, x31

AND x19, x18, x14

ADD x13, x22, x4

AUIPC x8, 19

SRLI x18, x17, 7

XORI x13, x20, -42

SRL x15, x12, x31

SRL x4, x23, x15

ORI x31, x26, -29

ORI x28, x17, 27

SLL x16, x4, x12

SLLI x20, x6, 21

SLTIU x2, x5, 56

XOR x17, x27, x7

ORI x15, x3, 84

SLLI x13, x8, 13

OR x14, x12, x12

SLTIU x29, x23, -1

SLT x11, x27, x9

OR x29, x26, x22

OR x21, x31, x23

SLTIU x24, x5, 6

SLT x23, x23, x29

SLTIU x24, x11, -20

SRA x3, x6, x18

ORI x4, x24, 7

SLLI x30, x15, 8

XOR x12, x20, x26

XORI x29, x4, 84

LUI x10, 20

SLTIU x14, x2, -93

OR x23, x13, x12

LUI x8, 20

SUB x9, x24, x3

XOR x26, x13, x18

SLLI x16, x20, 22

LUI x31, 4

OR x8, x3, x16

SLT x20, x5, x19

SRAI x30, x12, 20

ORI x9, x2, -62

AND x7, x6, x18

AND x20, x8, x20

SLLI x9, x13, 7

SRAI x22, x2, 1

SLL x21, x6, x16

SRLI x7, x26, 21

SLTIU x6, x3, -45

SLT x7, x2, x2

SLL x2, x4, x17

SLL x25, x19, x21

SLL x18, x17, x28

XOR x31, x28, x8

SLLI x19, x7, 10

ADD x25, x20, x31

SLTIU x10, x20, -12

ANDI x26, x8, -83

LUI x1, 17

SRL x19, x13, x19

ADDI x2, x9, -53

ORI x17, x3, 58

ANDI x26, x6, 66

SRAI x30, x28, 21

AUIPC x2, 3

ADDI x5, x11, -14

AND x8, x11, x21

SUB x31, x20, x29

SLL x21, x27, x4

ORI x21, x1, -81

ADDI x27, x16, 24

OR x13, x13, x18

LUI x6, 0

SLL x21, x9, x26

SRLI x18, x19, 15

SRLI x12, x29, 13

AND x8, x24, x28

AUIPC x8, 19

ORI x29, x23, -36

SRLI x25, x25, 2

SRA x16, x29, x3

SRAI x20, x3, 23

ADD x1, x15, x26

SUB x3, x26, x31

SUB x2, x14, x20

ADDI x19, x20, 20

SRL x24, x7, x29

ADD x11, x3, x25

AUIPC x21, 7

ADD x24, x9, x1

OR x8, x19, x22

ORI x1, x21, 18

SLTIU x13, x6, 79

SRA x31, x6, x18

SLT x11, x5, x19

XORI x27, x18, -30

ORI x22, x8, 51

SLTU x31, x17, x7

SLTU x22, x23, x14

AND x6, x13, x4

ORI x29, x20, 5

SRLI x25, x24, 15

SLTI x11, x23, 92

SRLI x23, x29, 5

SRAI x11, x27, 22

ANDI x16, x30, 15

SLL x21, x24, x13

SUB x29, x1, x19

ORI x1, x19, -55

SLLI x5, x9, 20

ADD x18, x1, x5

AUIPC x8, 21

SLL x28, x5, x28

SLTIU x30, x26, 5

SLTU x17, x12, x5

ADDI x8, x8, -72

ADDI x26, x12, 47

ANDI x19, x28, -17

LUI x27, 20

SLTIU x4, x13, -43

ADD x2, x27, x25

LUI x31, 3

ANDI x6, x5, 78

ORI x11, x15, 31

SRL x19, x15, x10

AUIPC x14, 11

SRL x28, x18, x12

SRA x18, x1, x22

SLT x15, x11, x10

LUI x22, 11

SRA x6, x9, x16

SRL x1, x16, x16

SLL x8, x21, x31

SLL x15, x9, x27

SRAI x27, x24, 17

SLTI x6, x23, -50

OR x10, x25, x15

SRA x12, x19, x13

XOR x24, x13, x31

SRA x16, x13, x20

ORI x21, x2, 0

SRL x19, x3, x31

AND x19, x13, x2

ANDI x6, x23, 13

SUB x29, x31, x16

SLTU x6, x27, x3

SRLI x8, x5, 7

LUI x19, 17

SLLI x13, x23, 0

SRL x9, x10, x19

ORI x18, x3, 14

XORI x4, x16, 91

SLTIU x10, x17, 23

SRL x9, x30, x22

XORI x23, x19, -93

SRL x7, x16, x3

SRLI x7, x27, 23

SLT x10, x8, x24

XORI x30, x29, -33

ADD x30, x27, x22

SRL x22, x16, x28

SUB x19, x22, x30

AND x14, x9, x2

ADDI x20, x12, 15

SRAI x2, x5, 7

ADDI x11, x29, 56

SLTI x27, x25, -1

ANDI x30, x29, -39

SLTU x24, x7, x17

ANDI x11, x9, 93

SLLI x8, x18, 2

SRLI x10, x12, 2

SLT x4, x19, x24

ADDI x22, x20, 20

SUB x10, x19, x4

ANDI x1, x14, -43

SLT x6, x4, x19

ADDI x25, x9, -56

SLT x1, x10, x15

SLTI x20, x5, 55

SUB x6, x15, x28

SLTU x25, x31, x18

ADDI x16, x6, -58

ADDI x27, x29, -52

OR x7, x31, x15

XORI x31, x25, -52

SLL x24, x9, x21

AUIPC x2, 7

SRLI x18, x11, 1

SLLI x30, x7, 5

SRL x5, x5, x22

LUI x25, 5

XOR x6, x1, x19

SLLI x9, x31, 7

OR x18, x8, x29

SLTU x10, x10, x18

ORI x11, x15, 79

ANDI x22, x5, -8

AND x22, x10, x5

AND x26, x6, x23

SLL x7, x29, x4

LUI x14, 13

SLTU x17, x4, x18

AUIPC x9, 10

LUI x26, 20

ADD x31, x23, x16

SLLI x2, x8, 4

SRL x6, x1, x13

SLL x31, x16, x4

XOR x15, x18, x14

SLLI x27, x16, 1

ANDI x22, x16, 37

SLTU x15, x9, x4

SUB x19, x29, x21

OR x18, x31, x22

SLLI x29, x22, 8

SLL x29, x14, x30

SRA x11, x4, x3

XOR x1, x9, x9

SRA x9, x19, x8

SLTU x18, x13, x12

SLTI x10, x29, -6

SLL x22, x10, x30

SLTI x5, x20, 86

ADD x10, x8, x28

XORI x29, x12, -70

XOR x19, x29, x15

SRAI x22, x22, 6

SLTU x15, x25, x23

ORI x22, x21, 40

SRA x19, x7, x28

SRAI x4, x20, 17

SUB x10, x20, x27

SUB x6, x29, x27

SLTU x28, x3, x4

SLL x2, x2, x15

SUB x8, x8, x14

SLTI x3, x28, -90

SUB x31, x3, x17

LUI x17, 9

SRAI x16, x15, 19

XORI x17, x11, -12

SLL x6, x21, x31

AUIPC x20, 13

SRAI x22, x28, 23

SUB x30, x8, x12

ADD x12, x25, x5

SLTIU x28, x7, 0

XORI x29, x21, 25

XORI x14, x23, -1

SLTI x21, x22, 27

SLT x13, x21, x22

SLTIU x11, x31, -48

SLTU x7, x6, x8

SLLI x29, x4, 21

SLTU x19, x14, x4

ORI x20, x2, -92

SRLI x23, x19, 16

ANDI x12, x29, -92

SLTIU x10, x17, -49

ANDI x29, x9, -93

AUIPC x4, 23

SLTU x25, x28, x5

SRL x22, x19, x31

SRLI x8, x28, 22

ADDI x27, x18, -75

ANDI x17, x10, -46

SRL x16, x26, x21

SLTU x27, x16, x20

SRAI x8, x18, 1

SRLI x4, x9, 23

SRA x26, x24, x6

SLTU x5, x20, x9

SRLI x9, x8, 10

ORI x8, x21, 84

ANDI x17, x15, -34

AUIPC x20, 15

SLLI x14, x14, 16

SLTIU x24, x9, 72

SLLI x10, x8, 13

SLTU x28, x6, x29

AND x6, x16, x12

SRAI x8, x13, 17

SRL x12, x10, x20

SRLI x20, x14, 14

LUI x12, 9

AUIPC x10, 0

SRLI x21, x23, 10

OR x23, x4, x7

ADDI x7, x13, -19

AUIPC x20, 18

SLTU x23, x25, x5

SLTI x21, x5, -16

ADD x28, x31, x20

ADD x1, x11, x9

LUI x21, 10

SUB x26, x14, x8

ANDI x15, x25, 9

OR x1, x22, x14

ADDI x6, x5, -27

SRAI x10, x24, 24

SRLI x10, x25, 20

XORI x17, x27, -91

SLTI x2, x24, -39

SLLI x13, x3, 13

SLLI x30, x9, 13

AND x13, x24, x11

SRAI x12, x18, 17

ADD x1, x21, x21

SRL x2, x22, x16

ADD x9, x27, x21

AUIPC x28, 6

SLTU x15, x16, x13

ADDI x1, x6, -83

SRAI x4, x30, 17

SRAI x16, x12, 8

SLTI x15, x23, 89

SLTIU x20, x31, -77

SLTI x9, x3, -20

SLT x2, x14, x19

SLT x13, x21, x3

SLTU x9, x14, x22

SUB x18, x29, x22

LUI x30, 1

SRLI x22, x9, 9

ADDI x15, x22, -17

LUI x21, 17

SUB x10, x1, x21

SRAI x25, x2, 9

OR x19, x13, x20

SLT x12, x6, x3

SRL x26, x27, x18

OR x4, x15, x28

SUB x19, x2, x29

SLTIU x16, x13, 10

XORI x13, x26, -39

SRLI x6, x14, 15

ADDI x12, x7, -61

SLTIU x10, x6, -98

SLLI x7, x22, 16

ADDI x9, x17, 22

XORI x8, x2, 16

SLTIU x9, x6, 63

SLT x22, x28, x7

ADDI x17, x6, 8

SRA x26, x3, x1

SUB x1, x24, x26

ADD x21, x18, x15

XORI x27, x20, 58

SLT x19, x9, x10

ADD x18, x29, x15

AUIPC x17, 1

SRLI x21, x8, 19

AND x29, x20, x6

LUI x5, 1

OR x21, x12, x9

AND x19, x22, x6

SLTU x15, x10, x31

AUIPC x2, 15

ADD x1, x2, x20

SLT x16, x12, x29

SRLI x28, x17, 9

SRLI x11, x29, 16

SLTU x16, x13, x10

ADD x13, x15, x23

SRL x26, x25, x13

ANDI x11, x21, 89

XORI x30, x7, 66

SRA x18, x14, x5

SRLI x29, x8, 3

SLTU x31, x10, x15

SUB x14, x3, x20

SLTI x24, x31, -15

SRA x5, x21, x28


    # Add your own test cases here!
		
    slti x0, x0, -256 # this is the magic instruction to end the simulation
