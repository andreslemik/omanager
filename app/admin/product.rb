ActiveAdmin.register Product do

  permit_params :name, :image, :image_cache, :category_id,
                product_properties_attributes: [ :property_id, :value, :_destroy ]

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
      f.inputs do
        f.has_many :product_properties, heading: 'Свойства', allow_destroy: true, new_record: true do |a|
          a.input :property
          a.input :value
        end
      end
    end
    f.actions
  end

  show do
    panel 'Продукт' do
      attributes_table_for product do
        row :id
        row :category
        row :name
        row :image do
          image_tag product.image.url
        end
        table_for product.product_properties do
          column :property
          column :value
        end

      end
    end
  end


end
