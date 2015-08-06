# ActiveAdmin.register Role do
#   permit_params :name, :caption,
#                 users_ids: []
#
#   filter :users
#   filter :caption
#
#
#   index do
#     selectable_column
#     id_column
#     column :caption
#     actions
#   end
#
#   form do |f|
#     f.inputs 'Роль пользователей' do
#       f.input :caption
#       f.input :name
#       end
#     f.actions
#   end
#
#   show do
#     panel 'Детали роли' do
#       attributes_table_for role do
#         row :id
#         row :caption
#         row :name
#         row :users_s
#       end
#     end
#   end
#
# end