class HistoryController < ApplicationController
  def film_movements
    @film_movements = PaperTrail::Version.history.where("'phase' = ANY (columns_changed)").page(params[:page])
  end

  def fg_film_movements
    fg_film_movements = PaperTrail::Version.history.where("phase_change[2] = 'fg' AND phase_change[1] <> 'fg'")
    @fg_film_movements = fg_film_movements.page(params[:page])
    respond_to do |format|
      format.html
      format.csv { send_data fg_film_movements.fg_film_movements_to_csv }
    end
  end

  def scrap_film_movements
    @scrap_film_movements = PaperTrail::Version.history.where("phase_change[2] = 'scrap'").page(params[:page])
  end

  def film_resizes
    @film_resizes = PaperTrail::Version.history.where("'width' = ANY (columns_changed) OR 'length' = ANY (columns_changed)").page(params[:page])
  end

  def film_deletes
    @film_deletes = PaperTrail::Version.order('versions.created_at DESC').where("'deleted' = ANY (columns_changed)").page(params[:page])
  end
end
