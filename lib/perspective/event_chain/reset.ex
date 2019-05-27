defmodule Perspective.EventChain.Reset do
  def start_new_chain do
    Perspective.StorageConfig.set_new_key()

    suppress_console_info(fn ->
      Application.stop(:perspective)
      Application.start(:perspective)
    end)
  end

  def suppress_console_info(function) do
    Logger.configure_backend(:console, level: :warn)
    function.()
    Logger.configure_backend(:console, level: :info)
  end
end
