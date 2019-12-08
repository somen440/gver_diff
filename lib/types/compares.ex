defmodule Compares do
  defstruct base: nil, target: nil

  @type t(base, target) :: %Compares{base: base, target: target}

  @type compare_target :: string

  @type t :: %Compares{base: compare_target, target: compare_target}
end