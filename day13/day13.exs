defmodule Day13 do
  # Awful.

  def solve(file_path) do
    File.read!(file_path)
    |> String.split("\n")
    |> List.delete_at(-1)
    |> List.foldl(%{}, &(create_layers(&1, &2)))
    |> Enum.reduce(0, &(get_severity(&1, 0) + &2))
  end
  
  def solve_second(file_path) do
    layers = File.read!(file_path)
    |> String.split("\n")
    |> List.delete_at(-1)
    |> List.foldl(%{}, &(create_layers(&1, &2)))

    get_delay_needed(0, Enum.reduce(layers, 0, &(get_severity(&1, 0) + &2)), layers, file_path)
  end
  
  defp get_delay_needed(delay, false, _, _), do: delay
  
  defp get_delay_needed(delay, _solution, layers, file_path) do
    get_delay_needed(delay + 1, Enum.any?(layers, fn {depth, range} -> is_caught(depth + delay + 1, range) end), layers, file_path)
  end

  defp get_severity({depth, range}, delay) do
    if get_scanner_pos(depth + delay, range) == 0 do
      Enum.max([depth, 1]) * range
    else
      0
    end
  end

  defp create_layers(input, layers) do
    layer = Regex.named_captures(~r/(?<depth>\d+): (?<range>\d+)/, input)
    Map.put(layers, layer["depth"] |> String.to_integer(), layer["range"] |> String.to_integer())
  end

  defp is_caught(turn, range) do
    get_scanner_pos(turn, range) == 0
  end

  defp get_scanner_pos(turn, range) do
    rem(turn, (range - 1) * 2)
  end
end

IO.puts Day13.solve("input")
IO.puts Day13.solve_second("input")