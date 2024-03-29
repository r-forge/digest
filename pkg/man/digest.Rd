% $Id$
\name{digest}
\alias{digest}
\title{Create hash function digests for arbitrary R objects}
\description{
  The \code{digest} function applies a cryptographical hash function to
  arbitrary R objects. By default, the objects are internally
  serialized, and either one of the currently implemented MD5 and SHA-1
  hash functions algorithms can be used to compute a compact digest of
  the serialized object.

  In order to compare this implementation with others, serialization of
  the input argument can also be turned off in which the input argument
  must be a character string for which its digest is returned.
}
\usage{
digest(object, algo=c("md5", "sha1", "crc32", "sha256", "sha512"), 
       serialize=TRUE, file=FALSE, length=Inf, skip="auto", ascii=FALSE,
       raw=FALSE)
}
\arguments{
  \item{object}{An arbitrary R object which will then be passed to the
    \code{\link{serialize}} function, unless the \code{serialize}
    argument is set to \code{FALSE}.}
  \item{algo}{The algorithms to be used; currently available choices are
    \code{md5}, which is also the default, \code{sha1}, \code{crc32} and
    \code{sha256}.}
  \item{serialize}{A logical variable indicating whether the object
    should be serialized using \code{serialize} (in ASCII
    form). Setting this to \code{FALSE} allows to compare the digest
    output of given character strings to known control output. It also
    allows the use of raw vectors such as the output of non-ASCII
    serialization.
 }
  \item{file}{A logical variable indicating whether the object is a file
    name or a file name if \code{object} is not specified.}
  \item{length}{Number of characters to process. By default, when
    \code{length} is set to \code{Inf}, the whole string or file is
    processed.}
  \item{skip}{Number of input bytes to skip before calculating the
    digest. Negative values are invalid and currently treated as zero.
    Special value \code{"auto"} will cause serialization header to be
    skipped if \code{serialize} is set to \code{TRUE} (the serialization
    header contains the R version number thus skipping it allows the
    comparison of hashes across platoforms and some R versions).
  }
  \item{ascii}{This flag is passed to the \code{serialize} function if
    \code{serialize} is set to \code{TRUE}, determining whether the hash
    is computed on the ASCII or binary represenataion.}
  \item{raw}{A logical variable with a default value of FALSE, implying
    \code{digest} returns digest output as ASCII hex values. Set to TRUE
    to return \code{digest} output in raw (binary) form. }
}
\value{
  The \code{digest} function returns a character string of a fixed
  length containing the requested digest of the supplied R object. For
  MD5, a string of length 32 is returned; for SHA-1, a string of length
  40 is returned; for CRC32 a string of length 8.
}
\details{
  Cryptographic hash functions are well researched and documented. The
  MD5 algorithm by Ron Rivest is specified in RFC 1321. The SHA-1
  algorithm is specified in FIPS-180-1, SHA-2 is described in
  FIPS-180-2. Crc32 is described in
  \url{ftp://ftp.rocksoft.com/cliens/rocksoft/papers/crc_v3.txt}.

  For md5, sha-1 and sha-256, this R implementation relies on standalone
  implementations in C by Christophe Devine. For crc32, code from the
  zlib library by Jean-loup Gailly and Mark Adler is used.
  
  For sha-512, a standalone implementation from Aaron Gifford is used.

  Please note that this package is not meant to be used for
  cryptographic purposes for which more comprehensive (and widely
  tested) libraries such as OpenSSL should be used. Also, it is known
  that crc32 is not collision-proof. For sha-1, recent results indicate
  certain cryptographic weaknesses as well. For more details, see for example 
  \url{http://www.schneier.com/blog/archives/2005/02/cryptanalysis_o.html}.
}
\references{
  MD5: \url{http://www.ietf.org/rfc/rfc1321.txt}. 

  SHA-1: \url{http://www.itl.nist.gov/fipspubs/fip180-1.htm}.
  SHA-256: \url{http://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf}.
  CRC32:  \url{ftp://ftp.rocksoft.com/cliens/rocksoft/papers/crc_v3.txt}. 
  
  \url{http://www.aarongifford.com/computers/sha.html} for the 
  integrated C implementation of sha-512.

  \url{http://www.cr0.net:8040/code/crypto} for the underlying
  C functions used here for sha-1 and md5, and further references.

  \url{http://zlib.net} for documentation on the zlib library which
  supplied the code for crc32.

  \url{http://en.wikipedia.org/wiki/SHA_hash_functions} for
  documentation on the sha functions.
}
\author{Dirk Eddelbuettel \email{edd@debian.org} for the \R interface;
  Antoine Lucas for the integration of crc32; Jarek Tuszynski for the
  file-based operationss; Henrik Bengtsson and Simon Urbanek for improved
  serialization patches; Christophe Devine for the hash function
  implementations for sha-1, sha-256 and md5; Jean-loup Gailly and Mark Adler
  for crc32; Hannes Muehleisen for the integration of sha-512.} 
\seealso{\code{\link{serialize}}, \code{\link{md5sum}}}

\examples{

## Standard RFC 1321 test vectors
md5Input <-
  c("",
    "a",
    "abc",
    "message digest",
    "abcdefghijklmnopqrstuvwxyz",
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
    paste("12345678901234567890123456789012345678901234567890123456789012",
          "345678901234567890", sep=""))
md5Output <-
  c("d41d8cd98f00b204e9800998ecf8427e",
    "0cc175b9c0f1b6a831c399e269772661",
    "900150983cd24fb0d6963f7d28e17f72",
    "f96b697d7cb7938d525a2f31aaf161d0",
    "c3fcd3d76192e4007dfb496cca67e13b",
    "d174ab98d277d9f5a5611c2c9f419d9f",
    "57edf4a22be3c955ac49da2e2107b67a")

for (i in seq(along=md5Input)) {
  md5 <- digest(md5Input[i], serialize=FALSE)
  stopifnot(identical(md5, md5Output[i]))
}

sha1Input <-
  c("abc", "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
sha1Output <- 
  c("a9993e364706816aba3e25717850c26c9cd0d89d",
    "84983e441c3bd26ebaae4aa1f95129e5e54670f1")

for (i in seq(along=sha1Input)) {
  sha1 <- digest(sha1Input[i], algo="sha1", serialize=FALSE)
  stopifnot(identical(sha1, sha1Output[i]))
}

crc32Input <-
  c("abc",
    "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
crc32Output <- 
  c("352441c2",
    "171a3f5f")

for (i in seq(along=crc32Input)) {
  crc32 <- digest(crc32Input[i], algo="crc32", serialize=FALSE)
  stopifnot(identical(crc32, crc32Output[i]))
}


sha256Input <-
  c("abc",
    "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
sha256Output <- 
  c("ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
    "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1")

for (i in seq(along=sha256Input)) {
  sha256 <- digest(sha256Input[i], algo="sha256", serialize=FALSE)
  stopifnot(identical(sha256, sha256Output[i]))
}

# SHA 512 example
sha512Input <-
  c("abc",
    "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
sha512Output <- 
  c(paste("ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a",
          "2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f",
          sep=""),
    paste("204a8fc6dda82f0a0ced7beb8e08a41657c16ef468b228a8279be331a703c335",
          "96fd15c13b1b07f9aa1d3bea57789ca031ad85c7a71dd70354ec631238ca3445",
          sep=""))

for (i in seq(along=sha512Input)) {
  sha512 <- digest(sha512Input[i], algo="sha512", serialize=FALSE)
  stopifnot(identical(sha512, sha512Output[i]))
}

# example of a digest of a standard R list structure
digest(list(LETTERS, data.frame(a=letters[1:5], b=matrix(1:10,ncol=2))))

# test 'length' parameter and file input
fname <- file.path(R.home(),"COPYING")
x <- readChar(fname, file.info(fname)$size) # read file
for (alg in c("sha1", "md5", "crc32")) {
  # partial file
  h1 <- digest(x    , length=18000, algo=alg, serialize=FALSE)
  h2 <- digest(fname, length=18000, algo=alg, serialize=FALSE, file=TRUE)
  h3 <- digest( substr(x,1,18000) , algo=alg, serialize=FALSE)
  stopifnot( identical(h1,h2), identical(h1,h3) )
  # whole file
  h1 <- digest(x    , algo=alg, serialize=FALSE)
  h2 <- digest(fname, algo=alg, serialize=FALSE, file=TRUE)
  stopifnot( identical(h1,h2) )
}

# compare md5 algorithm to other tools
library(tools)
fname <- file.path(R.home(),"COPYING")
h1 <- as.character(md5sum(fname))
h2 <- digest(fname, algo="md5", file=TRUE)
stopifnot( identical(h1,h2) )
}
\keyword{misc}
