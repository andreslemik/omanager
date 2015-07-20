ActiveAdmin.register Category do

  permit_params :name

  filter :name

  form do |f|
    f.inputs 'Категория...' do
      f.input :name
    end
    f.actions
  end


end
