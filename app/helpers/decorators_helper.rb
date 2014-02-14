module DecoratorsHelper
  def decorate(object)
    ApplicationDecorator.decorate(object)
  end

  def decorate_collection(collection)
    collection.map { |o| decorate(o) }
  end
end
