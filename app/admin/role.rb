ActiveAdmin.register Role do
  permit_params :name,
                users_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :users
    actions
  end

  form do |f|
    f.inputs 'Роль пользователей' do
      f.input :name
      f.inputs do
        f.input :users, as: :select, multiple: true, member_label: :email
        end
      end
    f.actions
  end

end