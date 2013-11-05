module FilmsHelper
  def column_headers(scope, phase)
    if scope == "deleted"
      headers = %w(Phase Width Length)
    else
      headers = PhaseDefinitions.table_columns(phase).keys 
    end
    headers.map do |header|
      content_tag(:th, header)
    end.join.html_safe
  end

  def column_values(film)
    if film.deleted?
      values = %w(phase width length)
    else
      values = PhaseDefinitions.table_columns(film.phase).values
    end
    values.map do |value|
      content_tag(:td, film.send(value), class: value)
    end.join.html_safe
  end

  def edit_fields_for(phase, f)
    PhaseDefinitions.edit_fields(phase).map do |fields|
      render fields, f: f
    end.join.html_safe
  end
end
