module ApplicationHelper
  def edit_and_destroy_buttons(item)
    return if current_user.nil?

    edit = link_to("Edit", url_for([:edit, item]), class: "btn btn-primary")
    del = link_to("Destroy", item, data: { turbo_confirm: "Are you sure?", turbo_method: :delete },
                                   class: "btn btn-danger")
    raw("#{edit} #{del}")
  end

  def round(number)
    "%0.1f" % [number]
  end
end
