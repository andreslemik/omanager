ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :last_name, :first_name,
                role_ids: []

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
    column :email
    column :roles_s
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :last_name
      f.input :first_name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :roles, as: :select, collection: Role.all.map{|r| [r.caption, r.id]}
    end
    f.actions
  end

end
