ActiveAdmin.register Property do

  permit_params :name

  filter :name
  filter :products

  index do
    selectable_column
    id_column
    column :name
  end
end
