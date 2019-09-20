defmodule Perspective.ActionRequest.RequestDataTransformer.Test do
  use ExUnit.Case, async: true

  test "transform_data returns the provided data as a fallback" do
    defmodule FallbackRequestExample do
      use Perspective.ActionRequest

      @domain_event FallbackEventExample
    end

    request = FallbackRequestExample.new("", %{a: 2})
    assert %{a: 2} == Perspective.ActionRequest.RequestDataTransformer.transform_data(request)
  end

  test "transform_data returns the provided block" do
    defmodule TransformationRequestExample do
      use Perspective.ActionRequest

      @domain_event TransformationEventExample

      transform_data(%{data: %{a: a}}) do
        %{
          a: a * 2
        }
      end
    end

    request = TransformationRequestExample.new("", %{a: 2})

    assert %{a: 4} == Perspective.ActionRequest.RequestDataTransformer.transform_data(request)
  end
end
