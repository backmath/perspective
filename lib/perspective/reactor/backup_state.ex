defmodule Perspective.Reactor.BackupState do
  def save_state(reactor_name, state) do
    state
    |> Perspective.Serialize.to_json()
    |> Perspective.SaveLocalFile.save(backup_filename(reactor_name))
  end

  def load_state(reactor_name) do
    try do
      reactor_name
      |> backup_filename()
      |> Perspective.LoadLocalFile.load!()
      |> Perspective.Deserialize.deserialize()
    rescue
      Perspective.LocalFileNotFound -> raise Perspective.Reactor.BackupStateMissing, reactor_name
    end
  end

  defp backup_filename(reactor_name) do
    reactor_name
    |> to_string()
    |> String.replace(~r/^Elixir\./, "")
    |> String.replace_suffix("", ".json")
    |> Perspective.StorageConfig.path()
  end
end
