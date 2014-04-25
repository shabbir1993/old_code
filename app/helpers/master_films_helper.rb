module MasterFilmsHelper
  def serial_input_if_admin(form)
    form.text_field :serial if current_user.admin?
  end
end
