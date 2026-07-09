class WorldController < ApplicationController
  layout false

  def iran
  end

  def hamas
  end

  def houthis
  end

  def hezbollah
  end

  def cuba
  end

  def gaesa
  end

  def q929
    @entries = SacredFireEntry.order(:tab, :year_of_incident, :site_name)
    @tab_counts = SacredFireEntry.group(:tab).count
    @stats = {
      total:     @entries.count,
      destroyed: @entries.where(status: ['Destroyed', 'Demolished']).count,
      damaged:   @entries.where(status: ['Severely damaged', 'Damaged']).count,
      nearmiss:  @entries.where(status: 'Near-miss').count,
    }
  end
end
