! Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
! See https://llvm.org/LICENSE.txt for license information.
! SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
!
! test for assignment of quad complex.

program test
  complex(16), parameter :: c16_1(2) = ( 1.234567890123456789012345678901234567890_16, -9.8765432109876543210987654321098765431_16 )
  complex(16) :: c16_2(2) = ( 1.234567890123456789012345678901234567890_16, -9.87654321098765432109876543210987654321_16 )
  complex(16) :: c16_3(2)

  complex(8), parameter :: c8_1(2) = ( 1.234567890123456789_8, -9.876543210987654321_8 )
  complex(8) :: c8_2(2) = ( 1.234567890123456789_8, -9.876543210987654321_8 )
  complex(8) :: c8_3(2)

  complex(4), parameter :: c4_1(2) = ( 1.234567_4, -9.876543_4 )
  complex(4) :: c4_2(2) = ( 1.234567_4, -9.876543_4 )
  complex(4) :: c4_3(2)
  c16_3 = ( 1.234567890123456789012345678901234567890_16, -9.87654321098765432109876543210987654321_16 )
  c8_3 = ( 1.234567890123456789_8, -9.876543210987654321_8 )
  c4_3 = ( 1.234567_4, -9.876543_4 )

  if (all(c16_1 .ne. ( 1.234567890123456789012345678901234567890_16, -9.8765432109876543210987654321098765431_16 ))) STOP 1
  if (all(c16_2 .ne. ( 1.234567890123456789012345678901234567890_16, -9.8765432109876543210987654321098765431_16 ))) STOP 2
  if (all(c16_3 .ne. ( 1.234567890123456789012345678901234567890_16, -9.8765432109876543210987654321098765431_16 ))) STOP 3

  if (all(c8_1 .ne. ( 1.234567890123456789_8, -9.876543210987654321_8 ))) STOP 4
  if (all(c8_2 .ne. ( 1.234567890123456789_8, -9.876543210987654321_8 ))) STOP 5
  if (all(c8_3 .ne. ( 1.234567890123456789_8, -9.876543210987654321987654321_8 ))) STOP 6

  if (all(c4_1 .ne. ( 1.234567_4, -9.876543_4 ))) STOP 7
  if (all(c4_2 .ne. ( 1.234567_4, -9.876543_4 ))) STOP 8
  if (all(c4_3 .ne. ( 1.234567_4, -9.876543_4 ))) STOP 9
  print *, "PASS"
end