ActiveAdmin.register Partner do
  permit_params :name, :memo, :partner_type, :own

  controller do
    def create
      super do |format|
        redirect_to partners_path and return if resource.valid?
      end
    end
    def update
      super do |format|
        redirect_to partners_path and return if resource.valid?
      end
    end
  end

  partner_types = Partner.partner_types.map { |k,v| [I18n.t(k), k.to_sym] }
  filter :name
  filter :own
  filter :partner_type, as: :select, collection: partner_types

  index do
    selectable_column
    column :own
    column :name
    column :partner_type do |pt|
      I18n.translate(pt.partner_type) if pt.partner_type
    end
    column :balance do |pt|
      number_to_currency pt.balance, precision: 0
    end
    actions
  end

  form do |f|
    f.inputs 'Контрагент' do
      f.input :name
      f.input :partner_type, as: :select, collection: partner_types
      f.input :own
      f.input :memo
    end
    f.actions
  end

end