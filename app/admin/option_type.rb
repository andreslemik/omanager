ActiveAdmin.register OptionType do
  menu parent: 'Управление продуктами', priority: 90
  permit_params :name,
                option_values_attributes: [:id, :name, :_destroy]

  filter :name

  index do
    selectable_column
    column :name
    column :values do |o|
      o.option_values.count
    end
    column :option_values_string
    actions
  end

  form do |f|
    f.inputs 'Опция продукта' do
      f.input :name
      f.inputs do
        f.has_many :option_values, heading: 'Значения опции',
                                   allow_destroy: true, new_record: true do |ff|
          ff.input :name, label: 'Значение'
        end
      end
    end
    f.actions
  end
end
