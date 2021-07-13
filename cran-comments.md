## Test environments and check results

### Local computer: Pop!_OS 20.04 LTS, R version 4.0.3

0 errors | 0 warnings | 0 notes

### win-builder (devel and release)

0 errors | 0 warnings | 1 notes

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Zachary Foster <zacharyfoster1989@gmail.com>'

Possibly mis-spelled words in DESCRIPTION:
  Vectorized (6:42)

### Rhub (Fedora Linux, R-devel and	Ubuntu Linux 20.04.1 LTS, R-release)

0 errors | 0 warnings | 1 notes

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Zachary Foster <zacharyfoster1989@gmail.com>'

Possibly mis-spelled words in DESCRIPTION:
  Vectorized (6:42)

## Reverse dependencies

### taxlist

The only code used is a function to convert a class used in `taxa` to one used in `taxlist`.
This function will break, but no other functionality in `taxlist` should be affected.
I have alerted the maintainer to this issue 2 weeks ago (Jun 24).