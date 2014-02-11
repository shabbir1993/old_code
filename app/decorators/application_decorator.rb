class ApplicationDecorator < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  attr_reader :context, :object

  def initialize(object, context)
    @context = context
    @object = object
    super(object)
  end

  def self.decorators
    [
      UserDecorator,
      FilmDecorator,
      SalesOrderDecorator,
      MasterFilmDecorator
    ]
  end

  def self.decorate(object, context)
    decorators.inject(object) do |object, decorator_class|
      decorator_class.decorate_if_applicable(object, context)
    end
  end

  def self.decorate_if_applicable(object, context)
    if applicable_to?(object)
      new(object, context)
    else
      object
    end
  end

  def self.applicable_to?(object)
    applicable_classes.any? { |c| object.is_a?(c) }
  end

  def class
    __getobj__.class
  end
end
