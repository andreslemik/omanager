ActiveAdmin.register Dept do
  permit_params :name

  filter :name

  index do
    selectable_column
    column :name
    actions
  end

  form do |f|
    f.inputs 'Подразделение' do
      f.input :name
    end
    f.actions
  end


end
