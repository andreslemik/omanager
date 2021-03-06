ActiveAdmin.register User do
  menu parent: 'Управление пользователями'
  permit_params :email, :username, :password, :password_confirmation, :last_name, :first_name,
                role_ids: []

  filter :first_name_or_last_name_cont, as: :string, label: 'ФИО'
  filter :email
  # todo: rewrite it filter. this line caused a database error
  #filter :roles, collection: Role.pluck(:caption, :id)

  controller do
    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete 'password'
        params[:user].delete 'password_confirmation'
      end
      super
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :username
    column :email
    column :roles_s
    actions
  end

  form do |f|
    f.inputs 'Admin Details' do
      f.input :last_name
      f.input :first_name
      f.input :username
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :roles, as: :select,
                      collection: Role.pluck(:caption, :id)
    end
    f.actions
  end
end
