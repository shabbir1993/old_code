class Admin::MachinesController < AdminController
  def index
    @machines = machines.page(params[:page])
  end

  def new
    @machine = current_tenant.new_machine
    render layout: false
  end

  def create
    @machine = current_tenant.new_machine(machine_params)
    unless @machine.save
      render :display_modal_error_messages, locals: { object: @machine }
    end
  end

  def edit
    session[:return_to] ||= request.referer
    @machine = machines.find(params[:id])
    render layout: false
  end

  def update
    @machine = machines.find(params[:id])
    unless @machine.update(machine_params)
      render :display_modal_error_messages, locals: { object: @machine }
    end
  end 

  private

  def machines
    current_tenant.machines
  end

  def machine_params
    params.require(:machine).permit(:code, :yield_constant)
  end
end
