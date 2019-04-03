defmodule Perspective.ActionRequest.RequestDataTransformer.Test do
  use ExUnit.Case

  test "transform_data returns the provided data as a fallback" do
    defmodule FallbackRequestExample do
      use Perspective.ActionRequest

      @domain_event FallbackEventExample
    end

    defmodule FallbackEventExample do
      use Perspective.DomainEvent

      @action_request FallbackRequestExample
    end

    request = FallbackRequestExample.new(%{a: 2})
    assert %{a: 2} == Perspective.ActionRequest.RequestDataTransformer.transform_data(request)
  end

  test "transform_data returns the provided block" do
    defmodule TransformationRequestExample do
      use Perspective.ActionRequest

      @domain_event TransformationEventExample
    end

    defmodule TransformationEventExample do
      use Perspective.DomainEvent

      @action_request TransformationRequestExample

      transform_data(%{data: %{a: a}}) do
        %{
          a: a * 2
        }
      end
    end

    request = TransformationRequestExample.new(%{a: 2})

    assert %{a: 4} == Perspective.ActionRequest.RequestDataTransformer.transform_data(request)
  end
end
