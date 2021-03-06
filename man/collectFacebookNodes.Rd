% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/studyCase.R
\name{collectFacebookNodes}
\alias{collectFacebookNodes}
\title{Collect facebook data}
\usage{
collectFacebookNodes(nodeid, edge = "feed", user = FALSE, rootPath)
}
\arguments{
\item{nodeid}{Id of the target facebook node}

\item{user}{FALSE to use an application based call, TRUE to use an Autenticated call (used to fetch private groups and events)}

\item{rootPath}{path to save the generated results}
}
\description{
This function collect data from a facebook node that could be a page, group, event or else based on a given
edge which represents the type of data to collect such, posts and feed
then parse it and save into an R dataframe and spredsheet excel file.
}
