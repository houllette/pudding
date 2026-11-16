defmodule Foundation.Pair do
  @moduledoc "A pure tuple permutation used only to qualify the backend."

  @spec swap(pair :: {term(), term()}) :: {term(), term()}
  def swap({left, right}), do: {right, left}
end
