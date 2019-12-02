defmodule GverDiff.OptionComparer do
  def compare?(%{:base => base, :target => target}) do
    base < target
  end
end
