ActiveAdmin.register Category do
  menu parent: 'Управление продуктами', priority: 100

  permit_params :name

  filter :name

  index do
    selectable_column
    id_column
    column :name
    actions
  end

  form do |f|
    f.inputs 'Категория...' do
      f.input :name
    end
    f.actions
  end


end
