class ImportsController < ApplicationController
  def home
  end

  def import_master_films
    MasterFilm.import(params[:file])
    redirect_to imports_path, notice: "Master films imported."
  end

  def import_films
    Film.import(params[:file])
    redirect_to imports_path, notice: "Films imported."
  end
  
  def import_users
    User.import(params[:file])
    redirect_to imports_path, notice: "Users imported."
  end

  def import_machines
    Machine.import(params[:file])
    redirect_to imports_path, notice: "Machines imported."
  end

  def import_defects
    Defect.import(params[:file])
    redirect_to imports_path, notice: "Defects imported."
  end

  def import_film_movements
    FilmMovement.import(params[:file])
    redirect_to imports_path, notice: "Film movements imported."
  end
end

