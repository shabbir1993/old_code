module DecoratorHelper
  def decorate(object, context=self)
    ApplicationDecorator.decorate(object, context)
  end
end
