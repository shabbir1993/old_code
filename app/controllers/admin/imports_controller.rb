class Admin::ImportsController < AdminController
  def home
  end

  def import_master_films
    DataImporter.import_csv(MasterFilm, "master_films", params[:file])
    redirect_to imports_path, notice: "Master films imported."
  end

  def import_films
    DataImporter.import_csv(Film, "films", params[:file])
    redirect_to imports_path, notice: "Films imported."
  end
  
  def import_users
    DataImporter.import_csv(User, "users", params[:file])
    redirect_to imports_path, notice: "Users imported."
  end

  def import_machines
    DataImporter.import_csv(Machine, "machines", params[:file])
    redirect_to imports_path, notice: "Machines imported."
  end

  def import_defects
    DataImporter.import_csv(Defect, "defects", params[:file])
    redirect_to imports_path, notice: "Defects imported."
  end
end

