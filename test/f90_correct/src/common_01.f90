!
! Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
! See https://llvm.org/LICENSE.txt for license information.
! SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
!
! Check if two common block variables are equal when turn on optimization

module mod1
  integer :: mi1
  common /com1/ mi1
contains
  subroutine newmi1()
    mi1 = 30
  end subroutine newmi1
end module mod1

program test
  use mod1
  integer, parameter :: n = 6
  integer :: res(n), rres(n)
  integer :: pi1
  common /com1/ pi1

  res = 0
  rres= 1
  pi1 = 10
  mi1 = 20
  if (pi1 == mi1) res(1) = 1
  if (pi1 == 20) res(2) = 1
  if (mi1 == 20) res(3) = 1
  call newmi1()
  if (pi1 == mi1) res(4) = 1
  if (pi1 == 30) res(5) = 1
  if (mi1 == 30) res(6) = 1

  call check(res, rres, n)
end
