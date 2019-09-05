defmodule Perspective.ActionRequest.MetadataTransformer.Test do
  use ExUnit.Case, async: true

  test "transform_meta returns the provided data as a fallback" do
    defmodule DefaultExample do
      use Perspective.ActionRequest
      @domain_event nil
    end

    request = DefaultExample.new(%{}, "", %{a: 2})
    assert %{a: 2} == Perspective.ActionRequest.MetadataTransformer.transform_meta(request)
  end

  test "transform_meta returns the provided block" do
    defmodule RequestExample do
      use Perspective.ActionRequest

      @domain_event EventExample
    end

    defmodule EventExample do
      use Perspective.DomainEvent

      @action_request RequestExample

      transform_meta(%{meta: %{a: a}}) do
        %{
          a: a * 2
        }
      end
    end

    request = RequestExample.new(%{}, "", %{a: 2})
    assert %{a: 4} == Perspective.ActionRequest.MetadataTransformer.transform_meta(request)
  end
end
