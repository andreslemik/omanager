ActiveAdmin.register Product do

  permit_params :name, :image, :base_price

  filter :name
  filter :base_price

  index do
    selectable_column
    id_column
    column :name
    actions
  end

  form html: { multipart: true } do |f|
    f.inputs 'Создание продукта...' do
      f.input :name
      f.input :image, hint: f.object.image.present? \
        ? image_tag(f.object.image.url(:thumb)) \
        : content_tag(:span, 'нет изображения')
      f.input :image_cache, as: :hidden
      f.input :base_price
    end
    f.actions
  end


end
