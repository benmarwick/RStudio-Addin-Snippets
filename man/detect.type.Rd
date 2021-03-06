% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/copy.data.R
\name{detect.type}
\alias{detect.type}
\title{Check the type of the variable}
\usage{
detect.type(variable.name = "")
}
\arguments{
\item{variable.name}{The name of the variable taht will be checked.}
}
\value{
The list of 4 values:
    \describe{
        \item{name}{name of the variable}
        \item{type}{type of the variable}
        \item{value}{value of the variable}
        \item{supported}{\code{TRUE} if tsv can be generated,
                         \code{FALSE} otherwise}
    }
}
\description{
Method checks if the variable exists, and what type it is. Based
             on that it decides if the type is supported or not.
}

