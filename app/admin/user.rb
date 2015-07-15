ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :last_name, :first_name

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
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
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
    end
    f.actions
  end

end
