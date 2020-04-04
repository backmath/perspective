defmodule Perspective.TestCase do
  defmacro __using__(_) do
    quote do
      use ExUnit.Case, async: true
      use Perspective.LaunchANewInstancePerTest
    end
  end
end
