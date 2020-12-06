defmodule MaverickTest do
  use ExUnit.Case

  test "creates getters for annotated public functions" do
    assert %Maverick.Route{
             module: Maverick.TestRoute1,
             function: :multiply,
             method: "POST",
             path: ["api", "v1", "multiply"],
             args: {:required_params, ["num1", "num2"]},
             error_code: 403,
             success_code: 200
           } in Maverick.TestRoute1.Maverick.Router.routes()

    assert %Maverick.Route{
             module: Maverick.TestRoute1,
             function: :hello,
             method: "GET",
             path: ["api", "v1", "hello", {:variable, "name"}],
             args: :params,
             error_code: 404,
             success_code: 200
           } in Maverick.TestRoute1.Maverick.Router.routes()

    assert %Maverick.Route{
             module: Maverick.TestRoute2,
             function: :come_fly_with_me,
             method: "POST",
             path: ["api", "v1", "fly", "me", "to", "the"],
             args: :request,
             error_code: 404,
             success_code: 200
           } in Maverick.TestRoute2.Maverick.Router.routes()

    assert %Maverick.Route{
             module: Maverick.TestRoute2,
             function: :current_time,
             method: "PUT",
             path: ["api", "v1", "clock", "now"],
             args: :params,
             error_code: 404,
             success_code: 200
           } in Maverick.TestRoute2.Maverick.Router.routes()
  end

  test "ignores invalid or unannotated functions" do
    route1_functions = Maverick.TestRoute1.Maverick.Router.routes()
    route2_functions = Maverick.TestRoute2.Maverick.Router.routes()

    refute function_member(route1_functions, :double)
    refute function_member(route1_functions, :interpolate)
    refute function_member(route2_functions, :upcase)
  end

  defp function_member(routes, function) do
    Enum.any?(routes, fn %{function: func} -> func == function end)
  end
end
