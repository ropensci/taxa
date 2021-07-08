
## R CMD check results

### Local computer: Pop!_OS 20.04 LTS, R version 4.0.3

0 errors | 0 warnings | 0 notes

### win-builder (devel and release)

0 errors | 0 warnings | 1 notes

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Zachary Foster <zacharyfoster1989@gmail.com>'

License components with restrictions and base license permitting such:
  MIT + file LICENSE
File 'LICENSE':
  MIT License
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

Possibly mis-spelled words in DESCRIPTION:
  Vectorized (6:42)

Found the following (possibly) invalid URLs:
  URL: http://www.repostatus.org/#wip (moved to https://www.repostatus.org/)
    From: README.md
    Status: 200
    Message: OK


## Rhub (Fedora Linux, R-devel and	Ubuntu Linux 20.04.1 LTS, R-release)

0 errors | 0 warnings | 1 notes

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Zachary Foster <zacharyfoster1989@gmail.com>'

License components with restrictions and base license permitting such:
  MIT + file LICENSE
File 'LICENSE':
  MIT License
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

Possibly mis-spelled words in DESCRIPTION:
  Vectorized (6:42)

Found the following (possibly) invalid URLs:
  URL: http://www.repostatus.org/#wip (moved to https://www.repostatus.org/)
    From: README.md
    Status: 200
    Message: OK

## Reverse dependencies

### taxlist

The only code used is a function to convert a class used in `taxa` to one used in `taxlist`.
This function will break, but no other functionality in `taxlist` should be affected.
I have alerted the maintainer to this issue 2 weeks ago (Jun 24).