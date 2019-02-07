defmodule Web.ErrorView do
  use Phoenix.View,
    root: "lib/web/templates",
    namespace: Web

  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
