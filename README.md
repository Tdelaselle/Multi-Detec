# Welcome to the __Multi-Detec__ repository
  
</div>

## About

_Methods for the automated detection of acoustic multiplets and their hierarchical classification according to the similarity of their emission mechanisms_

This package was written and documented by Théotime de la Selle.
Any contributions are very welcomed.

This work was supported by the french ANR project _e-Warnings_ (ANR-19-CE42-001).

> __Copyright ©️ 2024 Théotime de la Selle__
>
> This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
> This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
> You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.

## Installation

No installation is needed ; just download the codes and their dependencies (functions).

## Content description
_(See graphic for more details of the [Method architecture.pdf](https://github.com/Tdelaselle/Multi-Detec/files/14540092/Method.architecture.pdf))_

Principal function :

1. __MultiDetec()__ : identifies multiplets in an AE waveform dataset and establishes the dissimilarity structure between them (dendrogram).

Multiplets or clusters of multiplets analysis : 

2. __DendroCut()__ : plot colored dendrogram (pre-computed ; _Ward_' method) and calculate clusters of multiplets from it according to a user-selected level of dissimilarity.  
3. __MultiCentroid()__ : Determine the centroid iteratively by calculating cross-correlation maximum between each waveforms of a multiplet and the centroid steps ; then plot the resulting                             centroid.
4. __MultiWFsuperposed()__ : align and plot all waveforms of a multiplet or cluster of multiplets ; also compute and plot the centroid. 

Sub-functions of MultiDetec() : 

1.1 __PartialDissimiMat()__ : compute the partial dissimilarity matrix of a waveform dataset part by finding the maximum of the cross-correlation function between specific pairs of waveforms.

1.2 __Threshold()__ : estimate automatically a dissimilarity threshold from the distribution of partial dissimilarity matrix coefficients. 

 ->  1.2.1 __Distribution()__ : compute distribution of some matrix coefficients from its diagonals.
  
1.3 __MultiPeriod()__ : _(optionnal)_ give a measure of the multiplets signals emission time period.

1.4 __MultiAssembly()__ : assembles (or delete) pre-clusters, obtained by application of DBSCAN on partial dissimilarity matrices, into multiplets by cutting a dendrogram (_centroid_                                 linkage), obtained by hierarchical clustering of pre-clusters centroids. The mean of dissimilarity thresholds is used to automatically select the cutting level.

 ->  1.4.1 __MultiCentroid()__ : same as 3. but on pre_clusters (no plot of centroid). 

