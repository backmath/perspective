defmodule Perspective.StorageConfig do
  use Perspective.Config, Perspective.LocalFileStorage

  def path(file_name, subdirectory \\ "") do
    app_id = Perspective.AppID.app_id()
    Path.join([config(:path), app_id, subdirectory, file_name])
  end
end
