## Copyright (c) 2017, Muhammad Adnan Siddique <siddiqu@ifu.baug.ethz.ch>
##
## Permission to use, copy, modify, and/or distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

@doc doc"""
  Compute variogram from a covraince model

    where

    * covModel is an instance of class CovarianceModel from the GeoStats package
    * h is the vector of lags

  """ ->
function variogramFromCovModel(covModel, h)

  # covModel is an instance of class CovarianceModel from the GeoStats package
  # h => an array of the lags

  covf = covModel(h)
  gamma = covModel.sill - covf
  return gamma

end
