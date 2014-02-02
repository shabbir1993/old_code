class CollectionDecorator < ApplicationDecorator
  include Enumerable

  def self.applicable_classes
    [ActiveRecord::Relation, Enumerable]
  end

  def class
    CollectionDecorator
  end

  def to_ary
    self.map { |i| self.class.decorate(i, self) }
  end
end
