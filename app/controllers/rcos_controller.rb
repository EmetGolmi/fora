class RcosController < ApplicationController
  # "19wc" starts with a digit and cannot be a regular Ruby method name,
  # so we use define_method with a string key — Rails dispatches via send().
  define_method("19wc") do
    @rco = {
      name:             "19th Ward Committee RCO",
      slug:             "19wc",
      address:          "2122 N Hancock Street, Philadelphia, PA 19122",
      meeting_location: "147 W. Susquehanna Avenue, Philadelphia, PA 19122",
      primary_name:     "Maria Matos",
      primary_email:    "philly19thward@gmail.com",
      primary_phone:    "(267) 236-9857",
      expiration_year:  2027,
      website:          nil
    }
    render :show
  end

  def nscan
    @rco = {
      name:             "Norris Square Community Action Network",
      slug:             "nscan",
      address:          "c/o West Kensington Ministry, 2140 N. Hancock Street, Philadelphia, PA 19122",
      meeting_location: "West Kensington Ministry, 2140 N Hancock Street, Philadelphia, PA 19122",
      primary_name:     "Nilda L. Pimentel-Perez",
      primary_email:    "contact@nscanphilly.org",
      primary_phone:    "(267) 231-9470",
      expiration_year:  2026,
      website:          "www.nscanphilly.org"
    }
    render :show
  end
end
