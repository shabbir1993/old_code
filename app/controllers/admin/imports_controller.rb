class Admin::ImportsController < AdminController
  def home
  end

  def import_master_films
    MasterFilm.import_csv(params[:file])
    redirect_to imports_path, notice: "Master films imported."
  end

  def import_films
    Film.import_csv(params[:file])
    redirect_to imports_path, notice: "Films imported."
  end
  
  def import_machines
    Machine.import_csv(params[:file])
    redirect_to imports_path, notice: "Machines imported."
  end
end

