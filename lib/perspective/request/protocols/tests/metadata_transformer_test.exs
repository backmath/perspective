defmodule Perspective.ActionRequest.MetadataTransformer.Test do
  use ExUnit.Case

  test "event_meta returns the provided data as a fallback" do
    defmodule DefaultExample do
      use Perspective.ActionRequest
    end

    request = DefaultExample.new(%{}, "", %{a: 2})
    assert %{a: 2} == Perspective.ActionRequest.MetadataTransformer.event_meta(request)
  end

  test "event_meta returns the provided block" do
    defmodule DefinitionExample do
      use Perspective.ActionRequest

      event_meta(%{meta: %{a: a}}) do
        %{
          a: a * 2
        }
      end
    end

    request = DefinitionExample.new(%{}, "", %{a: 2})
    assert %{a: 4} == Perspective.ActionRequest.MetadataTransformer.event_meta(request)
  end
end
