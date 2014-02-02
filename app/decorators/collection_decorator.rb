class CollectionDecorator < ApplicationDecorator
  include Enumerable

  def class
    CollectionDecorator
  end

  def decorated_collection
    self.map { |i| self.class.decorate(i, context) }
  end
end
