# Welcome to the __Multi-Detec__ repository
  
</div>

_Methods for the automated detection of acoustic multiplets and their hierarchical classification according to the similarity of their emission mechanisms_


__Note__ : originally, this method has been developped to study acoustic multiplets from fatigue of materials. However, as general AE method, acoustic multiplets from other fields can also be detected.

See publications on this topic for more details [1] and [2].

## About

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

No installation is needed. Just download the codes and their dependencies (functions).

## Content description
_(See graphic for more details of the [Method architecture.pdf](https://github.com/Tdelaselle/Multi-Detec/files/14540092/Method.architecture.pdf))_

### Glossary

- __AE__ : acoustic emission. 
- __WF__ : digitized waveform of an individual AE signal (generally around hundreds of microseconds,sampled between 1 and 5 MHz).
- __TOA__ : time of arrival of a single WF. In AE field, TOAs are commonly defined as threshold crossings.
- __PDM__ : Partial Dissimilarity Matrix, see graphic and [1]. 

### Functions and dependencies

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

 ->  1.4.1 __MultiCentroid()__ : same as 3, but on pre_clusters (no plot of centroid). 

## Entries and returns 

__Entries :__ 

- _WF(s,n)_ : array of all _n_ individual AE waveforms composed of _s_ points, ordered by increasing time of arrival.

- _Toa(n)_ : list (sorted) of _n_ Time Of Arrival associated to each waveforms of _WF_.
- _dtmax_ : (float number) time limit for partial dissimilarity matrix calculation (see _Content description_).
- _PDM(n,n)_ (optionnal) : previously computed partial dissimilarity matrix (see _How to use_).

__Returns :__

- _Multiplets(n)_ : list of multiplets assignations (identified by numbers) of each _n_ waveforms, ordered by increasing time of arrival.

- _Dendrogram_ : array of multiplets links and respective levels of recomputed dissimilarity metric (Ward' method). Used to plot dendrograms and perform clustering. 

## Parameters of detection

Multi-Detec, to be user-friendly as possible, has been developped upon **3 categories of parameters**. According to your expertise and Multi-Detec usage, you will set only one or all of the 3 categories.  

__Operator__ parameter is a function parameter (in _MultiDetec_) while __cross-correlation__ and __super-user__ parameters has to be set directly in _MultiDetec_ code, into the structure variable _para_.  

### Operator parameter
_(parameter for all)_

__dtmax__ : defines the maximum gap between TOAs of 2 WF to perform dissimilarity measure of them (i.e. a PDM coefficient). Note that _dtmax_ is not used by the code if a _PDM_ is provided.
  -  In case of periodically emitted multiplets signals (MultiPeriod function activated), _dtmax_ has to reach a value to accurately detect multiplets. However, above this value, a large _dtmax_ increases time complexity as more PDM coefficients are computed.
  -  In case of non-periodically emitted multiplets signals (MultiPeriod function disactivated), _dtmax_ defines totally _PDM_ and thus the multiplets detection. _dtmax_ has to be chosen according to the context.

### Cross-correlation parameter  
_(parameters for ajusting the dissimilarity metric based on cross-correlation function)_

- __pretrig_cut__ : (boolean) keep (0) or not (1) the WF pretrigger during calculation of dissimilarity between WF. 
- __pretrig_length__ : (integer) size of pretrigger in points.
- __window__ : (integer) size of the cross-correlation window in pts. 

### Super-user parameters

(all are integers)
- __minsize__ : minimal nomber of WF in each multiplets (clusters composed of less WF are deleted). 
- __d__ : multiplets density parameters (see [1]).
- __mat_size__ : defines _PDM_ size.
- __degree__ : factor for selecting number of diagonals in _Threshold_ function.
- __minpts__ : a DBSCAN parameter, see [1] or DBSCAN definition.

## How to use ? 

## Bibliography

[1] Théotime de la Selle, Jérome Weiss, Stéphanie Deschanel,
Acoustic multiplets detection based on DBSCAN and cross-correlation,
Mechanical Systems and Signal Processing,
Volume 211,
2024,
https://doi.org/10.1016/j.ymssp.2024.111149.

For more information about physical sources of multiplets : 

[2] de la Selle, Théotime and Réthoré, Julien and Weiss, Jerome and Lachambre, J. and Deschanel, Stéphanie, Early Detection and Characterization of Fatigue Crack Growth Fromacoustic Emission Repeaters and Image Correlation. Available at SSRN: https://ssrn.com/abstract=4758696 or http://dx.doi.org/10.2139/ssrn.4758696
