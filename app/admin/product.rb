ActiveAdmin.register Product do
  menu parent: 'Управление продуктами', priority: 10
  permit_params :name, :image, :image_cache, :category_id,
                :price, :manufacturer_id, :margin,
                product_properties_attributes: [:id, :property_id, :value, :_destroy],
                product_option_types_attributes: [:id, :option_type_id, :_destroy],
                product_option_values_attributes: [:id, :option_value_id, :diff, :_destroy]

  filter :name
  filter :category
  filter :manufacturer, as: :select,
                        collection: proc {
                          Hash[Partner.order(:name)
                            .joins(:products).uniq.map { |p| [p.name, p.id] }]
                        }

  index do
    selectable_column
    id_column
    column :category
    column :name
    # column 'Изображение' do |p|
    #   image_tag p.image.url(:thumb)
    # end
    column :manufacturer
    column :margin
    actions
  end

  form html: { multipart: true } do |f|
    f.inputs 'Создание продукта...' do
      f.input :name
      f.input :category
      f.input :manufacturer, as: :select, collection: Partner.suppliers
      f.input :price
      f.input :margin
      f.input :image,
              hint: f.object.image.present? ? image_tag(f.object.image.url(:thumb)) : content_tag(:span, 'нет изображения')
      f.input :image_cache, as: :hidden
      f.inputs do
        f.has_many :product_option_types, allow_destroy: true do |a|
          a.input :option_type, label: 'Опция'
        end
      end
      f.inputs do
        f.has_many :product_properties, heading: 'Свойства', allow_destroy: true, new_record: true do |a|
          a.input :property, label: 'Свойство'
          a.input :value, label: 'Значение'
        end
      end
      f.inputs do
        f.has_many :product_option_values, heading: 'Модификаторы цены', allow_destroy: true, new_record: true do |m|
          m.input :option_value, label: 'Опция', as: :select, collection: OptionValue.all.map { |ov| [ov.full_name, ov.id] }
          m.input :diff, label: 'Изменение цены'
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
        row :price
        row :margin
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
