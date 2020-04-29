## Test environments and check results

### local: ubuntu 18.04, R 3.6.3

0 errors | 0 warnings | 0 notes

### travis-ci: ubuntu 14.04.05, R development

0 errors | 0 warnings | 0 notes

### travis-ci: ubuntu 14.04.05, R 4.0.0

0 errors | 0 warnings | 0 notes

### Rhub: Windows Server 2008 R2 SP1, R-devel, 32/64 bit

1223#> * checking package dependencies ... ERROR
1224#> Packages required but not available:
1225#> 'stringr', 'tidyr', 'taxize'
1226#> Packages suggested but not available: 'roxygen2', 'testthat', 'rmarkdown'
1227#> VignetteBuilder package required for checking but not installed: 'knitr'
1228#> 'jsonlite', 'dplyr', 'lazyeval', 'tibble', 'knitr', 'rlang',

### Rhub: Ubuntu Linux 16.04 LTS, R-release, GCC

0 errors | 0 warnings | 0 notes

### Rhub: Fedora Linux, R-devel, clang, gfortran

0 errors | 0 warnings | 0 notes

### Win builder: R devel

0 errors | 0 warnings | 0 notes

### Win builder: R version 4.0.0 (2020-04-24)

0 errors | 0 warnings | 0 notes

## Reverse dependencies

### metacoder

I also maintain `metacoder` and the current CRAN version should be compatible.

### taxlist

`taxa` is in the suggests and no code from `taxa` is actually used.