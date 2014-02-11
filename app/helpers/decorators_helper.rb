module DecoratorsHelper
  def decorate(object, context=self)
    ApplicationDecorator.decorate(object, context)
  end

  def decorate_collection(collection, context=self)
    collection.map { |o| decorate(o, context) }
  end
end
