ActiveAdmin.register Product do

  permit_params :name, :image, :category_id

  filter :category
  filter :name

  index do
    selectable_column
    id_column
    column :category
    column :name
    column 'Изображение' do |p|
      image_tag p.image.url(:thumb)
    end
    actions
  end

  form html: { multipart: true } do |f|
    f.inputs 'Создание продукта...' do
      f.input :name
      f.input :category
      f.input :image, hint: f.object.image.present? \
        ? image_tag(f.object.image.url(:thumb)) \
        : content_tag(:span, 'нет изображения')
      f.input :image_cache, as: :hidden
    end
    f.actions
  end


end
