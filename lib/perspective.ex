defmodule Perspective do
  use Perspective.Application

  def call!(data, actor_id \\ "") do
    Perspective.Processor.run(data, actor_id)
  end

  def call(data, actor_id \\ "") do
    try do
      call!(data, actor_id)
    rescue
      error -> {:error, error}
    end
  end
end
