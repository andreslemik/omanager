json.extract! @product, :id, :name
json.price @product.price_mod(@mods)