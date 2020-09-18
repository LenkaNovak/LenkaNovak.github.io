---
layout: archive
title: "Visualisation"
permalink: /visualisation/
author_profile: true
---

## CliMA-specific tools

### Julia and Python scripts and notebooks
- [Bash scripts](visualisation/slurm_bash_scripts.md): end to end run-analysis pipeline
- [VizCLIMA](https://lenkanovak.github.io/_pages/visualisation/slurm_bash_scripts#VizCLIMA-contains)
- [Plotly scripts](plotly.md)
- [Remote access of notebooks](https://github.com/CliMA/ClimateMachine.jl/wiki/Visualization)

### DataVis project
As part of [DataVis](http://datavis.caltech.edu), Caltech has partnered with JPL and the ArtCenter College of Design to bring together software engineers and artists to build an interactive data visualisation tool, consulted by and build exclusively for CliMA's scientists and developers ([code](https://drive.google.com/file/d/1xFlVKunny2ZIgg_xFn7vgIWZko151zwG/view?usp=sharing), please contact me or a CliMA member for access).

## Third party interactive software packages
- There are various third party packages that enable instant 3D interactive visualisation, slicing and animations of our data (NetCDF format by default), as well as conversion to other data formats. Examples include:
  - [ParaView](https://www.paraview.org): 3d visualisation, slicing and simple data manipulation, handles VTK files and can convert data to CSV and other formats.
  - [VisIt](https://visitusers.org/index.php?title=Main_Page): similar to ParaView
  - [Panoply](https://www.giss.nasa.gov/tools/panoply/): summarises geospatial information of the global geospatial data
  - [Ncview](http://meteora.ucsd.edu/~pierce/ncview_home_page.html): useful for a quick check of geospatial data on the Caltech cluster. It can handle large data files more easily than most other packages.
