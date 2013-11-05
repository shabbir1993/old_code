class HistoryController < ApplicationController
  def film_movements
    @film_movements = PaperTrail::Version.where("'phase' = ANY (columns_changed)").page(params[:page])
  end

  def fg_film_movements
    @fg_film_movements = PaperTrail::Version.where("phase_change[2] = 'fg'").page(params[:page])
  end

  def scrap_film_movements
    @scrap_film_movements = PaperTrail::Version.where("phase_change[2] = 'scrap'").page(params[:page])
  end

  def film_resizes
    @film_resizes = PaperTrail::Version.where("'width' = ANY (columns_changed) OR 'length' = ANY (columns_changed)").page(params[:page])
  end

  def film_deletes
    @film_deletes = PaperTrail::Version.where("'deleted' = ANY (columns_changed)").page(params[:page])
  end
end
