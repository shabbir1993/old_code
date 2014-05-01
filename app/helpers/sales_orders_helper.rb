module SalesOrdersHelper
  def code_input_if_admin(form)
    form.text_field :code, label: "SO#" if current_user.admin?
  end
end
