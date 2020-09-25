---
layout: default
title: "Research Interests"
permalink: /research_interests/
author_profile: true
redirect_from:
  - /about/
  - /about.html

image: /images/wood_narrow_1.png

---

<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

  <style>
  table {
    border-color: white;
  }
  td {
    border-color: white;
  }
  tr {
    border-color: white;
  }
  </style>
</head>
<body>

<br>

<div class="container">
  <a href="#demo" class="btn btn-info" data-toggle="collapse">Click for introduction to midlatitude wind storms and jet streams</a>
  <div id="demo" class="collapse">
    <p>
    Midlatitude weather is primarily controlled by large-scale turbulence, which determines extreme weather (weather bombs, extreme precipitation, gustiness, aircraft turbulence in upper atmosphere) and long-term conditions (heat waves, droughts). Understanding and good prediction of its behaviour can therefore save lives, avoid property damage, and mitigate loss to the agricultural, transport and energy industries.
    </p>
    <p>
    This large-scale turbulence arises due to the earth’s rotation and the strong temperature contrast between the equator and the poles making the atmosphere (“baroclinically”) unstable. This instability manifests itself as waves (meanders) in the global jet streams and/or individual eddies (vortices, storms). The regions where these eddies occur most frequently are referred to as storm tracks. This is different from a track of an individual storm, such as the path of a hurricane. A storm track in the statistical sense is analogous to a footprint of its eddies, and is measurable using the eddy kinetic energy, or other similar eddy variance/covariance quantities (F1). The storm track variability allows us to investigate the probabilistic behaviour and overall impact of the wind storms that form the storm track.
    </p>
    <p>
    Despite the vast existing research devoted to it and its importance for determining midlatitude weather, the interaction between storm track eddies, planetary-scale waves and the jet streams remains far from being fully understood. The addition of moisture and cloud processes, as well as incoming perturbations from the tropics, polar regions, oceans and the stratosphere further complicate our physical understanding, precise forecasting, and robust longer-term prediction of the midlatitude weather. The fact that storm tracks remain one of the major sources of uncertainty in the most sophisticated CMIP6 climate models is a testament of that.
    </p>
  </div>
</div>

<br>
<p>
I am interested in disentangling the components of the complex nonlinear large-scale dynamics in the midlatitudes, using diverse tools, ranging from recent advancements in pen-and-paper theories (e.g., quasi-linear growth  baroclinic and barotropic instability and applicability of dynamical systems theories), idealised numerical simulations (e.g. barotropic model, shallow water equation model and dry dynamical cores), mid-range complexity models (e.g., moist aquaplanet models with and without clouds), realistic earth system models (e.g., CliMA’s ClimateMachine.jl, ECMWF’s IFS), local eddy-resolving models (e.g., large-eddy simulations), observations (e.g., ERA and NCEP reanalyses, satellite observations), feature tracking (e.g., TEMPEST, TRACK) and statistical methods (e.g. neural networks, random forests, parameter optimisation). Using this hierarchy of tools, I am hoping to provide robust physical theoretical frameworks to help reduce the large uncertainties in climate projections and better identify error precursors in numerical and statistical weather forecasts.
</p>

<br>
<h6>
Here is a selection of how I have used these tools so far:
</h6>

<table width="500px" height="100%" bordercolor="white">

<tr>

  <td>
    <h6>Jet shifts in latitude are modulated by growth of storms</h6>
    <p>
      The positions of the midlatitude jet, averaged over the North Atlantic sector, can be categorised into three main clusters, referred to as the South, Middle and North jet regimes. Using reanalysis data (global observations stitched together by the ECMWF model) we found that these jet regimes are highly correlated with features of eddy lifecycles, including their growth rate, vertical tilt, horizontal tilt and shape. We found that the preferred regime cycling from S to M to N to S, is often related to the explosive cyclone growth upstream of the jet fluctuations.
    </p>
  </td>

  <td>
  <img src="/images/NAT15_eddyregimes.png" alt="description here" />
  </td>

</tr>
<tr>
<tr>

  <td>
  <img src="/images/NAH18_steadystateNOM.png" alt="description here" />
  </td>

  <td>
    <h6>The response of storm tracks to temperature changes can be large even when their growth rate remains largely unchanged (multilayer dry global circulation model, PUMA)</h6>
    <p>
    It has been noted in observational studies that on seasonal and longer timescales, storminess is very sensitive, even though its growth rate (related to the temperature gradients) is not. To investigate this seemingly counterintuitive phenomenon, we used the steady state of the nonlinear oscillator model discussed below and in (Ambaum and Novak 2014). According to this pen-paper model, the growth rate is maintained by the eddies, so any change to the its replenishing forcing will be counteracted by an increase in the eddy activity. Conversely, when eddy dissipation (e.g. friction) is modified, this will be counteracted by changes in the temperature gradients and thus the eddy growth rate (evidently the storms may be more explosive, but their time-mean intensity is largely unchanged due to their fasted dissipation. This highlights the difference between mean weather and extreme weather changes). This hypothesis was confirmed in a dry global circulation model, which was run with multiple times with constant external parameters until its statistical steady state (model is run for decades until the circulation equilibrates) was reached. This experiment also showed some secondary importance of barotropic processes (linked to the decay of eddies) for this balance, which need to be considered in more comprehensive models.
    </p>
  </td>

</tr>
<tr>

  <td>
    <h6>A model with no vertical structure can reproduce observed nonlinear suppressions in winter storminess (modelling using a one-layer barotropic model)</h6>
    <p>Understanding the formation of the suppression has been in dynamicists’ minds now for decades, because it does opposite to what linear theory predicts. Recently idealised modelling efforts has proven insightful for shedding more light on this phenomenon. We joined this effort by showing that even one-layer (barotopic) model can reproduce this suppression and quantified the processes necessary for its formation.
    </p>
  </td>

  <td>
  <img src="/images/NS20_BTsuppression.png" alt="description here" />
  </td>

</tr>
<tr>

  <td>
  <img src="/images/NT16_local_energetics.png" alt="description here" />
  </td>

  <td>
    <h6>Ability to diagnose local potential energy available for turbulent motions locally</h6>
    <p>Energy currently used by atmospheric motions (kinetic energy, KE) and energy available to be converted into atmospheric motion (available potential energy, APE) sum to a total energy that has to be globally conserved in time. The usefulness of these energies for diagnosing properties of the circulation is greatly enhanced if considered locally, so that one can diagnose the processes that lead to their spatial-temporal changes. While KE density is easy to diagnose locally from the horizontal wind components, Lorenz originally defined APE as a global quality, and its estimates in the following research have mostly been approximations that curtailed research requiring precise estimates, such as energy budgets. We extended an often-overlooked derivation for a local APE density from the 1980s, to provide a new diagnostic that facilitates local APE diagnosis and offers precise calculations of the processes that modify it.
    </p>
  </td>

</tr>
<tr>

  <td>
    <h6>Extreme storminess occurs on monthly timescales</h6>
    <p>This is a fundamental property of the nonlinearly oscillatory relationship between the storminess and the sharp temperature gradients that give rise to storminess in the first place. Much the same as a biological predator-prey model where storminess feeds on the gradients until they are eaten up to the point they can no longer sustain new growth of storms. The subsequent reduced storminess then allows the gradients to build up again by (e.g. radiative) forcing and the cycle repeats. Borrowing concepts from dynamical systems, we developed a pen-and-paper model that describes this behaviour and models some of the detailed properties of the real atmosphere.</p>
  </td>

  <td>
  <img src="/images/AN14_phaseplot.png" alt="description here" />
  </td>

</tr>
</table>



</body>