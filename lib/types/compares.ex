defmodule Compares do
  defstruct base: nil, target: nil

  @type t(base, target) :: %Compares{base: base, target: target}

  @type compare_target :: binary | integer | float | boolean | Date | DateTime

  @type t :: %Compares{base: compare_target, target: compare_target}
end

defmodule TypeAndCompares do
  defstruct id: nil, compares: nil

  @type t(id, compares) :: {id, compares}

  @type identifier_target :: :string | :integer | :float | :date | :datetime | :version

  @type t :: %TypeAndCompares{id: identifier_target, compares: Compares.t()}
end
