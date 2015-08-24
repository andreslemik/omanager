ActiveAdmin.register Partner do
  permit_params :name, :memo, :partner_type

  filter :name
  filter :partner_type

  index do
    selectable_column
    column :name
    column :partner_type do |pt|
      I18n.translate pt.partner_type.to_s
    end
    column :balance do |pt|
      number_to_currency pt.balance, precision: 0
    end
    actions
  end

  form do |f|
    f.inputs 'Контрагент' do
      f.input :name
      f.input :partner_type, as: :select, collection: Partner.partner_types.map { |k,v| [I18n.t(k), k.to_sym] }
      f.input :memo
    end
    f.actions
  end

end