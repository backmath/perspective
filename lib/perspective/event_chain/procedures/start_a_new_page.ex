defmodule Perspective.EventChain.StartANewPage do
  def run do
    Perspective.EventChain.PageManifest.add_page()
    Perspective.EventChain.CurrentPage.start_new_page()

    Perspective.EventChain.SaveCurrentPage.run()
  end
end
