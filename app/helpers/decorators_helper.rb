module DecoratorsHelper
  def decorate(object, context=self)
    ApplicationDecorator.decorate(object, context)
  end

  def decorate_collection(collection, context=self)
    CollectionDecorator.new(collection, context).decorated_collection
  end
end
