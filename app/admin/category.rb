ActiveAdmin.register Category do
  menu parent: 'Управление продуктами', priority: 100

  permit_params :name, :fabrication

  filter :name

  index do
    selectable_column
    id_column
    column :name
    column :fabrication
    actions
  end

  form do |f|
    f.inputs 'Категория...' do
      f.input :name
      f.input :fabrication
    end
    f.actions
  end


end
