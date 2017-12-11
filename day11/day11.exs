defmodule Day11 do

  def solve(file_path) do
    solution = File.read!(file_path)
    |> String.trim()
    |> String.split(",")
    |> List.foldl(%{x: 0, y: 0, z: 0, max_distance: 0}, &(traverse_grid(&1, &2)))
    {manhattan_distance(solution.x, solution.y, solution.z), solution.max_distance}
  end

  defp traverse_grid("nw", s), do: update_state(s, 1, 0, -1)
  defp traverse_grid("n", s),  do: update_state(s, 0, 1, -1)
  defp traverse_grid("ne", s), do: update_state(s, -1, 1, 0)
  defp traverse_grid("se", s), do: update_state(s, -1, 0, +1)
  defp traverse_grid("s", s),  do: update_state(s, 0, -1, +1)
  defp traverse_grid("sw", s), do: update_state(s, 1, -1, 0)

  defp update_state(s, dx, dy, dz) do
    %{
      x: s.x + dx,
      y: s.y + dy,
      z: s.z + dz,
      max_distance: Enum.max([s.max_distance, manhattan_distance(s.x + dx, s.y + dy, s.z + dz)])
    }
  end

  defp manhattan_distance(x, y, z) do
    (abs(x) + abs(y) + abs(z)) / 2
  end
end

{part1, part2} = Day11.solve("input")
IO.puts "First part: #{part1}, Second part: #{part2}"