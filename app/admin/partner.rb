ActiveAdmin.register Partner do
  permit_params :name, :memo

  filter :name

  index do
    selectable_column
    column :name
    actions
  end

  form do |f|
    f.inputs 'Контрагент' do
      f.input :name
      f.input :memo
    end
    f.actions
  end

end