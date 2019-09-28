defmodule Perspective do
  use Perspective.Application

  def call!(data, token \\ "") do
    Perspective.Processor.run(data, token)
  end

  def call(data, token \\ "") do
    try do
      call!(data, token)
    rescue
      error -> {:error, error}
    end
  end
end
