json.array! @films do |film|
  json.serial film.serial
  json.shelf film.shelf
  json.phase film.phase
end
