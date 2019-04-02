defmodule Perspective.ActionRequest.RequestDataTransformer.Test do
  use ExUnit.Case

  test "event_data returns the provided data as a fallback" do
    defmodule DefaultExample do
      use Perspective.ActionRequest
    end

    request = DefaultExample.new(%{a: 2}, "", %{})
    assert %{a: 2} == Perspective.ActionRequest.RequestDataTransformer.event_data(request)
  end

  test "event_data returns the provided block" do
    defmodule DefinitionExample do
      use Perspective.ActionRequest

      event_data(%{data: %{a: a}}) do
        %{
          a: a * 2
        }
      end
    end

    request = DefinitionExample.new(%{a: 2}, "", %{})

    assert %{a: 4} == Perspective.ActionRequest.RequestDataTransformer.event_data(request)
  end
end
