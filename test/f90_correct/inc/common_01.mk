#
# Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#

common_01: run


build:  $(SRC)/common_01.f90
	-$(RM) common_01.$(EXESUFFIX) core *.d *.mod FOR*.DAT FTN* ftn* fort.*
	@echo ------------------------------------ building test $@
	-$(CC) -c $(CFLAGS) $(SRC)/check.c -o check.$(OBJX)
	-$(FC) -c $(FFLAGS) -O1 $(LDFLAGS) $(SRC)/common_01.f90 -o common_01.$(OBJX)
	-$(FC) $(FFLAGS) $(LDFLAGS) common_01.$(OBJX) check.$(OBJX) $(LIBS) -o common_01.$(EXESUFFIX)


run:
	@echo ------------------------------------ executing test common_01
	common_01.$(EXESUFFIX)

verify: ;

common_01.run: run

