ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    section 'Последние изменения' do
      table_for PaperTrail::Version.order('id desc').limit(20) do
        column ('Что') { |v| v.item.to_s }
        column ('Тип') { |v| v.item_type.underscore.humanize }
        column ('Изменения') { |v| v.item.versions.last.changeset unless v.item.nil? }
        column ('Когда') { |v| I18n.l(v.created_at) }
        column ('Кто менял') { |v| User.find_by_id(v.whodunnit).try(:name) }
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
